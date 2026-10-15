<!--#include file="../includes/core.asp"-->
<!--#include file="../includes/layout.asp"-->
<%
RequiereAdmin
BASE="../"
Dim rsSongs,rsUsers,rsAlbums,rsArtists
Set rsSongs=Consultar("SELECT COUNT(*) AS C FROM TBL_SONG")
Set rsUsers=Consultar("SELECT COUNT(*) AS C FROM TBL_USER")
Set rsAlbums=Consultar("SELECT COUNT(*) AS C FROM TBL_ALBUM")
Set rsArtists=Consultar("SELECT COUNT(*) AS C FROM TBL_ARTIST")
RenderHeader "Panel de control", "admin"
%><div class="eyebrow">Administracion</div><h1 class="page-title">Panel de control</h1><p class="page-subtitle">Gestiona el catalogo de PoliMusic.</p><div class="card-grid" style="grid-template-columns:repeat(auto-fit,minmax(170px,1fr));margin-bottom:28px"><a class="music-card" href="canciones.asp"><div class="eyebrow">Canciones</div><div style="font-size:32px;font-weight:800"><%=rsSongs("C")%></div><div class="card-sub">Gestionar catalogo</div></a><a class="music-card" href="usuarios.asp"><div class="eyebrow">Usuarios</div><div style="font-size:32px;font-weight:800"><%=rsUsers("C")%></div><div class="card-sub">Revisar cuentas</div></a><a class="music-card" href="albumes.asp"><div class="eyebrow">Albumes</div><div style="font-size:32px;font-weight:800"><%=rsAlbums("C")%></div><div class="card-sub">Gestionar albumes</div></a><a class="music-card" href="artistas.asp"><div class="eyebrow">Artistas</div><div style="font-size:32px;font-weight:800"><%=rsArtists("C")%></div><div class="card-sub">Gestionar artistas</div></a></div><div class="form-card"><h2 style="font-size:17px;margin:0 0 10px">Acciones rapidas</h2><p style="color:var(--muted);font-size:12px;line-height:1.7;margin:0 0 17px">Usa las secciones de abajo para actualizar los elementos que ven los usuarios.</p><div style="display:flex;flex-wrap:wrap;gap:10px"><a class="btn small" href="canciones.asp">Administrar canciones</a><a class="btn small secondary" href="albumes.asp">Administrar albumes</a><a class="btn small secondary" href="artistas.asp">Administrar artistas</a><a class="btn small secondary" href="usuarios.asp">Administrar usuarios</a></div></div><%RenderFooter%>
