<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim id,rsA,rs
id=IdSeguro(Request.QueryString("id"))
Set rsA=Consultar("SELECT TOP 1 ID_ALBUM,TITLE_ALBUM,RELEASE_YEAR,ALBUM_IMAGE_PATH FROM TBL_ALBUM WHERE ID_ALBUM="&SqlInt(id))
RenderHeader "Album", "library"
If rsA.EOF Then %><div class="empty">Album no encontrado.</div><% Else
Set rs=Consultar("SELECT s.ID_SONG,s.SONG_NAME,s.SONG_PATH,s.PLAYS,ISNULL(a.ARTIST_NAME+' '+ISNULL(a.ARTIST_LASTNAME,''),'Artista PoliMusic') AS ARTIST_NAME,ISNULL(a.ARTIST_IMAGE,'') AS ARTIST_IMAGE FROM TBL_TRACKLIST t INNER JOIN TBL_SONG s ON s.ID_SONG=t.ID_SONG LEFT JOIN TBL_PLAYER p ON p.ID_SONG=s.ID_SONG LEFT JOIN TBL_ARTIST a ON a.ID_ARTIST=p.ID_ARTIST WHERE t.ID_ALBUM="&SqlInt(id)&" ORDER BY s.ID_SONG)
%><div class="eyebrow">Album · <%=Html(rsA("RELEASE_YEAR"))%></div><h1 class="page-title"><%=Html(rsA("TITLE_ALBUM"))%></h1><p class="page-subtitle">Coleccion de canciones de PoliMusic.</p><div class="table-wrap"><table><thead><tr><th>#</th><th>Cancion</th><th>Artista</th><th>Reproducciones</th><th></th></tr></thead><tbody><%Dim n,ar,an:n=0:Do While Not rs.EOF:n=n+1:ar=Portada(rs("ARTIST_IMAGE")):an=rs("ARTIST_NAME")&""%><tr><td><%=n%></td><td><div class="mini-row"><img class="mini-cover" src="<%=Html(ar)%>" alt=""><div class="mini-info"><div class="mini-title"><%=Html(rs("SONG_NAME"))%></div><div class="mini-sub"><%=Html(rsA("TITLE_ALBUM"))%></div></div></div></td><td><%=Html(an)%></td><td><span class="badge"><%=Html(rs("PLAYS"))%> plays</span></td><td><button class="btn small js-play-track" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=Html(rs("SONG_NAME"))%>" data-artist="<%=Html(an)%>" data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>" data-cover="<%=Html(ar)%>"><%Icon "play"%></button></td></tr><%rs.MoveNext:Loop%></tbody></table></div><% End If
RenderFooter
%>
