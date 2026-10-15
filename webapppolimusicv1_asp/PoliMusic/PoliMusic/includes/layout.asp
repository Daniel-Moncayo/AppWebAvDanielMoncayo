<%
'=====================================================================
'  PoliMusic - layout compartido
'=====================================================================

Sub Icon(ByVal name)
    Select Case LCase(name)
        Case "home": Response.Write "<svg viewBox='0 0 24 24'><path d='m3 10 9-7 9 7v10a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1V10Z'/></svg>"
        Case "search": Response.Write "<svg viewBox='0 0 24 24'><circle cx='11' cy='11' r='7'/><path d='m20 20-4-4'/></svg>"
        Case "library": Response.Write "<svg viewBox='0 0 24 24'><path d='M4 5h16v14H4z'/><path d='M8 8h8M8 12h8M8 16h5'/></svg>"
        Case "heart": Response.Write "<svg viewBox='0 0 24 24'><path d='M20.8 8.7c0 5-8.8 10.2-8.8 10.2S3.2 13.7 3.2 8.7A4.7 4.7 0 0 1 12 6.2a4.7 4.7 0 0 1 8.8 2.5Z'/></svg>"
        Case "plus": Response.Write "<svg viewBox='0 0 24 24'><path d='M12 5v14M5 12h14'/></svg>"
        Case "settings": Response.Write "<svg viewBox='0 0 24 24'><path d='M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8Z'/><path d='m19.4 15 .1.1a2 2 0 0 1-2.8 2.8l-.1-.1a2 2 0 0 0-3.4 1.4v.2a2 2 0 0 1-4 0v-.2a2 2 0 0 0-3.4-1.4l-.1.1a2 2 0 0 1-2.8-2.8l.1-.1A2 2 0 0 0 1.7 12a2 2 0 0 0 1.3-3.4l-.1-.1a2 2 0 0 1 2.8-2.8l.1.1A2 2 0 0 0 9.2 4.4V4.2a2 2 0 0 1 4 0v.2a2 2 0 0 0 3.4 1.4l.1-.1a2 2 0 0 1 2.8 2.8l-.1.1A2 2 0 0 0 20.7 12 2 2 0 0 0 19.4 15Z'/></svg>"
        Case "admin": Response.Write "<svg viewBox='0 0 24 24'><path d='M12 3 4 6v5c0 5.2 3.4 8.5 8 10 4.6-1.5 8-4.8 8-10V6l-8-3Z'/><path d='m9 12 2 2 4-4'/></svg>"
        Case "logout": Response.Write "<svg viewBox='0 0 24 24'><path d='M10 5H5v14h5M14 8l4 4-4 4M18 12H9'/></svg>"
        Case "chevron": Response.Write "<svg viewBox='0 0 24 24'><path d='m9 18 6-6-6-6'/></svg>"
        Case "play": Response.Write "<svg viewBox='0 0 24 24'><path d='m8 5 11 7-11 7V5Z'/></svg>"
        Case "pause": Response.Write "<svg viewBox='0 0 24 24'><path d='M8 5v14M16 5v14'/></svg>"
        Case "prev": Response.Write "<svg viewBox='0 0 24 24'><path d='m19 5-9 7 9 7V5ZM6 5v14'/></svg>"
        Case "next": Response.Write "<svg viewBox='0 0 24 24'><path d='m5 5 9 7-9 7V5Zm13 0v14'/></svg>"
        Case "shuffle": Response.Write "<svg viewBox='0 0 24 24'><path d='M4 7h3c4 0 6 10 10 10h3M17 5l3 2-3 2M17 15l3 2-3 2M4 17h3c1.6 0 2.8-1 3.8-2.5M14.5 9.5C15.5 8 16.5 7 17 7h3'/></svg>"
        Case "repeat": Response.Write "<svg viewBox='0 0 24 24'><path d='M17 2l4 4-4 4M3 11V9a3 3 0 0 1 3-3h15M7 22l-4-4 4-4M21 13v2a3 3 0 0 1-3 3H3'/></svg>"
        Case "volume": Response.Write "<svg viewBox='0 0 24 24'><path d='M4 10v4h4l5 4V6l-5 4H4ZM17 9a5 5 0 0 1 0 6M19 6a9 9 0 0 1 0 12'/></svg>"
        Case "more": Response.Write "<svg viewBox='0 0 24 24'><circle cx='5' cy='12' r='1'/><circle cx='12' cy='12' r='1'/><circle cx='19' cy='12' r='1'/></svg>"
        Case "back": Response.Write "<svg viewBox='0 0 24 24'><path d='m15 18-6-6 6-6'/></svg>"
        Case "forward": Response.Write "<svg viewBox='0 0 24 24'><path d='m9 18 6-6-6-6'/></svg>"
        Case "upload": Response.Write "<svg viewBox='0 0 24 24'><path d='M12 16V4m0 0L7 9m5-5 5 5M5 15v4h14v-4'/></svg>"
        Case "edit": Response.Write "<svg viewBox='0 0 24 24'><path d='m4 16-.8 4.8L8 20l11.5-11.5a2.1 2.1 0 0 0-3-3L5 17Z'/></svg>"
        Case "trash": Response.Write "<svg viewBox='0 0 24 24'><path d='M5 7h14M10 11v6M14 11v6M8 7l1-3h6l1 3m-10 0 1 14h8l1-14'/></svg>"
    End Select
