<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim id, rsP, rs, sql, nCanciones
id=IdSeguro(Request.QueryString("id"))
Set rsP=Consultar("SELECT TOP 1 ID_PLAYLIST,TITLE,PHOTO,TYPE,ID_USER FROM TBL_PLAYLIST WHERE ID_PLAYLIST="&SqlInt(id)&" AND (TYPE=0 OR ID_USER="&SqlInt(UsuarioId())&")")
RenderHeader "Playlist", "library"
If rsP.EOF Then %><div class="empty">Playlist no encontrada o no tienes acceso.</div><% Else
Set rs=Consultar("SELECT s.ID_SONG,s.SONG_NAME,s.SONG_PATH,s.PLAYS,ISNULL(a.ARTIST_NAME+' '+ISNULL(a.ARTIST_LASTNAME,''),'Artista PoliMusic') AS ARTIST_NAME,ISNULL(a.ARTIST_IMAGE,'') AS ARTIST_IMAGE FROM TBL_PLAYLIST_SONG ps INNER JOIN TBL_SONG s ON s.ID_SONG=ps.ID_SONG LEFT JOIN TBL_PLAYER p ON p.ID_SONG=s.ID_SONG LEFT JOIN TBL_ARTIST a ON a.ID_ARTIST=p.ID_ARTIST WHERE ps.ID_PLAYLIST="&SqlInt(id)&" ORDER BY s.SONG_NAME")
%><div class="eyebrow">Playlist <%=Html(IIf(rsP("TYPE")=1,"privada","publica"))%></div><h1 class="page-title"><%=Html(rsP("TITLE"))%></h1><p class="page-subtitle">Una seleccion para escuchar sin parar.</p><div class="table-wrap"><table><thead><tr><th>#</th><th>Cancion</th><th>Artista</th><th>Reproducciones</th><th></th></tr></thead><tbody><% Dim num, ar, an:num=0:Do While Not rs.EOF:num=num+1:ar=Portada(rs("ARTIST_IMAGE")):an=rs("ARTIST_NAME")&"" %><tr><td><%=num%></td><td><div class="mini-row"><img class="mini-cover" src="<%=Html(ar)%>" alt=""><div class="mini-info"><div class="mini-title"><%=Html(rs("SONG_NAME"))%></div><div class="mini-sub">PoliMusic</div></div></div></td><td><%=Html(an)%></td><td><span class="badge"><%=Html(rs("PLAYS"))%> plays</span></td><td><button class="btn small js-play-track" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=Html(rs("SONG_NAME"))%>" data-artist="<%=Html(an)%>" data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>" data-cover="<%=Html(ar)%>"><%Icon "play"%></button></td></tr><%rs.MoveNext:Loop%></tbody></table></div><% End If
RenderFooter
%>
