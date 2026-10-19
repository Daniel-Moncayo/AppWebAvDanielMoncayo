<!--#include file="includes/core.asp"-->
<%
'=====================================================================
'  PoliMusic - SongList (diseno propio)
'  - Roles: normal (solo escucha) y admin (CRUD de canciones)
'  - Saludo con el nombre guardado en sesion por login.asp
'=====================================================================
RequiereLogin

Dim accion, idSong, nombre, ruta, msg, tipoMsg, rs, rsEdit, editId, editNombre, editRuta
msg = "" : tipoMsg = "ok"
accion = LCase(Request("accion") & "")
idSong = IdSeguro(Request("id"))

'--- CRUD: solo administrador ----------------------------------------
If accion <> "" And accion <> "editar" Then
    If Not EsAdmin() Then
        msg = "No tienes permisos para modificar canciones." : tipoMsg = "error"
    Else
        On Error Resume Next
        Select Case accion
            Case "crear"
                nombre = Trim(Request.Form("nombre") & "")
                ruta   = Trim(Request.Form("ruta") & "")
                If nombre = "" Or ruta = "" Then
                    msg = "Completa el nombre y la ruta del audio." : tipoMsg = "error"
                Else
                    Ejecutar "INSERT INTO TBL_SONG(SONG_NAME,SONG_PATH,PLAYS) VALUES(" & SqlStr(nombre) & "," & SqlStr(ruta) & ",0)"
                    msg = "Cancion agregada correctamente."
                End If
            Case "actualizar"
                nombre = Trim(Request.Form("nombre") & "")
                ruta   = Trim(Request.Form("ruta") & "")
                If idSong = 0 Or nombre = "" Or ruta = "" Then
                    msg = "Datos incompletos para actualizar." : tipoMsg = "error"
                Else
                    Ejecutar "UPDATE TBL_SONG SET SONG_NAME=" & SqlStr(nombre) & ", SONG_PATH=" & SqlStr(ruta) & " WHERE ID_SONG=" & SqlInt(idSong)
                    msg = "Cancion actualizada correctamente."
                End If
            Case "eliminar"
                Ejecutar "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_SONG=" & SqlInt(idSong)
                Ejecutar "DELETE FROM TBL_TRACKLIST WHERE ID_SONG=" & SqlInt(idSong)
                Ejecutar "DELETE FROM TBL_PLAYER WHERE ID_SONG=" & SqlInt(idSong)
                Ejecutar "DELETE FROM TBL_SONG WHERE ID_SONG=" & SqlInt(idSong)
                msg = "Cancion eliminada."
        End Select
        If Err.Number <> 0 Then
            msg = "Error: " & Err.Description : tipoMsg = "error"
            Err.Clear
        End If
        On Error GoTo 0
    End If
End If

'--- Cancion a editar (carga el formulario) ---------------------------
editId = 0 : editNombre = "" : editRuta = ""
If accion = "editar" And EsAdmin() And idSong > 0 Then
    Set rsEdit = Consultar("SELECT ID_SONG,SONG_NAME,SONG_PATH FROM TBL_SONG WHERE ID_SONG=" & SqlInt(idSong))
    If Not rsEdit.EOF Then
        editId = rsEdit("ID_SONG") : editNombre = rsEdit("SONG_NAME") & "" : editRuta = rsEdit("SONG_PATH") & ""
    End If
    rsEdit.Close
End If