End Sub

Sub RenderHeader(ByVal titulo, ByVal activo)
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=Html(titulo)%> · PoliMusic</title>
<link rel="stylesheet" href="<%=BASE%>css/estilo.css">
</head>
<body>
<div class="app-shell">
<aside class="sidebar">
    <a class="brand" href="<%=BASE%>home.asp"><span class="brand-mark"><svg viewBox="0 0 24 24"><path d="M5 8c5-2 10-2 14 0M6 12c4-1.5 8-1.5 12 0M8 16c3-1 5-1 8 0" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/></svg></span><span>PoliMusic</span></a>
    <div class="nav-section">
        <div class="nav-label">Descubre</div>
        <a class="nav-link <%=IIf(activo="home","active","")%>" href="<%=BASE%>home.asp"><%Icon "home"%><span>Inicio</span></a>
        <a class="nav-link <%=IIf(activo="search","active","")%>" href="<%=BASE%>buscar.asp"><%Icon "search"%><span>Buscar</span></a>
        <a class="nav-link <%=IIf(activo="library","active","")%>" href="<%=BASE%>biblioteca.asp"><%Icon "library"%><span>Tu biblioteca</span></a>
    </div>
    <div class="nav-section">
        <div class="nav-label">Tu musica</div>
        <a class="nav-link <%=IIf(activo="liked","active","")%>" href="<%=BASE%>favoritos.asp"><%Icon "heart"%><span>Canciones que te gustan</span></a>
        <a class="nav-link" href="<%=BASE%>biblioteca.asp#playlists"><%Icon "plus"%><span>Crear playlist</span></a>
    </div>
    <% If EstaLogueado() And EsAdmin() Then %>
    <div class="nav-section">
        <div class="nav-label">Administracion</div>
        <a class="nav-link <%=IIf(activo="admin","active","")%>" href="<%=BASE%>admin/index.asp"><%Icon "admin"%><span>Panel de control</span></a>
    </div>
    <% End If %>
    <div class="sidebar-spacer"></div>
    <% If EstaLogueado() Then %>
    <div class="user-chip"><img class="avatar" src="<%=BASE%><%=Html(RutaRecurso(Session("PM_Imagen") & ""))%>" onerror="this.src='<%=BASE%>assets/img/avatar-default.svg'" alt=""><div class="user-meta"><div class="user-name"><%=Html(UsuarioNombre())%></div><div class="user-role"><%=Html(IIf(EsAdmin(),"Administrador","Usuario"))%></div></div></div>
    <% End If %>
</aside>
<main class="main">
<header class="topbar">
    <div class="history"><a class="round-btn" href="javascript:history.back()"><%Icon "back"%></a><a class="round-btn" href="javascript:history.forward()"><%Icon "forward"%></a></div>
    <form class="search" action="<%=BASE%>buscar.asp" method="get"><%Icon "search"%><input name="q" value="<%=Qs("q")%>" placeholder="¿Qué quieres escuchar?" autocomplete="off"></form>
    <div class="top-actions"><% If EstaLogueado() Then %><a href="<%=BASE%>logout.asp">Cerrar sesion</a><a class="profile-menu" href="<%=BASE%>perfil.asp"><img class="avatar" src="<%=BASE%><%=Html(RutaRecurso(Session("PM_Imagen") & ""))%>" onerror="this.src='<%=BASE%>assets/img/avatar-default.svg'" alt=""><%=Html(UsuarioNombre())%></a><% Else %><a href="<%=BASE%>login.asp">Iniciar sesion</a><a class="btn small" href="<%=BASE%>registro.asp">Registrarse</a><% End If %></div>
</header>
<div class="content">
<%
End Sub

Sub RenderFooter()
%>
</div>
</main>
</div>
<% If EstaLogueado() Then %>
<footer class="player" id="player" data-app-path="<%=APP_PATH%>">
    <div class="now-playing"><img id="player-cover" src="<%=BASE%>assets/img/cover-default.svg" alt=""><div class="now-copy"><div class="now-title" id="player-title">Selecciona una cancion</div><div class="now-artist" id="player-artist">PoliMusic</div></div><button class="heart-btn" id="player-like" type="button" aria-label="Me gusta"><%Icon "heart"%></button></div>
    <div class="transport"><div class="transport-buttons"><button type="button" id="shuffle" title="Aleatorio"><%Icon "shuffle"%></button><button type="button" id="prev" title="Anterior"><%Icon "prev"%></button><button type="button" id="play" class="main-play" title="Reproducir"><%Icon "play"%></button><button type="button" id="next" title="Siguiente"><%Icon "next"%></button><button type="button" id="repeat" title="Repetir"><%Icon "repeat"%></button></div><div class="progress-line"><span class="time" id="current-time">0:00</span><input class="range" id="progress" type="range" min="0" max="100" value="0"><span class="time" id="total-time">0:00</span></div></div>
    <div class="volume"><%Icon "volume"%><input class="range" id="volume" type="range" min="0" max="1" step=".01" value=".8"></div>
</footer>
<audio id="audio"></audio><div class="toast" id="toast"></div>
<script>window.POLIMUSIC_BASE='<%=BASE%>';window.POLIMUSIC_APP='<%=APP_PATH%>';</script><script src="<%=BASE%>js/app.js"></script>
<% End If %>
</body></html>
<%
End Sub
%>
