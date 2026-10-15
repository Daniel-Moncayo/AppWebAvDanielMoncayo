<!--#include file="includes/core.asp"-->
<%
Dim mensaje, ok, nombre, correo, usuario, password
mensaje = "": ok = False
nombre = Trim(Request.Form("nombre") & "")
correo = Trim(Request.Form("correo") & "")
usuario = Trim(Request.Form("usuario") & "")
password = Request.Form("password") & ""
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    If Len(password) < 6 Then
        mensaje = "La contrasena debe tener al menos 6 caracteres."
    Else
        ok = RegistrarUsuario(nombre, correo, usuario, password, mensaje)
    End If
End If
%>
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Crear cuenta · PoliMusic</title><link rel="stylesheet" href="css/estilo.css"></head><body class="auth-page"><section class="auth-box"><a class="brand" href="home.asp"><span class="brand-mark"><svg viewBox="0 0 24 24"><path d="M5 8c5-2 10-2 14 0M6 12c4-1.5 8-1.5 12 0M8 16c3-1 5-1 8 0" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/></svg></span><span>PoliMusic</span></a><h1>Crea tu cuenta</h1><p class="lead">Unete a la comunidad de PoliMusic.</p><% If mensaje <> "" Then %><div class="alert <%=IIf(ok,"","error")%>"><%=Html(mensaje)%></div><% End If %><% If Not ok Then %><form method="post"><div class="field"><label for="nombre">Nombre visible</label><input id="nombre" name="nombre" value="<%=Html(nombre)%>" required></div><div class="field"><label for="usuario">Nombre de usuario</label><input id="usuario" name="usuario" value="<%=Html(usuario)%>" required></div><div class="field"><label for="correo">Correo</label><input id="correo" type="email" name="correo" value="<%=Html(correo)%>" required></div><div class="field"><label for="password">Contrasena</label><input id="password" type="password" name="password" minlength="6" required></div><button class="btn" type="submit">Crear cuenta</button></form><% Else %><a class="btn" href="login.asp">Ir a iniciar sesion</a><% End If %><p class="auth-foot">¿Ya tienes cuenta? <a href="login.asp">Inicia sesion</a></p></section></body></html>
