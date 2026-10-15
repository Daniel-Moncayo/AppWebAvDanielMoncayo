<%
'=====================================================================
'  PoliMusic - helpers de presentacion
'=====================================================================

'--- HTML --------------------------------------------------------------
Function Html(ByVal v)
    If IsNull(v) Then
        Html = ""
    Else
        Html = Server.HTMLEncode(CStr(v))
    End If
End Function

'--- Numero seguro desde QueryString -----------------------------------
Function IdSeguro(ByVal v)
    If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
        IdSeguro = 0
    Else
        IdSeguro = CLng(v)
    End If
End Function

'--- IIf propio (VBScript no lo trae) ----------------------------------
Function IIf(ByVal cond, ByVal a, ByVal b)
    If cond Then IIf = a Else IIf = b
End Function

'--- Texto recortado ---------------------------------------------------
Function Recortar(ByVal v, ByVal n)
    v = v & ""
    If Len(v) > n Then
        Recortar = Left(v, n - 1) & "…"
    Else
        Recortar = v
    End If
End Function

'--- Duracion: acepta segundos (int) o cadenas "mm:ss" ------------------
Function FmtDuracion(ByVal v)
    Dim s, mins, secs
    If IsNull(v) Or v = "" Then
        FmtDuracion = "0:00"
        Exit Function
    End If
    If IsNumeric(v) Then
        s = CLng(v)
        If s < 0 Then s = 0
        mins = Fix(s / 60)
        secs = s Mod 60
        FmtDuracion = mins & ":" & Right("00" & secs, 2)
    Else
        FmtDuracion = CStr(v)
    End If
End Function

'--- Portada con fallback ----------------------------------------------
Function RutaRecurso(ByVal v)
    Dim low
    v = Trim(v & "")
    low = LCase(v)
    If v = "" Then
        RutaRecurso = ""
    ElseIf Left(v, 2) = "~/" Then
        v = Mid(v, 3)
        low = LCase(v)
        If Left(low, 9) = "songfiles" Then
            RutaRecurso = APP_PATH & "assets/SongFiles/" & Mid(v, 11)
        ElseIf Left(low, 10) = "userimages" Then
            RutaRecurso = APP_PATH & "assets/UserImages/" & Mid(v, 12)
        ElseIf Left(low, 14) = "playlistimages" Then
            RutaRecurso = APP_PATH & "assets/PlaylistImages/" & Mid(v, 16)
        Else
            RutaRecurso = APP_PATH & v
        End If
    ElseIf Left(low, 4) = "http" Then
        RutaRecurso = v
    Else
        RutaRecurso = v
    End If
End Function

Function Portada(ByVal v)
    v = RutaRecurso(v)
    If v = "" Then Portada = APP_PATH & COVER_DEFAULT Else Portada = v
End Function

'--- Ruta del audio ----------------------------------------------------
Function AudioRuta(ByVal v)
    Dim ruta, fso, existe
    ruta = RutaRecurso(v)
    If ruta = "" Then
        AudioRuta = APP_PATH & SONG_DEFAULT
        Exit Function
    End If
    ' El ZIP de recursos puede no incluir todos los audios indicados por
    ' el script. En ese caso usamos el audio de muestra para que el
    ' reproductor no quede roto durante la prueba local.
    On Error Resume Next
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    existe = fso.FileExists(Server.MapPath(ruta))
    Set fso = Nothing
    Err.Clear
    On Error GoTo 0
    If existe Then AudioRuta = ruta Else AudioRuta = APP_PATH & SONG_DEFAULT
End Function

'--- Saludo segun la hora ----------------------------------------------
Function Saludo()
    Dim h
    h = Hour(Now())
    If h < 6 Then
        Saludo = "Buenas madrugadas"
    ElseIf h < 12 Then
        Saludo = "Buenos dias"
    ElseIf h < 19 Then
        Saludo = "Buenas tardes"
    Else
        Saludo = "Buenas noches"
    End If
End Function

'--- Avatar del usuario ------------------------------------------------
Function AvatarUsuario()
    Dim v
    v = Session("PM_Imagen") & ""
    If v = "" Then
        AvatarUsuario = "assets/img/avatar-default.svg"
    Else
        AvatarUsuario = v
    End If
End Function

'--- Inicial del nombre (para el circulo del menu) ---------------------
Function InicialUsuario()
    Dim n
    n = Trim(UsuarioNombre())
    If n = "" Then
        InicialUsuario = "?"
    Else
        InicialUsuario = UCase(Left(n, 1))
    End If
End Function

'--- QueryString seguro (evita XSS al reimprimir la busqueda) ----------
Function Qs(ByVal clave)
    Qs = Html(Request.QueryString(clave))
End Function

'--- Respuesta JSON generica -------------------------------------------
Sub JsonOut(ByVal ok, ByVal extra)
    Response.ContentType = "application/json"
    Response.Write "{""ok"":" & LCase(CStr(ok))
    If extra <> "" Then Response.Write "," & extra
    Response.Write "}"
End Sub
%>
