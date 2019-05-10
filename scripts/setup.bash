#!/bin/bash

# required packages
sudo apt-get update && sudo apt-get install -y unzip

# ------------------------------------------------------------

#
# このファイルが存在するディレクトリがカレントディレクトリとなるようにする
#
cd $(dirname $0)

set -e

ASSETS_DIR="../assets"
KEYS_DIR="../keys"

#
# ssh
#
SSH_DIR="$HOME/.ssh"
ROOT_SSH_DIR="/root/.ssh"
PUBLIC_KEY="$KEYS_DIR/public_key"
PRIVATE_KEY="$KEYS_DIR/private_key"

if [ ! -f "$PUBLIC_KEY" ]; then
  echo "Please create the public key '$PWD/$PUBLIC_KEY'"
  exit 1
fi
if [ ! -f "$PRIVATE_KEY" ]; then
  echo "Please create the private key '$PWD/$PRIVATE_KEY'"
  exit 1
fi

# ssh config
cp -f $ASSETS_DIR/sshconfig "$SSH_DIR/config"
sudo bash -c "[ -d $ROOT_SSH_DIR ] || mkdir $ROOT_SSH_DIR" && sudo cp -f $ASSETS_DIR/sshconfig "$ROOT_SSH_DIR/config" # sudo git 用

# public keys
cat "$PUBLIC_KEY" >> "$SSH_DIR/authorized_keys"

# private keys
cp -f "$PRIVATE_KEY" "$SSH_DIR/private_key" && chmod 600 "$SSH_DIR/private_key"
sudo cp -f "$PRIVATE_KEY" "$ROOT_SSH_DIR/private_key" && sudo chmod 600 "$ROOT_SSH_DIR/private_key" # sudo git 用

#
# root ディレクトリ以下を git 管理下に置く
#
cp -f $ASSETS_DIR/.gitconfig "$HOME/.gitconfig"
sudo cp -f $ASSETS_DIR/_.gitignore /.gitignore
sudo git -C / init
read -p "Please input your repository url (e.g. git@github.com:unblee/isucon.git): " REPOSITORY_URL
sudo git remote add origin $REPOSITORY_URL
sudo git fetch
# sudo git branch master origin/master
# sudo git reset


#
# tools
#

# alp
(
  cd /tmp;
  wget https://github.com/tkuchiki/alp/releases/download/v0.0.4/alp_linux_amd64.zip \
  && unzip alp_linux_amd64.zip \
  && sudo mv alp_linux_amd64 /usr/local/bin/alp \
  && sudo chown root:root /usr/local/bin/alp
)

# vim
cp -f $ASSETS_DIR/.vimrc "$HOME/.vimrc"

# netdata
yes | bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh)

# dstat

sudo apt-get install dstat

#
# alias
#
BASH_PROFILE="$HOME/.bash_profile"
echo 'alias sgit="sudo git"' >> "$BASH_PROFILE"
echo 'alias systemctl="sudo systemctl"' >> "$BASH_PROFILE"
echo 'alias journalctl="sudo journalctl"' >> "$BASH_PROFILE"
echo 'alias mysql="mysql -uisucon -pisucon"' >> "$BASH_PROFILE"

echo "Setup Finished!"
echo "Please execute 'source ~/.bash_profile'"
