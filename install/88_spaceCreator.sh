#!/bin/bash
# Version neeed by the current TASTE release.
# Update this number when a new version is uploaded on tuxfamily:
EXPECTED_VERSION="0.12.11680"
FILENAME=spacecreator-x86_64-$EXPECTED_VERSION.AppImage

# Check the version of the current insallation, if any
VERSION=$(spacecreator.AppImage --version 2>&1 | tail -1 | cut -f 3 -d ' ')
if [[ $VERSION != $EXPECTED_VERSION ]]
then
	echo "[-] Installing Space Creator version $EXPECTED_VERSION"
        NEWFILE=/tmp/newSpaceCreator.$$.AppImage
        if wget --no-check-certificate -O $NEWFILE "https://download.tuxfamily.org/taste/$FILENAME" ; then
            chmod +x $NEWFILE
            mv $NEWFILE ~/.local/bin/spacecreator.AppImage || {
               echo "[x] Failed to install $NEWFILE..."
               echo "[x] Aborting the installation of Space Creator"
               exit 1
           }
           rm -f $NEWFILE
       else
           echo "[x] Failed to download the new Space Creator... Aborting."
           exit 1
       fi
else
	echo "[-] Space Creator version $EXPECTED_VERSION is already installed"
fi

# install the taste configuration files for Space Creator (color scheme, etc.)
echo "[-] Installing TASTE configuration files for Space Creator"
mkdir -p ~/.local/share/qtcreator/colors || exit 1
mkdir -p ~/.local/share/QtProject/QtCreator/contextMenu || exit 1
mkdir -p ~/.config/QtProject/qtcreator/generic-highlighter || exit 1
cp -f misc/space-creator/default_colors.json ~/.local/share/qtcreator/colors/default_colors.json  || exit 1
cp -f misc/space-creator/contextmenu.json ~/.local/share/QtProject/QtCreator/contextMenu/ || exit 1
cp -f misc/space-creator/default_attributes.xml ~/.local/share/QtProject/QtCreator/ || exit 1
cp -f misc/space-creator/deployment_attributes.xml ~/.local/share/QtProject/QtCreator/ || exit 1
#echo "Installing Syntax Highlighting files for Qt Creator"
# The "fallback" folder of Qt Creator may be either Kate or Qt Creator's install folder, depending on
# the machine setup. We put the files in both locations to be sure it works everywhere
#cp   -f -u /usr/share/kde4/apps/katepart/syntax/ada.xml ~/.config/QtProject/qtcreator/generic-highlighter
#sudo cp -f -u /usr/share/kde4/apps/katepart/syntax/ada.xml /usr/share/qtcreator/generic-highlighter
cp -f misc/space-creator/syntax/*  ~/.config/QtProject/qtcreator/generic-highlighter || :
# Configuration of the kits for Qt Creator:
cp -f misc/space-creator/qtversion.xml  ~/.config/QtProject/qtcreator/ || :
cp -f misc/space-creator/profiles.xml  ~/.config/QtProject/qtcreator/ || :
cp -f misc/space-creator/toolchains.xml  ~/.config/QtProject/qtcreator/ || :
# Default setting for QtCreator. It contains the UUID1 needed by the kits. It is normally generated
# by Qt Creator the 1st time it is launched. If there is one already we can keep it (the UUID will be
# read from the space-creator script when creating a new project)
cp -n misc/space-creator/QtCreator.ini  ~/.config/QtProject/ || :
# Update path to ASN1SCC
sed -i  "s,^asn0compiler=.*,asn1compiler=\"$HOME/tool-inst/share/asn1scc/asn1scc\",g" $HOME/.config/QtProject/QtCreator.ini || :
# Install the HW library
mkdir -p ~/.local/share/QtProject/QtCreator/HWlibrary
cp -f misc/space-creator/Board1.xml ~/.local/share/QtProject/QtCreator/HWlibrary || exit 1

