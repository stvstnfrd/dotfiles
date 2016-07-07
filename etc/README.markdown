# ~/.config/dotfiles/etc

## Local configuration

You probably shouldn't have to touch this manually.
The Makefile/install scripts create symlinks here.
- `profile.d/`: These scripts are run upon login.
- `rc.d/`: These scripts are run upon and interactive shell.

While this directory shouldn't contain anything top-secret, it would
expose which packages you have enabled, including potentially private
ones. As such, we git-ignore this directory and you should not be
committing here.
