#! /bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# shellcheck disable=SC2016
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "${HOME}/.zshrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install \
    ast-grep \
    bat \
    broot \
    btop \
    direnv \
    dust \
    grex \
    htmlq \
    pipx \
    ripgrep \
    teaxyz/pkgs/tea-cli \
    thefuck \
    tokei \
    up \
    yq
# shellcheck disable=SC2016
{
    echo 'source <(tea --magic=zsh)'
    echo 'eval "$(direnv hook zsh)"'
    echo 'eval "$(thefuck --alias oops)"'
    echo 'alias sgrep=ast-grep'
} >> "${HOME}/.zshrc"