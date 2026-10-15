<!--#include file="includes/core.asp"-->
<%
Dim mensaje, login, password, retorno
mensaje = ""
login = Trim(Request.Form("login") & "")
password = Request.Form("password") & ""
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    If Autenticar(login, password) Then
        retorno = Session("PM_Retorno") & ""
        Session("PM_Retorno") = ""
        If retorno = "" Then retorno = "home.asp"
        Response.Redirect retorno
    Else
        mensaje = "Usuario/correo o contrasena incorrectos."
    End If
End If
%>
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Iniciar sesion · PoliMusic</title><link rel="stylesheet" href="css/estilo.css"></head><body class="auth-page"><section class="auth-box"><a class="brand" href="home.asp"><span class="brand-mark"><svg viewBox="0 0 24 24"><path d="M5 8c5-2 10-2 14 0M6 12c4-1.5 8-1.5 12 0M8 16c3-1 5-1 8 0" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/></svg></span><span>PoliMusic</span></a><h1>Bienvenido de nuevo</h1><p class="lead">Tu musica, tu espacio, tu ritmo.</p><% If mensaje <> "" Then %><div class="alert error"><%=Html(mensaje)%></div><% End If %><form method="post"><div class="field"><label for="login">Usuario o correo</label><input id="login" name="login" value="<%=Html(login)%>" required autofocus></div><div class="field"><label for="password">Contrasena</label><input id="password" type="password" name="password" required></div><button class="btn" type="submit">Iniciar sesion</button></form><p class="auth-foot">¿No tienes cuenta? <a href="registro.asp">Registrate gratis</a></p></section></body></html>
