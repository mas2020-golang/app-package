# app-package
Repo for showing how to deploy a Golang app in several packaging system

## Create the release

To create a release first apply a tag and then you can run:
```shell
goreleaser init
# edit go releaser
```
To create a snapshot type:
```shell
goreleaser  --rm-dist --snapshot --skip-publish
```

To release the software type:
```shell
export GITHUB_TOKEN=<YOUR_TOKEN>
git tag -a "vx.x.x" -m "release x.x.x"
goreleaser release --rm-dist
```

## Installation

This chapter shows the several ways the app can be installed.

### Download from github

You can download directly from github, extract the file and place into a folder that is included in your PATH.
Go [here](https://github.com/mas2020-golang/app-package/releases) and download the release and the package that is compatible with your operating system.

### Install the Homebrew formulae (Mac, Linux)

You can install on Mac and Linux if you have Homebrew on board:

```shell
brew tap mas2020-golang/app-package
brew update
brew info app-package
brew install app-package
# test the application then
app-package
```

### Install the .deb package (Linux Debian based distro)

You can download the package for your system from the official [releases](https://github.com/mas2020-golang/app-package/releases) and run the installation.

For example:

```shell
sudo dpkg --install app-package_0.1.0-rc.2_Tux_64-bit.deb
# take a look
sudo dpkg --list | grep app-package
# run the application
app-package
```

TODO: take a look [here](https://wiki.debian.org/DebianRepository/SetupWithReprepro) for understanding how to create an apt pakcage for distributing on the Debian based distros.

### Install through install.sh script (Linux, Mac)

You can install the latest version using the installation script. Run the following:

```shell
curl -sL  https://raw.githubusercontent.com/mas2020-golang/app-package/main/install.sh | bash
```

TODO: test install.sh on CentOS and Alpine.
TODO: test install.sh on Mac and Ubuntu using sudo and the normal user.