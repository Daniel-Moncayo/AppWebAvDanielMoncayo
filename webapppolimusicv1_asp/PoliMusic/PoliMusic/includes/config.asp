<%
Option Explicit
Response.CodePage = 65001
Response.CharSet  = "UTF-8"
Session.CodePage  = 65001

'=====================================================================
'  PoliMusic - configuracion global
'  ASP Clasico (VBScript) + SQL Server
'=====================================================================

'--- Cadena de conexion -----------------------------------------------
'  Se proveen varios proveedores OLEDB. El activo es CONN_PROVIDER.
'  Si en tu servidor no existe MSOLEDBSQL, cambia a "SQLOLEDB" o "SQLNCLI11".
Const DB_PROVIDER   = "MSOLEDBSQL"
Const DB_SERVER     = "localhost"
Const DB_DATABASE   = "BDD_PoliMusic"
Const DB_USER       = "usr_polimusic"
Const DB_PASSWORD   = "Politecnica1"
Const DB_ENCRYPT    = "True"
Const DB_TRUSTCERT  = "True"

Function GetConnectionString()
    GetConnectionString = _
        "Provider=" & DB_PROVIDER & ";" & _
        "Data Source=" & DB_SERVER & ";" & _
        "Initial Catalog=" & DB_DATABASE & ";" & _
        "User ID=" & DB_USER & ";" & _
        "Password=" & DB_PASSWORD & ";" & _
        "Encrypt=" & DB_ENCRYPT & ";" & _
        "Trust Server Certificate=" & DB_TRUSTCERT & ";"
End Function

'--- Rutas -------------------------------------------------------------
'  Ruta virtual de la aplicacion. Si publicas en la raiz del sitio
'  dejalo en "/" ; si publicas en una carpeta, pon "/PoliMusic/".
Const APP_PATH      = "/PoliMusic/"
Const COVER_DEFAULT = "assets/img/cover-default.svg"
Const SONG_DEFAULT  = "assets/SongFiles/bensound-adventure.mp3"

'--- Paginacion / listados ---------------------------------------------
Const PAGE_SIZE     = 20
Const HOME_RECENT   = 8     ' ultimas reproducciones en Inicio
Const HOME_ITEMS    = 12    ' items por carrusel en Inicio

'--- Roles -------------------------------------------------------------
'  Se detecta el rol por el NOMBRE del rol en la tabla Rol, para no
'  depender de un Id magico. Si en tu BD el admin tiene otro nombre,
'  agregalo a esta lista separada por comas.
Const ROL_ADMIN_KEYWORDS = "ADMIN,ADMINISTRADOR"

'--- Seguridad ---------------------------------------------------------
'  IMPORTANTE: si las contrasenas en tu BD estan hasheadas (MD5/SHA),
'  implementa la funcion HashPassword() al final de este archivo.
'  Por defecto compara texto plano (lo mas comun en BDD de practicas).
Const PASSWORD_PLANO = True
%>
