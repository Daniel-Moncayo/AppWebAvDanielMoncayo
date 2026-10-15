<%
'=====================================================================
'  PoliMusic - autenticacion y control de roles
'=====================================================================

'---------------------------------------------------------------------
'  HashPassword: punto unico donde aplicar el algoritmo de la BD.
'  Si tus passwords estan en MD5/SHA, cambia el cuerpo de esta funcion.
'---------------------------------------------------------------------
Function HashPassword(ByVal plano)
    If PASSWORD_PLANO Then
        HashPassword = plano
    Else
        ' TODO: implementar aqui el mismo algoritmo usado al crear usuarios
        HashPassword = plano
    End If
End Function

'---------------------------------------------------------------------
'  Intenta autenticar. Acepta correo o nombre de usuario.
'  Devuelve True y llena la Sesion si las credenciales son validas.
'---------------------------------------------------------------------
Function Autenticar(ByVal login, ByVal password)
    Dim rs, sql, tipo
    Autenticar = False

    login    = Trim(login & "")
    password = Trim(password & "")
    If login = "" Or password = "" Then Exit Function

    sql = "SELECT TOP 1 ID_USER, USERNAME, EMAIL, USER_PHOTO, USER_TYPE " & _
          "FROM TBL_USER " & _
          "WHERE (USERNAME = " & SqlStr(login) & " OR EMAIL = " & SqlStr(login) & ") " & _
          "AND PASSWORD = " & SqlStr(HashPassword(password))

    Set rs = Consultar(sql)
    If Not rs.EOF Then
        tipo = CInt(rs("USER_TYPE"))
        Session("PM_IdUsuario")  = CLng(rs("ID_USER"))
        Session("PM_Nombre")     = rs("USERNAME") & ""
        Session("PM_Correo")     = rs("EMAIL") & ""
        Session("PM_IdRol")      = tipo
        Session("PM_RolNombre")  = IIf(tipo = 1, "ADMIN", "USER")
        Session("PM_Login")      = rs("USERNAME") & ""
        Session("PM_Imagen")     = rs("USER_PHOTO") & ""
        Session("PM_EsAdmin")    = (tipo = 1 Or LCase(rs("USERNAME") & "") = "useradmin")
        Autenticar = True
    End If
    rs.Close
    Set rs = Nothing
End Function

'---------------------------------------------------------------------
'  Determina si el rol/ usuario corresponde a administrador
'---------------------------------------------------------------------
Function EsRolAdmin(ByVal nombreRol, ByVal nombreUsuario)
    Dim claves, i
    EsRolAdmin = False

    ' Regla explicita: la cuenta userAdmin siempre es administrador
    If LCase(Trim(nombreUsuario)) = "useradmin" Then
        EsRolAdmin = True
        Exit Function
    End If

    claves = Split(ROL_ADMIN_KEYWORDS, ",")
    For i = 0 To UBound(claves)
        If InStr(1, UCase(nombreRol), UCase(Trim(claves(i))), 1) > 0 Then
            EsRolAdmin = True
            Exit Function
        End If
    Next
End Function

'---------------------------------------------------------------------
'  Acceso de lectura a la sesion
'---------------------------------------------------------------------
Function EstaLogueado()
    EstaLogueado = (Session("PM_IdUsuario") & "" <> "")
End Function

Function UsuarioId()
    UsuarioId = CLng(Session("PM_IdUsuario") & "")
End Function

Function UsuarioNombre()
    If Session("PM_Nombre") & "" = "" Then
        UsuarioNombre = Session("PM_Login") & ""
    Else
        UsuarioNombre = Session("PM_Nombre") & ""
    End If
End Function

Function EsAdmin()
    Dim flag
    flag = LCase(Trim(Session("PM_EsAdmin") & ""))
    EsAdmin = (flag = "true" Or flag = "1")
End Function

'---------------------------------------------------------------------
'  Registro de nuevos usuarios (siempre con el rol normal)
'---------------------------------------------------------------------
Function RegistrarUsuario(ByVal nombre, ByVal correo, ByVal usuario, ByVal password, ByRef mensaje)
    Dim idRolNormal
    RegistrarUsuario = False

    If Existe("SELECT 1 FROM TBL_USER WHERE EMAIL=" & SqlStr(correo) & _
              " OR USERNAME=" & SqlStr(usuario)) Then
        mensaje = "El correo o el nombre de usuario ya estan registrados."
        Exit Function
    End If

    ' USER_TYPE = 0 corresponde al rol normal en TBL_CATALOG.
    On Error Resume Next
    Ejecutar "INSERT INTO TBL_USER (USERNAME, PASSWORD, EMAIL, BIRTHDAY, USER_PHOTO, USER_TYPE) " & _
             "VALUES (" & SqlStr(usuario) & "," & SqlStr(HashPassword(password)) & "," & _
                          SqlStr(correo) & ", NULL, NULL, 0)"
    If Err.Number <> 0 Then
        mensaje = "No se pudo crear la cuenta: " & Err.Description
        Err.Clear
        On Error GoTo 0
        Exit Function
    End If
    On Error GoTo 0

    mensaje = "Cuenta creada correctamente. Ya puedes iniciar sesion."
    RegistrarUsuario = True
End Function

'---------------------------------------------------------------------
'  Guardas de acceso
'---------------------------------------------------------------------
Sub RequiereLogin()
    If Not EstaLogueado() Then
        Session("PM_Retorno") = Request.ServerVariables("SCRIPT_NAME") & _
                                IIf(Request.QueryString <> "", "?" & Request.QueryString, "")
        Response.Redirect "login.asp"
    End If
End Sub

Sub RequiereAdmin()
    If Not EstaLogueado() Then
        Response.Redirect "../login.asp"
    ElseIf Not EsAdmin() Then
        Response.Redirect "../home.asp?error=sin_permisos"
    End If
End Sub

Sub CerrarSesion()
    Session.Abandon
End Sub
%>
