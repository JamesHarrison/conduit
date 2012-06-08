#!/usr/bin/liquidsoap -v

# Pull in configuration

%include "configuration.liq"

## Liquidsoap Runtime parameters
# Allow remote access on telnet
set("server.telnet", true)
set("server.telnet.bind_addr","0.0.0.0")
set("server.telnet.port",1234)
set("log.file.path", log_file_path)
set("log.stdout", true)
set("harbor.bind_addr","0.0.0.0")

# Input from ALSA
soundcard_source = mksafe(input.alsa(bufferize=false,clock_safe=false))
# If you really want you can use JACK with this but it's a bit clunky and won't auto-reconnect ports by itself!
# soundcard_source = strip_blank(length=35.,threshold=-60.,track_sensitive=false,input.jack())

# Input from the file system
backup_music = playlist.safe(mode="random",reload=21600,"./backup-material/music/*")
backup_jingles = playlist.safe(mode="random",reload=21600,"./backup-material/jingles/*")
backup_source = backup_music
backup_source = random(weights = [1, 4],[backup_jingles, backup_source])
backup_source = smart_crossfade(fade_out=0.5,fade_in=0.5,backup_source)
backup_source = skip_blank(threshold=-35.,length=3.,backup_source)

# Input from the harbor (external HTTP streams)
# (Allows for takeover from the backup system)
takeover_source = input.harbor("backup-harbor",port=harbor_port,password=harbor_password)

# Set up our backup for ALSA
infallible_alsa = fallback(track_sensitive=false,[soundcard_source, backup_source])
# And finally let our takeover, er, takeover.
source = fallback(track_sensitive=false, [takeover_source, infallible_alsa])

## Audio processing

# Gate the input for starters, stops noise from clobbering things in silent periods.
source = ladspa.gate(source, threshold = -60.0, attack = 0.15, hold = 1.0, decay = 200.0, range = -25.0)
# Multiband compression - split up, compress, recombine, sky does it all, but is not very configurable. 3-band.
source = sky(source)
# Now overall compression, faster attack, harder ratio, mostly RMS based.
source = compress(source, attack = 5.0, gain = 8.0, knee = 10.0, ratio = 5.0, release = 100.0, threshold = -18.0, rms_window = 0.7)
# Normalize, with a higher threshold to stop suck-up.
source = normalize(source, target = -1.0, threshold = -65.0)
# Limiter, this one's a scaling one which limits nicely and without artefacting mostly
source = ladspa.tap_limiter(source, limit_level = -0.5)
# And a final limiter - this should never really get hit, but stops anything nasty hitting the DAC. Highly peak-focused.
source = limit(source, threshold = -0.2, attack = 2.0, release = 25.0, rms_window = 0.02)
# Stick a meter on this. This is queryable via telnet. Force the source name.
source = server.rms(source, id="input_source")

# Stream it out in all the formats we want.
if enable_mp3 == true then
  if enable_mp3_320k == true then
    ignore(output.icecast(%mp3(bitrate=320, samplerate=48000),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}320k.mp3",
      name = "#{quote(stream_name)} 320k MP3 48kHz",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_mp3_192k == true then
    ignore(output.icecast(%mp3(bitrate=192, samplerate=44100),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}192k.mp3",
      name = "#{quote(stream_name)} 192k MP3",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_mp3_96k == true then
    ignore(output.icecast(%mp3(bitrate=96, samplerate=44100),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}96k.mp3",
      name = "#{quote(stream_name)} 96k MP3",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
end
if enable_aacplus == true then
  # Pull this in if we need it.
  %include "aacplus.liq"
end
if enable_aac then
  if enable_aac_192k == true then
    ignore(output.icecast(%aac(bitrate=192, channels=2, samplerate=44100, adts=true),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}192k.aac",
      name = "#{quote(stream_name)} 192k AAC",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_aac_128k == true then
    ignore(output.icecast(%aac(bitrate=128, channels=2, samplerate=44100, adts=true),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}128k.aac",
      name = "#{quote(stream_name)} 128k AAC",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_aac_96k == true then
    ignore(output.icecast(%aac(bitrate=96, channels=2, samplerate=44100, adts=true),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}96k.aac",
      name = "#{quote(stream_name)} 96k AAC",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_aac_64k == true then
    ignore(output.icecast(%aac(bitrate=64, channels=2, samplerate=44100, adts=true),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}64k.aac",
      name = "#{quote(stream_name)} 64k AAC",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_aac_32k == true then
    ignore(output.icecast(%aac(bitrate=32, channels=2, samplerate=44100, adts=true),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}32k.aac",
      name = "#{quote(stream_name)} 32k AAC",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
end
if enable_flac == true then
  ignore(output.icecast(%ogg(%flac(compression=7, channels=2, samplerate=48000, bits_per_sample=16)),
    host = stream_host, port = stream_port,
    password = stream_password, mount = "#{quote(stream_mount_prefix)}flac.ogg",
    name = "#{quote(stream_name)} FLAC 48kHz",
    genre = stream_genre,
    timeout = 10.0,
    url = stream_url,
    description = stream_description,
    source))
end
if enable_vorbis == true then
  if enable_vorbis_high == true then
    ignore(output.icecast(%ogg(%vorbis(quality=0.9, channels=2, samplerate=44100)),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}high-vbr.ogg",
      name = "#{quote(stream_name)} Vorbis High VBR",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
  if enable_vorbis_low == true then
    ignore(output.icecast(%ogg(%vorbis(quality=0.3, channels=2, samplerate=44100)),
      host = stream_host, port = stream_port,
      password = stream_password, mount = "#{quote(stream_mount_prefix)}low-vbr.ogg",
      name = "#{quote(stream_name)} Vorbis Low VBR",
      genre = stream_genre,
      timeout = 10.0,
      url = stream_url,
      description = stream_description,
      source))
  end
end