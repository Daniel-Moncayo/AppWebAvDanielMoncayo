<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim q, rs, sql, encontrado
q = Trim(Request.QueryString("q") & "")
Set rs = Nothing
encontrado = False
If q <> "" Then
    sql = "SELECT TOP 50 s.ID_SONG,s.SONG_NAME,s.SONG_PATH,s.PLAYS,ISNULL(a.ARTIST_NAME+' '+ISNULL(a.ARTIST_LASTNAME,''),'Artista PoliMusic') AS ARTIST_NAME,ISNULL(a.ARTIST_IMAGE,'') AS ARTIST_IMAGE FROM TBL_SONG s LEFT JOIN TBL_PLAYER p ON p.ID_SONG=s.ID_SONG LEFT JOIN TBL_ARTIST a ON a.ID_ARTIST=p.ID_ARTIST WHERE s.SONG_NAME LIKE '%" & Replace(q,"'","''") & "%' OR a.ARTIST_NAME LIKE '%" & Replace(q,"'","''") & "%' OR a.ARTIST_LASTNAME LIKE '%" & Replace(q,"'","''") & "%' ORDER BY s.PLAYS DESC"
    Set rs = Consultar(sql)
    encontrado = Not rs.EOF
End If
RenderHeader "Buscar", "search"
%><div class="eyebrow">Explora el catalogo</div><h1 class="page-title">Buscar musica</h1><p class="page-subtitle">Encuentra canciones y artistas de PoliMusic.</p><% If q = "" Then %><div class="empty">Escribe una canción o artista en el buscador para empezar.</div><% Else %><div class="section-head"><h2>Resultados para “<%=Html(q)%>”</h2></div><% If Not encontrado Then %><div class="empty">No encontramos resultados para tu busqueda.</div><% Else %><div class="card-grid"><% Do While Not rs.EOF %><% Dim ar, an: ar=Portada(rs("ARTIST_IMAGE")):an=rs("ARTIST_NAME")&"" %><article class="music-card"><img class="cover" src="<%=Html(IIf(ar="",BASE&"assets/img/cover-default.svg",ar))%>" onerror="this.src='<%=BASE%>assets/img/cover-default.svg'" alt=""><div class="card-title"><%=Html(rs("SONG_NAME"))%></div><div class="card-sub"><%=Html(an)%></div><button class="card-play js-play-track" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=Html(rs("SONG_NAME"))%>" data-artist="<%=Html(an)%>" data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>" data-cover="<%=Html(ar)%>"><%Icon "play"%></button></article><% rs.MoveNext:Loop %></div><% End If %><% End If %><% RenderFooter %>
