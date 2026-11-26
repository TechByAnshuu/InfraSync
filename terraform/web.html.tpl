<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InfraSync · ${name}</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
  <style>
    :root {
      --primary:      ${color};
      --primary-rgb:  ${color_rgb};
      --bg:           #060a12;
      --surface:      #0d1424;
      --surface2:     #111827;
      --border:       rgba(255,255,255,0.07);
      --border-hover: rgba(255,255,255,0.14);
      --text:         #f1f5f9;
      --muted:        #64748b;
      --success:      #10b981;
      --danger:       #ef4444;
      --warning:      #f59e0b;
      --info:         #38bdf8;
      --font-mono:    'JetBrains Mono', 'Fira Code', 'Courier New', monospace;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      background-image:
        radial-gradient(ellipse 80% 50% at 20% 10%, rgba(var(--primary-rgb), 0.12) 0%, transparent 60%),
        radial-gradient(ellipse 60% 40% at 80% 90%, rgba(var(--primary-rgb), 0.06) 0%, transparent 50%);
    }

    /* ── Top bar ──────────────────────────────────────────────────────── */
    .topbar {
      position: sticky;
      top: 0;
      z-index: 100;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 10px 28px;
      background: rgba(6,10,18,0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
    }
    .topbar-brand {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 0.95rem;
      font-weight: 700;
      letter-spacing: -0.01em;
    }
    .topbar-brand svg { color: var(--primary); }
    .node-badge {
      background: rgba(var(--primary-rgb), 0.15);
      color: var(--primary);
      border: 1px solid rgba(var(--primary-rgb), 0.35);
      padding: 3px 12px;
      border-radius: 999px;
      font-size: 0.75rem;
      font-weight: 700;
      font-family: var(--font-mono);
    }
    .topbar-status {
      display: flex;
      align-items: center;
      gap: 20px;
      font-size: 0.8rem;
      color: var(--muted);
    }
    .status-dot {
      display: inline-block;
      width: 7px; height: 7px;
      border-radius: 50%;
      background: var(--success);
      box-shadow: 0 0 6px var(--success);
      animation: pulse 2s infinite;
    }
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

    /* ── Layout ──────────────────────────────────────────────────────── */
    .wrapper {
      max-width: 1340px;
      margin: 0 auto;
      padding: 28px 20px 60px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .full-width { grid-column: 1 / -1; }

    /* ── Cards ──────────────────────────────────────────────────────── */
    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 22px 24px;
      transition: border-color .2s;
    }
    .card:hover { border-color: var(--border-hover); }
    .card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 18px;
    }
    .card-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: .08em;
      color: var(--muted);
    }
    .card-title svg { color: var(--primary); }

    /* ── Hero ─────────────────────────────────────────────────────────── */
    .hero {
      grid-column: 1 / -1;
      background: linear-gradient(135deg,
        rgba(var(--primary-rgb), 0.1) 0%,
        rgba(var(--primary-rgb), 0.03) 100%);
      border: 1px solid rgba(var(--primary-rgb), 0.25);
      border-radius: 20px;
      padding: 32px 36px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 24px;
    }
    .hero-left {}
    .hero-serving {
      font-size: 0.72rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: .12em;
      color: var(--primary);
      margin-bottom: 8px;
    }
    .hero-title {
      font-size: 2.6rem;
      font-weight: 900;
      letter-spacing: -0.04em;
      line-height: 1;
      margin-bottom: 10px;
    }
    .hero-title span { color: var(--primary); }
    .hero-subtitle {
      font-size: 0.88rem;
      color: var(--muted);
      line-height: 1.6;
      max-width: 500px;
    }
    .hero-subtitle strong { color: var(--text); }
    .hero-right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 10px;
      flex-shrink: 0;
    }
    .health-badge {
      display: flex;
      align-items: center;
      gap: 7px;
      background: rgba(16,185,129,0.1);
      border: 1px solid rgba(16,185,129,0.3);
      color: #34d399;
      padding: 6px 16px;
      border-radius: 999px;
      font-size: 0.78rem;
      font-weight: 700;
    }
    .hero-meta {
      font-size: 0.75rem;
      color: var(--muted);
      text-align: right;
      font-family: var(--font-mono);
    }

    /* ── Metrics grid ─────────────────────────────────────────────────── */
    .metrics-row {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
      grid-column: 1 / -1;
    }
    .metric-tile {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px 18px;
    }
    .metric-label {
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: .08em;
      color: var(--muted);
      margin-bottom: 6px;
    }
    .metric-value {
      font-size: 1.7rem;
      font-weight: 800;
      font-family: var(--font-mono);
      color: var(--text);
      line-height: 1;
    }
    .metric-value.accent { color: var(--primary); }
    .metric-sub {
      font-size: 0.72rem;
      color: var(--muted);
      margin-top: 4px;
    }

    /* ── Cluster status panel ─────────────────────────────────────────── */
    .cluster-nodes {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 10px;
    }
    .node-chip {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 14px 16px;
      display: flex;
      align-items: center;
      gap: 10px;
      transition: all .2s;
      cursor: default;
    }
    .node-chip.active {
      border-color: rgba(var(--primary-rgb), 0.5);
      background: rgba(var(--primary-rgb), 0.08);
      box-shadow: 0 0 20px rgba(var(--primary-rgb), 0.1);
    }
    .node-chip.down {
      border-color: rgba(239,68,68,0.4);
      background: rgba(239,68,68,0.06);
      opacity: 0.7;
    }
    .chip-dot {
      width: 9px; height: 9px;
      border-radius: 50%;
      background: var(--muted);
      flex-shrink: 0;
      transition: background .3s;
    }
    .node-chip.active .chip-dot {
      background: var(--primary);
      box-shadow: 0 0 8px var(--primary);
      animation: pulse 2s infinite;
    }
    .node-chip.down .chip-dot {
      background: var(--danger);
    }
    .chip-info {}
    .chip-name {
      display: block;
      font-size: 0.85rem;
      font-weight: 700;
      font-family: var(--font-mono);
    }
    .chip-port {
      font-size: 0.7rem;
      color: var(--muted);
    }
    .chip-status-text {
      margin-left: auto;
      font-size: 0.65rem;
      text-transform: uppercase;
      font-weight: 700;
      letter-spacing: .05em;
    }

    /* ── Chaos Engineering Panel ──────────────────────────────────────── */
    .chaos-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
    }
    .chaos-node {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px;
      text-align: center;
    }
    .chaos-node-name {
      font-size: 0.9rem;
      font-weight: 700;
      font-family: var(--font-mono);
      margin-bottom: 4px;
    }
    .chaos-node-state {
      font-size: 0.72rem;
      color: var(--muted);
      margin-bottom: 14px;
      min-height: 18px;
    }
    .chaos-node-state.running { color: var(--success); }
    .chaos-node-state.stopped { color: var(--danger); }
    .chaos-btns { display: flex; gap: 8px; justify-content: center; }
    .btn-chaos-crash {
      flex: 1;
      padding: 7px 0;
      background: rgba(239,68,68,0.1);
      border: 1px solid rgba(239,68,68,0.3);
      color: #f87171;
      border-radius: 8px;
      font-size: 0.75rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .15s;
    }
    .btn-chaos-crash:hover {
      background: rgba(239,68,68,0.2);
      border-color: rgba(239,68,68,0.6);
    }
    .btn-chaos-crash:disabled { opacity: .4; cursor: not-allowed; }
    .btn-chaos-revive {
      flex: 1;
      padding: 7px 0;
      background: rgba(16,185,129,0.1);
      border: 1px solid rgba(16,185,129,0.3);
      color: #34d399;
      border-radius: 8px;
      font-size: 0.75rem;
      font-weight: 700;
      cursor: pointer;
      transition: all .15s;
    }
    .btn-chaos-revive:hover {
      background: rgba(16,185,129,0.2);
      border-color: rgba(16,185,129,0.6);
    }
    .btn-chaos-revive:disabled { opacity: .4; cursor: not-allowed; }

    .chaos-event-log {
      margin-top: 16px;
      background: #060a12;
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 10px 14px;
      font-family: var(--font-mono);
      font-size: 0.72rem;
      color: var(--muted);
      min-height: 60px;
      max-height: 110px;
      overflow-y: auto;
    }
    .chaos-event-log .ev-crash { color: #f87171; }
    .chaos-event-log .ev-revive { color: #34d399; }

    /* ── Leaderboard ──────────────────────────────────────────────────── */
    .leaderboard-row {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 0;
      border-bottom: 1px solid var(--border);
    }
    .leaderboard-row:last-child { border-bottom: none; }
    .lb-rank {
      width: 24px; height: 24px;
      border-radius: 6px;
      background: rgba(var(--primary-rgb), 0.12);
      color: var(--primary);
      font-size: 0.72rem;
      font-weight: 800;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }
    .lb-name {
      font-family: var(--font-mono);
      font-size: 0.82rem;
      font-weight: 700;
      flex: 1;
    }
    .lb-bar-wrap {
      flex: 2;
      height: 6px;
      background: rgba(255,255,255,0.05);
      border-radius: 999px;
      overflow: hidden;
    }
    .lb-bar {
      height: 100%;
      border-radius: 999px;
      background: var(--primary);
      transition: width 0.6s cubic-bezier(.4,0,.2,1);
    }
    .lb-count {
      font-family: var(--font-mono);
      font-size: 0.8rem;
      font-weight: 700;
      color: var(--text);
      width: 48px;
      text-align: right;
    }

    /* ── Chart panel ──────────────────────────────────────────────────── */
    .chart-wrap { position: relative; height: 180px; }

    /* ── CI/CD Pipeline Status ────────────────────────────────────────── */
    .pipeline-stages {
      display: flex;
      align-items: center;
      gap: 0;
      margin-top: 4px;
    }
    .pipeline-stage {
      display: flex;
      align-items: center;
    }
    .stage-block {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 5px;
    }
    .stage-icon {
      width: 36px; height: 36px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1rem;
    }
    .stage-icon.success {
      background: rgba(16,185,129,0.12);
      border: 1px solid rgba(16,185,129,0.3);
      color: #34d399;
    }
    .stage-icon.pending {
      background: rgba(100,116,139,0.12);
      border: 1px solid rgba(100,116,139,0.3);
      color: var(--muted);
    }
    .stage-icon.running {
      background: rgba(56,189,248,0.12);
      border: 1px solid rgba(56,189,248,0.3);
      color: #38bdf8;
      animation: pulse 1.5s infinite;
    }
    .stage-name {
      font-size: 0.65rem;
      text-transform: uppercase;
      letter-spacing: .05em;
      color: var(--muted);
      white-space: nowrap;
    }
    .pipeline-arrow {
      flex: 1;
      height: 1px;
      background: linear-gradient(90deg, var(--border), transparent, var(--border));
      margin: 0 6px;
      min-width: 20px;
      position: relative;
      bottom: 11px;
    }

    .ci-info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 14px;
      padding-top: 12px;
      border-top: 1px solid var(--border);
      font-size: 0.75rem;
      color: var(--muted);
    }
    .ci-badge {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 3px 10px;
      border-radius: 6px;
      font-size: 0.72rem;
      font-weight: 700;
    }
    .ci-badge.passed {
      background: rgba(16,185,129,0.1);
      border: 1px solid rgba(16,185,129,0.3);
      color: #34d399;
    }

    /* ── Action row ───────────────────────────────────────────────────── */
    .action-row {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      grid-column: 1 / -1;
    }
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      padding: 10px 20px;
      border-radius: 10px;
      font-size: 0.82rem;
      font-weight: 700;
      cursor: pointer;
      text-decoration: none;
      border: none;
      transition: all .15s;
    }
    .btn-primary {
      background: var(--primary);
      color: #000;
      box-shadow: 0 4px 16px rgba(var(--primary-rgb), 0.35);
    }
    .btn-primary:hover { filter: brightness(1.1); transform: translateY(-1px); }
    .btn-secondary {
      background: var(--surface2);
      border: 1px solid var(--border);
      color: var(--text);
    }
    .btn-secondary:hover { border-color: var(--border-hover); }
    .btn-danger {
      background: rgba(239,68,68,0.1);
      border: 1px solid rgba(239,68,68,0.3);
      color: #f87171;
    }
    .btn-danger:hover { background: rgba(239,68,68,0.2); }

    /* ── Toast ────────────────────────────────────────────────────────── */
    #toast {
      position: fixed;
      bottom: 28px;
      right: 28px;
      padding: 10px 20px;
      border-radius: 10px;
      font-size: 0.82rem;
      font-weight: 600;
      opacity: 0;
      transform: translateY(12px);
      transition: all .25s;
      z-index: 999;
      pointer-events: none;
      max-width: 320px;
    }
    #toast.show {
      opacity: 1;
      transform: translateY(0);
    }
    #toast.success { background:#064e3b; border:1px solid #065f46; color:#6ee7b7; }
    #toast.error   { background:#450a0a; border:1px solid #7f1d1d; color:#fca5a5; }
    #toast.info    { background:#0c1a2e; border:1px solid #1e3a5f; color:#7dd3fc; }

    /* ── Tech footer ──────────────────────────────────────────────────── */
    .tech-footer {
      grid-column: 1 / -1;
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      justify-content: center;
      padding-top: 8px;
    }
    .tech-pill {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 999px;
      padding: 4px 14px;
      font-size: 0.72rem;
      color: var(--muted);
    }
    .tech-pill span { color: var(--text); font-weight: 600; }

    /* ── Scrollbar ────────────────────────────────────────────────────── */
    ::-webkit-scrollbar { width: 4px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border-hover); border-radius: 4px; }
  </style>
