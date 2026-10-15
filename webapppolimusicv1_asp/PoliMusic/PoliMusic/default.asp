<%
If Session("PM_IdUsuario") & "" <> "" Then
    Response.Redirect "home.asp"
Else
    Response.Redirect "login.asp"
End If
%>
