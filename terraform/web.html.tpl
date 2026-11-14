<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InfraSync Node - ${name}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary: ${color};
      --bg: #090d16;
      --card-bg: rgba(18, 24, 38, 0.75);
      --card-border: rgba(255, 255, 255, 0.08);
      --card-hover: rgba(255, 255, 255, 0.12);
      --text: #f1f5f9;
      --text-muted: #94a3b8;
      --badge-bg: rgba(255, 255, 255, 0.05);
      --success: #10b981;
      --warning: #f59e0b;
      --danger: #ef4444;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
      background-color: var(--bg);
      background-image: 
        radial-gradient(circle at 15% 20%, rgba(${color}, 0.15) 0%, transparent 40%),
        radial-gradient(circle at 85% 80%, rgba(99, 102, 241, 0.12) 0%, transparent 40%),
        linear-gradient(to bottom, #090d16, #05070c);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 24px;
      overflow-x: hidden;
    }

    .container {
      width: 100%;
      max-width: 920px;
      animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(16px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Top Nav / Banner */
    .top-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      padding: 12px 20px;
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      backdrop-filter: blur(12px);
      border-radius: 16px;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 700;
      font-size: 1.1rem;
      letter-spacing: -0.02em;
    }

    .brand-logo {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      background: linear-gradient(135deg, ${color}, #6366f1);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 0 16px ${color}66;
    }

    .brand-logo svg {
      width: 18px;
      height: 18px;
      fill: #fff;
    }

    .pulse-pill {
      display: flex;
      align-items: center;
      gap: 8px;
      background: rgba(16, 185, 129, 0.12);
      border: 1px solid rgba(16, 185, 129, 0.3);
      padding: 6px 14px;
      border-radius: 999px;
      font-size: 0.82rem;
      font-weight: 600;
      color: #34d399;
    }

    .pulse-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #10b981;
      box-shadow: 0 0 8px #10b981;
      animation: pulse 1.8s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50% { opacity: 0.4; transform: scale(0.85); }
    }

    /* Hero Card */
    .hero-card {
      background: var(--card-bg);
      border: 1px solid var(--card-border);
      border-top: 4px solid ${color};
      backdrop-filter: blur(16px);
      border-radius: 24px;
      padding: 40px;
      box-shadow: 0 20px 40px -15px rgba(0,0,0,0.5), 0 0 30px ${color}1a;
      position: relative;
      margin-bottom: 24px;
    }

    .hero-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: ${color}20;
      border: 1px solid ${color}40;
      color: ${color};
      padding: 4px 12px;
      border-radius: 999px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      margin-bottom: 16px;
    }

    /* Exact H1 for test curl grep "<h1>" compatibility */
    h1 {
      font-size: 2.5rem;
      font-weight: 800;
      letter-spacing: -0.03em;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .node-highlight {
      color: ${color};
      text-shadow: 0 0 24px ${color}66;
    }

    .hero-subtitle {
      color: var(--text-muted);
      font-size: 1.05rem;
      margin-bottom: 28px;
      line-height: 1.6;
    }

    /* Metric Grid */
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 16px;
      margin-bottom: 28px;
    }

    .metric-card {
      background: var(--badge-bg);
      border: 1px solid var(--card-border);
      border-radius: 14px;
      padding: 16px;
      transition: all 0.2s ease;
    }

    .metric-card:hover {
      background: var(--card-hover);
      border-color: rgba(255,255,255,0.18);
      transform: translateY(-2px);
    }

    .metric-label {
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--text-muted);
      margin-bottom: 6px;
    }

    .metric-value {
      font-family: 'JetBrains Mono', monospace;
      font-size: 1.15rem;
      font-weight: 600;
      color: #fff;
    }

    /* Topology cluster status */
    .cluster-status {
      background: rgba(10, 14, 23, 0.6);
      border: 1px solid var(--card-border);
      border-radius: 16px;
      padding: 20px;
      margin-bottom: 24px;
    }

    .cluster-title {
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--text-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 14px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .cluster-nodes {
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    .node-chip {
      flex: 1;
      min-width: 130px;
      background: rgba(255,255,255,0.03);
      border: 1px solid rgba(255,255,255,0.08);
      padding: 12px 14px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .node-chip.active {
      background: ${color}15;
      border-color: ${color};
      box-shadow: 0 0 16px ${color}33;
    }

    .chip-indicator {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      background: #475569;
    }

    .node-chip.active .chip-indicator {
      background: ${color};
      box-shadow: 0 0 8px ${color};
    }

    .chip-info {
      display: flex;
      flex-direction: column;
    }

    .chip-name {
      font-weight: 700;
      font-size: 0.9rem;
    }

    .chip-port {
      font-family: 'JetBrains Mono', monospace;
      font-size: 0.75rem;
      color: var(--text-muted);
    }

    /* Actions / interactive button */
    .action-row {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      align-items: center;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 22px;
      border-radius: 12px;
      font-weight: 600;
      font-size: 0.9rem;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.2s ease;
      border: none;
    }

    .btn-primary {
      background: ${color};
      color: #fff;
      box-shadow: 0 8px 20px ${color}4d;
    }

    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 24px ${color}66;
      filter: brightness(1.1);
    }

    .btn-secondary {
      background: rgba(255, 255, 255, 0.08);
      color: #fff;
      border: 1px solid rgba(255, 255, 255, 0.12);
    }

    .btn-secondary:hover {
      background: rgba(255, 255, 255, 0.15);
      transform: translateY(-2px);
    }

    /* Footer info */
    .tech-stack {
      display: flex;
      justify-content: center;
      gap: 20px;
      flex-wrap: wrap;
      font-size: 0.8rem;
      color: var(--text-muted);
      margin-top: 16px;
      text-align: center;
    }

    .tech-pill {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .tech-pill span {
      color: #cbd5e1;
      font-weight: 600;
    }

    @media (max-width: 640px) {
      .hero-card { padding: 24px; }
      h1 { font-size: 1.8rem; }
      .metrics-grid { grid-template-columns: 1fr 1fr; }
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Top System Bar -->
    <div class="top-bar">
      <div class="brand">
        <div class="brand-logo">
          <svg viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>
        </div>
        <span>InfraSync DevOps Core</span>
      </div>
      <div class="pulse-pill">
        <div class="pulse-dot"></div>
        <span>HEALTHY &bull; 200 OK</span>
      </div>
    </div>

    <!-- Main Node Card -->
    <div class="hero-card">
      <div class="hero-badge">Serving Backend Node</div>
      
      <!-- H1 exactly matches required regex for automated checks -->
      <h1>Web Server: <span class="node-highlight">${name}</span></h1>
      
      <p class="hero-subtitle">
        Provisioned by <strong>Terraform</strong>. Monitored by <strong>Nagios Core</strong>. Load balanced via <strong>HAProxy</strong> with automatic remediation.
      </p>

      <!-- Real-time metrics grid -->
      <div class="metrics-grid">
        <div class="metric-card">
          <div class="metric-label">Container Name</div>
          <div class="metric-value">${name}</div>
        </div>
        <div class="metric-card">
          <div class="metric-label">Network Tier</div>
          <div class="metric-value">lab-net (Bridge)</div>
        </div>
        <div class="metric-card">
          <div class="metric-label">Health Probe</div>
          <div class="metric-value" style="color: #10b981;">check_http - OK</div>
        </div>
        <div class="metric-card">
          <div class="metric-label">Session ID</div>
          <div class="metric-value" id="requestId">#SYNC-0000</div>
        </div>
      </div>

      <!-- Cluster Nodes Overview -->
      <div class="cluster-status">
        <div class="cluster-title">
          <span>Active Load Balancing Cluster</span>
          <span style="font-size:0.75rem; text-transform:none;">Algorithm: Round Robin</span>
        </div>
        <div class="cluster-nodes">
          <div class="node-chip ${name == 'web1' ? 'active' : ''}">
            <div class="chip-indicator"></div>
            <div class="chip-info">
              <span class="chip-name">web1</span>
              <span class="chip-port">:8081</span>
            </div>
          </div>
          <div class="node-chip ${name == 'web2' ? 'active' : ''}">
            <div class="chip-indicator"></div>
            <div class="chip-info">
              <span class="chip-name">web2</span>
              <span class="chip-port">:8082</span>
            </div>
          </div>
          <div class="node-chip ${name == 'web3' ? 'active' : ''}">
            <div class="chip-indicator"></div>
            <div class="chip-info">
              <span class="chip-name">web3</span>
              <span class="chip-port">:8083</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="action-row">
        <button class="btn btn-primary" onclick="simulateRoundRobin()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/></svg>
          Send Next Request (Reload)
        </button>
        <a class="btn btn-secondary" href="http://" + window.location.hostname + ":8404/stats" id="statsBtn" target="_blank">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 20V10M12 20V4M6 20v-6"/></svg>
          HAProxy Stats (:8404)
        </a>
        <a class="btn btn-secondary" href="/nagios4" id="nagiosBtn" target="_blank">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/></svg>
          Nagios Monitor
        </a>
      </div>
    </div>

    <!-- Technical Specs Footer -->
    <div class="tech-stack">
      <div class="tech-pill">&bull; Provisioning: <span>Terraform v1.6+</span></div>
      <div class="tech-pill">&bull; Configuration: <span>Ansible Core</span></div>
      <div class="tech-pill">&bull; Monitoring: <span>Nagios Core 4</span></div>
      <div class="tech-pill">&bull; Proxy: <span>HAProxy 2.8 LTS</span></div>
      <div class="tech-pill">&bull; OS: <span>Ubuntu 24.04 LTS</span></div>
    </div>
  </div>

  <script>
    // Generate simulated dynamic request ID and timestamp
    document.getElementById('requestId').innerText = '#SYNC-' + Math.floor(1000 + Math.random() * 9000);

    // Setup dynamic links based on current hostname
    const host = window.location.hostname || 'localhost';
    document.getElementById('statsBtn').href = 'http://' + host + ':8404/stats';
    document.getElementById('nagiosBtn').href = 'http://' + host + '/nagios4';

    function simulateRoundRobin() {
      window.location.reload();
    }
  </script>
</body>
</html>
