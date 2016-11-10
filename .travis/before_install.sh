#!/usr/bin/env bash
# https://github.com/atlassian/lerna-semantic-release/blob/caribou/.travis/before_install.sh

set -e

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "We are in a pull request, not setting up release"
  exit 0
fi

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
  rm -rf .git
  git init
  git clean -dfx
  git remote add origin git@github.com:${TRAVIS_REPO_SLUG}.git
  git fetch origin
  git checkout ${TRAVIS_BRANCH}

  git config credential.helper store
  echo "https://mfellner:$RELEASE_GH_TOKEN@github.com/$TRAVIS_REPO_SLUG.git" > ~/.git-credentials

  npm config set //registry.npmjs.org/:_authToken=${NPM_TOKEN} -q
  npm prune

  git config --global user.email "maximilian.fellner@zalando.de"
  git config --global user.name "Maximilian Fellner"
  git config --global push.default simple

  git fetch --tags
  git branch -u origin/${TRAVIS_BRANCH}
fi