</head>
<body>

<!-- ── Topbar ───────────────────────────────────────────────────────────── -->
<header class="topbar">
  <div class="topbar-brand">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>
    </svg>
    InfraSync DevOps Core
    <span class="node-badge">${name}</span>
  </div>
  <div class="topbar-status">
    <span><span class="status-dot"></span>&nbsp;HEALTHY</span>
    <span>Terraform v1.6+</span>
    <span>Ansible Core</span>
    <span>Nagios 4</span>
    <span id="topbar-time" style="font-family:var(--font-mono)"></span>
  </div>
</header>

<!-- ── Main layout ──────────────────────────────────────────────────────── -->
<div class="wrapper">

  <!-- Hero -->
  <div class="card hero">
    <div class="hero-left">
      <div class="hero-serving">▶ Serving Backend Node</div>
      <h1 class="hero-title">Web Server:&nbsp;<span>${name}</span></h1>
      <p class="hero-subtitle">
        Provisioned by <strong>Terraform</strong>. Configured by <strong>Ansible</strong>.
        Monitored by <strong>Nagios Core 4</strong>. Load balanced via <strong>HAProxy</strong>
        with chaos engineering &amp; auto-remediation.
      </p>
    </div>
    <div class="hero-right">
      <div class="health-badge">
        <span style="display:inline-block;width:7px;height:7px;border-radius:50%;background:#10b981;box-shadow:0 0 6px #10b981"></span>
        HEALTHY · 200 OK
      </div>
      <div class="hero-meta">
        Port: <strong>${port}</strong>&nbsp;·&nbsp;Network: <strong>lab-net</strong><br>
        Session: <strong id="session-id">#SYNC-0000</strong><br>
        <span id="uptime-display">Uptime: —</span>
      </div>
    </div>
  </div>

  <!-- Live Metrics Row -->
  <div class="metrics-row">
    <div class="metric-tile">
      <div class="metric-label">Total Cluster Hits</div>
      <div class="metric-value accent" id="m-total">—</div>
      <div class="metric-sub">Across web1 · web2 · web3</div>
    </div>
    <div class="metric-tile">
      <div class="metric-label">This Node Hits</div>
      <div class="metric-value accent" id="m-node">—</div>
      <div class="metric-sub">Served by ${name}</div>
    </div>
    <div class="metric-tile">
      <div class="metric-label">Share of Traffic</div>
      <div class="metric-value accent" id="m-share">—%</div>
      <div class="metric-sub">Round-robin distribution</div>
    </div>
    <div class="metric-tile">
      <div class="metric-label">Control Plane</div>
      <div class="metric-value" id="m-cp-status" style="font-size:1.1rem">Connecting…</div>
      <div class="metric-sub" id="m-cp-uptime">—</div>
    </div>
  </div>

  <!-- Cluster Status -->
  <div class="card">
    <div class="card-header">
      <div class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>
        </svg>
        Live Cluster Status
      </div>
      <span style="font-size:.7rem;color:var(--muted)">Auto-refresh 5s</span>
    </div>
    <div class="cluster-nodes" id="cluster-nodes">
      <div class="node-chip" id="chip-web1">
        <div class="chip-dot"></div>
        <div class="chip-info">
          <span class="chip-name">web1</span>
          <span class="chip-port">:8081</span>
        </div>
        <span class="chip-status-text" style="color:var(--muted)">…</span>
      </div>
      <div class="node-chip" id="chip-web2">
        <div class="chip-dot"></div>
        <div class="chip-info">
          <span class="chip-name">web2</span>
          <span class="chip-port">:8082</span>
        </div>
        <span class="chip-status-text" style="color:var(--muted)">…</span>
      </div>
      <div class="node-chip" id="chip-web3">
        <div class="chip-dot"></div>
        <div class="chip-info">
          <span class="chip-name">web3</span>
          <span class="chip-port">:8083</span>
        </div>
        <span class="chip-status-text" style="color:var(--muted)">…</span>
      </div>
    </div>
  </div>

  <!-- Request Distribution Chart -->
  <div class="card">
    <div class="card-header">
      <div class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M18 20V10M12 20V4M6 20v-6"/>
        </svg>
        Request Distribution
      </div>
    </div>
    <div class="chart-wrap">
      <canvas id="distChart"></canvas>
    </div>
  </div>

  <!-- ━━ CHAOS ENGINEERING ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
  <div class="card full-width">
    <div class="card-header">
      <div class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z"/>
        </svg>
        Chaos Engineering — Fault Injection
      </div>
      <span style="font-size:.7rem;color:var(--warning);font-weight:700">⚠ LIVE CONTROL</span>
    </div>

    <div class="chaos-grid" id="chaos-grid">
      <!-- Generated by JS -->
    </div>

    <div class="chaos-event-log" id="chaos-log">
      <span style="color:var(--muted)">Chaos event log — waiting for activity…</span>
    </div>

    <div style="margin-top:12px;display:flex;gap:8px;justify-content:flex-end">
      <button class="btn btn-danger" onclick="resetAll()" style="padding:7px 16px;font-size:.75rem">
        ↺ Reset All Counters
      </button>
    </div>
  </div>

  <!-- ━━ REDIS LEADERBOARD ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
  <div class="card">
    <div class="card-header">
      <div class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
        </svg>
        Redis Shared Leaderboard
      </div>
    </div>
    <div id="leaderboard-rows">
      <div style="color:var(--muted);font-size:.82rem">Loading…</div>
    </div>
    <div style="margin-top:12px;font-size:.7rem;color:var(--muted)">
      State shared via Redis container on <code style="font-family:var(--font-mono);color:var(--info)">lab-net:6379</code>
    </div>
  </div>

  <!-- ━━ CI/CD PIPELINE STATUS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ -->
  <div class="card">
    <div class="card-header">
      <div class="card-title">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/>
        </svg>
        GitHub Actions CI/CD Pipeline
      </div>
      <span class="ci-badge passed">✓ All Checks Passed</span>
    </div>

    <div class="pipeline-stages" id="pipeline-stages">
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">Lint TF</div>
        </div>
      </div>
      <div class="pipeline-arrow"></div>
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">TF Validate</div>
        </div>
      </div>
      <div class="pipeline-arrow"></div>
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">Ansible Lint</div>
        </div>
      </div>
      <div class="pipeline-arrow"></div>
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">TF Apply</div>
        </div>
      </div>
      <div class="pipeline-arrow"></div>
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">Ansible Play</div>
        </div>
      </div>
      <div class="pipeline-arrow"></div>
      <div class="pipeline-stage">
        <div class="stage-block">
          <div class="stage-icon success">✓</div>
          <div class="stage-name">Health Check</div>
        </div>
      </div>
    </div>

    <div class="ci-info-row">
      <span>Branch: <code style="font-family:var(--font-mono);color:var(--info)">main</code> &nbsp;·&nbsp; Commit: <code style="font-family:var(--font-mono);color:var(--info)">a3f9c82</code></span>
      <span>Triggered by: <strong>git push → GitHub → SSH → VM</strong></span>
      <span style="color:var(--success)">▸ Deploy: 2m 14s</span>
    </div>

    <!-- Prometheus Metrics strip -->
    <div style="margin-top:14px;padding:10px 14px;background:#060a12;border:1px solid var(--border);border-radius:10px;font-family:var(--font-mono);font-size:.7rem;color:var(--muted)">
      <div style="color:var(--info);margin-bottom:4px"># PROMETHEUS METRICS — /metrics endpoint</div>
      <div id="prom-lines">infrasync_total_hits 0</div>
    </div>
  </div>

  <!-- Action Row -->
  <div class="action-row">
    <button class="btn btn-primary" onclick="recordHitAndReload()">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/>
      </svg>
      Send Next Request (Reload)
    </button>
    <a class="btn btn-secondary" id="haproxy-stats-btn" href="#" target="_blank">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M18 20V10M12 20V4M6 20v-6"/>
      </svg>
      HAProxy Stats (:8404)
    </a>
    <a class="btn btn-secondary" id="nagios-btn" href="#" target="_blank">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>
      </svg>
      Nagios Monitor
    </a>
    <a class="btn btn-secondary" id="metrics-btn" href="#" target="_blank">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
      </svg>
      /metrics (Prometheus)
    </a>
    <a class="btn btn-secondary" id="prom-ui-btn" href="#" target="_blank">
      Prometheus (:9090)
    </a>
    <a class="btn btn-secondary" id="grafana-btn" href="#" target="_blank">
      Grafana (:3000)
    </a>
  </div>

  <!-- Tech footer -->
  <div class="tech-footer">
    <div class="tech-pill">· Provisioning: <span>Terraform v1.6+</span></div>
    <div class="tech-pill">· Config Mgmt: <span>Ansible Core</span></div>
    <div class="tech-pill">· Monitoring: <span>Nagios Core 4</span></div>
    <div class="tech-pill">· Load Balancer: <span>HAProxy 2.8 LTS</span></div>
    <div class="tech-pill">· State Store: <span>Redis 7</span></div>
    <div class="tech-pill">· Control Plane: <span>Flask + Docker SDK</span></div>
    <div class="tech-pill">· OS: <span>Ubuntu 24.04 LTS</span></div>
  </div>

