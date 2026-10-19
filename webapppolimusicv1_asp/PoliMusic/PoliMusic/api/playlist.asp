<!--#include file="../includes/core.asp"-->
<%
RequiereLogin
Dim action, idSong, idPlaylist, titulo, ok, msg
ok = False
msg = ""
action = LCase(Request.QueryString("action") & "")

If action = "create" Then
    titulo = Trim(Request.Form("titulo") & "")
    If titulo <> "" Then
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_PLAYLIST(ID_USER,TITLE,CREATION_DATE,TYPE,PHOTO) VALUES(" & SqlInt(UsuarioId()) & "," & SqlStr(titulo) & ",GETDATE(),0,'~/PlaylistImages/default.jpg')"
        ok = (Err.Number = 0)
        msg = Err.Description
        Err.Clear
        On Error GoTo 0
    End If
ElseIf action = "add" Then
    idPlaylist = IdSeguro(Request.Form("playlist"))
    idSong = IdSeguro(Request.Form("song"))
    If idPlaylist > 0 And idSong > 0 Then
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_PLAYLIST_SONG(ID_PLAYLIST,ID_SONG) SELECT " & SqlInt(idPlaylist) & "," & SqlInt(idSong) & " WHERE EXISTS(SELECT 1 FROM TBL_PLAYLIST WHERE ID_PLAYLIST=" & SqlInt(idPlaylist) & " AND ID_USER=" & SqlInt(UsuarioId()) & ") AND NOT EXISTS(SELECT 1 FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST=" & SqlInt(idPlaylist) & " AND ID_SONG=" & SqlInt(idSong) & ")"
        ok = (Err.Number = 0)
        msg = Err.Description
        Err.Clear
        On Error GoTo 0
    End If
ElseIf action = "remove" Then
    idPlaylist = IdSeguro(Request.Form("playlist"))
    idSong = IdSeguro(Request.Form("song"))
    If idPlaylist > 0 And idSong > 0 Then
        On Error Resume Next
        Ejecutar "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_PLAYLIST=" & SqlInt(idPlaylist) & " AND ID_SONG=" & SqlInt(idSong) & " AND EXISTS(SELECT 1 FROM TBL_PLAYLIST WHERE ID_PLAYLIST=" & SqlInt(idPlaylist) & " AND ID_USER=" & SqlInt(UsuarioId()) & ")"
        ok = (Err.Number = 0)
        msg = Err.Description
        Err.Clear
        On Error GoTo 0
    End If
End If
JsonOut ok, """message"":""" & Replace(msg, """", "\""") & """"
%>
