<!--#include file="../includes/core.asp"-->
<!--#include file="../includes/layout.asp"-->
<%
RequiereAdmin
BASE="../"
Dim rs
Set rs=Consultar("SELECT ID_USER,USERNAME,EMAIL,BIRTHDAY,USER_TYPE FROM TBL_USER ORDER BY ID_USER")
RenderHeader "Gestionar usuarios", "admin"
%><div class="eyebrow">Administrador</div><h1 class="page-title">Usuarios</h1><p class="page-subtitle">Consulta las cuentas registradas y sus roles.</p><div class="table-wrap"><table><thead><tr><th>ID</th><th>Usuario</th><th>Correo</th><th>Fecha de nacimiento</th><th>Rol</th></tr></thead><tbody><%Do While Not rs.EOF%><tr><td><%=rs("ID_USER")%></td><td><strong><%=Html(rs("USERNAME"))%></strong></td><td><%=Html(rs("EMAIL"))%></td><td><%=Html(rs("BIRTHDAY"))%></td><td><span class="badge"><%=Html(IIf(rs("USER_TYPE")=1,"Administrador","Usuario normal"))%></span></td></tr><%rs.MoveNext:Loop%></tbody></table></div><%RenderFooter%>
