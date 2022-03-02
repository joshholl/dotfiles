wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add -

echo "deb https://packages.adoptium.net/artifactory/deb hirsute main" | sudo tee /etc/apt/sources.list.d/adoptium.list