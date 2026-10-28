using System;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV2
{
    /// <summary>
    /// Pantalla principal de canciones (estilo Spotify).
    /// Lista TBL_SONG en un GridView, permite buscar y reproducir,
    /// y suma reproducciones mediante un client callback (ICallbackEventHandler, disponible desde .NET 2.0).
    /// </summary>
    public partial class Song : System.Web.UI.Page, ICallbackEventHandler
    {
        string strConnString = ConfigurationManager.ConnectionStrings["BDD_PoliMusicConnectionString"].ConnectionString;
        private string callbackResult = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterPlayCallback();

            if (!Page.IsPostBack)
            {
                ShowUser();
                LoadSongs();
            }
        }

        // ------------------------------------------------------------ usuario autenticado
        private void ShowUser()
        {
            Entities.User user = Session[Util.Constants.USER] as Entities.User;
            string userName = (user != null) ? user.UserName : Context.User.Identity.Name;
            if (string.IsNullOrEmpty(userName))
            {
                userName = "Guest";
            }

            lblUser.Text = Server.HtmlEncode(userName);
            litAvatarInitial.Text = Server.HtmlEncode(userName.Substring(0, 1).ToUpper());
            litGreeting.Text = Greeting() + ", " + Server.HtmlEncode(userName);

            if (user != null && !string.IsNullOrEmpty(user.Photo))
            {
                imgUser.ImageUrl = user.Photo;
                // Si la foto no existe en el servidor, se queda la inicial
                imgUser.Attributes["onerror"] = "this.style.display='none'";
                imgUser.Visible = true;
            }
        }

        private string Greeting()
        {
            int hour = DateTime.Now.Hour;
            if (hour < 12) return "Good morning";
            if (hour < 19) return "Good afternoon";
            return "Good evening";
        }

        // ------------------------------------------------------------ canciones
        private void LoadSongs()
        {
            try
            {
                DataTable dtSongs = new BLL.Song(strConnString).Search(txtSearch.Text);
                gvSongs.DataSource = dtSongs;
                gvSongs.DataBind();

                if (gvSongs.HeaderRow != null)
                {
                    // Genera <thead> para la tabla
                    gvSongs.HeaderRow.TableSection = TableRowSection.TableHeader;
                }

                litCount.Text = dtSongs.Rows.Count.ToString();
                if (string.IsNullOrEmpty(litLibCount.Text) || txtSearch.Text.Trim() == string.Empty)
                {
                    litLibCount.Text = dtSongs.Rows.Count.ToString();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading songs: " + Server.HtmlEncode(ex.Message);
                litCount.Text = "0";
            }
        }

        protected void GvSongs_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView row = (DataRowView)e.Row.DataItem;
                e.Row.CssClass = "track";
                // Datos que usa el reproductor (JavaScript) para cada fila
                e.Row.Attributes["data-id"] = row["ID_SONG"].ToString();
                e.Row.Attributes["data-src"] = GetSongUrl(row["SONG_PATH"]);
                e.Row.Attributes["data-title"] = row["SONG_NAME"].ToString();
                e.Row.Attributes["data-artist"] = row["ARTISTS"].ToString();
                e.Row.Attributes["data-cover"] = CoverClass(row["ID_SONG"]);
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadSongs();
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadSongs();
        }

        // ------------------------------------------------------------ helpers para el diseño
        /// <summary>
        /// Convierte SONG_PATH ("~/songFiles/x.mp3", "../songFiles/x.mp3" o solo "x.mp3")
        /// en una URL valida dentro del sitio.
        /// </summary>
        protected string GetSongUrl(object songPath)
        {
            if (songPath == null || songPath == DBNull.Value)
            {
                return string.Empty;
            }
            string path = songPath.ToString().Trim().Replace("\\", "/");
            if (path == string.Empty)
            {
                return string.Empty;
            }
            if (path.StartsWith("http://") || path.StartsWith("https://"))
            {
                return path;
            }

            string fileName = path.Substring(path.LastIndexOf('/') + 1);

            // songFolderPath = "../songFiles/" en Web.config -> "~/songFiles/"
            string folder = ConfigurationManager.AppSettings["songFolderPath"];
            if (string.IsNullOrEmpty(folder))
            {
                folder = "~/songFiles/";
            }
            folder = "~/" + folder.TrimStart('.', '~', '/');
            if (!folder.EndsWith("/"))
            {
                folder += "/";
            }
            return ResolveUrl(folder + Uri.EscapeDataString(fileName));
        }

        protected string Html(object value)
        {
            return (value == null || value == DBNull.Value) ? string.Empty : Server.HtmlEncode(value.ToString());
        }

        protected string Initial(object value)
        {
            string text = (value == null || value == DBNull.Value) ? string.Empty : value.ToString().Trim();
            return text == string.Empty ? "?" : Server.HtmlEncode(text.Substring(0, 1).ToUpper());
        }

        protected string CoverClass(object idSong)
        {
            int id;
            if (idSong == null || !int.TryParse(idSong.ToString(), out id))
            {
                id = 0;
            }
            return "c" + (Math.Abs(id) % 6);
        }

        // ------------------------------------------------------------ callback: sumar reproduccion
        private void RegisterPlayCallback()
        {
            string callbackRef = ClientScript.GetCallbackEventReference(
                this, "songId", "PoliMusic.onPlayRegistered", "context", "PoliMusic.onPlayError", true);
            string script = "function registerPlay(songId, context) { " + callbackRef + "; }";
            ClientScript.RegisterClientScriptBlock(GetType(), "registerPlay", script, true);
        }

        public void RaiseCallbackEvent(string eventArgument)
        {
            int idSong;
            if (int.TryParse(eventArgument, out idSong))
            {
                int plays = new BLL.Song(strConnString).IncrementPlays(idSong);
                callbackResult = idSong + "|" + plays;
            }
            else
            {
                callbackResult = string.Empty;
            }
        }

        public string GetCallbackResult()
        {
            return callbackResult;
        }
    }
}
