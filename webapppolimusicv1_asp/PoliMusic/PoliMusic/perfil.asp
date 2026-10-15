<!--#include file="includes/core.asp"-->
<!--#include file="includes/layout.asp"-->
<%
RequiereLogin
Dim rs
Set rs=Consultar("SELECT TOP 1 USERNAME,EMAIL,BIRTHDAY,USER_PHOTO,USER_TYPE FROM TBL_USER WHERE ID_USER="&SqlInt(UsuarioId()))
RenderHeader "Mi perfil", ""
%><div class="eyebrow">Cuenta</div><h1 class="page-title">Mi perfil</h1><p class="page-subtitle">Administra los datos de tu cuenta PoliMusic.</p><div class="form-card"><%If Not rs.EOF Then%><div style="display:flex;align-items:center;gap:18px;margin-bottom:24px"><img class="avatar" style="width:70px;height:70px" src="<%=Html(RutaRecurso(rs("USER_PHOTO")))%>" onerror="this.src='<%=BASE%>assets/img/avatar-default.svg'" alt=""><div><h2 style="margin:0 0 6px;font-size:19px"><%=Html(rs("USERNAME"))%></h2><div style="color:var(--muted);font-size:12px"><%=Html(rs("EMAIL"))%></div></div></div><div class="form-grid"><div class="field"><label>Nombre de usuario</label><input value="<%=Html(rs("USERNAME"))%>" disabled></div><div class="field"><label>Correo</label><input value="<%=Html(rs("EMAIL"))%>" disabled></div><div class="field"><label>Rol</label><input value="<%=Html(IIf(rs("USER_TYPE")=1,"Administrador","Usuario normal"))%>" disabled></div></div><%End If%></div><%RenderFooter%>
