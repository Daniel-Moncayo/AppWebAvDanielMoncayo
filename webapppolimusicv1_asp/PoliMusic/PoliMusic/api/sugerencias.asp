<!--#include file="../includes/core.asp"-->
<%
RequiereLogin
Dim q,rs,json,first
q=Trim(Request.QueryString("q")&""):json="[":first=True
If Len(q)>=2 Then
Set rs=Consultar("SELECT TOP 8 ID_SONG,SONG_NAME FROM TBL_SONG WHERE SONG_NAME LIKE '%"&Replace(q,"'","''")&"%' ORDER BY PLAYS DESC")
Do While Not rs.EOF
If Not first Then json=json&","
json=json&"{""id"":"&rs("ID_SONG")&",""name"":"""&Replace(rs("SONG_NAME")&"","""","\""")&"""}"
first=False:rs.MoveNext:Loop
End If
json=json&"]":Response.ContentType="application/json":Response.Write json%>
