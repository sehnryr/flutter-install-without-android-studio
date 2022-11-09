# flutter-install-without-android-studio
Install flutter with all the android studio dependencies using only the CLI.

Flutter and the Android Studio dependencies are stored in the `/opt` directory
in `flutter-sdk` and `android-sdk` respectively.

This script must be ran as root with sudo.

This script can be used on Fedora and Ubuntu.

`-y` argument can be passed to accept all licenses automatically and silently.

Add the following to your `.bashrc` or `.zshrc` file:

```bash
export PATH="/opt/flutter-sdk/bin:$PATH"
export PATH="/opt/android-sdk/platform-tools:$PATH"
export PATH="/opt/android-sdk/cmdline-tools/latest/bin:$PATH"
```

You can run the script simply with the following command:

```bash
curl -s "https://raw.githubusercontent.com/sehnryr/flutter-install-without-android-studio/main/install.sh" | sudo sh
```