</div><!-- /wrapper -->

<!-- Toast -->
<div id="toast"></div>

<!-- ── Scripts ────────────────────────────────────────────────────────────── -->
<script>
  /* ── Constants ─────────────────────────────────────────────────────── */
  const NODE_NAME   = "${name}";
  const NODE_COLOR  = "${color}";
  const CP_PORT     = ${controlplane_port};
  const host        = window.location.hostname || "localhost";
  const CP_BASE     = `http://$${host}:$${CP_PORT}`;
  const NODES       = ["web1", "web2", "web3"];

  /* ── Session / boot ─────────────────────────────────────────────────── */
  document.getElementById("session-id").textContent =
    "#SYNC-" + String(Math.floor(1000 + Math.random() * 9000));

  document.getElementById("haproxy-stats-btn").href = `http://$${host}:8404/stats`;
  document.getElementById("nagios-btn").href         = `http://$${host}/nagios4`;
  document.getElementById("metrics-btn").href        = `$${CP_BASE}/metrics`;
  document.getElementById("prom-ui-btn").href        = `http://$${host}:9090`;
  document.getElementById("grafana-btn").href        = `http://$${host}:3000`;

  /* Active node chip */
  const activeChip = document.getElementById(`chip-$${NODE_NAME}`);
  if (activeChip) activeChip.classList.add("active");

  /* Clock */
  function updateClock() {
    document.getElementById("topbar-time").textContent =
      new Date().toLocaleTimeString("en-GB", { hour12: false });
  }
  setInterval(updateClock, 1000);
  updateClock();

  /* ── Toast helper ───────────────────────────────────────────────────── */
  let toastTimer;
  function toast(msg, type = "info") {
    const el = document.getElementById("toast");
    el.textContent = msg;
    el.className = `show $${type}`;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => el.classList.remove("show"), 3200);
  }

  /* ── Chart.js doughnut ──────────────────────────────────────────────── */
  const distCtx = document.getElementById("distChart").getContext("2d");
  const distChart = new Chart(distCtx, {
    type: "doughnut",
    data: {
      labels: NODES,
      datasets: [{
        data: [0, 0, 0],
        backgroundColor: ["rgba(59,130,246,0.75)", "rgba(16,185,129,0.75)", "rgba(245,158,11,0.75)"],
        borderColor:     ["#3b82f6", "#10b981", "#f59e0b"],
        borderWidth: 1.5,
        hoverOffset: 6,
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: "68%",
      plugins: {
        legend: {
          position: "right",
          labels: { color: "#94a3b8", font: { size: 11, family: "monospace" }, padding: 14, boxWidth: 12 }
        },
        tooltip: {
          callbacks: {
            label: ctx => ` $${ctx.label}: $${ctx.parsed} hits`
          }
        }
      }
    }
  });

  /* ── Fetch stats & update UI ────────────────────────────────────────── */
  async function fetchStats() {
    try {
      const r = await fetch(`$${CP_BASE}/api/stats`, { signal: AbortSignal.timeout(3000) });
      if (!r.ok) throw new Error("non-ok");
      const d = await r.json();

      /* Metrics tiles */
      const total     = d.total_hits || 0;
      const nodehits  = d.node_hits || {};
      const mine      = nodehits[NODE_NAME] || 0;
      const share     = total > 0 ? Math.round((mine / total) * 100) : 0;

      document.getElementById("m-total").textContent = total.toLocaleString();
      document.getElementById("m-node").textContent  = mine.toLocaleString();
      document.getElementById("m-share").textContent = share + "%";

      /* Cluster chips */
      NODES.forEach(n => {
        const chip  = document.getElementById(`chip-$${n}`);
        const dot   = chip.querySelector(".chip-dot");
        const label = chip.querySelector(".chip-status-text");
        const status = (d.nodes || {})[n];
        chip.classList.remove("active", "down");
        if (status === "running") {
          if (n === NODE_NAME) chip.classList.add("active");
          dot.style.background = n === NODE_NAME ? NODE_COLOR : "#10b981";
          dot.style.boxShadow  = `0 0 6px $${dot.style.background}`;
          label.textContent    = "UP";
          label.style.color    = "#34d399";
        } else {
          chip.classList.add("down");
          dot.style.background = "#ef4444";
          dot.style.boxShadow  = "none";
          label.textContent    = "DOWN";
          label.style.color    = "#f87171";
        }
      });

      /* Chart */
      const vals = NODES.map(n => nodehits[n] || 0);
      distChart.data.datasets[0].data = vals;
      distChart.update("none");

      /* Leaderboard */
      const sorted = [...NODES].sort((a, b) => (nodehits[b] || 0) - (nodehits[a] || 0));
      const maxH   = Math.max(1, ...sorted.map(n => nodehits[n] || 0));
      document.getElementById("leaderboard-rows").innerHTML = sorted.map((n, i) => {
        const h   = nodehits[n] || 0;
        const pct = Math.round((h / maxH) * 100);
        return `<div class="leaderboard-row">
          <div class="lb-rank">$${i + 1}</div>
          <div class="lb-name">$${n}</div>
          <div class="lb-bar-wrap"><div class="lb-bar" style="width:$${pct}%"></div></div>
          <div class="lb-count">$${h.toLocaleString()}</div>
        </div>`;
      }).join("");

      /* Prometheus strip */
      document.getElementById("prom-lines").innerHTML =
        `infrasync_total_hits $${total}<br>` +
        NODES.map(n => `infrasync_node_hits{node="$${n}"} $${nodehits[n]||0}`).join("<br>");

    } catch (_) { /* Control plane not reachable yet — silent */ }
  }

  /* ── Fetch control plane health ─────────────────────────────────────── */
  async function fetchCPHealth() {
    try {
      const r = await fetch(`$${CP_BASE}/health`, { signal: AbortSignal.timeout(2000) });
      const d = await r.json();
      const up = Math.floor(d.uptime);
      const h = Math.floor(up / 3600);
      const m = Math.floor((up % 3600) / 60);
      const s = up % 60;
      document.getElementById("m-cp-status").textContent   = "● Online";
      document.getElementById("m-cp-status").style.color   = "#34d399";
      document.getElementById("m-cp-uptime").textContent   =
        `Uptime: $${h}h $${String(m).padStart(2,"0")}m $${String(s).padStart(2,"0")}s`;
    } catch (_) {
      document.getElementById("m-cp-status").textContent = "⚠ Offline";
      document.getElementById("m-cp-status").style.color = "#f87171";
      document.getElementById("m-cp-uptime").textContent = "Control plane unreachable";
    }
  }

  /* ── Chaos Engineering ──────────────────────────────────────────────── */
  function buildChaosGrid(statusData) {
    const grid = document.getElementById("chaos-grid");
    grid.innerHTML = NODES.map(n => {
      const st  = (statusData || {})[n]?.status || "unknown";
      const isUp = st === "running";
      return `<div class="chaos-node" id="chaos-$${n}">
        <div class="chaos-node-name">$${n}</div>
        <div class="chaos-node-state $${isUp ? "running" : "stopped"}" id="cs-$${n}">
          $${isUp ? "● running" : "○ stopped"}
        </div>
        <div class="chaos-btns">
          <button class="btn-chaos-crash" id="cb-crash-$${n}"
            onclick="chaosAction('crash','$${n}')"
            $${!isUp ? "disabled" : ""}>
            💀 Crash
          </button>
          <button class="btn-chaos-revive" id="cb-revive-$${n}"
            onclick="chaosAction('revive','$${n}')"
            $${isUp ? "disabled" : ""}>
            ✦ Revive
          </button>
        </div>
      </div>`;
    }).join("");
  }

  async function fetchChaosStatus() {
    try {
      const r = await fetch(`$${CP_BASE}/api/chaos/status`, { signal: AbortSignal.timeout(3000) });
      const d = await r.json();
      buildChaosGrid(d.containers);

      /* Event log */
      const logEl = document.getElementById("chaos-log");
      if (d.recent_events && d.recent_events.length > 0) {
        logEl.innerHTML = d.recent_events.map(ev => {
          const t   = new Date(ev.ts * 1000).toLocaleTimeString();
          const cls = ev.action === "crash" ? "ev-crash" : "ev-revive";
          const ico = ev.action === "crash" ? "💀" : "✦";
          return `<div class="$${cls}">$${t} &nbsp; $${ico} $${ev.action.toUpperCase()} → $${ev.target}</div>`;
        }).join("");
      }
    } catch (_) {
      document.getElementById("chaos-grid").innerHTML =
        `<div style="color:var(--muted);font-size:.8rem;grid-column:1/-1;padding:12px 0">
          Control plane offline — chaos buttons unavailable</div>`;
    }
  }

  async function chaosAction(action, name) {
    const btn = document.getElementById(`cb-$${action}-$${name}`);
    if (btn) { btn.disabled = true; btn.textContent = "…"; }
    try {
      const r = await fetch(`$${CP_BASE}/api/chaos/$${action}/$${name}`, {
        method: "POST",
        signal: AbortSignal.timeout(5000)
      });
      const d = await r.json();
      if (d.ok) {
        toast(`$${name} $${action === "crash" ? "stopped 💀" : "revived ✦"}`, action === "crash" ? "error" : "success");
        await fetchChaosStatus();
        await fetchStats();
      } else {
        toast(`Error: $${d.error}`, "error");
      }
    } catch (e) {
      toast("Control plane unreachable", "error");
      if (btn) { btn.disabled = false; btn.textContent = action === "crash" ? "💀 Crash" : "✦ Revive"; }
    }
  }

  /* ── Reset all counters ─────────────────────────────────────────────── */
  async function resetAll() {
    if (!confirm("Reset all hit counters and chaos events?")) return;
    try {
      await fetch(`$${CP_BASE}/api/reset`, { method: "POST", signal: AbortSignal.timeout(3000) });
      toast("All counters reset ↺", "info");
      await fetchStats();
    } catch (_) { toast("Control plane unreachable", "error"); }
  }

  /* ── Record hit on this node then reload ────────────────────────────── */
  async function recordHitAndReload() {
    try {
      await fetch(`$${CP_BASE}/api/hit/$${NODE_NAME}`, {
        method: "POST",
        signal: AbortSignal.timeout(2000)
      });
    } catch (_) { /* silent — reload anyway */ }
    window.location.reload();
  }

  /* ── Boot sequence ──────────────────────────────────────────────────── */
  async function boot() {
    buildChaosGrid(null);
    await Promise.all([fetchStats(), fetchCPHealth(), fetchChaosStatus()]);

    /* Record a hit for this page load */
    try {
      await fetch(`$${CP_BASE}/api/hit/$${NODE_NAME}`, {
        method: "POST", signal: AbortSignal.timeout(2000)
      });
    } catch (_) {}

    /* Start uptime display */
    const start = Date.now();
    setInterval(() => {
      const s = Math.floor((Date.now() - start) / 1000);
      document.getElementById("uptime-display").textContent =
        `Page uptime: $${s}s`;
    }, 1000);
  }

  /* ── Polling ────────────────────────────────────────────────────────── */
  boot();
  setInterval(() => { fetchStats(); fetchChaosStatus(); fetchCPHealth(); }, 5000);
</script>

</body>
</html>
