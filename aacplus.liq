if (enable_aacplus_64k == true) then
  output.icecast(%aacplus(bitrate=64, channels=2, samplerate=44100),
    host = stream_host, port = stream_port,
    password = stream_password, mount = "#{quote(live)}64k-aacplus.aac",
    name = "#{quote(stream_name)} 64k HE-AACv2",
    genre = stream_genre,
    timeout = 10.0,
    url = stream_url,
    description = stream_description,
    source)
end
if (enable_aacplus_32k == true) then
  output.icecast(%aacplus(bitrate=32, channels=2, samplerate=44100),
    host = stream_host, port = stream_port,
    password = stream_password, mount = "#{quote(live)}32k-aacplus.aac",
    name = "#{quote(stream_name)} 32k HE-AACv2",
    genre = stream_genre,
    timeout = 10.0,
    url = stream_url,
    description = stream_description,
    source)
end