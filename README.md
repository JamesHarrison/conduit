# Conduit

A simple Liquidsoap based online stream encoder for broadcast audio. It is intended to be used as a gateway between a sound card (ALSA, tentative JACK support) and Icecast, where your streams can be distributed out to the internet for listeners.

It provides level data telemetry for monitoring, automatic playback of a set of jingles and music in the event of audio loss on the sound card, and provides for remote takeover of the audio source from any Icecast-supporting audio encoder source to allow for remote intervention of the audio stream, eg for remote broadcasting in internet-radio only situations.

Conduit also provides a basic audio processing chain on top of standard encoding. Audio is run through a multiband compressor, an overall compressor (for general gain control), normalised, and limited.

It supports a wide variety of encoding formats and bitrates out of the box and can be set up with nearly no work - just configure and run.

## Installation

First install liquidsoap and plugins - on Ubuntu 12.04, this is `sudo apt-get install liquidsoap-plugin-all liquidsoap`.

Next, clone and configure:

    git clone git://github.com/JamesHarrison/conduit.git
    cd conduit
    cp configuration.liq.example configuration.liq

Now edit the configuration file with your Icecast details and streams you want enabled, for instance with nano (`nano -w configuration.liq`).

### Running conduit

In simple situations, you can run conduit with `liquidsoap conduit.liq`. However, chances are you want some monitoring in your production environment.

## Contributing

Standard git model:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request against this project in github

I'll also accept patches if you prefer working with that, so long as they're minimally intrusive and can be run against the latest codebase without conflicts.

## License

Copyright (c) 2012, James Harrison. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Conduit nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMES HARRISON BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

### aacPlus Licensing

Conduit optionally makes use of the aacPlus encoder built into Liquidsoap. This is disabled by default. aacPlus is a bit *interesting* license-wise, so you may wish to not make use of this encoder. If you do not enable it, the encoder will not be referenced from the script and can be left unloaded from liquidsoap.
