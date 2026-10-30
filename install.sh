#!/bin/bash
CUR_DIR=$(cd "$(dirname "$0")" && pwd)

TARGETS=(
    "${CUR_DIR}/.gitconfig"
    "${CUR_DIR}/.bashrc"
    "${CUR_DIR}/.local"
    "${CUR_DIR}/.tmux.conf"
    "${CUR_DIR}/.vimrc"
    "${CUR_DIR}/.vim"
)

link_file() {
    local src="$1"
    local dst="$HOME/$(basename "$1")"

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            echo "skip: $dst already points to $src"
        else
            echo "update: $dst ($(readlink "$dst") -> $src)"
            rm "$dst" && ln -sv "$src" "$dst"
        fi
    elif [ -e "$dst" ]; then
        echo "warn: $dst exists and is not a symlink, skipping"
    else
        ln -sv "$src" "$dst"
    fi
}

for target in "${TARGETS[@]}"; do
    link_file "$target"
done
