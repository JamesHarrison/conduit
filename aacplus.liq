if (enable_aacplus_64k == true) then
  ignore(iceout(%aacplus(bitrate=64, channels=2, samplerate=44100),
    mount = "#{quote(stream_mount_prefix)}64k-aacplus.aac", name = "#{quote(stream_name)} 64k AAC+ 44.1kHz",source))
end
if (enable_aacplus_32k == true) then
  ignore(iceout(%aacplus(bitrate=32, channels=2, samplerate=44100),
    mount = "#{quote(stream_mount_prefix)}32k-aacplus.aac", name = "#{quote(stream_name)} 32k AAC+ 44.1kHz",source))
end