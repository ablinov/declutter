name: Bumps the Homebrew formula at https://github.com/ablinov/homebrew-made/blob/master/declutter.rb

on:
  push:
    tags: 'v*'

jobs:
  homebrew:
    name: Bump Homebrew formula
    runs-on: ubuntu-latest
    steps:
      - uses: mislav/bump-homebrew-formula-action@v1.6
        with:
          formula-name: declutter
          homebrew-tap: ablinov/homebrew-made
        env:
          COMMITTER_TOKEN: ${{ secrets.COMMITTER_TOKEN }}