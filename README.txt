Setup notes
Install vagrant, see http://www.vagrantup.com/
Create a folder, for vagrant, for instance Vagrant_CAIRIS
Unzip the contents of this zip into the folder
Download the latest version of Cairis and place it in a folder called sourcecode
Run vagrant and mount sourcecode folder to /vagrant/sourcecode/ in the Virtual machine
Run puppet, this should setup mysql and download and install all dependencies

Issues:
Current process setups Ubuntu server edition, this will need Gui to use CAIRIS, see http://www.ubuntugeek.com/install-gui-in-ubuntu-server.html or similar to setup this up, alternatively see list of alternative base boxes at http://www.vagrantbox.es/

