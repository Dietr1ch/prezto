#!/bin/zsh
set -e

GITHUB_USERNAME="Dietr1ch"

if [ ! -n "$ZSH" ]; then
  ZSH=~/.zprezto
fi

if [ -d "$ZSH" ]; then
  echo "\033[0;33mYou already have prezto/oh-my-zsh installed.\033[0m You'll need to remove $ZSH if you want to install"
  exit
fi

echo "\033[0;34mCloning $GITHUB_USERNAME's repo...\033[0m"
hash git > /dev/null 2>&1  &&  env git clone --recursive https://github.com/$GITHUB_USERNAME/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" || {
  echo "git not installed"
  exit
}

echo "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc-old\033[0m";
  mv ~/.zshrc ~/.zshrc-old;
fi

echo "\033[0;34mCreating new zsh config\033[0m"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

echo "\033[0;34mCopying your current PATH and adding it to ~/.zpath for you. (You may want to setup the .zpath PATH by hand)\033[0m"
sed -i "s,\#EXPORT_OLD_PATH,export PATH='$PATH'," ~/.zpath

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "\033[0;34mTime to change your default shell to zsh!\033[0m"
    chsh -s /bin/zsh
fi

env zsh
. ~/.zshrc
