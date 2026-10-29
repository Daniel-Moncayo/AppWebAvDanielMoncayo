using System;

namespace EntityLayer.PoliMusicV3
{
    /// <summary>
    /// Entidad que representa un registro de la tabla TBL_SONG.
    /// </summary>
    public class Song
    {
        public Song()
        {
        }

        public Song(int id, string name, string path, int plays)
        {
            ID = id;
            Name = name;
            Path = path;
            Plays = plays;
        }

        public int ID { get; set; }      // ID_SONG
        public string Name { get; set; } // SONG_NAME  varchar(50)
        public string Path { get; set; } // SONG_PATH  varchar(255)  ej: ~/songFiles/bensound-adventure.mp3
        public int Plays { get; set; }   // PLAYS
    }
}
