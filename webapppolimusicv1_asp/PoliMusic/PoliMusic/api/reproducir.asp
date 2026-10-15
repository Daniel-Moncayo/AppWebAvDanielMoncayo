<!--#include file="../includes/core.asp"-->
<%
RequiereLogin
Dim id, ok
id=IdSeguro(Request.QueryString("id"))
ok=False
If id>0 Then
On Error Resume Next
Ejecutar "UPDATE TBL_SONG SET PLAYS=ISNULL(PLAYS,0)+1 WHERE ID_SONG="&SqlInt(id)
ok=(Err.Number=0):Err.Clear
On Error GoTo 0
End If
JsonOut ok,""%>
