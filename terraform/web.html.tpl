<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>InfraSync &middot; ${name}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@200;300;400;600&family=Manrope:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
:root {
  --accent: ${color};
  --bg:#101014; --surface:#17161B; --surface2:#1C1C21;
  --border:rgba(255,255,255,.07); --border-hover:rgba(255,255,255,.14);
  --text:#F2F5F3; --text-2:#A8A8B0; --text-3:#8A8A92;
  --ok:#10B981; --crit:#EF4444; --warn:#F59E0B;
  --mint:#3FAF82; --mint-bright:#5FD4A4; --lime:#B6FF58;
  --font-ui:'Manrope','Inter',system-ui,sans-serif;
  --font-num:'Outfit','Manrope',system-ui,sans-serif;
  --font-mono:'JetBrains Mono',ui-monospace,Consolas,monospace;
  --r-card:20px; --r-tile:14px; --r-pill:999px;
}
*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
html { font-size:14px; }
body {
  font-family: var(--font-ui);
  background: var(--bg);
  color: var(--text);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 0;
  background-image:
    radial-gradient(ellipse 70% 50% at 50% 0%, rgba(63,175,130,.08) 0%, transparent 60%);
}
a { color: inherit; text-decoration: none; }
button { font-family: var(--font-ui); cursor: pointer; border: none; background: none; }
:focus-visible { outline: 2px solid var(--lime); outline-offset: 2px; }

/* Top bar */
.topbar {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 32px;
  border-bottom: 1px solid var(--border);
  background: rgba(10,10,10,.8);
  backdrop-filter: blur(10px);
  position: sticky; top: 0; z-index: 100;
}
.logo {
  display: flex; align-items: center; gap: 10px;
  font-weight: 700; font-size: .95rem; letter-spacing: -.01em;
}
.logo-hex {
  width: 30px; height: 30px;
  background: linear-gradient(135deg, var(--mint) 0%, var(--mint-bright) 100%);
  clip-path: polygon(50% 0%,93% 25%,93% 75%,50% 100%,7% 75%,7% 25%);
  display: flex; align-items: center; justify-content: center;
}
.logo-hex svg { color: #0a120d; }
.topbar-right {
  display: flex; align-items: center; gap: 10px;
  font-size: .78rem; color: var(--text-3);
}
.status-pill {
  display: flex; align-items: center; gap: 6px;
  background: rgba(16,185,129,.1);
  border: 1px solid rgba(16,185,129,.2);
  border-radius: var(--r-pill);
  padding: 4px 12px;
  color: var(--ok);
  font-size: .75rem; font-weight: 600;
}
.pulse-dot {
  width: 7px; height: 7px; border-radius: 50%;
  background: var(--ok);
  box-shadow: 0 0 6px var(--ok);
  animation: pdot 2s infinite;
}
@keyframes pdot { 0%, 100% { opacity: 1; } 50% { opacity: .4; } }
.topbar-time { font-family: var(--font-mono); font-size: .78rem; color: var(--text-3); }

/* Main card */
.main-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
}
.node-card {
  width: 100%;
  background: var(--surface);
  border: 1px solid var(--accent);
  border-radius: 28px;
  padding: 40px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 0 60px rgba(63,175,130,.06), 0 0 0 1px var(--border);
}
.node-card::before {
  content: '';
  position: absolute; top: 0; left: 0;
  width: 300px; height: 300px;
  background: radial-gradient(circle at 0 0, rgba(255,255,255,.04) 0%, transparent 60%);
  pointer-events: none;
}
.node-card::after {
  content: '';
  position: absolute; top: -40px; right: -40px;
  width: 200px; height: 200px;
  background: radial-gradient(circle, color-mix(in srgb, var(--accent) 15%, transparent) 0%, transparent 70%);
  pointer-events: none;
}

/* Node header */
.node-serving {
  font-size: .7rem; font-weight: 700; text-transform: uppercase;
  letter-spacing: .1em; color: var(--accent);
  margin-bottom: 10px;
  display: flex; align-items: center; gap: 7px;
}
.node-serving::before {
  content: '';
  display: inline-block;
  width: 8px; height: 8px; border-radius: 50%;
  background: var(--accent);
  box-shadow: 0 0 8px var(--accent);
  animation: pdot 2s infinite;
}

/* TC03 target — keep this exact line */

.node-title {
  font-family: var(--font-num);
  font-size: 3.4rem; font-weight: 300; letter-spacing: -.03em; line-height: 1;
  margin-bottom: 14px;
}
.node-title .node-highlight { color: var(--accent); font-weight: 600; }
.node-desc {
  font-size: .88rem; color: var(--text-2); line-height: 1.6;
  max-width: 520px; margin-bottom: 28px;
}
.node-desc strong { color: var(--text); }

