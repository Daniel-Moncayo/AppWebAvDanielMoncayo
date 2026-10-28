using System;
using System.Data;
using System.Data.SqlClient;

namespace WebAppPoliMusicV2.DAL
{
    /// <summary>
    /// Capa de acceso a datos de la tabla TBL_SONG (CRUD).
    /// Las consultas de lectura agregan el/los artistas (TBL_PLAYER + TBL_ARTIST)
    /// y el album (TBL_TRACKLIST + TBL_ALBUM) de cada cancion.
    /// </summary>
    public class Song
    {
        private const string SELECT_SONGS =
            "SELECT S.[ID_SONG], S.[SONG_NAME], S.[SONG_PATH], ISNULL(S.[PLAYS], 0) AS [PLAYS], " +
            // Artistas separados por coma (FOR XML PATH funciona desde SQL Server 2005)
            "ISNULL(STUFF((SELECT ', ' + A.[ARTIST_NAME] + ISNULL(' ' + A.[ARTIST_LASTNAME], '') " +
            "              FROM [TBL_PLAYER] P INNER JOIN [TBL_ARTIST] A ON A.[ID_ARTIST] = P.[ID_ARTIST] " +
            "              WHERE P.[ID_SONG] = S.[ID_SONG] ORDER BY A.[ARTIST_NAME] " +
            "              FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 2, ''), 'Unknown artist') AS [ARTISTS], " +
            // Primer album en el que aparece la cancion
            "ISNULL((SELECT TOP 1 AL.[TITLE_ALBUM] FROM [TBL_TRACKLIST] T " +
            "        INNER JOIN [TBL_ALBUM] AL ON AL.[ID_ALBUM] = T.[ID_ALBUM] " +
            "        WHERE T.[ID_SONG] = S.[ID_SONG] ORDER BY AL.[ID_ALBUM]), 'Single') AS [ALBUM] " +
            "FROM [TBL_SONG] S ";

        private string strConnectionString;

        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        // ---------------------------------------------------------------- CREATE
        public int Save(Entities.Song song)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "INSERT INTO [TBL_SONG]([SONG_NAME], [SONG_PATH], [PLAYS]) " +
                                      "VALUES(@SONG_NAME, @SONG_PATH, @PLAYS); " +
                                      "SELECT CAST(SCOPE_IDENTITY() AS INT);";
                    cmd.Parameters.AddWithValue("@SONG_NAME", song.Name);
                    cmd.Parameters.AddWithValue("@SONG_PATH", song.Path);
                    cmd.Parameters.AddWithValue("@PLAYS", song.Plays);
                    cmd.Connection = con;
                    con.Open();
                    // Devuelve el ID_SONG generado
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        // ---------------------------------------------------------------- READ
        public DataTable Read()
        {
            DataTable dtSong = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(SELECT_SONGS + "ORDER BY S.[SONG_NAME]", con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }

        public DataTable ReadById(int idSong)
        {
            DataTable dtSong = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(SELECT_SONGS + "WHERE S.[ID_SONG] = @ID_SONG", con))
                {
                    cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }

        /// <summary>
        /// Busca por nombre de cancion, artista o album.
        /// </summary>
        public DataTable ReadByText(string text)
        {
            DataTable dtSong = new DataTable();
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                string sentence = "SELECT * FROM (" + SELECT_SONGS + ") X " +
                                  "WHERE X.[SONG_NAME] LIKE @TEXT OR X.[ARTISTS] LIKE @TEXT OR X.[ALBUM] LIKE @TEXT " +
                                  "ORDER BY X.[SONG_NAME]";
                using (SqlCommand cmd = new SqlCommand(sentence, con))
                {
                    cmd.Parameters.AddWithValue("@TEXT", "%" + text + "%");
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }

        public int CheckExistSong(string songName)
        {
            object returnValue;
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "SELECT [ID_SONG] FROM [TBL_SONG] WHERE [SONG_NAME] = @SONG_NAME";
                    cmd.Parameters.AddWithValue("@SONG_NAME", songName);
                    cmd.Connection = con;
                    con.Open();
                    returnValue = cmd.ExecuteScalar();
                    return (returnValue == null) ? 0 : (int)returnValue;
                }
            }
        }

        // ---------------------------------------------------------------- UPDATE
        public int Update(Entities.Song song)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sentence = "UPDATE [TBL_SONG] SET [SONG_NAME] = @SONG_NAME";
                    if (song.Path != null && song.Path != string.Empty)
                    {
                        sentence += ", [SONG_PATH] = @SONG_PATH";
                    }
                    sentence += " WHERE [ID_SONG] = @ID_SONG";

                    cmd.CommandText = sentence;
                    cmd.Parameters.AddWithValue("@ID_SONG", song.ID);
                    cmd.Parameters.AddWithValue("@SONG_NAME", song.Name);
                    if (song.Path != null && song.Path != string.Empty)
                    {
                        cmd.Parameters.AddWithValue("@SONG_PATH", song.Path);
                    }
                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Suma 1 a las reproducciones y devuelve el nuevo total.
        /// </summary>
        public int IncrementPlays(int idSong)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "UPDATE [TBL_SONG] SET [PLAYS] = ISNULL([PLAYS], 0) + 1 WHERE [ID_SONG] = @ID_SONG; " +
                                      "SELECT ISNULL([PLAYS], 0) FROM [TBL_SONG] WHERE [ID_SONG] = @ID_SONG;";
                    cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                    cmd.Connection = con;
                    con.Open();
                    object returnValue = cmd.ExecuteScalar();
                    return (returnValue == null || returnValue == DBNull.Value) ? 0 : Convert.ToInt32(returnValue);
                }
            }
        }

        // ---------------------------------------------------------------- DELETE
        /// <summary>
        /// Elimina la cancion y sus relaciones (artistas, albumes y playlists) en una transaccion.
        /// </summary>
        public int Delete(int idSong)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                con.Open();
                SqlTransaction tran = con.BeginTransaction();
                try
                {
                    string[] sentences = new string[]
                    {
                        "DELETE [TBL_PLAYER] WHERE [ID_SONG] = @ID_SONG",
                        "DELETE [TBL_TRACKLIST] WHERE [ID_SONG] = @ID_SONG",
                        "DELETE [TBL_PLAYLIST_SONG] WHERE [ID_SONG] = @ID_SONG",
                        "DELETE [TBL_SONG] WHERE [ID_SONG] = @ID_SONG"
                    };
                    int rows = 0;
                    foreach (string sentence in sentences)
                    {
                        using (SqlCommand cmd = new SqlCommand(sentence, con, tran))
                        {
                            cmd.Parameters.AddWithValue("@ID_SONG", idSong);
                            rows = cmd.ExecuteNonQuery();
                        }
                    }
                    tran.Commit();
                    return rows; // filas eliminadas de TBL_SONG
                }
                catch
                {
                    tran.Rollback();
                    throw;
                }
            }
        }
    }
}
