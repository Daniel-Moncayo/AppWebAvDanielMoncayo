<!--#include file="../includes/core.asp"-->
<!--#include file="../includes/layout.asp"-->
<%
RequiereAdmin
BASE = "../"
Dim action, id, titulo, anio, imagen, msg, rs
msg = ""
action = LCase(Request.QueryString("action") & "")
id = IdSeguro(Request.QueryString("id"))
If action = "delete" And id > 0 Then
    On Error Resume Next
    Ejecutar "DELETE FROM TBL_ALBUM WHERE ID_ALBUM=" & SqlInt(id)
    If Err.Number <> 0 Then
        msg = "No se puede eliminar un album que tenga canciones asociadas."
        Err.Clear
    Else
        On Error GoTo 0
        Response.Redirect "albumes.asp"
    End If
    On Error GoTo 0
End If
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    titulo = Trim(Request.Form("titulo") & "")
    anio = Trim(Request.Form("anio") & "")
    imagen = Trim(Request.Form("imagen") & "")
    If titulo = "" Then
        msg = "El titulo es obligatorio."
    Else
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_ALBUM(TITLE_ALBUM,RELEASE_YEAR,ALBUM_IMAGE_PATH) VALUES(" & SqlStr(titulo) & "," & SqlInt(anio) & "," & SqlStr(imagen) & ")"
        If Err.Number <> 0 Then
            msg = Err.Description
            Err.Clear
        Else
            On Error GoTo 0
            Response.Redirect "albumes.asp"
        End If
        On Error GoTo 0
    End If
End If
Set rs = Consultar("SELECT ID_ALBUM,TITLE_ALBUM,RELEASE_YEAR,ALBUM_IMAGE_PATH FROM TBL_ALBUM ORDER BY ID_ALBUM DESC")
RenderHeader "Gestionar albumes", "admin"
%>
<div class="eyebrow">Administrador</div><h1 class="page-title">Albumes</h1><p class="page-subtitle">Organiza las colecciones del catalogo.</p><% If msg <> "" Then %><div class="alert error"><%=Html(msg)%></div><% End If %>
<div class="form-card" style="margin-bottom:24px"><h2 style="font-size:16px;margin:0 0 16px">Nuevo album</h2><form method="post" class="form-grid"><div class="field"><label>Titulo</label><input name="titulo" maxlength="50" required></div><div class="field"><label>Año de lanzamiento</label><input name="anio" type="number" min="1900" max="2100"></div><div class="field full"><label>Ruta de portada</label><input name="imagen" placeholder="~/PlaylistImages/playlist1.png"></div><div class="field full"><button class="btn" type="submit">Guardar album</button></div></form></div>
<div class="table-wrap"><table><thead><tr><th>ID</th><th>Titulo</th><th>Año</th><th>Portada</th><th></th></tr></thead><tbody><% Do While Not rs.EOF %><tr><td><%=rs("ID_ALBUM")%></td><td><strong><%=Html(rs("TITLE_ALBUM"))%></strong></td><td><%=rs("RELEASE_YEAR")%></td><td><span style="color:var(--muted);font-size:11px"><%=Html(rs("ALBUM_IMAGE_PATH"))%></span></td><td><a class="btn small danger" href="albumes.asp?action=delete&id=<%=rs("ID_ALBUM")%>" onclick="return confirm('¿Eliminar este album?')"><%Icon "trash"%> Eliminar</a></td></tr><% rs.MoveNext: Loop %></tbody></table></div><% RenderFooter %>
