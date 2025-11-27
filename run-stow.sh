#!/usr/bin/env bash

# /etc
sudo stow -v -t /etc keyd

# ~/.config
stow -v -t ~ 1password
stow -v -t ~ bash
stow -v -t ~ fcitx5
stow -v -t ~ ghostty
stow -v -t ~ git
stow -v -t ~ hyprland
stow -v -t ~ nvim
stow -v -t ~ starship
stow -v -t ~ tmux
stow -v -t ~ walker
stow -v -t ~ systemd
stow -v -t ~ waybar

# ~/.local/bin
stow -v -t ~/.local/bin bin

source ./enable-systemd.sh
