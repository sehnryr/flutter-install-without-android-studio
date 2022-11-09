#!/bin/sh

# if not ran as sudo then exit
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# get optional argument -y for yes to accept all licenses automatically
accept_licenses=0
if [ "$1" = "-y" ]; then
    accept_licenses=1
fi

# install dependencies depending on the OS

# if ran on fedora, install clang cmake gtk3-devel ninja-build
if [ -f /etc/fedora-release ]; then
    sudo dnf install -y clang cmake gtk3-devel ninja-build
# else if ran on ubuntu, install clang cmake libgtk-3-dev ninja-build
elif [ -f /etc/lsb-release ]; then
    sudo apt install -y clang cmake libgtk-3-dev ninja-build default-jre git
else
    echo "Your OS is not supported"
    exit 1
fi

INSTALL_DIR="/opt"
TEMP="/tmp"

ANDROID_SDK="$INSTALL_DIR/android-sdk"
CMDLINE_TOOLS_DIR="$ANDROID_SDK/cmdline-tools"
CMDLINE_TOOLS_BIN="$CMDLINE_TOOLS_DIR/latest/bin"
PLATFORM_TOOLS_DIR="$ANDROID_SDK/platform-tools"
PLATFORM_TOOLS_BIN="$PLATFORM_TOOLS_DIR"

FLUTTER_SDK="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_SDK/bin"

# Install flutter from github
git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_SDK"

# Install android studio dependencies

# get the url of the latest version of command line tool from android studio website
cmdline_tools_url=$(
    curl -s https://developer.android.com/studio | 
        grep -oP 'https://dl.google.com/android/repository/commandlinetools-linux-.+?zip'
)

# download the command line tool silently with wget
wget --quiet --show-progress -O $TEMP/cmdline-tools.zip "$cmdline_tools_url"
unzip $TEMP/cmdline-tools.zip -d $TEMP
rm $TEMP/cmdline-tools.zip

# find sdkmanager binary and add sdk_root flag
mkdir $ANDROID_SDK
sdkmanager="$(find $TEMP/cmdline-tools -name sdkmanager) --sdk_root=$ANDROID_SDK"

# accept all licenses of android sdk silently if -y flag is passed
if [ $accept_licenses -eq 1 ]; then
    yes | $sdkmanager --licenses
fi

# install android studio dependencies without GUI
$sdkmanager "cmdline-tools;latest" \
            "platform-tools" \
            "platforms;android-30" \
            "build-tools;33.0.0"

# update sdkmanager packages to latest version
$sdkmanager --update

echo ""
echo "export PATH=\"$FLUTTER_BIN:\$PATH\""
echo "export PATH=\"$PLATFORM_TOOLS_BIN:\$PATH\""
echo "export PATH=\"$CMDLINE_TOOLS_BIN:\$PATH\""
echo ""
echo "Add those lines to your ~/.bashrc and use source to apply changes."