Set rs = Consultar( _
    "SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS,0) AS PLAYS, " & _
    "ISNULL((SELECT TOP 1 a.ARTIST_NAME + ' ' + ISNULL(a.ARTIST_LASTNAME,'') FROM TBL_PLAYER p " & _
    "INNER JOIN TBL_ARTIST a ON a.ID_ARTIST = p.ID_ARTIST WHERE p.ID_SONG = s.ID_SONG), 'Artista desconocido') AS ARTISTA " & _
    "FROM TBL_SONG s ORDER BY s.ID_SONG")
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>SongList - PoliMusic</title>
<style>
  :root{
    --fondo:#0b1426; --panel:#13213d; --panel2:#1a2c50; --linea:#24395f;
    --texto:#e8eefc; --suave:#93a4c7; --azul:#2f80ff; --azul2:#5aa2ff;
    --cian:#22d3ee; --rojo:#ef4565; --ok:#2dd4a7;
  }
  *{box-sizing:border-box}
  body{margin:0;font-family:"Segoe UI",Roboto,Arial,sans-serif;background:
       radial-gradient(1200px 500px at 10% -10%,#1d3b78 0%,transparent 60%),var(--fondo);
       color:var(--texto);min-height:100vh}
  header{display:flex;justify-content:space-between;align-items:center;padding:18px 32px;
         border-bottom:1px solid var(--linea);background:rgba(11,20,38,.75);backdrop-filter:blur(6px);
         position:sticky;top:0;z-index:5}
  .logo{font-weight:800;font-size:22px;letter-spacing:.5px}
  .logo span{color:var(--azul2)}
  .usuario{display:flex;align-items:center;gap:14px;font-size:14px}
  .rol{padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;
       background:var(--panel2);color:var(--cian);border:1px solid var(--linea)}
  .rol.admin{color:#ffd166;border-color:#5b4a1c}
  .btn{border:0;border-radius:8px;padding:9px 16px;font-weight:600;cursor:pointer;text-decoration:none;
       font-size:13px;display:inline-flex;align-items:center;gap:6px;transition:.15s}
  .btn-azul{background:linear-gradient(135deg,var(--azul),var(--azul2));color:#fff}
  .btn-azul:hover{filter:brightness(1.1)}
  .btn-borde{background:transparent;color:var(--texto);border:1px solid var(--linea)}
  .btn-borde:hover{border-color:var(--azul2)}
  .btn-rojo{background:transparent;color:var(--rojo);border:1px solid #5a2333}
  .btn-rojo:hover{background:var(--rojo);color:#fff}
  main{max-width:1100px;margin:0 auto;padding:32px}
  .bienvenida{background:linear-gradient(120deg,var(--panel2),var(--panel));border:1px solid var(--linea);
              border-radius:16px;padding:26px 30px;margin-bottom:26px}
  .bienvenida h1{margin:0 0 6px;font-size:28px}
  .bienvenida h1 b{color:var(--azul2)}
  .bienvenida p{margin:0;color:var(--suave)}
  h2.titulo{font-size:20px;margin:0 0 4px}
  .sub{color:var(--suave);margin:0 0 18px;font-size:14px}
  .alerta{padding:12px 16px;border-radius:10px;margin-bottom:18px;font-size:14px}
  .alerta.ok{background:rgba(45,212,167,.12);border:1px solid rgba(45,212,167,.4);color:var(--ok)}
  .alerta.error{background:rgba(239,69,101,.12);border:1px solid rgba(239,69,101,.4);color:var(--rojo)}
  .formulario{background:var(--panel);border:1px solid var(--linea);border-radius:14px;padding:20px;margin-bottom:24px}
  .formulario h3{margin:0 0 14px;font-size:15px}
  .fila{display:grid;grid-template-columns:1fr 1fr auto;gap:12px;align-items:end}
  label{display:block;font-size:12px;color:var(--suave);margin-bottom:5px}
  input{width:100%;padding:10px 12px;border-radius:8px;border:1px solid var(--linea);background:var(--fondo);
        color:var(--texto);font-size:14px}
  input:focus{outline:none;border-color:var(--azul2)}
  .tabla-wrap{background:var(--panel);border:1px solid var(--linea);border-radius:14px;overflow-x:auto}
  table{width:100%;border-collapse:collapse;font-size:14px}
  thead th{text-align:left;padding:14px 16px;color:var(--suave);font-size:12px;text-transform:uppercase;
           letter-spacing:.6px;border-bottom:1px solid var(--linea);background:var(--panel2)}
  tbody td{padding:12px 16px;border-bottom:1px solid var(--linea)}
  tbody tr:last-child td{border-bottom:0}
  tbody tr:hover{background:rgba(47,128,255,.07)}
  tbody tr.sonando{background:rgba(34,211,238,.10)}
  tbody tr.sonando .nombre{color:var(--cian)}
  .num{color:var(--suave);width:40px}
  .nombre{font-weight:600}
  .artista{color:var(--suave);font-size:13px}
  .play{width:38px;height:38px;border-radius:50%;border:0;cursor:pointer;font-size:15px;
        background:var(--azul);color:#fff;transition:.15s}
  .play:hover{transform:scale(1.08);background:var(--azul2)}
  .acciones{display:flex;gap:8px}
  .vacio{text-align:center;color:var(--suave);padding:30px}
  .reproductor{position:fixed;left:0;right:0;bottom:0;background:#08101f;border-top:1px solid var(--linea);
               padding:12px 32px;display:flex;align-items:center;gap:20px}
  .reproductor .actual{min-width:220px;font-size:14px}
  .reproductor .actual small{display:block;color:var(--suave)}
  .reproductor audio{flex:1;height:36px}
  main{padding-bottom:110px}
  @media (max-width:700px){
    header,main,.reproductor{padding-left:16px;padding-right:16px}
    .fila{grid-template-columns:1fr}
    .reproductor{flex-direction:column;align-items:stretch;gap:8px}
  }
</style>
</head>
<body>
<header>
  <div class="logo">Poli<span>Music</span></div>
  <div class="usuario">
    <span><%=Html(UsuarioNombre())%></span>
    <% If EsAdmin() Then %><span class="rol admin">Admin</span><% Else %><span class="rol">Normal</span><% End If %>
    <a class="btn btn-borde" href="logout.asp">Cerrar sesi&oacute;n</a>
  </div>
</header>

<main>
  <section class="bienvenida">
    <h1>&iexcl;Bienvenido, <b><%=Html(Session("PM_Nombre"))%></b>!</h1>
    <p>Disfruta de tu m&uacute;sica favorita en PoliMusic.</p>
  </section>

  <h2 class="titulo">SongList</h2>
  <p class="sub">A continuaci&oacute;n se presenta el listado de canciones disponibles.</p>

  <% If msg <> "" Then %><div class="alerta <%=tipoMsg%>"><%=Html(msg)%></div><% End If %>

  <% If EsAdmin() Then %>
  <div class="formulario">
    <% If editId > 0 Then %>
    <h3>Editar canci&oacute;n #<%=editId%></h3>
    <form method="post" action="songlist.asp">
      <input type="hidden" name="accion" value="actualizar">
      <input type="hidden" name="id" value="<%=editId%>">
      <div class="fila">
        <div><label>Nombre</label><input name="nombre" maxlength="50" required value="<%=Html(editNombre)%>"></div>
        <div><label>Ruta del audio</label><input name="ruta" maxlength="255" required value="<%=Html(editRuta)%>"></div>
        <div class="acciones"><button class="btn btn-azul" type="submit">Guardar</button><a class="btn btn-borde" href="songlist.asp">Cancelar</a></div>
      </div>
    </form>
    <% Else %>
    <h3>Nueva canci&oacute;n</h3>
    <form method="post" action="songlist.asp">
      <input type="hidden" name="accion" value="crear">
      <div class="fila">
        <div><label>Nombre</label><input name="nombre" maxlength="50" required></div>
        <div><label>Ruta del audio</label><input name="ruta" maxlength="255" placeholder="~/songFiles/archivo.mp3" required></div>
        <div><button class="btn btn-azul" type="submit">+ Agregar</button></div>
      </div>
    </form>
    <% End If %>
  </div>
  <% End If %>

  <div class="tabla-wrap">
    <table>
      <thead>
        <tr>
          <th>#</th><th></th><th>Canci&oacute;n</th><th>Artista</th><th>Reproducciones</th>
          <% If EsAdmin() Then %><th>Acciones</th><% End If %>
        </tr>
      </thead>
      <tbody>
      <% If rs.EOF Then %>
        <tr><td class="vacio" colspan="6">No hay canciones registradas.</td></tr>
      <% End If
         Dim n : n = 0
         Do While Not rs.EOF
           n = n + 1 %>
        <tr data-id="<%=rs("ID_SONG")%>">
          <td class="num"><%=n%></td>
          <td><button class="play" type="button" title="Reproducir"
                data-src="<%=Html(AudioRuta(rs("SONG_PATH")))%>"
                data-nombre="<%=Html(rs("SONG_NAME"))%>"
                data-artista="<%=Html(rs("ARTISTA"))%>">&#9654;</button></td>
          <td class="nombre"><%=Html(rs("SONG_NAME"))%></td>
          <td class="artista"><%=Html(rs("ARTISTA"))%></td>
          <td class="plays"><%=rs("PLAYS")%></td>
          <% If EsAdmin() Then %>
          <td class="acciones">
            <a class="btn btn-borde" href="songlist.asp?accion=editar&id=<%=rs("ID_SONG")%>">Editar</a>
            <a class="btn btn-rojo" href="songlist.asp?accion=eliminar&id=<%=rs("ID_SONG")%>"
               onclick="return confirm('&iquest;Eliminar esta canci&oacute;n?')">Eliminar</a>
          </td>
          <% End If %>
        </tr>
      <%   rs.MoveNext
         Loop
         rs.Close %>
      </tbody>
    </table>
  </div>
</main>

<div class="reproductor">
  <div class="actual" id="actual">Selecciona una canci&oacute;n<small>&nbsp;</small></div>
  <audio id="audio" controls></audio>
</div>

<script>
(function () {
  var audio = document.getElementById('audio');
  var actual = document.getElementById('actual');
  var filaActiva = null;

  document.querySelectorAll('.play').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var fila = btn.closest('tr');
      if (filaActiva === fila && !audio.paused) {
        audio.pause();
        return;
      }
      if (filaActiva !== fila) {
        audio.src = btn.dataset.src;
        actual.innerHTML = '';
        actual.appendChild(document.createTextNode(btn.dataset.nombre));
        var s = document.createElement('small');
        s.textContent = btn.dataset.artista;
        actual.appendChild(s);
        if (filaActiva) filaActiva.classList.remove('sonando');
        filaActiva = fila;
        fila.classList.add('sonando');
        // Suma una reproduccion en la BD
        fetch('api/reproducir.asp?id=' + fila.dataset.id).catch(function () {});
      }
      audio.play();
    });
  });

  audio.addEventListener('play', function () { if (filaActiva) filaActiva.querySelector('.play').innerHTML = '&#10074;&#10074;'; });
  audio.addEventListener('pause', function () { if (filaActiva) filaActiva.querySelector('.play').innerHTML = '&#9654;'; });
})();
</script>
</body>
</html>
<% CerrarConexion %>
