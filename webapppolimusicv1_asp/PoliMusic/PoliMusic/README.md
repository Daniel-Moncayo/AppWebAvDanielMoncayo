# PoliMusic - clon de Spotify en ASP clasico

Aplicacion web en **ASP Clasico + VBScript + SQL Server** con tema morado. Incluye autenticacion, roles, catalogo de canciones, albums, artistas, playlists, reproductor HTML5 y panel de administrador.

## Credenciales de prueba del script incluido

- Administrador: `userAdmin` / `12345678`
- Usuario normal: `userNormal` / `12345678`

> El script de base de datos tambien contiene otros registros. La cuenta `userAdmin` se reconoce por `USER_TYPE = 1`.

## Puesta en marcha en Windows + IIS

1. Instala/activa **IIS**, **ASP (Classic ASP)** y el proveedor OLE DB de SQL Server **MSOLEDBSQL**. Si solo tienes el proveedor antiguo, cambia `DB_PROVIDER` en `includes/config.asp` a `SQLOLEDB`.
2. Ejecuta `BDD_PoliMusic.sql` en SQL Server Management Studio. El script crea la base `BDD_PoliMusic`, el login `usr_polimusic` y carga datos de ejemplo.
3. Copia la carpeta `PoliMusic` a `C:\inetpub\wwwroot\PoliMusic`.
4. En IIS crea una aplicacion con alias `PoliMusic` apuntando a esa carpeta. El pool debe tener ASP habilitado.
5. Abre `http://localhost/PoliMusic/`.
6. Si publicas con otro alias, cambia `APP_PATH` en `includes/config.asp`, por ejemplo `/MiMusica/`.

## Conexión SQL

La configuracion ya usa:

```text
Provider=MSOLEDBSQL;Data Source=localhost;Initial Catalog=BDD_PoliMusic;User ID=usr_polimusic;Password=Politecnica1;Encrypt=True;Trust Server Certificate=True;
```

Si tu instancia de SQL Server no escucha en `localhost`, ajusta `DB_SERVER` en `includes/config.asp`.

## Recursos incluidos

Los recursos entregados fueron copiados dentro de `assets/`:

- `assets/SongFiles/`
- `assets/UserImages/`
- `assets/PlaylistImages/`
- `assets/img/` contiene los SVG de fallback creados para la interfaz.

El ZIP entregado contiene un audio real (`bensound-adventure.mp3`), que es el unico MP3 presente en el paquete original de recursos. El reproductor usa ese audio como fallback para las filas del SQL cuyos MP3 no fueron entregados. El script original usa rutas como `~/SongFiles/...`; la funcion `RutaRecurso()` las traduce automaticamente a las rutas web dentro de `assets/`.

## Estructura principal

- `home.asp`, `buscar.asp`, `biblioteca.asp`, `favoritos.asp`: experiencia de usuario.
- `playlist.asp`, `album.asp`, `artista.asp`: detalle de contenido.
- `api/`: reproduccion, favoritos en sesion, playlists y sugerencias.
- `admin/`: dashboard y CRUD basico de canciones, albumes, artistas y consulta de usuarios.
- `includes/`: conexion, autenticacion, helpers y layout compartido.
- `preview.html`: vista visual estatica para revisar el tema sin IIS.

## Notas

- Los favoritos se guardan en la sesion actual porque el esquema entregado no incluye una tabla de favoritos.
- La contrasena se compara en texto plano porque asi aparece en `TBL_USER` del script de ejemplo. Para un entorno real se recomienda migrar a hash seguro.
- El administrador puede crear y eliminar canciones, albums y artistas. Las restricciones de claves foraneas evitan eliminar elementos relacionados.
