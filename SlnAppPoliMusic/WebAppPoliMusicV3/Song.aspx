<%@ Page Title="Canciones" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV3.Song" %>

<asp:Content ID="SongContent" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        /* Todo el diseño esta encapsulado en .pm para no chocar con Bootstrap del Site.Master */
        .pm {
            --bg: #0b0713;
            --surface: #150e22;
            --surface-2: #1e1530;
            --hover: #2a1e42;
            --line: #2c2140;
            --text: #f4effc;
            --muted: #a99bc2;
            --accent: #a855f7;
            --accent-2: #c084fc;
            --accent-deep: #6d28d9;
            margin: 20px 0 110px 0;
            background: var(--bg);
            color: var(--text);
            border-radius: 12px;
            overflow: hidden;
            font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
            box-shadow: 0 10px 30px rgba(17, 8, 33, .25);
        }
        .pm * { box-sizing: border-box; }
        .pm button { font-family: inherit; }

        /* ---------- hero ---------- */
        .pm .hero {
            padding: 28px 28px 24px 28px;
            background: linear-gradient(180deg, #5b21b6 0%, #3b1680 55%, var(--bg) 100%);
            display: flex; align-items: flex-end; gap: 24px;
        }
        .pm .hero-cover {
            width: 170px; height: 170px; flex-shrink: 0; border-radius: 6px;
            background: linear-gradient(135deg, #7c3aed 0%, #c084fc 60%, #f0abfc 100%);
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5);
            display: flex; align-items: center; justify-content: center;
        }
        .pm .hero-cover svg { width: 70px; height: 70px; fill: #fff; }
        .pm .hero-info { flex: 1; min-width: 0; }
        .pm .kicker { font-size: 13px; font-weight: 700; }
        .pm .hero h1 { font-size: 64px; line-height: 1; margin: 8px 0 14px 0; letter-spacing: -2px; font-weight: 900; color: #fff; }
        .pm .meta { font-size: 14px; color: #e9ddff; }
        .pm .meta b { color: #fff; }
        .pm .greeting { font-size: 15px; color: #e9ddff; margin-bottom: 6px; }
        .pm .user-pill {
            align-self: flex-start;
            display: flex; align-items: center; gap: 8px;
            background: rgba(0, 0, 0, 0.45); border-radius: 999px;
            padding: 3px 14px 3px 3px; font-weight: 700; font-size: 14px; white-space: nowrap;
        }
        .pm .avatar {
            width: 30px; height: 30px; border-radius: 50%;
            background: var(--accent); color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 800; overflow: hidden; position: relative;
        }
        .pm .avatar img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }

        /* ---------- barra de acciones ---------- */
        .pm .actions {
            display: flex; align-items: center; gap: 18px; flex-wrap: wrap;
            padding: 20px 28px;
        }
        .pm .big-play {
            width: 56px; height: 56px; border-radius: 50%; border: none; cursor: pointer;
            background: var(--accent); display: flex; align-items: center; justify-content: center;
            box-shadow: 0 8px 18px rgba(168, 85, 247, 0.35); transition: transform .1s, background .1s;
        }
        .pm .big-play:hover { transform: scale(1.05); background: var(--accent-2); }
        .pm .big-play svg { width: 24px; height: 24px; fill: #12081f; }
        .pm .search { display: flex; gap: 8px; align-items: center; margin-left: auto; }
        .pm .search-box { position: relative; }
        .pm .search-box svg { position: absolute; left: 12px; top: 50%; margin-top: -9px; width: 18px; height: 18px; fill: var(--muted); }
        .pm .search input[type=text] {
            width: 280px; padding: 11px 14px 11px 40px; border-radius: 999px;
            border: 1px solid transparent; background: var(--surface-2); color: var(--text); font-size: 14px; outline: none;
        }
        .pm .search input[type=text]::placeholder { color: var(--muted); }
        .pm .search input[type=text]:focus { border-color: var(--accent); background: var(--hover); }
        .pm .pm-btn {
            padding: 10px 18px; border-radius: 999px; border: none; cursor: pointer;
            font-weight: 700; font-size: 13px; background: var(--accent); color: #12081f;
        }
        .pm .pm-btn:hover { background: var(--accent-2); }
        .pm .pm-btn.ghost { background: transparent; color: var(--muted); border: 1px solid var(--line); }
        .pm .pm-btn.ghost:hover { color: var(--text); border-color: var(--muted); }

        /* ---------- GridView de canciones ---------- */
        .pm .tracks { padding: 0 28px 28px 28px; }
        .pm .grid { width: 100%; border-collapse: collapse; table-layout: fixed; }
        .pm .grid th {
            text-align: left; font-size: 12px; font-weight: 600; letter-spacing: .08em; text-transform: uppercase;
            color: var(--muted); padding: 8px 12px; border-bottom: 1px solid var(--line);
        }
        .pm .grid th.c-num, .pm .grid td.c-num { width: 56px; text-align: center; }
        .pm .grid th.c-plays, .pm .grid td.c-plays { width: 160px; text-align: right; }
        .pm .grid th.c-dur, .pm .grid td.c-dur { width: 110px; text-align: right; }
        .pm .grid td { padding: 8px 12px; font-size: 14px; color: var(--muted); vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; border: none; }
        .pm .grid tr.track td:first-child { border-radius: 6px 0 0 6px; }
        .pm .grid tr.track td:last-child { border-radius: 0 6px 6px 0; }
        .pm .grid tr.track:hover td { background: var(--hover); }
        .pm .grid tr.track.active td { background: rgba(168, 85, 247, 0.14); }
        .pm .grid tr.track.active .t-name { color: var(--accent-2); }
        .pm .grid tr.track.unavailable { opacity: .45; }

        .pm .c-num .idx { display: inline-block; font-variant-numeric: tabular-nums; }
        .pm .row-play { display: none; background: none; border: none; cursor: pointer; padding: 0; }
        .pm .row-play svg { width: 16px; height: 16px; fill: var(--text); }
        .pm .row-play .i-pause { display: none; }
        .pm tr.track:hover .idx, .pm tr.track.is-playing .idx { display: none; }
        .pm tr.track:hover .row-play { display: inline-block; }
        .pm tr.track.is-playing .row-play .i-play { display: none; }
        .pm tr.track.is-playing .row-play .i-pause { display: inline; }
        .pm tr.track.is-playing .eq { display: inline-flex; }
        .pm tr.track.is-playing:hover .eq { display: none; }
        .pm tr.track.is-playing .row-play { display: none; }
        .pm tr.track.is-playing:hover .row-play { display: inline-block; }

        .pm .eq { display: none; gap: 2px; align-items: flex-end; height: 14px; }
        .pm .eq i { display: block; width: 3px; background: var(--accent-2); animation: pm-eq 0.9s ease-in-out infinite; }
        .pm .eq i:nth-child(2) { animation-delay: .2s; }
        .pm .eq i:nth-child(3) { animation-delay: .4s; }
        @keyframes pm-eq { 0%, 100% { height: 3px; } 50% { height: 14px; } }

        .pm .title-cell { display: flex; align-items: center; gap: 12px; min-width: 0; }
        .pm .title-cell > div:last-child { min-width: 0; }
        .pm .cover {
            width: 40px; height: 40px; border-radius: 4px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            color: rgba(255, 255, 255, .9); font-weight: 800; font-size: 17px;
        }
        .pm .c0 { background: linear-gradient(135deg, #7c3aed, #f0abfc); }
        .pm .c1 { background: linear-gradient(135deg, #4c1d95, #818cf8); }
        .pm .c2 { background: linear-gradient(135deg, #9333ea, #f472b6); }
        .pm .c3 { background: linear-gradient(135deg, #312e81, #a78bfa); }
        .pm .c4 { background: linear-gradient(135deg, #6d28d9, #22d3ee); }
        .pm .c5 { background: linear-gradient(135deg, #581c87, #fb7185); }
        .pm .t-name { color: var(--text); font-size: 15px; overflow: hidden; text-overflow: ellipsis; }
        .pm .t-artist { font-size: 13px; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
        .pm .pm-badge { display: none; font-size: 10px; text-transform: uppercase; letter-spacing: .06em; color: #fda4af; margin-left: 6px; }
        .pm tr.unavailable .pm-badge { display: inline; }

        .pm .empty { padding: 40px 0; text-align: center; color: var(--muted); }
        .pm .msg { display: block; color: #fda4af; padding: 0 28px 16px 28px; }

        /* ---------- reproductor fijo abajo ---------- */
        .pm .player {
            position: fixed; left: 0; right: 0; bottom: 0; z-index: 1030; height: 88px;
            display: grid; grid-template-columns: 30% 40% 30%; align-items: center;
            padding: 0 16px; background: #07040d; border-top: 1px solid var(--line);
        }
        .pm .np { display: flex; align-items: center; gap: 14px; min-width: 0; }
        .pm .np .cover { width: 56px; height: 56px; font-size: 22px; }
        .pm .np-cover.empty-cover { background: var(--surface-2); color: var(--muted); }
        .pm .np-title { font-size: 14px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .pm .np-artist { font-size: 12px; color: var(--muted); margin-top: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .pm .center { display: flex; flex-direction: column; align-items: center; gap: 6px; }
        .pm .ctrls { display: flex; align-items: center; gap: 20px; }
        .pm .ic { background: none; border: none; cursor: pointer; padding: 4px; color: var(--muted); display: flex; position: relative; }
        .pm .ic:hover { color: var(--text); }
        .pm .ic svg { width: 18px; height: 18px; fill: currentColor; }
        .pm .ic.on { color: var(--accent-2); }
        .pm .ic.on::after { content: ""; position: absolute; bottom: -4px; left: 50%; margin-left: -2px; width: 4px; height: 4px; border-radius: 50%; background: var(--accent-2); }
        .pm .play-main {
            width: 34px; height: 34px; border-radius: 50%; border: none; cursor: pointer;
            background: #fff; display: flex; align-items: center; justify-content: center; transition: transform .1s;
        }
        .pm .play-main:hover { transform: scale(1.06); }
        .pm .play-main svg { width: 16px; height: 16px; fill: #12081f; }
        .pm .i-pause-main { display: none; }
        .pm.playing .i-play-main { display: none; }
        .pm.playing .i-pause-main { display: inline; }
        .pm .bar { display: flex; align-items: center; gap: 8px; width: 100%; font-size: 11px; color: var(--muted); font-variant-numeric: tabular-nums; }
        .pm .bar span { width: 38px; text-align: center; }
        .pm .right { display: flex; justify-content: flex-end; align-items: center; gap: 8px; }
        .pm .right svg { width: 18px; height: 18px; fill: var(--muted); }

        .pm input[type=range].slider {
            -webkit-appearance: none; appearance: none; flex: 1; height: 4px; border-radius: 2px; outline: none; cursor: pointer;
            background: linear-gradient(to right, var(--text) 0%, var(--text) var(--p, 0%), #4a3d63 var(--p, 0%), #4a3d63 100%);
        }
        .pm input[type=range].slider:hover { background: linear-gradient(to right, var(--accent) 0%, var(--accent) var(--p, 0%), #4a3d63 var(--p, 0%), #4a3d63 100%); }
        .pm input[type=range].slider::-webkit-slider-thumb { -webkit-appearance: none; width: 12px; height: 12px; border-radius: 50%; background: #fff; opacity: 0; }
        .pm input[type=range].slider:hover::-webkit-slider-thumb { opacity: 1; }
        .pm input[type=range].slider::-moz-range-thumb { width: 12px; height: 12px; border: none; border-radius: 50%; background: #fff; }
        .pm #vol { flex: 0 0 110px; }

        .pm .pm-toast {
            position: fixed; left: 50%; bottom: 104px; transform: translateX(-50%) translateY(20px);
            background: var(--accent); color: #12081f; font-weight: 700; font-size: 13px;
            padding: 10px 18px; border-radius: 8px; opacity: 0; transition: all .25s; pointer-events: none; z-index: 1040;
        }
        .pm .pm-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

        /* ---------- responsive ---------- */
        @media (max-width: 900px) {
            .pm .player { grid-template-columns: 1fr auto; gap: 12px; }
            .pm .right { display: none; }
            .pm .hero h1 { font-size: 42px; letter-spacing: -1px; }
            .pm .hero-cover { width: 110px; height: 110px; }
            .pm .grid .c-album, .pm .grid .c-plays { display: none; }
        }
        @media (max-width: 600px) {
            .pm .hero { flex-direction: column; align-items: flex-start; }
            .pm .search { margin-left: 0; width: 100%; }
            .pm .search-box, .pm .search input[type=text] { width: 100%; }
            .pm .search-box { flex: 1; }
            .pm .grid .c-dur { display: none; }
            .pm .center .bar { display: none; }
            .pm #btnShuffle, .pm #btnRepeat { display: none; }
            .pm .ctrls { gap: 12px; }
            .pm .tracks, .pm .actions, .pm .hero { padding-left: 16px; padding-right: 16px; }
        }
    </style>

    <div class="pm" id="pm">

        <!-- ================= ENCABEZADO ================= -->
        <section class="hero">
            <div class="hero-cover">
                <svg viewBox="0 0 24 24"><path d="M12 3v10.55A4 4 0 1 0 14 17V7h4V3h-6z" /></svg>
            </div>
            <div class="hero-info">
                <div class="greeting"><asp:Literal ID="litGreeting" runat="server" /></div>
                <div class="kicker">Playlist</div>
                <h1>Canciones</h1>
                <div class="meta"><b>PoliMusic</b> &middot; <asp:Literal ID="litCount" runat="server" /> canciones</div>
            </div>
            <div class="user-pill" title="Usuario en sesión">
                <span class="avatar">
                    <asp:Literal ID="litAvatarInitial" runat="server" />
                    <asp:Image ID="imgUser" runat="server" Visible="false" AlternateText="" />
                </span>
                <asp:Label ID="lblUser" runat="server" />
            </div>
        </section>

        <!-- ================= ACCIONES / BUSQUEDA ================= -->
        <div class="actions">
            <button type="button" class="big-play" id="btnBigPlay" title="Reproducir">
                <svg class="i-play-main" viewBox="0 0 24 24"><path d="M7 4v16l13-8z" /></svg>
                <svg class="i-pause-main" viewBox="0 0 24 24"><path d="M6 4h4v16H6zM14 4h4v16h-4z" /></svg>
            </button>

            <asp:Panel ID="pnlSearch" runat="server" CssClass="search" DefaultButton="btnSearch">
                <div class="search-box">
                    <svg viewBox="0 0 24 24"><path d="M10.5 3a7.5 7.5 0 0 1 5.96 12.05l4.74 4.74-1.41 1.41-4.74-4.74A7.5 7.5 0 1 1 10.5 3zm0 2a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11z" /></svg>
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Buscar canción, artista o álbum" MaxLength="50"></asp:TextBox>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Buscar" CssClass="pm-btn" OnClick="BtnSearch_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Limpiar" CssClass="pm-btn ghost" OnClick="BtnClear_Click" />
            </asp:Panel>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="msg" EnableViewState="false" />

        <!-- ================= GRIDVIEW DE CANCIONES ================= -->
        <div class="tracks">
            <asp:GridView ID="gvSongs" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid"
                GridLines="None"
                CellSpacing="0"
                DataKeyNames="ID_SONG"
                OnRowDataBound="GvSongs_RowDataBound">
                <Columns>
                    <asp:TemplateField HeaderText="#">
                        <HeaderStyle CssClass="c-num" />
                        <ItemStyle CssClass="c-num" />
                        <ItemTemplate>
                            <span class="idx"><%# Container.DataItemIndex + 1 %></span>
                            <button type="button" class="row-play" title="Reproducir">
                                <svg class="i-play" viewBox="0 0 24 24"><path d="M7 4v16l13-8z" /></svg>
                                <svg class="i-pause" viewBox="0 0 24 24"><path d="M6 4h4v16H6zM14 4h4v16h-4z" /></svg>
                            </button>
                            <span class="eq"><i></i><i></i><i></i></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Título">
                        <ItemTemplate>
                            <div class="title-cell">
                                <div class="cover <%# CoverClass(Eval("ID_SONG")) %>"><%# Initial(Eval("SONG_NAME")) %></div>
                                <div>
                                    <div class="t-name"><%# Html(Eval("SONG_NAME")) %><span class="pm-badge">archivo no encontrado</span></div>
                                    <div class="t-artist"><%# Html(Eval("ARTISTS")) %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Álbum">
                        <HeaderStyle CssClass="c-album" />
                        <ItemStyle CssClass="c-album" />
                        <ItemTemplate><%# Html(Eval("ALBUM")) %></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Reproducciones">
                        <HeaderStyle CssClass="c-plays" />
                        <ItemStyle CssClass="c-plays" />
                        <ItemTemplate><span class="plays"><%# Eval("PLAYS") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Duración">
                        <HeaderStyle CssClass="c-dur" />
                        <ItemStyle CssClass="c-dur" />
                        <ItemTemplate><span class="dur">--:--</span></ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty">No se encontraron canciones. Prueba con otra búsqueda.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <!-- ================= REPRODUCTOR ================= -->
        <div class="player">
            <div class="np">
                <div class="cover np-cover empty-cover" id="npCover">&#9835;</div>
                <div style="min-width: 0">
                    <div class="np-title" id="npTitle">Elige una canción</div>
                    <div class="np-artist" id="npArtist">PoliMusic</div>
                </div>
            </div>
            <div class="center">
                <div class="ctrls">
                    <button type="button" class="ic" id="btnShuffle" title="Aleatorio">
                        <svg viewBox="0 0 24 24"><path d="M16 3h5v5l-1.8-1.8-4.4 4.4-1.4-1.4 4.4-4.4L16 3zM3 5.4 4.4 4l15.6 15.6V16h1v5h-5v-1h3.6L3 5.4zm6.2 7.8 1.4 1.4-5.2 5.2L4 18.4l5.2-5.2z" /></svg>
                    </button>
                    <button type="button" class="ic" id="btnPrev" title="Anterior">
                        <svg viewBox="0 0 24 24"><path d="M6 5h2v14H6zM20 5v14L9 12z" /></svg>
                    </button>
                    <button type="button" class="play-main" id="btnPlay" title="Reproducir / Pausar">
                        <svg class="i-play-main" viewBox="0 0 24 24"><path d="M7 4v16l13-8z" /></svg>
                        <svg class="i-pause-main" viewBox="0 0 24 24"><path d="M6 4h4v16H6zM14 4h4v16h-4z" /></svg>
                    </button>
                    <button type="button" class="ic" id="btnNext" title="Siguiente">
                        <svg viewBox="0 0 24 24"><path d="M16 5h2v14h-2zM4 5v14l11-7z" /></svg>
                    </button>
                    <button type="button" class="ic" id="btnRepeat" title="Repetir">
                        <svg viewBox="0 0 24 24"><path d="M7 7h10v3l4-4-4-4v3H5v6h2V7zm10 10H7v-3l-4 4 4 4v-3h12v-6h-2v4z" /></svg>
                    </button>
                </div>
                <div class="bar">
                    <span id="tCur">0:00</span>
                    <input type="range" class="slider" id="seek" min="0" max="1000" value="0" />
                    <span id="tDur">0:00</span>
                </div>
            </div>
            <div class="right">
                <svg viewBox="0 0 24 24"><path d="M3 9v6h4l5 5V4L7 9H3zm13.5 3A4.5 4.5 0 0 0 14 8v8a4.5 4.5 0 0 0 2.5-4zM14 3.2v2.1a7 7 0 0 1 0 13.4v2.1a9 9 0 0 0 0-17.6z" /></svg>
                <input type="range" class="slider" id="vol" min="0" max="100" value="80" />
            </div>
            <audio id="audio" preload="none"></audio>
        </div>

        <div class="pm-toast" id="pmToast"></div>
    </div>

    <script type="text/javascript">
        (function () {
            var pm = document.getElementById('pm');
            var audio = document.getElementById('audio');
            var rows = Array.prototype.slice.call(pm.querySelectorAll('tr.track'));
            var seek = document.getElementById('seek');
            var vol = document.getElementById('vol');
            var npTitle = document.getElementById('npTitle');
            var npArtist = document.getElementById('npArtist');
            var npCover = document.getElementById('npCover');
            var tCur = document.getElementById('tCur');
            var tDur = document.getElementById('tDur');
            var btnShuffle = document.getElementById('btnShuffle');
            var btnRepeat = document.getElementById('btnRepeat');
            var toastEl = document.getElementById('pmToast');
            var current = -1, shuffle = false, repeat = false, counted = false, seeking = false, toastTimer = null;

            function fmt(s) {
                if (!isFinite(s) || s < 0) return '0:00';
                var m = Math.floor(s / 60), x = Math.floor(s % 60);
                return m + ':' + (x < 10 ? '0' : '') + x;
            }
            function paint(range) {
                var p = (range.value - range.min) / (range.max - range.min) * 100;
                range.style.setProperty('--p', p + '%');
            }
            function toast(text) {
                toastEl.textContent = text;
                toastEl.className = 'pm-toast show';
                clearTimeout(toastTimer);
                toastTimer = setTimeout(function () { toastEl.className = 'pm-toast'; }, 2800);
            }
            function refreshUI() {
                var playing = !audio.paused && current >= 0;
                for (var i = 0; i < rows.length; i++) {
                    rows[i].classList.toggle('active', i === current);
                    rows[i].classList.toggle('is-playing', i === current && playing);
                }
                pm.classList.toggle('playing', playing);
            }
            function firstAvailable(from) {
                for (var k = 0; k < rows.length; k++) {
                    var i = (from + k) % rows.length;
                    if (!rows[i].classList.contains('unavailable')) return i;
                }
                return -1;
            }
            function load(i) {
                if (i < 0 || i >= rows.length) return;
                var r = rows[i];
                current = i;
                counted = false;
                audio.src = r.getAttribute('data-src');
                npTitle.textContent = r.getAttribute('data-title');
                npArtist.textContent = r.getAttribute('data-artist');
                npCover.className = 'cover np-cover ' + r.getAttribute('data-cover');
                npCover.textContent = r.getAttribute('data-title').charAt(0).toUpperCase();
                seek.value = 0; paint(seek);
                tCur.textContent = '0:00';
                tDur.textContent = r.querySelector('.dur').textContent.replace('--:--', '0:00');
                var p = audio.play();
                if (p && p.catch) { p.catch(function () { }); }
                refreshUI();
            }
            function toggle() {
                if (current < 0) {
                    var i = firstAvailable(0);
                    if (i < 0) { toast('No hay canciones disponibles para reproducir'); return; }
                    load(i);
                    return;
                }
                if (audio.paused) { audio.play(); } else { audio.pause(); }
            }
            function next(auto) {
                if (!rows.length) return;
                var i;
                if (shuffle && rows.length > 1) {
                    do { i = Math.floor(Math.random() * rows.length); } while (i === current);
                } else {
                    i = current + 1;
                    if (i >= rows.length) {
                        if (auto && !repeat) { audio.pause(); refreshUI(); return; }
                        i = 0;
                    }
                }
                var target = firstAvailable(i);
                if (target >= 0) load(target);
            }
            function prev() {
                if (audio.currentTime > 3 || current <= 0) { audio.currentTime = 0; return; }
                load(current - 1);
            }

            // ---- filas del GridView ----
            rows.forEach(function (r, i) {
                r.querySelector('.row-play').addEventListener('click', function (e) {
                    e.stopPropagation();
                    if (i === current) { toggle(); } else { load(i); }
                });
                r.addEventListener('dblclick', function () { load(i); });

                // Duracion de cada cancion (solo metadatos) y deteccion de archivos faltantes
                var probe = new Audio();
                probe.preload = 'metadata';
                probe.addEventListener('loadedmetadata', function () {
                    r.querySelector('.dur').textContent = fmt(probe.duration);
                });
                probe.addEventListener('error', function () {
                    r.classList.add('unavailable');
                });
                probe.src = r.getAttribute('data-src');
            });

            // ---- controles ----
            document.getElementById('btnPlay').addEventListener('click', toggle);
            document.getElementById('btnBigPlay').addEventListener('click', toggle);
            document.getElementById('btnNext').addEventListener('click', function () { next(false); });
            document.getElementById('btnPrev').addEventListener('click', prev);
            btnShuffle.addEventListener('click', function () { shuffle = !shuffle; btnShuffle.classList.toggle('on', shuffle); });
            btnRepeat.addEventListener('click', function () { repeat = !repeat; btnRepeat.classList.toggle('on', repeat); });

            seek.addEventListener('input', function () {
                seeking = true; paint(seek);
                if (audio.duration) tCur.textContent = fmt(seek.value / 1000 * audio.duration);
            });
            seek.addEventListener('change', function () {
                if (audio.duration) audio.currentTime = seek.value / 1000 * audio.duration;
                seeking = false;
            });

            var savedVol = 80;
            try { var v = localStorage.getItem('polimusic.vol'); if (v !== null) savedVol = parseInt(v, 10); } catch (e) { }
            vol.value = savedVol; audio.volume = savedVol / 100; paint(vol);
            vol.addEventListener('input', function () {
                audio.volume = vol.value / 100; paint(vol);
                try { localStorage.setItem('polimusic.vol', vol.value); } catch (e) { }
            });

            // ---- eventos del <audio> ----
            audio.addEventListener('play', refreshUI);
            audio.addEventListener('pause', refreshUI);
            audio.addEventListener('ended', function () { next(true); });
            audio.addEventListener('loadedmetadata', function () { tDur.textContent = fmt(audio.duration); });
            audio.addEventListener('timeupdate', function () {
                if (seeking || !audio.duration) return;
                seek.value = Math.round(audio.currentTime / audio.duration * 1000); paint(seek);
                tCur.textContent = fmt(audio.currentTime);
            });
            audio.addEventListener('playing', function () {
                // Suma una reproduccion en TBL_SONG.PLAYS (callback al servidor, sin recargar la pagina)
                if (counted || current < 0) return;
                counted = true;
                if (typeof registerPlay === 'function') {
                    registerPlay(rows[current].getAttribute('data-id'), current);
                }
            });
            audio.addEventListener('error', function () {
                if (current < 0 || !audio.getAttribute('src')) return;
                rows[current].classList.add('unavailable');
                toast('"' + rows[current].getAttribute('data-title') + '" - no se encontró el archivo de audio');
                refreshUI();
            });

            // Barra espaciadora = play/pausa (excepto cuando se escribe en el buscador)
            document.addEventListener('keydown', function (e) {
                var tag = (e.target.tagName || '').toLowerCase();
                if (e.keyCode === 32 && tag !== 'input' && tag !== 'textarea' && tag !== 'button') {
                    e.preventDefault(); toggle();
                }
            });

            // Respuesta del callback de reproducciones
            window.PoliMusic = {
                onPlayRegistered: function (result, context) {
                    var parts = String(result).split('|');
                    var r = rows[context];
                    if (r && parts.length === 2) { r.querySelector('.plays').textContent = parts[1]; }
                },
                onPlayError: function () { }
            };

            paint(seek);
        })();
    </script>
</asp:Content>
