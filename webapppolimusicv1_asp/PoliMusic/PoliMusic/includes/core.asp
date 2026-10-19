<%
'=====================================================================
'  PoliMusic - nucleo
'  Unico archivo que deben incluir las paginas junto con layout.asp.
'  (IIS procesa los #include aunque esten comentados, por eso los
'   ejemplos se escriben sin la sintaxis completa de la directiva)
'  Ejemplo (pagina en la raiz):
'      include file = includes/core.asp
'      include file = includes/layout.asp
'  Ejemplo (pagina dentro de /admin):
'      include file = ../includes/core.asp
'      include file = ../includes/layout.asp
'
'  Los cuatro incluidos viven en el mismo directorio, por lo que las
'  rutas relativas siempre resuelven igual sin importar quien los llame.
'  No incluyas config/db/auth/funciones por separado: se duplicarian
'  las constantes y VBScript lanzaria "Nombre redefinido".
'=====================================================================
'%>
<!--#include file="config.asp"-->
<!--#include file="db.asp"-->
<!--#include file="auth.asp"-->
<!--#include file="funciones.asp"-->
<%
' BASE: prefijo para armar enlaces y rutas de assets.
'   ""    -> pagina en la raiz
'   "../" -> pagina dentro de una subcarpeta (admin, api, ...)
Dim BASE
BASE = ""

' TEXTOS comunes de la interfaz
Const APP_NAME = "PoliMusic"
Const APP_LEMA = "Escuela Politécnica Nacional"
%>
