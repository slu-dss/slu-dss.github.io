#!/usr/bin/env bash

# This script does the required work to set up your personal GitHub Pages
# repository for deployment using Hugo. Run this script only once -- when the
# setup has been done, run the `deploy.sh` script to deploy changes and update
# your website. See
# https://hjdskes.github.io/blog/deploying-hugo-on-personal-github-pages/index.html
# for more information.

# File copied from https://proquestionasker.github.io/blog/Making_Site/ tutorial
# on creating websites with blogdown, Hugo, and GitHub.

# GitHub username
USERNAME=chris-prener
# Name of the branch containing the Hugo source files.
# Name of the branch containing the Hugo source files.
SOURCE=sources

msg() {
    printf "\033[1;32m :: %s\n\033[0m" "$1"
}

msg "Adding a README.md file to \'$SOURCE\' branch"
touch README.md

msg "Deleting the \`master\` branch"
git branch -D master
git push origin --delete master

msg "Creating an empty, orphaned \`master\` branch"
git checkout --orphan master
git rm --cached $(git ls-files)

msg "Grabbing one file from the \`$SOURCE\` branch so that a commit can be made"
git checkout "$SOURCE" README.md
git commit -m "Initial commit on master branch"
git push origin master

msg "Returning to the \`$SOURCE\` branch"
git checkout -f "$SOURCE"

msg "Removing the \`public\` folder to make room for the \`master\` subtree"
rm -rf public
git add -u
git commit -m "Remove stale public folder"

msg "Adding the new \`master\` branch as a subtree"
git subtree add --prefix=public \
    https://github.com/$USERNAME/$USERNAME.github.io.git master --squash

# The following code was in the original file but generates an error:
# fatal: refusing to merge unrelated histories
#
# This error is due to a recent change in Git that now requires an
# option to allow merges on unreleated histories. This option does not
# exist for the subtree commands.
#
# msg "Pulling down the just committed file to help avoid merge conflicts"
# git subtree pull --prefix=public \
#    https://github.com/$USERNAME/$USERNAME.github.io.git master
