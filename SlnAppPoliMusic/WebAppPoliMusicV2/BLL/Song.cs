using System;
using System.Data;

namespace WebAppPoliMusicV2.BLL
{
    /// <summary>
    /// Logica de negocio de canciones. Valida y delega en DAL.Song.
    /// </summary>
    public class Song
    {
        private string strConnectionString;

        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        public int Save(Entities.Song song)
        {
            return new DAL.Song(strConnectionString).Save(song);
        }

        public DataTable Read()
        {
            return new DAL.Song(strConnectionString).Read();
        }

        public DataTable ReadById(int idSong)
        {
            return new DAL.Song(strConnectionString).ReadById(idSong);
        }

        /// <summary>
        /// Busca por cancion, artista o album. Si el texto esta vacio devuelve todas.
        /// </summary>
        public DataTable Search(string text)
        {
            if (text == null || text.Trim() == string.Empty)
            {
                return Read();
            }
            return new DAL.Song(strConnectionString).ReadByText(text.Trim());
        }

        public int Update(Entities.Song song)
        {
            return new DAL.Song(strConnectionString).Update(song);
        }

        public int Delete(int idSong)
        {
            return new DAL.Song(strConnectionString).Delete(idSong);
        }

        public int IncrementPlays(int idSong)
        {
            return new DAL.Song(strConnectionString).IncrementPlays(idSong);
        }

        public int CheckExistSong(string songName)
        {
            return new DAL.Song(strConnectionString).CheckExistSong(songName);
        }

        /// <summary>
        /// Validaciones antes de guardar/actualizar. Devuelve string.Empty si todo esta bien.
        /// </summary>
        public string Validations(Entities.Song song)
        {
            if (song.Name == null || song.Name.Trim() == string.Empty)
            {
                return "Song name is required!";
            }
            if (song.Name.Length > 50)
            {
                return "Song name must have 50 characters or less!";
            }
            if (song.ID == 0 && (song.Path == null || song.Path.Trim() == string.Empty))
            {
                return "Song file is required!";
            }
            if (song.Path != null && song.Path.Length > 255)
            {
                return "Song path is too long!";
            }
            int existing = CheckExistSong(song.Name.Trim());
            if (existing != 0 && existing != song.ID)
            {
                return "Song already registered!";
            }
            return string.Empty;
        }
    }
}
