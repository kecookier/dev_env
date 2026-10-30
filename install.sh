#!/bin/bash
CUR_DIR=$(cd "$(dirname "$0")" && pwd)

TARGETS=(
    "${CUR_DIR}/.gitconfig"
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

# ===== .bashrc: source shared config instead of symlink =====
# machine ~/.bashrc may contain generated tooling (e.g. loongsuite-pilot hooks),
# so we never replace it; we only append a source line to pull in dev_env/.bashrc
_bsrc="$HOME/.bashrc"
_bsrc_src="${CUR_DIR}/.bashrc"
if [ -L "$_bsrc" ] && [ "$(readlink "$_bsrc")" = "$_bsrc_src" ]; then
    echo "warn:    $_bsrc is a legacy symlink to dev_env; consider migrating back to a real file"
elif [ -f "$_bsrc" ]; then
    if grep -q "dev_env/.bashrc" "$_bsrc"; then
        echo "ok:      $_bsrc already sources dev_env config"
    else
        printf '\n# ===== dev_env shared config (PS1/alias) =====\n[ -f "$HOME/dev_env/.bashrc" ] && . "$HOME/dev_env/.bashrc"\n' >> "$_bsrc"
        echo "bashrc:  appended dev_env source line to $_bsrc"
    fi
else
    ln -s "$_bsrc_src" "$_bsrc"
    echo "linked:  $_bsrc -> $_bsrc_src"
fi
