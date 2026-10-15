<%
'=====================================================================
'  PoliMusic - capa de acceso a datos
'=====================================================================

Dim PM_Conn

'---------------------------------------------------------------------
'  Abre (y reutiliza) la conexion global
'---------------------------------------------------------------------
Function AbrirConexion()
    If Not IsObject(PM_Conn) Then
        Set PM_Conn = Server.CreateObject("ADODB.Connection")
        PM_Conn.ConnectionString = GetConnectionString()
        PM_Conn.CommandTimeout = 30
        PM_Conn.Open
    ElseIf PM_Conn.State <> 1 Then
        PM_Conn.Open
    End If
    Set AbrirConexion = PM_Conn
End Function

Sub CerrarConexion()
    If IsObject(PM_Conn) Then
        If PM_Conn.State = 1 Then PM_Conn.Close
        Set PM_Conn = Nothing
    End If
End Sub

'---------------------------------------------------------------------
'  Escapa una cadena para usarla dentro de una sentencia SQL.
'  Duplica comillas simples y bloquea caracteres de control.
'---------------------------------------------------------------------
Function SqlStr(ByVal v)
    If IsNull(v) Then
        SqlStr = "NULL"
        Exit Function
    End If
    v = CStr(v)
    v = Replace(v, "'", "''")
    SqlStr = "'" & v & "'"
End Function

'---------------------------------------------------------------------
'  Convierte un valor a entero seguro (evita inyeccion en Ids)
'---------------------------------------------------------------------
Function SqlInt(ByVal v)
    If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
        SqlInt = "0"
    Else
        SqlInt = CStr(CLng(v))
    End If
End Function

'---------------------------------------------------------------------
'  Ejecuta un SELECT y devuelve un Recordset desconectado
'---------------------------------------------------------------------
Function Consultar(ByVal sql)
    Dim rs, conn
    Set conn = AbrirConexion()
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.CursorLocation = 3          ' adUseClient
    rs.Open sql, conn, 0, 1        ' adOpenForwardOnly, adLockReadOnly
    Set Consultar = rs
End Function

'---------------------------------------------------------------------
'  Ejecuta INSERT / UPDATE / DELETE. Devuelve filas afectadas.
'---------------------------------------------------------------------
Function Ejecutar(ByVal sql)
    Dim conn, afectadas
    Set conn = AbrirConexion()
    conn.Execute sql, afectadas
    Ejecutar = CLng(afectadas & "")
End Function

'---------------------------------------------------------------------
'  Devuelve un unico valor escalar (primera columna de la primera fila)
'---------------------------------------------------------------------
Function Escalar(ByVal sql)
    Dim rs
    Set rs = Consultar(sql)
    If Not rs.EOF Then
        Escalar = rs.Fields(0).Value
    Else
        Escalar = Null
    End If
    rs.Close
    Set rs = Nothing
End Function

'---------------------------------------------------------------------
'  Devuelve el ultimo identity insertado
'---------------------------------------------------------------------
Function UltimoId()
    UltimoId = CLng(Escalar("SELECT SCOPE_IDENTITY()") & "")
End Function

'---------------------------------------------------------------------
'  Ejecuta una consulta y devuelve el Recordset ya cerrado por el
'  llamador (helper para listados paginados)
'---------------------------------------------------------------------
Function Existe(ByVal sql)
    Dim rs, ok
    Set rs = Consultar(sql)
    ok = Not rs.EOF
    rs.Close
    Set rs = Nothing
    Existe = ok
End Function
%>