/* Stats grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 28px;
}
.stat-box {
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: var(--r-tile);
  padding: 14px 16px;
}
.stat-box-label {
  font-size: .68rem; text-transform: uppercase; letter-spacing: .07em;
  color: var(--text-3); margin-bottom: 6px; font-weight: 600;
}
.stat-box-val {
  font-family: var(--font-num);
  font-size: 1.5rem; font-weight: 300; letter-spacing: -.01em;
  color: var(--accent); line-height: 1;
}
.stat-box-val.ok { color: var(--ok); font-size: 1rem; font-weight: 600; }
.stat-box-sub { font-size: .68rem; color: var(--text-3); margin-top: 4px; }

/* Cluster row */
.cluster-row {
  display: flex; gap: 10px; margin-bottom: 24px;
}
.cluster-chip {
  display: flex; align-items: center; gap: 8px;
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: var(--r-pill);
  padding: 7px 14px;
  font-size: .78rem; font-weight: 600;
  font-family: var(--font-mono);
  transition: border-color .2s;
}
.cluster-chip.active {
  border-color: rgba(63,175,130,.4);
  background: rgba(63,175,130,.06);
}
.cluster-chip.this-node {
  border-color: var(--accent);
  background: color-mix(in srgb, var(--accent) 10%, transparent);
}
.chip-dot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
.chip-dot.animated { animation: pdot 2s infinite; }

/* Action buttons */
.action-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 24px; }
.btn-reload {
  display: inline-flex; align-items: center; gap: 8px;
  background: var(--accent);
  color: #0a120d;
  font-weight: 700; font-size: .82rem; font-family: var(--font-ui);
  padding: 10px 22px; border-radius: var(--r-pill);
  transition: all .15s;
}
.btn-reload:hover { filter: brightness(1.1); transform: translateY(-1px); }
.btn-link {
  display: inline-flex; align-items: center; gap: 7px;
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text-2);
  font-weight: 600; font-size: .8rem; font-family: var(--font-ui);
  padding: 9px 18px; border-radius: var(--r-pill);
  transition: all .15s;
}
.btn-link:hover { border-color: var(--mint); color: var(--mint); }
.btn-link.dashboard {
  background: rgba(63,175,130,.1);
  border-color: rgba(63,175,130,.3);
  color: var(--mint-bright);
}

/* Tech footer */
.tech-footer {
  border-top: 1px solid var(--border);
  padding-top: 20px;
  display: flex; flex-wrap: wrap; gap: 8px; justify-content: flex-start;
}
.tech-pill {
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: var(--r-pill);
  padding: 4px 12px;
  font-size: .68rem; color: var(--text-3);
}
.tech-pill span { color: var(--text-2); font-weight: 600; }

/* Uptime bar */
.uptime-mini {
  font-family: var(--font-mono);
  font-size: .72rem; color: var(--text-3);
  margin-top: 10px;
}
.uptime-mini span { color: var(--accent); }

/* Responsive */
@media (max-width: 600px) {
  .node-card { padding: 24px; }
  .node-title { font-size: 2.4rem; }
  .stats-grid { grid-template-columns: 1fr 1fr; }
  .cluster-row { flex-wrap: wrap; }
}
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}

/* Scrollbar */
::-webkit-scrollbar { width: 4px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(255,255,255,.1); border-radius: 4px; }
</style>
</head>
<body>

<!-- Top bar -->
<header class="topbar">
  <div class="logo">
    <div class="logo-hex">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>
      </svg>
    </div>
    InfraSync DevOps Core
    <span style="font-family:var(--font-mono);font-size:.75rem;background:rgba(63,175,130,.12);border:1px solid rgba(63,175,130,.25);color:var(--mint-bright);padding:2px 10px;border-radius:var(--r-pill);font-weight:500;">${name}</span>
  </div>
  <div class="topbar-right">
    <div class="status-pill">
      <div class="pulse-dot"></div>
      HEALTHY &middot; 200 OK
    </div>
    <span>Terraform v1.6+</span>
    <span>Ansible Core</span>
    <span>Nagios 4</span>
    <span class="topbar-time" id="tb-time"></span>
  </div>
</header>

