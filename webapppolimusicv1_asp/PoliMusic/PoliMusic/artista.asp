<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim id,rsA,rs
id=IdSeguro(Request.QueryString("id"))
Set rsA=Consultar("SELECT TOP 1 ID_ARTIST,ARTIST_NAME,ARTIST_LASTNAME,ARTIST_IMAGE FROM TBL_ARTIST WHERE ID_ARTIST="&SqlInt(id))
RenderHeader "Artista", "search"
If rsA.EOF Then %><div class="empty">Artista no encontrado.</div><% Else
Set rs=Consultar("SELECT DISTINCT s.ID_SONG,s.SONG_NAME,s.SONG_PATH,s.PLAYS FROM TBL_PLAYER p INNER JOIN TBL_SONG s ON s.ID_SONG=p.ID_SONG WHERE p.ID_ARTIST="&SqlInt(id)&" ORDER BY s.PLAYS DESC")
%><div class="eyebrow">Artista</div><h1 class="page-title"><%=Html(rsA("ARTIST_NAME")&" "&rsA("ARTIST_LASTNAME"))%></h1><p class="page-subtitle">Canciones disponibles en PoliMusic.</p><div class="table-wrap"><table><thead><tr><th>#</th><th>Cancion</th><th>Reproducciones</th><th></th></tr></thead><tbody><%Dim n:n=0:Do While Not rs.EOF:n=n+1%><tr><td><%=n%></td><td><div class="mini-row"><img class="mini-cover" src="<%=Html(Portada(rsA("ARTIST_IMAGE")))%>" alt=""><div class="mini-info"><div class="mini-title"><%=Html(rs("SONG_NAME"))%></div><div class="mini-sub"><%=Html(rsA("ARTIST_NAME")&" "&rsA("ARTIST_LASTNAME"))%></div></div></div></td><td><span class="badge"><%=Html(rs("PLAYS"))%> plays</span></td><td><button class="btn small js-play-track" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=Html(rs("SONG_NAME"))%>" data-artist="<%=Html(rsA("ARTIST_NAME")&" "&rsA("ARTIST_LASTNAME"))%>" data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>" data-cover="<%=Html(Portada(rsA("ARTIST_IMAGE")))%>"><%Icon "play"%></button></td></tr><%rs.MoveNext:Loop%></tbody></table></div><% End If
RenderFooter
%>
