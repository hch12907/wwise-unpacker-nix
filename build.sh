#!/bin/bash

if [[ $1 == "--help" ]]; then
    echo "Usage: $0 [no_quickbms],[no_revorb],[no_ww2ogg],[no_bnkextr]"
    echo "Example: $0 no_quickbms (for when you are using externally built quickbms)"
    echo ""
    echo "The built binaries are placed in the root of their respective directories, which are"
    echo "  ./quickbms/ for quickbms, ./bnkextr/ for bnkextr, ./revorb-nix/ for revorb, and ./ww2ogg/ for ww2ogg."

    exit 0
fi

RED='\033[0;31m'
PURPLE='\033[0;35m'
CLEAR='\033[0m'

QUICKBMS_DONE=1
BNKEXTR_DONE=1
REVORB_DONE=1
WW2OGG_DONE=1

CURRENT_DIR="$PWD"

# build quickbms
if [[ $1 != *"no_quickbms"* ]]; then
    cd ./quickbms/src
    echo -e "${PURPLE}Building quickbms...${CLEAR}\n"
    make

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed building quickbms! Did you put the relevant files in ./quickbms?${CLEAR}"
        QUICKBMS_DONE=0
    fi

    cp quickbms ../quickbms

    cd "$CURRENT_DIR"
fi

# build bnkextr
if [[ $1 != *"no_bnkextr"* ]]; then
    cd ./bnkextr
    echo -e "${PURPLE}Building bnkextr...${CLEAR}\n"
    cmake .
    cmake --build .
    
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed building bnkextr! Did you run: git submodule init && git submodule update ?${CLEAR}"
        BNKEXTR_DONE=1
    fi

    cd "$CURRENT_DIR"
fi

# build revorb
if [[ $1 != *"no_revorb"* ]]; then
    cd ./revorb-nix
    echo -e "${PURPLE}Building revorb...${CLEAR}\n"
    ./build.sh
    
    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed building revorb! Did you run: git submodule init && git submodule update ?${CLEAR}"
        REVORB_DONE=0
    fi

    cd "$CURRENT_DIR"
fi

if [[ $1 != *"no_ww2ogg"* ]]; then
    cd ./ww2ogg
    echo -e "${PURPLE}Building ww2ogg...${CLEAR}\n"
    make

    if [[ $? -ne 0 ]]; then
        echo -e "${RED}Failed building ww2ogg! Did you run: git submodule init && git submodule update ?${CLEAR}"
        WW2OGG_DONE=0
    fi

    cd "$CURRENT_DIR"
fi

if [[ $(expr $QUICKBMS_DONE + $BNKEXTR_DONE + $REVORB_DONE + $WW2OGG_DONE) -eq 4 ]]; then
    echo -e "\n${PURPLE}Build complete.${CLEAR}"
else
    echo -e "\n${PURPLE}Build incomplete. Please ensure you have the relevant dependencies installed, and then rebuild the repo.${CLEAR}"
fi
