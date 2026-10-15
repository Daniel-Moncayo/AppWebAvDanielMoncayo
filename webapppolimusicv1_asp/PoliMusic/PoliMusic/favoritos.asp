<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim rs, sql, favs
favs = Trim(Session("PM_Favoritos") & "")
If favs = "" Then
    Set rs = Consultar("SELECT TOP 0 ID_SONG,SONG_NAME,SONG_PATH,PLAYS,'' AS ARTIST_NAME,'' AS ARTIST_IMAGE FROM TBL_SONG")
Else
    Set rs = Consultar("SELECT s.ID_SONG,s.SONG_NAME,s.SONG_PATH,s.PLAYS,ISNULL(a.ARTIST_NAME+' '+ISNULL(a.ARTIST_LASTNAME,''),'Artista PoliMusic') AS ARTIST_NAME,ISNULL(a.ARTIST_IMAGE,'') AS ARTIST_IMAGE FROM TBL_SONG s LEFT JOIN TBL_PLAYER p ON p.ID_SONG=s.ID_SONG LEFT JOIN TBL_ARTIST a ON a.ID_ARTIST=p.ID_ARTIST WHERE s.ID_SONG IN (" & Replace(favs,"'","") & ") ORDER BY s.PLAYS DESC")
End If
RenderHeader "Canciones que te gustan", "liked"
%><div class="eyebrow">Tu musica</div><h1 class="page-title">Canciones que te gustan</h1><p class="page-subtitle">Un lugar para tus favoritas.</p><div class="card-grid"><% If rs.EOF Then %><div class="empty">Todavia no tienes canciones favoritas.</div><% Else %><% Do While Not rs.EOF %><% Dim ar, an: ar=Portada(rs("ARTIST_IMAGE")):an=rs("ARTIST_NAME")&"" %><article class="music-card"><img class="cover" src="<%=Html(ar)%>" alt=""><div class="card-title"><%=Html(rs("SONG_NAME"))%></div><div class="card-sub"><%=Html(an)%></div><button class="card-play js-play-track" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=Html(rs("SONG_NAME"))%>" data-artist="<%=Html(an)%>" data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>" data-cover="<%=Html(ar)%>"><%Icon "play"%></button></article><% rs.MoveNext:Loop %><% End If %></div><% RenderFooter %>
