<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim rsA,rsP
Set rsA=Consultar("SELECT ID_ALBUM,TITLE_ALBUM,RELEASE_YEAR,ALBUM_IMAGE_PATH FROM TBL_ALBUM ORDER BY TITLE_ALBUM")
Set rsP=Consultar("SELECT ID_PLAYLIST,TITLE,PHOTO,TYPE FROM TBL_PLAYLIST WHERE ID_USER="&SqlInt(UsuarioId())&" OR TYPE=0 ORDER BY TITLE")
RenderHeader "Tu biblioteca", "library"
%><div class="eyebrow">Coleccion personal</div><h1 class="page-title">Tu biblioteca</h1><p class="page-subtitle">Todo lo que quieres volver a escuchar.</p><div class="section-head"><h2 id="playlists">Tus playlists</h2><a href="nueva-playlist.asp">+ Crear playlist</a></div><div class="playlist-grid"><% If rsP.EOF Then %><div class="empty">Crea tu primera playlist.</div><% Else %><% Do While Not rsP.EOF %><a class="playlist-card" href="playlist.asp?id=<%=rsP("ID_PLAYLIST")%>"><img src="<%=Html(Portada(rsP("PHOTO")))%>" onerror="this.src='<%=BASE%>assets/img/cover-default.svg'" alt=""><div><h3><%=Html(rsP("TITLE"))%></h3><p><%=Html(IIf(rsP("TYPE")=1,"Privada","Publica"))%></p></div></a><% rsP.MoveNext:Loop %><% End If %></div><div class="section-head"><h2>Albumes guardados</h2></div><div class="card-grid"><% Do While Not rsA.EOF %><a class="music-card" href="album.asp?id=<%=rsA("ID_ALBUM")%>"><img class="cover" src="<%=Html(Portada(rsA("ALBUM_IMAGE_PATH")))%>" alt=""><div class="card-title"><%=Html(rsA("TITLE_ALBUM"))%></div><div class="card-sub"><%=Html(rsA("RELEASE_YEAR"))%></div></a><% rsA.MoveNext:Loop %></div><% RenderFooter %>
