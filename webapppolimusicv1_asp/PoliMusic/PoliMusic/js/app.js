(function () {
  'use strict';
  const audio = document.getElementById('audio');
  const playBtn = document.getElementById('play');
  const progress = document.getElementById('progress');
  const volume = document.getElementById('volume');
  const title = document.getElementById('player-title');
  const artist = document.getElementById('player-artist');
  const cover = document.getElementById('player-cover');
  const currentTime = document.getElementById('current-time');
  const totalTime = document.getElementById('total-time');
  const toast = document.getElementById('toast');
  if (!audio) return;

  const base = window.POLIMUSIC_BASE || '';
  let queue = [];
  let index = -1;
  let repeat = false;
  let shuffled = false;

  const icon = (name) => {
    const paths = {
      play: '<path d="m8 5 11 7-11 7V5Z"/>',
      pause: '<path d="M8 5v14M16 5v14"/>'
    };
    return '<svg viewBox="0 0 24 24">' + paths[name] + '</svg>';
  };
  const format = (seconds) => {
    if (!isFinite(seconds) || seconds < 0) seconds = 0;
    const m = Math.floor(seconds / 60);
    const s = Math.floor(seconds % 60).toString().padStart(2, '0');
    return m + ':' + s;
  };
  const notify = (message) => {
    if (!toast) return;
    toast.textContent = message;
    toast.classList.add('show');
    clearTimeout(window.__pmToast);
    window.__pmToast = setTimeout(() => toast.classList.remove('show'), 2600);
  };
  const setPlayIcon = (playing) => {
    if (playBtn) playBtn.innerHTML = icon(playing ? 'pause' : 'play');
  };
  const cards = () => Array.from(document.querySelectorAll('.js-play-track'));
  const readTrack = (node) => ({
    id: node.dataset.songId || '',
    title: node.dataset.title || 'Cancion',
    artist: node.dataset.artist || 'PoliMusic',
    src: node.dataset.src || '',
    cover: node.dataset.cover || (base + 'assets/img/cover-default.svg')
  });
  const syncQueue = () => {
    const nodes = cards();
    if (!nodes.length) return;
    queue = nodes.map(readTrack);
  };
  const load = (track, autoPlay) => {
    if (!track || !track.src) { notify('Esta cancion no tiene audio configurado.'); return; }
    title.textContent = track.title;
    artist.textContent = track.artist;
    cover.src = track.cover;
    cover.onerror = () => { cover.src = base + 'assets/img/cover-default.svg'; };
    audio.src = track.src;
    audio.dataset.songId = track.id;
    audio.load();
    document.querySelectorAll('.js-play-track').forEach((el) => el.classList.toggle('playing', el.dataset.songId === track.id));
    if (autoPlay) {
      const promise = audio.play();
      if (promise && promise.catch) promise.catch(() => notify('Pulsa reproducir para iniciar el audio.'));
    }
    if (track.id) fetch(base + 'api/reproducir.asp?id=' + encodeURIComponent(track.id), { credentials: 'same-origin' }).catch(() => {});
  };
  const playAt = (newIndex, autoPlay) => {
    if (!queue.length) syncQueue();
    if (!queue.length) { notify('Aun no hay canciones para reproducir.'); return; }
    index = (newIndex + queue.length) % queue.length;
    load(queue[index], autoPlay !== false);
  };

  syncQueue();
  document.addEventListener('click', (event) => {
    const button = event.target.closest('.js-play-track');
    if (button) {
      event.preventDefault();
      syncQueue();
      const id = button.dataset.songId || '';
      const found = queue.findIndex((track) => track.id === id);
      playAt(found >= 0 ? found : 0, true);
    }
    const like = event.target.closest('.js-like');
    if (like) {
      event.preventDefault();
      const id = like.dataset.songId;
      fetch(base + 'api/favorito.asp?id=' + encodeURIComponent(id), { credentials: 'same-origin' })
        .then((r) => r.json()).then((data) => {
          if (data.ok) { like.classList.toggle('liked', !!data.liked); notify(data.liked ? 'Anadida a tus favoritas' : 'Quitada de tus favoritas'); }
          else notify(data.message || 'No se pudo actualizar favoritos');
        }).catch(() => notify('No se pudo conectar con PoliMusic'));
    }
  });
  if (playBtn) playBtn.addEventListener('click', () => {
    if (!audio.src) { syncQueue(); playAt(0, true); return; }
    if (audio.paused) audio.play(); else audio.pause();
  });
  document.getElementById('prev')?.addEventListener('click', () => playAt(index - 1, true));
  document.getElementById('next')?.addEventListener('click', () => playAt(index + 1, true));
  document.getElementById('shuffle')?.addEventListener('click', (e) => { shuffled = !shuffled; e.currentTarget.classList.toggle('liked', shuffled); notify(shuffled ? 'Modo aleatorio activado' : 'Modo aleatorio desactivado'); });
  document.getElementById('repeat')?.addEventListener('click', (e) => { repeat = !repeat; e.currentTarget.classList.toggle('liked', repeat); notify(repeat ? 'Repetir activado' : 'Repetir desactivado'); });
  audio.addEventListener('play', () => setPlayIcon(true));
  audio.addEventListener('pause', () => setPlayIcon(false));
  audio.addEventListener('timeupdate', () => { if (progress && audio.duration) progress.value = (audio.currentTime / audio.duration) * 100; if (currentTime) currentTime.textContent = format(audio.currentTime); });
  audio.addEventListener('loadedmetadata', () => { if (totalTime) totalTime.textContent = format(audio.duration); });
  audio.addEventListener('ended', () => { if (repeat) { audio.currentTime = 0; audio.play(); return; } playAt(shuffled ? Math.floor(Math.random() * queue.length) : index + 1, true); });
  progress?.addEventListener('input', () => { if (audio.duration) audio.currentTime = (progress.value / 100) * audio.duration; });
  volume?.addEventListener('input', () => { audio.volume = Number(volume.value); });
  audio.volume = Number(volume?.value || .8);
  window.PoliMusicPlayer = { playAt, queue };
})();
