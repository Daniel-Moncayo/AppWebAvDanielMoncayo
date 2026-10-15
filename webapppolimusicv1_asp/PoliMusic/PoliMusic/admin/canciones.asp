<!--#include file="../includes/core.asp"-->
<!--#include file="../includes/layout.asp"-->
<%
RequiereAdmin
BASE = "../"
Dim action, id, nombre, ruta, ok, msg, rs
ok = False
msg = ""
action = LCase(Request.QueryString("action") & "")
id = IdSeguro(Request.QueryString("id"))

If action = "delete" And id > 0 Then
    On Error Resume Next
    Ejecutar "DELETE FROM TBL_SONG WHERE ID_SONG=" & SqlInt(id)
    If Err.Number <> 0 Then
        msg = "No se puede eliminar una cancion relacionada con otras tablas."
        Err.Clear
    Else
        On Error GoTo 0
        Response.Redirect "canciones.asp"
    End If
    On Error GoTo 0
End If
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    nombre = Trim(Request.Form("nombre") & "")
    ruta = Trim(Request.Form("ruta") & "")
    If nombre = "" Or ruta = "" Then
        msg = "Completa el nombre y la ruta del audio."
    Else
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_SONG(SONG_NAME,SONG_PATH,PLAYS) VALUES(" & SqlStr(nombre) & "," & SqlStr(ruta) & ",0)"
        If Err.Number <> 0 Then
            msg = Err.Description
            Err.Clear
        Else
            On Error GoTo 0
            Response.Redirect "canciones.asp"
        End If
        On Error GoTo 0
    End If
End If
Set rs = Consultar("SELECT ID_SONG,SONG_NAME,SONG_PATH,PLAYS FROM TBL_SONG ORDER BY ID_SONG DESC")
RenderHeader "Gestionar canciones", "admin"
%>
<div class="eyebrow">Administrador</div><h1 class="page-title">Canciones</h1><p class="page-subtitle">Agrega y administra los audios del catalogo.</p>
<% If msg <> "" Then %><div class="alert error"><%=Html(msg)%></div><% End If %>
<div class="form-card" style="margin-bottom:24px"><h2 style="font-size:16px;margin:0 0 16px">Nueva cancion</h2><form method="post" class="form-grid"><div class="field"><label>Nombre</label><input name="nombre" maxlength="50" required></div><div class="field"><label>Ruta del audio</label><input name="ruta" placeholder="~/SongFiles/archivo.mp3" required></div><div class="field full"><button class="btn" type="submit">Guardar cancion</button></div></form></div>
<div class="table-wrap"><table><thead><tr><th>ID</th><th>Nombre</th><th>Ruta</th><th>Plays</th><th>Acciones</th></tr></thead><tbody><% Do While Not rs.EOF %><tr><td><%=rs("ID_SONG")%></td><td><strong><%=Html(rs("SONG_NAME"))%></strong></td><td><span style="color:var(--muted);font-size:11px"><%=Html(rs("SONG_PATH"))%></span></td><td><%=rs("PLAYS")%></td><td><a class="btn small danger" href="canciones.asp?action=delete&id=<%=rs("ID_SONG")%>" onclick="return confirm('¿Eliminar esta cancion?')"><%Icon "trash"%> Eliminar</a></td></tr><% rs.MoveNext: Loop %></tbody></table></div><% RenderFooter %>
