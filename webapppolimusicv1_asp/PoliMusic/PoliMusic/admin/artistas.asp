<!--#include file="../includes/core.asp"-->
<!--#include file="../includes/layout.asp"-->
<%
RequiereAdmin
BASE = "../"
Dim action, id, nombre, apellido, imagen, msg, rs
msg = ""
action = LCase(Request.QueryString("action") & "")
id = IdSeguro(Request.QueryString("id"))
If action = "delete" And id > 0 Then
    On Error Resume Next
    Ejecutar "DELETE FROM TBL_ARTIST WHERE ID_ARTIST=" & SqlInt(id)
    If Err.Number <> 0 Then
        msg = "No se puede eliminar un artista con canciones asociadas."
        Err.Clear
    Else
        On Error GoTo 0
        Response.Redirect "artistas.asp"
    End If
    On Error GoTo 0
End If
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    nombre = Trim(Request.Form("nombre") & "")
    apellido = Trim(Request.Form("apellido") & "")
    imagen = Trim(Request.Form("imagen") & "")
    If nombre = "" Then
        msg = "El nombre es obligatorio."
    Else
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_ARTIST(ARTIST_NAME,ARTIST_LASTNAME,ARTIST_IMAGE) VALUES(" & SqlStr(nombre) & "," & SqlStr(apellido) & "," & SqlStr(imagen) & ")"
        If Err.Number <> 0 Then
            msg = Err.Description
            Err.Clear
        Else
            On Error GoTo 0
            Response.Redirect "artistas.asp"
        End If
        On Error GoTo 0
    End If
End If
Set rs = Consultar("SELECT ID_ARTIST,ARTIST_NAME,ARTIST_LASTNAME,ARTIST_IMAGE FROM TBL_ARTIST ORDER BY ID_ARTIST DESC")
RenderHeader "Gestionar artistas", "admin"
%>
<div class="eyebrow">Administrador</div><h1 class="page-title">Artistas</h1><p class="page-subtitle">Manten actualizados los perfiles de artistas.</p><% If msg <> "" Then %><div class="alert error"><%=Html(msg)%></div><% End If %>
<div class="form-card" style="margin-bottom:24px"><h2 style="font-size:16px;margin:0 0 16px">Nuevo artista</h2><form method="post" class="form-grid"><div class="field"><label>Nombre</label><input name="nombre" maxlength="100" required></div><div class="field"><label>Apellido</label><input name="apellido" maxlength="100"></div><div class="field full"><label>Ruta de imagen</label><input name="imagen" placeholder="~/UserImages/default.jpg"></div><div class="field full"><button class="btn" type="submit">Guardar artista</button></div></form></div>
<div class="table-wrap"><table><thead><tr><th>ID</th><th>Artista</th><th>Imagen</th><th></th></tr></thead><tbody><% Do While Not rs.EOF %><tr><td><%=rs("ID_ARTIST")%></td><td><strong><%=Html(rs("ARTIST_NAME") & " " & rs("ARTIST_LASTNAME"))%></strong></td><td><span style="color:var(--muted);font-size:11px"><%=Html(rs("ARTIST_IMAGE"))%></span></td><td><a class="btn small danger" href="artistas.asp?action=delete&id=<%=rs("ID_ARTIST")%>" onclick="return confirm('¿Eliminar este artista?')"><%Icon "trash"%> Eliminar</a></td></tr><% rs.MoveNext: Loop %></tbody></table></div><% RenderFooter %>
