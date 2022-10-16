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

### Install the Homebrew formulae

You can install on Mac and Linux if you have Homebrew on board:

```shell
brew tap mas2020-golang/app-package
brew update
brew info app-package
brew install app-package
# test the application then
app-package
```

