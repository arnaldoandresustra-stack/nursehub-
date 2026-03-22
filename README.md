<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>NurseHub — Comunidad de Enfermería y Especialidades</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  :root {
    --teal: #0a9396;--teal-light: #94d2bd;--teal-dark: #005f73;
    --cream: #f8f4ef;--coral: #ee9b00;
    --cardio: #c1121f;--cardio-light: #ffdad5;
    --hemo: #3a0ca3;--hemo-light: #e0d7ff;
    --dark: #1a1a2e;--mid: #3d3d5c;--soft: #7a7a99;
    --white: #ffffff;--border: #e8e3db;
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--cream); color:var(--dark); min-height:100vh; }

  nav {
    background:var(--dark); padding:0 2rem;
    display:flex; align-items:center; justify-content:space-between;
    height:64px; position:sticky; top:0; z-index:100;
    box-shadow:0 2px 20px rgba(0,0,0,0.3);
  }
  .logo { font-family:'DM Serif Display',serif; font-size:1.6rem; color:var(--white); display:flex; align-items:center; gap:.5rem; }
  .logo span { color:var(--teal-light); }
  .logo-icon { width:32px;height:32px;background:var(--teal);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:1rem; }
  .nav-right { display:flex; align-items:center; gap:1rem; }
  .lang-toggle { display:flex; background:rgba(255,255,255,0.1); border-radius:20px; overflow:hidden; }
  .lang-btn { padding:4px 12px;border:none;background:transparent;color:rgba(255,255,255,0.6);cursor:pointer;font-size:.8rem;font-family:'DM Sans',sans-serif;font-weight:500;transition:all .2s; }
  .lang-btn.active { background:var(--teal);color:white;border-radius:20px; }
  .btn-login { padding:8px 20px;background:transparent;border:1px solid rgba(255,255,255,0.3);color:white;border-radius:6px;cursor:pointer;font-family:'DM Sans',sans-serif;font-size:.85rem;transition:all .2s; }
  .btn-login:hover { background:rgba(255,255,255,0.1); }
  .btn-join { padding:8px 20px;background:var(--teal);border:none;color:white;border-radius:6px;cursor:pointer;font-family:'DM Sans',sans-serif;font-size:.85rem;font-weight:600;transition:all .2s; }
  .btn-join:hover { background:var(--teal-dark); }

  .hero {
    background:linear-gradient(135deg,var(--dark) 0%,#1b3a5c 50%,var(--teal-dark) 100%);
    padding:3.5rem 2rem 2.5rem; text-align:center; position:relative; overflow:hidden;
  }
  .hero::before { content:'';position:absolute;top:-50%;left:-50%;width:200%;height:200%;background:radial-gradient(ellipse at center,rgba(148,210,189,.07) 0%,transparent 60%);animation:pulse 6s ease-in-out infinite; }
  @keyframes pulse { 0%,100%{transform:scale(1)} 50%{transform:scale(1.1)} }
  .hero h1 { font-family:'DM Serif Display',serif;font-size:clamp(1.8rem,4vw,3rem);color:white;margin-bottom:.7rem;position:relative; }
  .hero h1 em { color:var(--teal-light);font-style:italic; }
  .hero p { color:rgba(255,255,255,.7);font-size:.95rem;max-width:520px;margin:0 auto 1.5rem;line-height:1.6;position:relative; }
  .hero-stats { display:flex;justify-content:center;gap:2rem;position:relative;flex-wrap:wrap; }
  .stat { text-align:center; }
  .stat-num { font-family:'DM Serif Display',serif;font-size:1.5rem;color:var(--teal-light); }
  .stat-label { font-size:.72rem;color:rgba(255,255,255,.5);text-transform:uppercase;letter-spacing:.05em; }

  .specialty-strip { background:var(--dark);border-top:1px solid rgba(255,255,255,.08);padding:.7rem 2rem;display:flex;gap:.8rem;overflow-x:auto;justify-content:center;flex-wrap:wrap; }
  .spec-badge { display:flex;align-items:center;gap:.4rem;padding:5px 14px;border-radius:20px;font-size:.78rem;font-weight:600;cursor:pointer;transition:all .2s;white-space:nowrap;border:1px solid transparent; }
  .spec-badge.cardio { background:rgba(193,18,31,.2);color:#ff8fa3;border-color:rgba(193,18,31,.3); }
  .spec-badge.cardio:hover { background:rgba(193,18,31,.35); }
  .spec-badge.hemo { background:rgba(58,12,163,.25);color:#c5b3ff;border-color:rgba(58,12,163,.3); }
  .spec-badge.hemo:hover { background:rgba(58,12,163,.4); }
  .spec-badge.icu { background:rgba(10,147,150,.2);color:var(--teal-light);border-color:rgba(10,147,150,.3); }
  .spec-badge.anest { background:rgba(238,155,0,.2);color:#ffd166;border-color:rgba(238,155,0,.3); }

  .tabs-bar { background:white;border-bottom:2px solid var(--border);padding:0 1rem;display:flex;gap:0;overflow-x:auto;position:sticky;top:64px;z-index:90; }
  .tab { padding:.9rem 1.2rem;border:none;background:transparent;font-family:'DM Sans',sans-serif;font-size:.85rem;font-weight:500;color:var(--soft);cursor:pointer;border-bottom:3px solid transparent;margin-bottom:-2px;white-space:nowrap;transition:all .2s;display:flex;align-items:center;gap:.35rem; }
  .tab:hover { color:var(--teal); }
  .tab.active { color:var(--teal-dark);border-bottom-color:var(--teal);font-weight:600; }
  .tab.tab-cardio.active { color:var(--cardio);border-bottom-color:var(--cardio); }
  .tab.tab-hemo.active { color:var(--hemo);border-bottom-color:var(--hemo); }
  .tab-new { font-size:.6rem;background:var(--coral);color:white;padding:1px 5px;border-radius:8px;font-weight:700;text-transform:uppercase; }

  .layout { max-width:1100px;margin:0 auto;padding:2rem;display:grid;grid-template-columns:1fr 300px;gap:2rem; }
  @media(max-width:768px){.layout{grid-template-columns:1fr}.sidebar{display:none}}

  .new-post-bar { background:white;border-radius:12px;padding:1rem 1.2rem;display:flex;align-items:center;gap:1rem;margin-bottom:1.5rem;border:1px solid var(--border);box-shadow:0 2px 8px rgba(0,0,0,.04); }
  .avatar-sm { width:38px;height:38px;border-radius:50%;background:linear-gradient(135deg,var(--teal),var(--teal-dark));display:flex;align-items:center;justify-content:center;color:white;font-weight:600;font-size:.9rem;flex-shrink:0; }
  .post-input-fake { flex:1;background:var(--cream);border:1px solid var(--border);border-radius:8px;padding:.7rem 1rem;color:var(--soft);font-family:'DM Sans',sans-serif;font-size:.9rem;cursor:pointer;transition:border-color .2s; }
  .post-input-fake:hover { border-color:var(--teal); }

  .filter-bar { display:flex;gap:.5rem;margin-bottom:1rem;flex-wrap:wrap; }
  .filter-chip { padding:5px 14px;border-radius:20px;border:1px solid var(--border);background:white;font-size:.8rem;cursor:pointer;font-family:'DM Sans',sans-serif;color:var(--mid);transition:all .2s; }
  .filter-chip:hover,.filter-chip.active { background:var(--teal);color:white;border-color:var(--teal); }

  .section-header { display:flex;align-items:center;gap:.8rem;padding:1rem 1.2rem;border-radius:12px;margin-bottom:1.2rem; }
  .section-header.cardio-header { background:linear-gradient(135deg,rgba(193,18,31,.08),rgba(193,18,31,.03));border:1px solid rgba(193,18,31,.15); }
  .section-header.hemo-header { background:linear-gradient(135deg,rgba(58,12,163,.08),rgba(58,12,163,.03));border:1px solid rgba(58,12,163,.15); }
  .section-header-icon { font-size:2rem; }
  .section-header-text h2 { font-family:'DM Serif Display',serif;font-size:1.2rem; }
  .section-header-text p { font-size:.82rem;color:var(--soft);margin-top:.2rem; }
  .cardio-header h2 { color:var(--cardio); }
  .hemo-header h2 { color:var(--hemo); }

  .expert-ribbon { display:inline-flex;align-items:center;gap:.3rem;font-size:.7rem;font-weight:700;padding:2px 10px;border-radius:10px;text-transform:uppercase;letter-spacing:.04em; }
  .expert-cardio { background:var(--cardio-light);color:var(--cardio); }
  .expert-hemo { background:var(--hemo-light);color:var(--hemo); }
  .expert-anest { background:#fff3cd;color:#8a5a00; }

  .post-card { background:white;border-radius:12px;border:1px solid var(--border);margin-bottom:1rem;overflow:hidden;transition:box-shadow .2s,transform .2s;box-shadow:0 2px 8px rgba(0,0,0,.04);animation:fadeUp .4s ease both; }
  @keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
  .post-card:hover { box-shadow:0 8px 24px rgba(10,147,150,.12);transform:translateY(-2px); }
  .post-card.cardio-card:hover { box-shadow:0 8px 24px rgba(193,18,31,.1); }
  .post-card.hemo-card:hover { box-shadow:0 8px 24px rgba(58,12,163,.1); }
  .post-card:nth-child(2){animation-delay:.05s}.post-card:nth-child(3){animation-delay:.1s}.post-card:nth-child(4){animation-delay:.15s}

  .post-inner { display:flex; }
  .vote-col { width:50px;background:var(--cream);display:flex;flex-direction:column;align-items:center;padding:1rem .5rem;gap:.3rem;flex-shrink:0; }
  .vote-col.cardio-vote { background:rgba(193,18,31,.05); }
  .vote-col.hemo-vote { background:rgba(58,12,163,.05); }
  .vote-btn { width:28px;height:28px;border:none;background:transparent;border-radius:4px;cursor:pointer;font-size:1rem;display:flex;align-items:center;justify-content:center;transition:all .2s;color:var(--soft); }
  .vote-btn:hover { background:var(--teal-light);color:var(--teal-dark); }
  .vote-btn.voted { color:var(--teal); }
  .vote-count { font-weight:700;font-size:.85rem;color:var(--mid); }

  .post-body { padding:1rem 1.2rem;flex:1; }
  .post-meta { display:flex;align-items:center;gap:.6rem;margin-bottom:.4rem;flex-wrap:wrap; }
  .section-tag { font-size:.7rem;font-weight:600;padding:3px 10px;border-radius:12px;text-transform:uppercase;letter-spacing:.04em; }
  .tag-qa { background:#ddf4f5;color:var(--teal-dark); }
  .tag-case { background:#ffeedd;color:#c05c00; }
  .tag-resource { background:#e8f5e9;color:#2e7d32; }
  .tag-news { background:#fce4ec;color:#c62828; }
  .tag-cardio { background:var(--cardio-light);color:var(--cardio); }
  .tag-hemo { background:var(--hemo-light);color:var(--hemo); }
  .post-author { font-size:.8rem;color:var(--soft); }
  .post-author strong { color:var(--mid); }
  .post-time { font-size:.75rem;color:#b0aec0; }
  .featured-badge { display:inline-flex;align-items:center;gap:.3rem;font-size:.72rem;color:var(--coral);font-weight:600;margin-bottom:.3rem; }
  .post-title { font-family:'DM Serif Display',serif;font-size:1.05rem;color:var(--dark);margin-bottom:.4rem;line-height:1.4;cursor:pointer; }
  .post-title:hover { color:var(--teal-dark); }
  .post-excerpt { font-size:.875rem;color:var(--soft);line-height:1.6;margin-bottom:.8rem; }
  .post-tags { display:flex;gap:.4rem;flex-wrap:wrap;margin-bottom:.8rem; }
  .tag-pill { font-size:.75rem;padding:3px 10px;border-radius:12px;background:var(--cream);color:var(--mid);border:1px solid var(--border);cursor:pointer; }
  .tag-pill:hover { border-color:var(--teal);color:var(--teal); }
  .post-actions { display:flex;gap:1rem;align-items:center; }
  .action-btn { display:flex;align-items:center;gap:.3rem;font-size:.8rem;color:var(--soft);cursor:pointer;padding:4px 8px;border-radius:6px;border:none;background:transparent;font-family:'DM Sans',sans-serif;transition:all .2s; }
  .action-btn:hover { background:var(--cream);color:var(--teal-dark); }

  .content-section { display:none; }
  .content-section.active { display:block; }

  .sidebar-card { background:white;border-radius:12px;border:1px solid var(--border);padding:1.2rem;margin-bottom:1rem;box-shadow:0 2px 8px rgba(0,0,0,.04); }
  .sidebar-title { font-family:'DM Serif Display',serif;font-size:1rem;color:var(--dark);margin-bottom:1rem;padding-bottom:.6rem;border-bottom:2px solid var(--teal-light); }
  .about-text { font-size:.85rem;color:var(--soft);line-height:1.6;margin-bottom:1rem; }
  .btn-full { width:100%;padding:10px;background:var(--teal);color:white;border:none;border-radius:8px;font-family:'DM Sans',sans-serif;font-weight:600;font-size:.9rem;cursor:pointer;transition:background .2s; }
  .btn-full:hover { background:var(--teal-dark); }
  .topic-list { display:flex;flex-direction:column;gap:.4rem; }
  .topic-item { display:flex;align-items:center;justify-content:space-between;padding:.5rem .7rem;border-radius:8px;cursor:pointer;transition:background .2s;font-size:.85rem; }
  .topic-item:hover { background:var(--cream); }
  .topic-name { display:flex;align-items:center;gap:.5rem;color:var(--mid); }
  .topic-count { font-size:.75rem;color:var(--soft);background:var(--cream);padding:2px 8px;border-radius:10px; }
  .top-user { display:flex;align-items:center;gap:.8rem;padding:.4rem 0; }
  .avatar-rank { width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:.85rem;color:white;flex-shrink:0; }
  .user-info { flex:1; }
  .user-name { font-size:.85rem;font-weight:600;color:var(--mid); }
  .user-pts { font-size:.75rem;color:var(--soft); }

  .perf-callout { background:linear-gradient(135deg,#1a1a2e,#2d1b4e);border-radius:12px;padding:1.2rem;border:1px solid rgba(197,179,255,.2);margin-bottom:1rem; }
  .perf-callout h3 { font-family:'DM Serif Display',serif;color:#c5b3ff;font-size:1rem;margin-bottom:.4rem;display:flex;align-items:center;gap:.5rem; }
  .perf-callout p { font-size:.8rem;color:rgba(255,255,255,.6);line-height:1.5; }

  .modal-overlay { display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:200;align-items:center;justify-content:center;backdrop-filter:blur(4px); }
  .modal-overlay.open { display:flex; }
  .modal { background:white;border-radius:16px;padding:2rem;width:90%;max-width:560px;animation:modalIn .3s ease;max-height:90vh;overflow-y:auto; }
  @keyframes modalIn{from{opacity:0;transform:scale(.95) translateY(20px)}to{opacity:1;transform:scale(1) translateY(0)}}
  .modal-title { font-family:'DM Serif Display',serif;font-size:1.4rem;color:var(--dark);margin-bottom:1.5rem; }
  .form-group { margin-bottom:1rem; }
  .form-label { display:block;font-size:.85rem;font-weight:600;color:var(--mid);margin-bottom:.4rem; }
  .form-input,.form-select,.form-textarea { width:100%;padding:.7rem 1rem;border:1.5px solid var(--border);border-radius:8px;font-family:'DM Sans',sans-serif;font-size:.9rem;color:var(--dark);background:var(--cream);transition:border-color .2s;outline:none; }
  .form-input:focus,.form-select:focus,.form-textarea:focus { border-color:var(--teal);background:white; }
  .form-textarea { min-height:100px;resize:vertical; }
  .modal-footer { display:flex;justify-content:flex-end;gap:.8rem;margin-top:1.5rem; }
  .btn-cancel { padding:10px 20px;background:transparent;border:1px solid var(--border);border-radius:8px;cursor:pointer;font-family:'DM Sans',sans-serif;color:var(--soft);transition:all .2s; }
  .btn-cancel:hover { border-color:var(--mid);color:var(--mid); }
  .btn-submit { padding:10px 24px;background:var(--teal);border:none;border-radius:8px;color:white;font-family:'DM Sans',sans-serif;font-weight:600;cursor:pointer;transition:background .2s; }
  .btn-submit:hover { background:var(--teal-dark); }
  .toast { position:fixed;bottom:2rem;right:2rem;background:var(--dark);color:white;padding:.8rem 1.5rem;border-radius:10px;font-size:.9rem;z-index:300;transform:translateY(100px);opacity:0;transition:all .3s; }
  .toast.show { transform:translateY(0);opacity:1; }
</style>
</head>
<body>

<nav>
  <div class="logo"><div class="logo-icon">🩺</div>Nurse<span>Hub</span></div>
  <div class="nav-right">
    <div class="lang-toggle">
      <button class="lang-btn active" onclick="setLang('es')">ES</button>
      <button class="lang-btn" onclick="setLang('en')">EN</button>
    </div>
    <button class="btn-login" onclick="showToast('🔐 Login próximamente')"><span class="es-txt">Entrar</span><span class="en-txt" style="display:none">Login</span></button>
    <button class="btn-join" onclick="openModal()"><span class="es-txt">Unirse</span><span class="en-txt" style="display:none">Join</span></button>
  </div>
</nav>

<div class="hero">
  <h1><em class="es-txt">Conocimiento clínico,</em><em class="en-txt" style="display:none">Clinical knowledge,</em><br><span class="es-txt">en comunidad</span><span class="en-txt" style="display:none">in community</span></h1>
  <p class="es-txt">Enfermería, perfusión, anestesia y especialidades críticas. Profesionales reales compartiendo conocimiento real.</p>
  <p class="en-txt" style="display:none">Nursing, perfusion, anesthesia and critical specialties. Real professionals sharing real knowledge.</p>
  <div class="hero-stats">
    <div class="stat"><div class="stat-num">2.4k</div><div class="stat-label es-txt">Miembros</div><div class="stat-label en-txt" style="display:none">Members</div></div>
    <div class="stat"><div class="stat-num">847</div><div class="stat-label es-txt">Publicaciones</div><div class="stat-label en-txt" style="display:none">Posts</div></div>
    <div class="stat"><div class="stat-num">6</div><div class="stat-label es-txt">Especialidades</div><div class="stat-label en-txt" style="display:none">Specialties</div></div>
    <div class="stat"><div class="stat-num">12</div><div class="stat-label es-txt">Países</div><div class="stat-label en-txt" style="display:none">Countries</div></div>
  </div>
</div>

<div class="specialty-strip">
  <div class="spec-badge cardio" onclick="switchTabById('cardio')">❤️ <span class="es-txt">Cirugía Cardiovascular</span><span class="en-txt" style="display:none">Cardiovascular Surgery</span></div>
  <div class="spec-badge hemo" onclick="switchTabById('hemo')">🫀 <span class="es-txt">Hemodinámica</span><span class="en-txt" style="display:none">Hemodynamics</span></div>
  <div class="spec-badge icu" onclick="switchTabById('qa')">🫀 UCI / Críticos</div>
  <div class="spec-badge anest" onclick="switchTabById('qa')">💉 <span class="es-txt">Anestesia</span><span class="en-txt" style="display:none">Anesthesia</span></div>
</div>

<div class="tabs-bar">
  <button class="tab active" id="tab-btn-qa" onclick="switchTabById('qa')">💬 Q&A</button>
  <button class="tab" id="tab-btn-cases" onclick="switchTabById('cases')">🩻 <span class="es-txt">Casos Clínicos</span><span class="en-txt" style="display:none">Cases</span></button>
  <button class="tab tab-cardio" id="tab-btn-cardio" onclick="switchTabById('cardio')">❤️ <span class="es-txt">Cir. Cardiovascular</span><span class="en-txt" style="display:none">Cardiovascular</span> <span class="tab-new">NEW</span></button>
  <button class="tab tab-hemo" id="tab-btn-hemo" onclick="switchTabById('hemo')">💧 <span class="es-txt">Hemodinámica</span><span class="en-txt" style="display:none">Hemodynamics</span> <span class="tab-new">NEW</span></button>
  <button class="tab" id="tab-btn-resources" onclick="switchTabById('resources')">📚 <span class="es-txt">Recursos</span><span class="en-txt" style="display:none">Resources</span></button>
  <button class="tab" id="tab-btn-news" onclick="switchTabById('news')">📰 <span class="es-txt">Noticias</span><span class="en-txt" style="display:none">News</span></button>
</div>

<div class="layout">
  <main>
    <div class="new-post-bar">
      <div class="avatar-sm">P</div>
      <div class="post-input-fake es-txt" onclick="openModal()">¿Qué querés compartir con la comunidad?</div>
      <div class="post-input-fake en-txt" style="display:none" onclick="openModal()">What do you want to share?</div>
    </div>
    <div class="filter-bar">
      <button class="filter-chip active" onclick="setFilter(this)"><span class="es-txt">Recientes</span><span class="en-txt" style="display:none">Recent</span></button>
      <button class="filter-chip" onclick="setFilter(this)"><span class="es-txt">Más votados</span><span class="en-txt" style="display:none">Top voted</span></button>
      <button class="filter-chip" onclick="setFilter(this)"><span class="es-txt">Sin respuesta</span><span class="en-txt" style="display:none">Unanswered</span></button>
      <button class="filter-chip" onclick="setFilter(this)"><span class="es-txt">Esta semana</span><span class="en-txt" style="display:none">This week</span></button>
    </div>

    <!-- Q&A -->
    <div id="tab-qa" class="content-section active">
      <div class="post-card">
        <div class="post-inner">
          <div class="vote-col"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">42</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-qa es-txt">Pregunta</span><span class="section-tag tag-qa en-txt" style="display:none">Question</span><span class="post-author"><strong>Lic. Martínez</strong></span><span class="post-time">• hace 2h</span></div>
            <div class="featured-badge">📌 <span class="es-txt">Destacado</span><span class="en-txt" style="display:none">Featured</span></div>
            <div class="post-title">¿Protocolo actualizado para úlceras por presión grado III en UCI?</div>
            <div class="post-excerpt">Trabajo en UCI con un paciente con UPP en región sacra. ¿Hay consenso actualizado sobre tipo de apósito y frecuencia de curación?</div>
            <div class="post-tags"><span class="tag-pill">#heridas</span><span class="tag-pill">#UCI</span><span class="tag-pill">#protocolos</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 8</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button><button class="action-btn" onclick="showToast('🔖 Guardado!')">🔖</button></div>
          </div>
        </div>
      </div>
      <div class="post-card">
        <div class="post-inner">
          <div class="vote-col"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">27</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-qa es-txt">Pregunta</span><span class="section-tag tag-qa en-txt" style="display:none">Question</span><span class="post-author"><strong>Enf. Rodríguez</strong></span><span class="post-time">• hace 5h</span></div>
            <div class="post-title">Insulina NPH vs Glargina — timing correcto en diabéticos tipo 2</div>
            <div class="post-excerpt">Recién empecé en endocrinología. ¿Cuál es el timing correcto de cada insulina? ¿Experiencia práctica?</div>
            <div class="post-tags"><span class="tag-pill">#diabetes</span><span class="tag-pill">#insulina</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 14</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>

    <!-- CASOS -->
    <div id="tab-cases" class="content-section">
      <div class="post-card">
        <div class="post-inner">
          <div class="vote-col"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">58</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-case es-txt">Caso Clínico</span><span class="section-tag tag-case en-txt" style="display:none">Clinical Case</span><span class="post-author"><strong>Lic. Vargas</strong></span><span class="post-time">• hace 3h</span></div>
            <div class="post-title">Post-quirúrgico con signos de sepsis temprana — ¿qué habrían hecho?</div>
            <div class="post-excerpt">Varón 67 años, 12h post-colecistectomía. FC 112, T° 38.7°C, PA 95/60. Apliqué bundle Sepsis-3 pero quiero otros criterios...</div>
            <div class="post-tags"><span class="tag-pill">#sepsis</span><span class="tag-pill">#postquirúrgico</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 22</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>

    <!-- CIRUGÍA CARDIOVASCULAR -->
    <div id="tab-cardio" class="content-section">
      <div class="section-header cardio-header">
        <div class="section-header-icon">❤️‍🩹</div>
        <div class="section-header-text">
          <h2 class="es-txt">Cirugía Cardiovascular & Perfusión</h2>
          <h2 class="en-txt" style="display:none">Cardiovascular Surgery & Perfusion</h2>
          <p class="es-txt">Espacio para perfusionistas, técnicos en CEC, anestesia cardiovascular y cirujanos</p>
          <p class="en-txt" style="display:none">Space for perfusionists, CPB techs, cardiovascular anesthesia and surgeons</p>
        </div>
      </div>
      <div class="post-card cardio-card">
        <div class="post-inner">
          <div class="vote-col cardio-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">74</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-cardio es-txt">Perfusión</span><span class="section-tag tag-cardio en-txt" style="display:none">Perfusion</span><span class="expert-ribbon expert-cardio">✦ Perfusionista</span><span class="post-author"><strong>Téc. Perf. González</strong></span><span class="post-time">• hace 1h</span></div>
            <div class="featured-badge">📌 <span class="es-txt">Destacado</span></div>
            <div class="post-title">Hipotermia moderada en CEC — ¿28°C o 32°C como estándar en bypass coronario?</div>
            <div class="post-excerpt">En nuestro servicio seguimos usando 28°C pero varios centros están migrando a normotermia. ¿Impacto real en protección miocárdica? ¿Experiencia de otros perfusionistas?</div>
            <div class="post-tags"><span class="tag-pill">#CEC</span><span class="tag-pill">#hipotermia</span><span class="tag-pill">#bypass</span><span class="tag-pill">#perfusión</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 18</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button><button class="action-btn" onclick="showToast('🔖 Guardado!')">🔖</button></div>
          </div>
        </div>
      </div>
      <div class="post-card cardio-card">
        <div class="post-inner">
          <div class="vote-col cardio-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">51</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-cardio es-txt">Caso CEC</span><span class="section-tag tag-cardio en-txt" style="display:none">CPB Case</span><span class="expert-ribbon expert-anest">💉 Téc. Anestesia</span><span class="post-author"><strong>T.A. Herrera</strong></span><span class="post-time">• hace 4h</span></div>
            <div class="post-title">Inducción anestésica en paciente con FE &lt; 25% para reemplazo valvular aórtico</div>
            <div class="post-excerpt">Paciente 72 años, estenosis aórtica severa con FE comprometida. ¿Qué agentes inductores usarían? ¿Ketamina en este escenario?</div>
            <div class="post-tags"><span class="tag-pill">#anestesia</span><span class="tag-pill">#valvular</span><span class="tag-pill">#FEreducida</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 31</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
      <div class="post-card cardio-card">
        <div class="post-inner">
          <div class="vote-col cardio-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">38</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-resource es-txt">Recurso</span><span class="section-tag tag-resource en-txt" style="display:none">Resource</span><span class="expert-ribbon expert-cardio">✦ Verificado</span><span class="post-author"><strong>Admin NurseHub</strong></span><span class="post-time">• hace 2d</span></div>
            <div class="post-title">Cardioplejia: comparativa Del Nido vs Buckberg vs HTK — evidencia actualizada</div>
            <div class="post-excerpt">Revisión de las principales soluciones cardiopléjicas en cirugía a corazón abierto. Composición, dosis, intervalos y outcomes comparados.</div>
            <div class="post-tags"><span class="tag-pill">#cardioplejia</span><span class="tag-pill">#DelNido</span><span class="tag-pill">#corazónabierto</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('📥 Próximamente')">📥 PDF</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>

    <!-- HEMODIÁLISIS -->
    <div id="tab-hemo" class="content-section">
      <div class="section-header hemo-header">
        <div class="section-header-icon">💧</div>
        <div class="section-header-text">
          <h2 class="es-txt">Hemodinámica & Soporte Circulatorio</h2>
          <h2 class="en-txt" style="display:none">Hemodynamics & Circulatory Support</h2>
          <p class="es-txt">Enfermeros y técnicos de hemodinámica, nefrólogos y especialistas en terapias de reemplazo renal</p>
          <p class="en-txt" style="display:none">Hemodynamic monitoring, circulatory support, shock management and critical cardiovascular care</p>
        </div>
      </div>
      <div class="post-card hemo-card">
        <div class="post-inner">
          <div class="vote-col hemo-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">63</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-hemo es-txt">Pregunta Técnica</span><span class="section-tag tag-hemo en-txt" style="display:none">Technical Q</span><span class="post-author"><strong>Enf. Hemodinámica Sosa</strong></span><span class="post-time">• hace 3h</span></div>
            <div class="featured-badge">📌 <span class="es-txt">Destacado</span></div>
            <div class="post-title">Hipotensión intrahemodinámica recurrente — ¿perfiles de ultrafiltración o temperatura del dializante?</div>
            <div class="post-excerpt">Paciente post-IAM con shock cardiogénico. Catéter de Swan-Ganz colocado. ¿Cómo interpretan los valores de PCP elevada con GC bajo? ¿Cuándo indican vasopresores vs inotrópicos?</div>
            <div class="post-tags"><span class="tag-pill">#hemodinámica</span><span class="tag-pill">#hipotensión</span><span class="tag-pill">#ultrafiltración</span><span class="tag-pill">#ERC</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 24</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button><button class="action-btn" onclick="showToast('🔖 Guardado!')">🔖</button></div>
          </div>
        </div>
      </div>
      <div class="post-card hemo-card">
        <div class="post-inner">
          <div class="vote-col hemo-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">44</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-hemo es-txt">Caso Clínico</span><span class="section-tag tag-hemo en-txt" style="display:none">Clinical Case</span><span class="post-author"><strong>Lic. Ramos</strong></span><span class="post-time">• hace 8h</span></div>
            <div class="post-title">Manejo del shock séptico con noradrenalina — ¿cuándo agregar vasopresina?</div>
            <div class="post-excerpt">Paciente séptico con PAM < 65 mmHg a pesar de noradrenalina a 0.5 mcg/kg/min. ¿En qué momento suman vasopresina? ¿Tienen protocolo definido en su UCI?</div>
            <div class="post-tags"><span class="tag-pill">#shockSéptico</span><span class="tag-pill">#noradrenalina</span><span class="tag-pill">#vasopresina</span><span class="tag-pill">#UCI</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 19</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
      <div class="post-card hemo-card">
        <div class="post-inner">
          <div class="vote-col hemo-vote"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">29</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-resource es-txt">Recurso</span><span class="section-tag tag-resource en-txt" style="display:none">Resource</span><span class="post-author"><strong>Admin NurseHub</strong></span><span class="post-time">• hace 3d</span></div>
            <div class="post-title">Guía de monitoreo hemodinámico no invasivo — PiCCO, NiCOM y ecocardiografía point-of-care</div>
            <div class="post-excerpt">Comparativa de métodos de monitoreo hemodinámico no invasivo disponibles en UCI. Indicaciones, limitaciones y correlación con Swan-Ganz.</div>
            <div class="post-tags"><span class="tag-pill">#PiCCO</span><span class="tag-pill">#ecocardiografía</span><span class="tag-pill">#monitoreo</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('📥 Próximamente')">📥 <span class="es-txt">Descargar</span><span class="en-txt" style="display:none">Download</span></button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>

    <!-- RECURSOS -->
    <div id="tab-resources" class="content-section">
      <div class="post-card">
        <div class="post-inner">
          <div class="vote-col"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">93</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-resource es-txt">Recurso</span><span class="section-tag tag-resource en-txt" style="display:none">Resource</span><span class="post-author"><strong>Admin NurseHub</strong></span></div>
            <div class="featured-badge">⭐ <span class="es-txt">Verificado</span><span class="en-txt" style="display:none">Verified</span></div>
            <div class="post-title">Cálculo de dosis pediátricas — Fórmulas y tablas 2024</div>
            <div class="post-excerpt">PDF con fórmulas, tablas de peso/dosis y ejemplos prácticos para farmacología pediátrica.</div>
            <div class="post-tags"><span class="tag-pill">#pediatría</span><span class="tag-pill">#farmacología</span><span class="tag-pill">#PDF</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('📥 Próximamente')">📥</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>

    <!-- NOTICIAS -->
    <div id="tab-news" class="content-section">
      <div class="post-card">
        <div class="post-inner">
          <div class="vote-col"><button class="vote-btn" onclick="vote(this,1)">▲</button><div class="vote-count">31</div><button class="vote-btn" onclick="vote(this,-1)">▼</button></div>
          <div class="post-body">
            <div class="post-meta"><span class="section-tag tag-news es-txt">Noticia</span><span class="section-tag tag-news en-txt" style="display:none">News</span><span class="post-author"><strong>Lic. Suárez</strong></span></div>
            <div class="post-title">OPS actualiza recomendaciones sobre higiene de manos en entornos hospitalarios 2025</div>
            <div class="post-excerpt">Nuevas guías que refuerzan los 5 momentos de higiene de manos con evidencia actualizada.</div>
            <div class="post-tags"><span class="tag-pill">#OPS</span><span class="tag-pill">#infecciones</span></div>
            <div class="post-actions"><button class="action-btn" onclick="showToast('💬 Próximamente')">💬 4</button><button class="action-btn" onclick="showToast('🔗 Copiado!')">🔗</button></div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <aside class="sidebar">
    <div class="perf-callout">
      <h3>🫀 <span class="es-txt">Espacio del Perfusionista</span><span class="en-txt" style="display:none">Perfusionist Space</span></h3>
      <p class="es-txt">Comunidad exclusiva para técnicos en CEC, perfusionistas y especialistas cardiovasculares. El único espacio en español dedicado a esta especialidad.</p>
      <p class="en-txt" style="display:none">Exclusive community for CPB techs, perfusionists and cardiovascular specialists.</p>
    </div>
    <div class="sidebar-card">
      <div class="sidebar-title">🩺 <span class="es-txt">Sobre NurseHub</span><span class="en-txt" style="display:none">About NurseHub</span></div>
      <div class="about-text es-txt">Comunidad bilingüe para enfermeros, perfusionistas, técnicos en anestesia y especialidades críticas.</div>
      <div class="about-text en-txt" style="display:none">Bilingual community for nurses, perfusionists, anesthesia techs and critical specialties.</div>
      <button class="btn-full" onclick="openModal()"><span class="es-txt">+ Crear publicación</span><span class="en-txt" style="display:none">+ Create post</span></button>
    </div>
    <div class="sidebar-card">
      <div class="sidebar-title">🏷️ <span class="es-txt">Especialidades</span><span class="en-txt" style="display:none">Specialties</span></div>
      <div class="topic-list">
        <div class="topic-item" onclick="switchTabById('cardio')"><span class="topic-name">❤️ <span class="es-txt">Cir. Cardiovascular</span><span class="en-txt" style="display:none">Cardiovascular</span></span><span class="topic-count">89</span></div>
        <div class="topic-item" onclick="switchTabById('hemo')"><span class="topic-name">💧 <span class="es-txt">Hemodinámica</span><span class="en-txt" style="display:none">Hemodynamics</span></span><span class="topic-count">67</span></div>
        <div class="topic-item"><span class="topic-name">💊 <span class="es-txt">Farmacología</span><span class="en-txt" style="display:none">Pharmacology</span></span><span class="topic-count">142</span></div>
        <div class="topic-item"><span class="topic-name">💉 <span class="es-txt">Anestesia</span><span class="en-txt" style="display:none">Anesthesia</span></span><span class="topic-count">74</span></div>
        <div class="topic-item"><span class="topic-name">🫀 UCI / <span class="es-txt">Críticos</span><span class="en-txt" style="display:none">Critical</span></span><span class="topic-count">98</span></div>
        <div class="topic-item"><span class="topic-name">🧠 <span class="es-txt">Neurología</span><span class="en-txt" style="display:none">Neurology</span></span><span class="topic-count">76</span></div>
      </div>
    </div>
    <div class="sidebar-card">
      <div class="sidebar-title">🏆 Top</div>
      <div class="top-user"><div class="avatar-rank" style="background:linear-gradient(135deg,#c1121f,#7d0000)">TP</div><div class="user-info"><div class="user-name">Téc. Perf. González</div><div class="user-pts">2.4k · Perfusionista</div></div></div>
      <div class="top-user"><div class="avatar-rank" style="background:linear-gradient(135deg,#f6c90e,#e8a000)">LM</div><div class="user-info"><div class="user-name">Lic. Martínez</div><div class="user-pts">2.1k pts</div></div></div>
      <div class="top-user"><div class="avatar-rank" style="background:linear-gradient(135deg,#3a0ca3,#7b2d8b)">ES</div><div class="user-info"><div class="user-name">Enf. Sosa</div><div class="user-pts">1.6k · Hemodinámica</div></div></div>
    </div>
  </aside>
</div>

<div class="modal-overlay" id="modal">
  <div class="modal">
    <div class="modal-title es-txt">Nueva publicación</div>
    <div class="modal-title en-txt" style="display:none">New post</div>
    <div class="form-group">
      <label class="form-label es-txt">Sección</label><label class="form-label en-txt" style="display:none">Section</label>
      <select class="form-select">
        <option>💬 Q&A</option>
        <option>🩻 Caso Clínico</option>
        <option>❤️ Cirugía Cardiovascular / Perfusión</option>
        <option>💧 Hemodinámica / Nefrología</option>
        <option>💉 Anestesia</option>
        <option>📚 Recurso / Guía</option>
        <option>📰 Noticia</option>
      </select>
    </div>
    <div class="form-group">
      <label class="form-label es-txt">Título</label><label class="form-label en-txt" style="display:none">Title</label>
      <input class="form-input" type="text" id="post-title" placeholder="Título de tu publicación...">
    </div>
    <div class="form-group">
      <label class="form-label es-txt">Contenido</label><label class="form-label en-txt" style="display:none">Content</label>
      <textarea class="form-textarea" id="post-content" placeholder="Desarrolla tu pregunta, caso o recurso..."></textarea>
    </div>
    <div class="form-group">
      <label class="form-label">Tags</label>
      <input class="form-input" type="text" placeholder="#CEC, #perfusión, #hemodinámica...">
    </div>
    <div class="modal-footer">
      <button class="btn-cancel" onclick="closeModal()"><span class="es-txt">Cancelar</span><span class="en-txt" style="display:none">Cancel</span></button>
      <button class="btn-submit" onclick="submitPost()"><span class="es-txt">Publicar</span><span class="en-txt" style="display:none">Post</span></button>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>

<script>
  let lang = 'es';
  function setLang(l) {
    lang = l;
    document.querySelectorAll('.lang-btn').forEach(b => b.classList.remove('active'));
    document.querySelector(`.lang-btn[onclick="setLang('${l}')"]`).classList.add('active');
    document.querySelectorAll('.es-txt').forEach(el => el.style.display = l==='es'?'':'none');
    document.querySelectorAll('.en-txt').forEach(el => el.style.display = l==='en'?'':'none');
  }
  function switchTabById(id) {
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    const btn = document.getElementById('tab-btn-'+id);
    if(btn) btn.classList.add('active');
    document.querySelectorAll('.content-section').forEach(s => s.classList.remove('active'));
    const sec = document.getElementById('tab-'+id);
    if(sec) sec.classList.add('active');
  }
  function setFilter(btn) {
    document.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    showToast(lang==='es'?'🔄 Filtrando...':'🔄 Filtering...');
  }
  function vote(btn, dir) {
    const col = btn.closest('.vote-col');
    const countEl = col.querySelector('.vote-count');
    let count = parseInt(countEl.textContent);
    const upBtn = col.querySelector('.vote-btn:first-child');
    const dnBtn = col.querySelector('.vote-btn:last-child');
    if(dir===1){if(upBtn.classList.contains('voted')){upBtn.classList.remove('voted');count--;}else{upBtn.classList.add('voted');dnBtn.classList.remove('voted');count++;}}
    else{if(dnBtn.classList.contains('voted')){dnBtn.classList.remove('voted');count++;}else{dnBtn.classList.add('voted');upBtn.classList.remove('voted');count--;}}
    countEl.textContent = count;
  }
  function openModal(){document.getElementById('modal').classList.add('open');}
  function closeModal(){document.getElementById('modal').classList.remove('open');}
  document.getElementById('modal').addEventListener('click',e=>{if(e.target===document.getElementById('modal'))closeModal();});
  function submitPost(){
    const title=document.getElementById('post-title').value.trim();
    if(!title){showToast(lang==='es'?'⚠️ Escribí un título primero':'⚠️ Write a title first');return;}
    closeModal();
    showToast(lang==='es'?'✅ ¡Publicación enviada! (demo)':'✅ Post submitted! (demo)');
    document.getElementById('post-title').value='';
    document.getElementById('post-content').value='';
  }
  function showToast(msg){const t=document.getElementById('toast');t.textContent=msg;t.classList.add('show');setTimeout(()=>t.classList.remove('show'),2800);}
</script>

  <!-- REGISTRATION BANNER -->
  <div id="reg-banner" style="position:fixed;bottom:0;left:0;right:0;background:linear-gradient(135deg,#005f73,#0a9396);padding:1rem 2rem;display:flex;align-items:center;justify-content:space-between;z-index:150;box-shadow:0 -4px 20px rgba(0,0,0,0.2);flex-wrap:wrap;gap:1rem;">
    <div>
      <div style="font-family:'DM Serif Display',serif;font-size:1.1rem;color:white;margin-bottom:.2rem;">🚀 <span class="es-txt">¡Sé parte del lanzamiento!</span><span class="en-txt" style="display:none">Be part of the launch!</span></div>
      <div style="font-size:.8rem;color:rgba(255,255,255,.75);" class="es-txt">Registrate gratis y recibí novedades antes que nadie</div>
      <div style="font-size:.8rem;color:rgba(255,255,255,.75);" class="en-txt" style="display:none">Register free and get updates before anyone else</div>
    </div>
    <div style="display:flex;gap:.6rem;align-items:center;flex-wrap:wrap;">
      <input id="reg-email" type="email" placeholder="tu@email.com" style="padding:.6rem 1rem;border-radius:8px;border:none;font-family:'DM Sans',sans-serif;font-size:.9rem;min-width:220px;outline:none;">
      <button onclick="registerEmail()" style="padding:.6rem 1.2rem;background:white;color:#005f73;border:none;border-radius:8px;font-family:'DM Sans',sans-serif;font-weight:700;cursor:pointer;font-size:.9rem;">
        <span class="es-txt">Registrarme</span><span class="en-txt" style="display:none">Register</span>
      </button>
      <button onclick="document.getElementById('reg-banner').style.display='none'" style="background:transparent;border:none;color:rgba(255,255,255,.6);cursor:pointer;font-size:1.2rem;">✕</button>
    </div>
  </div>
  <div style="height:80px"></div>

  <script>
    function registerEmail() {
      const email = document.getElementById('reg-email').value.trim();
      if (!email || !email.includes('@')) {
        showToast('⚠️ Ingresá un email válido');
        return;
      }
      document.getElementById('reg-banner').style.display = 'none';
      showToast('✅ ¡Registrado! Te avisamos cuando lancemos.');
    }
  </script>

</body>
</html>
