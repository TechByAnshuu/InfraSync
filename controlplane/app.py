"""
InfraSync Control Plane API
Provides REST endpoints for:
  - Chaos Engineering (crash / revive containers)
  - Shared Redis hit counters & leaderboard
  - Prometheus-style metrics export
  - HAProxy stats proxy (CORS)
"""

import os, time, json, docker, redis
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Allow all origins — required so web containers can call this API

# ── Clients ─────────────────────────────────────────────────────────────────
docker_client = docker.from_env()
redis_client  = redis.Redis(host="redis", port=6379, decode_responses=True)

ALLOWED = {"web1", "web2", "web3"}
BOOT_TIME = time.time()

# ── Helpers ──────────────────────────────────────────────────────────────────
def container_status(name):
    try:
        c = docker_client.containers.get(name)
        return c.status   # "running" | "exited" | "paused" ...
    except docker.errors.NotFound:
        return "not_found"

# ════════════════════════════════════════════════════════════════════════════
#  HEALTH
# ════════════════════════════════════════════════════════════════════════════
@app.route("/health")
def health():
    return jsonify(status="ok", uptime=round(time.time() - BOOT_TIME)), 200

# ════════════════════════════════════════════════════════════════════════════
#  CHAOS ENGINEERING  — crash / revive containers
# ════════════════════════════════════════════════════════════════════════════
@app.route("/api/chaos/crash/<name>", methods=["POST"])
def crash(name):
    if name not in ALLOWED:
        return jsonify(error=f"Container '{name}' not in allowlist"), 403
    try:
        c = docker_client.containers.get(name)
        c.stop(timeout=2)
        redis_client.incr(f"chaos:crash:{name}")
        redis_client.lpush("chaos:events", json.dumps({
            "ts": time.time(), "action": "crash", "target": name
        }))
        return jsonify(ok=True, container=name, action="stopped"), 200
    except Exception as e:
        return jsonify(error=str(e)), 500

@app.route("/api/chaos/revive/<name>", methods=["POST"])
def revive(name):
    if name not in ALLOWED:
        return jsonify(error=f"Container '{name}' not in allowlist"), 403
    try:
        c = docker_client.containers.get(name)
        c.start()
        redis_client.incr(f"chaos:revive:{name}")
        redis_client.lpush("chaos:events", json.dumps({
            "ts": time.time(), "action": "revive", "target": name
        }))
        return jsonify(ok=True, container=name, action="started"), 200
    except Exception as e:
        return jsonify(error=str(e)), 500

@app.route("/api/chaos/status")
def chaos_status():
    status = {}
    for name in ALLOWED:
        status[name] = {
            "status":  container_status(name),
            "crashes": int(redis_client.get(f"chaos:crash:{name}") or 0),
            "revives": int(redis_client.get(f"chaos:revive:{name}") or 0),
        }
    # Last 10 chaos events
    raw = redis_client.lrange("chaos:events", 0, 9)
    events = [json.loads(e) for e in raw]
    return jsonify(containers=status, recent_events=events), 200

# ════════════════════════════════════════════════════════════════════════════
#  REDIS STATE — hit counters & leaderboard
# ════════════════════════════════════════════════════════════════════════════
@app.route("/api/hit/<name>", methods=["POST"])
def record_hit(name):
    if name not in ALLOWED:
        return jsonify(error="Unknown node"), 403
    total = redis_client.incr("cluster:total_hits")
    node_hits = redis_client.hincrby("cluster:node_hits", name, 1)
    return jsonify(total=total, node=name, node_hits=node_hits), 200

@app.route("/api/stats")
def stats():
    total = int(redis_client.get("cluster:total_hits") or 0)
    node_hits = redis_client.hgetall("cluster:node_hits")
    node_hits = {k: int(v) for k, v in node_hits.items()}
    return jsonify(
        total_hits = total,
        node_hits  = node_hits,
        nodes      = {name: container_status(name) for name in ALLOWED},
    ), 200

# ════════════════════════════════════════════════════════════════════════════
#  PROMETHEUS-STYLE METRICS ENDPOINT
# ════════════════════════════════════════════════════════════════════════════
@app.route("/metrics")
def metrics():
    total      = int(redis_client.get("cluster:total_hits") or 0)
    node_hits  = redis_client.hgetall("cluster:node_hits")
    uptime     = round(time.time() - BOOT_TIME)

    lines = [
        "# HELP infrasync_total_hits Total HTTP requests across cluster",
        "# TYPE infrasync_total_hits counter",
        f"infrasync_total_hits {total}",
        "",
        "# HELP infrasync_node_hits Requests served per backend node",
        "# TYPE infrasync_node_hits counter",
    ]
    for name in ALLOWED:
        hits = int(node_hits.get(name, 0))
        lines.append(f'infrasync_node_hits{{node="{name}"}} {hits}')

    lines += [
        "",
        "# HELP infrasync_controlplane_uptime_seconds Control plane uptime",
        "# TYPE infrasync_controlplane_uptime_seconds gauge",
        f"infrasync_controlplane_uptime_seconds {uptime}",
    ]

    for name in ALLOWED:
        status = container_status(name)
        up = 1 if status == "running" else 0
        lines.append(f'infrasync_container_up{{container="{name}"}} {up}')

    return "\n".join(lines) + "\n", 200, {"Content-Type": "text/plain; charset=utf-8"}

# ════════════════════════════════════════════════════════════════════════════
#  RESET (useful for demos)
# ════════════════════════════════════════════════════════════════════════════
@app.route("/api/reset", methods=["POST"])
def reset():
    redis_client.delete("cluster:total_hits", "cluster:node_hits", "chaos:events")
    for name in ALLOWED:
        redis_client.delete(f"chaos:crash:{name}", f"chaos:revive:{name}")
    return jsonify(ok=True, message="All counters reset"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
