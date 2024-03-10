#!/bin/bash

echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# Kill any locked apt-get process

sudo pkill -9 apt-get

# Run apt-get update

sudo apt-get update -y

sudo pkill -9 apt-get

sudo dpkg --configure -a

# Install dependencies

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fuse libfuse2 nodejs ninja-build gettext cmake unzip curl ca-certificates

sudo DEBIAN_FRONTEND=noninteractive apt install -y npm

# Download Neovim appimage

mkdir -p ~/src

cd ~/src

wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim.appimage

chmod u+x nvim.appimage

# Install Docker

sudo DEBIAN_FRONTEND=noninteractive install -m 0755 -d /etc/apt/keyrings

sudo DEBIAN_FRONTEND=noninteractive curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Move Neovim appimage to /usr/local/bin

sudo mv nvim.appimage /usr/local/bin/nvim

# Clone Neovim configuration

git clone https://github.com/obarker94/dotfiles.git ~/.config

mv ~/.config/p10k/.p10k.zsh ~/

cd

sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh && \

yes | sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" && \

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \

sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc && \

echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=True' | tee -a ~/.zshrc > /dev/null && \

echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' | tee -a ~/.zshrc > /dev/null && \

# Restart Docker service

sudo systemctl restart docker

# Introduce a delay (10 seconds) to allow Docker service to restart

sleep 10

# Pull and run Nginx Docker container

docker pull nginx

docker run --name myServer -d -p 80:80 nginx

sudo apt install tmux

chsh -s $(which zsh)


