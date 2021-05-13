if [[ $1 == "--help" ]]; then
    echo "Usage: $0 <input-directory> [output-directory]"
    echo "If output directory is left unspecified, a directory named ./output is created."
    exit 0
fi

if ! [[ -e ./quickbms/quickbms ]]; then
    echo "quickbms not found in ./quickbms. Run ./build.sh or download an externally-built one,"
    echo "name it quickbms, and put it into ./quickbms."
    exit 1
fi

if ! [[ -e ./bnkextr/bnkextr ]]; then
    echo "bnkextr not found in ./bnkextr. Run ./build.sh or download an externally-built one,"
    echo "name it bnkextr, and put it into ./bnkextr."
    exit 1
fi

if ! [[ -e ./revorb-nix/revorb ]]; then
    echo "quickbms not found in ./revorb. Run ./build.sh or download an externally-built one,"
    echo "name it revorb, and put it into ./revorb-nix."
    exit 1
fi

if ! [[ -e ./ww2ogg/ww2ogg ]]; then
    echo "quickbms not found in ./ww2ogg. Run ./build.sh or download an externally-built one,"
    echo "name it ww2ogg, and put it into ./ww2ogg."
    exit 1
fi

if [[ $1 == "" ]]; then
    echo "Error: input directory is unspecified. See '$0 --help' for more."
    exit 1
fi

if [[ $2 == "" ]]; then
    echo "Note: output directory not specified, defaulting to ./output/."
    OUTPUT_DIR="./output/"
else
    OUTPUT_DIR="$2"
fi

mkdir $OUTPUT_DIR
mkdir ./quickbms/temp

for f in "$1/*.pck"; do
    ./quickbms/quickbms ./quickbms/wavescan.bms "$f" "./quickbms/temp"
done

for f in "$1/*.bnk"; do
    ./bnkextr/bnkextr "$f"
    
    f2=$(basename -- "$f")
    mv "$f" "./quickbms/temp/$f2"
done

for f in ./quickbms/temp/*; do
    ./ww2ogg/ww2ogg "$f" --pcb ./ww2ogg/packed_codebooks_aoTuV_603.bin
    ./revorb-nix/revorb "${f%.wav}.ogg"

    f2=$(basename -- "$f")
    mv "${f%.wav}.ogg" "$OUTPUT_DIR/${f2%.wav}.ogg"
done

rm -r ./quickbms/temp
