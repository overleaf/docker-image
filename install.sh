#!/bin/bash

# Install Node.js and Grunt
# update package chache
# zlib1g-dev is needed to compile the synctex binaries in the CLSI during `grunt install`.
# Install unzip for file uploads
# Install imagemagick for image conversions
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get update && apt-get install -y build-essential nodejs git python zlib1g-dev nginx wget unzip imagemagick optipng
npm install -g grunt-cli

# Set up sharelatex user and home directory
adduser --system --group --home /var/www/sharelatex --no-create-home sharelatex
mkdir -p /var/lib/sharelatex
chown sharelatex:sharelatex /var/lib/sharelatex
mkdir -p /var/log/sharelatex
chown sharelatex:sharelatex /var/log/sharelatex

# Install ShareLaTeX
git clone -b release https://github.com/sharelatex/sharelatex.git /var/www/sharelatex
cd /var/www/sharelatex
git pull origin release
npm install
grunt install

# Minify js assets
cd /var/www/sharelatex/web
grunt compile:minify

# Install Nginx as a reverse proxy
rm /etc/nginx/sites-enabled/default
mkdir /etc/service/nginx

# Set up ShareLaTeX services to run automatically on boot
mkdir /etc/service/chat-sharelatex
mkdir /etc/service/clsi-sharelatex
mkdir /etc/service/docstore-sharelatex
mkdir /etc/service/document-updater-sharelatex
mkdir /etc/service/filestore-sharelatex
mkdir /etc/service/real-time-sharelatex
mkdir /etc/service/spelling-sharelatex
mkdir /etc/service/tags-sharelatex
mkdir /etc/service/track-changes-sharelatex
mkdir /etc/service/web-sharelatex

mkdir /etc/sharelatex

# Install TexLive basic scheme
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
mkdir /install-tl-unx
tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1
echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile
/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile
rm install-tl-unx.tar.gz

# update tlmgr and install latexmk
tlmgr update --self
tlmgr install latexmk

# Install Aspell
apt-get install -y aspell aspell-en aspell-af aspell-am aspell-ar aspell-ar-large aspell-bg aspell-bn aspell-br aspell-ca aspell-cs aspell-cy aspell-da aspell-de aspell-de-alt aspell-el aspell-eo aspell-es aspell-et aspell-eu-es aspell-fa aspell-fo aspell-fr aspell-ga aspell-gl-minimos aspell-gu aspell-he aspell-hi aspell-hr aspell-hsb aspell-hu aspell-hy aspell-id aspell-is aspell-it aspell-kk aspell-kn aspell-ku aspell-lt aspell-lv aspell-ml aspell-mr aspell-nl aspell-no aspell-nr aspell-ns aspell-or aspell-pa aspell-pl aspell-pt-br aspell-ro aspell-ru aspell-sk aspell-sl aspell-ss aspell-st aspell-sv aspell-ta aspell-te aspell-tl aspell-tn aspell-ts aspell-uk aspell-uz aspell-xh aspell-zu

# sharelatex user should be owner for its home directory
chown -R sharelatex:sharelatex /var/www/sharelatex
