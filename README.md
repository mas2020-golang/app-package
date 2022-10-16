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
goreleaser release --rm-dist
```

## Installation

This chapter shows the several ways the app can be installed.