<!-- Main node card -->
<div class="main-wrap">
  <div class="node-card">

    <div class="node-serving">Serving Backend Node</div>

    <!-- TC03 grep target — KEEP THIS EXACT FORMAT -->
    <h1 class="node-title">Web Server: <span class="node-highlight">${name}</span></h1>

    <p class="node-desc">
      Provisioned by <strong>Terraform</strong> &middot; Configured by <strong>Ansible</strong> &middot;
      Monitored by <strong>Nagios Core 4</strong> &middot; Load balanced via <strong>HAProxy</strong>
      with round-robin rotation and health probes.
    </p>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-box">
        <div class="stat-box-label">Node Port</div>
        <div class="stat-box-val">${port}</div>
        <div class="stat-box-sub">host binding</div>
      </div>
      <div class="stat-box">
        <div class="stat-box-label">Network</div>
        <div class="stat-box-val" style="font-size:.9rem;font-family:var(--font-mono);color:var(--mint-bright)">lab-net</div>
        <div class="stat-box-sub">Docker bridge</div>
      </div>
      <div class="stat-box">
        <div class="stat-box-label">Status</div>
        <div class="stat-box-val ok">&bull; Running</div>
        <div class="stat-box-sub">HTTP 200</div>
      </div>
      <div class="stat-box">
        <div class="stat-box-label">Page Uptime</div>
        <div class="stat-box-val" id="uptime-val" style="font-size:1rem;">0s</div>
        <div class="stat-box-sub">since page load</div>
      </div>
    </div>

    <!-- Cluster row -->
    <div style="font-size:.7rem;font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--text-3);margin-bottom:8px;">Live Cluster</div>
    <div class="cluster-row">
      <div class="cluster-chip this-node" id="chip-this">
        <div class="chip-dot animated" style="background:${color};box-shadow:0 0 6px ${color}"></div>
        ${name} &middot; :${port}
      </div>
      <div class="cluster-chip active">
        <div class="chip-dot" style="background:var(--ok)"></div>
        web cluster &middot; 3 nodes
      </div>
      <div class="cluster-chip">
        <div class="chip-dot" style="background:var(--mint)"></div>
        haproxy &middot; :8080
      </div>
    </div>

    <!-- Actions -->
    <div class="action-row">
      <button class="btn-reload" onclick="window.location.reload()">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/>
        </svg>
        Send Next Request (Reload)
      </button>
      <a class="btn-link dashboard" href="http://VMIP:5000" id="cp-link">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
          <rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>
        </svg>
        Control Dashboard (:5000)
      </a>
      <a class="btn-link" href="http://VMIP:8080" id="lb-link">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M18 20V10M12 20V4M6 20v-6"/>
        </svg>
        Load Balancer (:8080)
      </a>
      <a class="btn-link" href="http://VMIP:8404/stats" id="stats-link">HAProxy Stats</a>
      <a class="btn-link" href="http://VMIP/nagios4/" id="nagios-link">Nagios Monitor</a>
      <a class="btn-link" href="http://VMIP:9090" id="prom-link">Prometheus</a>
      <a class="btn-link" href="http://VMIP:3000" id="grafana-link">Grafana</a>
    </div>

    <!-- Tech footer -->
    <div class="tech-footer">
      <div class="tech-pill">&bull; Provisioning: <span>Terraform v1.6+</span></div>
      <div class="tech-pill">&bull; Config Mgmt: <span>Ansible Core</span></div>
      <div class="tech-pill">&bull; Monitoring: <span>Nagios Core 4</span></div>
      <div class="tech-pill">&bull; Load Balancer: <span>HAProxy 2.8 LTS</span></div>
      <div class="tech-pill">&bull; OS: <span>Ubuntu 24.04 LTS</span></div>
      <div class="tech-pill">&bull; Network: <span>lab-net (Docker bridge)</span></div>
    </div>

    <div class="uptime-mini">Session: <span id="session-id">#SYNC-0000</span> &nbsp;&middot;&nbsp; <span id="uptime-txt">Uptime: 0s</span></div>
  </div>
</div>

<script>
  /* ── VM IP constant ───────────────────────────────── */
  var VM_IP = window.location.hostname || "192.168.59.138";

  /* ── Fix links ────────────────────────────────────── */
  var linkMap = {
    "cp-link":     "http://" + VM_IP + ":5000",
    "lb-link":     "http://" + VM_IP + ":8080",
    "stats-link":  "http://" + VM_IP + ":8404/stats",
    "nagios-link": "http://" + VM_IP + "/nagios4/",
    "prom-link":   "http://" + VM_IP + ":9090",
    "grafana-link":"http://" + VM_IP + ":3000"
  };
  Object.keys(linkMap).forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.href = linkMap[id];
  });

  /* ── Session ID ────────────────────────────────────── */
  document.getElementById("session-id").textContent =
    "#SYNC-" + String(1000 + Math.floor(Math.random() * 9000));

  /* ── Clock ─────────────────────────────────────────── */
  function updateClock() {
    var el = document.getElementById("tb-time");
    if (el) el.textContent = new Date().toLocaleTimeString("en-GB", { hour12: false });
  }
  setInterval(updateClock, 1000);
  updateClock();

  /* ── Page uptime ────────────────────────────────────── */
  var startTime = Date.now();
  function updateUptime() {
    var s = Math.floor((Date.now() - startTime) / 1000);
    var h = Math.floor(s / 3600);
    var m = Math.floor((s % 3600) / 60);
    var sec = s % 60;
    var str = h > 0 ? (h + "h " + String(m).padStart(2,"0") + "m " + String(sec).padStart(2,"0") + "s")
                   : (m > 0 ? (m + "m " + String(sec).padStart(2,"0") + "s") : (sec + "s"));
    var uv = document.getElementById("uptime-val");
    var ut = document.getElementById("uptime-txt");
    if (uv) uv.textContent = str;
    if (ut) ut.textContent = "Page uptime: " + str;
  }
  setInterval(updateUptime, 1000);
  updateUptime();
</script>
</body>
</html>
