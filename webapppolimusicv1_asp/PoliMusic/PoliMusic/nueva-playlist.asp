<!--#include file="includes/core.asp"-->
<%
RequiereLogin
Dim titulo, mensaje
mensaje = ""
titulo = ""
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    titulo = Trim(Request.Form("titulo") & "")
    If titulo = "" Then
        mensaje = "Escribe un nombre para la playlist."
    Else
        On Error Resume Next
        Ejecutar "INSERT INTO TBL_PLAYLIST(ID_USER,TITLE,CREATION_DATE,TYPE,PHOTO) VALUES(" & SqlInt(UsuarioId()) & "," & SqlStr(titulo) & ",GETDATE(),0,'~/PlaylistImages/default.jpg')"
        If Err.Number <> 0 Then
            mensaje = Err.Description
            Err.Clear
        Else
            On Error GoTo 0
            Response.Redirect "biblioteca.asp#playlists"
        End If
        On Error GoTo 0
    End If
End If
%>
<!--#include file="includes/layout.asp"-->
<%RenderHeader "Nueva playlist", "library"%><div class="eyebrow">Tu biblioteca</div><h1 class="page-title">Crear playlist</h1><p class="page-subtitle">Dale un nombre a tu nueva coleccion.</p><div class="form-card"><%If mensaje<>"" Then%><div class="alert error"><%=Html(mensaje)%></div><%End If%><form method="post"><div class="field"><label for="titulo">Nombre de la playlist</label><input id="titulo" name="titulo" value="<%=Html(titulo)%>" maxlength="50" required autofocus></div><div style="margin-top:18px;display:flex;gap:10px"><button class="btn" type="submit">Crear playlist</button><a class="btn secondary" href="biblioteca.asp">Cancelar</a></div></form></div><%RenderFooter%>
