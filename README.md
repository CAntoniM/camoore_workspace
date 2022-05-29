# CAntoniM Workspace

This is the project for my base docker image which i will be basing my workspaces off of. The idea of this project is to have a common enviroment to work with for every project i want to work on.

# What this image does
1. It installs a base set of repositries
2. It configures the software to work with how the users systems configuration is set up

# How to run

This will create a docker image called camoore_base and run it with the inteded it will exports the ssh service on port 1522

```shell
    make
```