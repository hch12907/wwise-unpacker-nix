# Wwise-Unpacker-nix

This is the *nix-compatible version of [Wwise-Unpacker](https://github.com/Vextil/Wwise-Unpacker),
read the README there for more general information about this tool.

## Build
First, you have to build all the dependencies for this tool to work:

```bash
$ git submodule init && git submodule update
$ ./build.sh
```

For quickbms, download the source code from [here](https://aluigi.altervista.org/quickbms.htm) and put it
into ./quickbms.

The directory structure should look like this:

```
 - wwise-unpacker-nix
   - bnkextr
   - quickbms
     - src
       - <...the source files for quickbms...>
     - wavescan.bms
   - revorb-nix
   - ww2ogg
```

Alternatively, you can download the static build from the same site, put the `quickbms` binary into
`./quickbms`, and then run `./build.sh no_quickbms` to build the rest of the tools. In this case,
`./quickbms/src` need not exist.

## Usage
After building all the necessary tools, run the script `./unpack_to_ogg.sh` to unpack your files.
The basic usage of this tool:

```
    Usage: ./unpack_to_ogg.sh <input-directory> [output-directory]
    If output directory is left unspecified, a directory named ./output is created.
```

For MP3 support, install ffmpeg, and run the following command in your output directory:

```bash
for f in *.ogg; do ffmpeg -i "$f" -acodec libmp3lame -q:a 0 -y "${f%.ogg}.mp3" && rm "$f"; done
```

## Credits
All credits go to the people who had created the original Wwise-Unpacker tool, quickbms, bnkextr,
ww2ogg, and revorb-nix.
