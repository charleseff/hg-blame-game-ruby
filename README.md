# hg-blame-game

[![Build Status](https://travis-ci.org/charleseff/hg-blame-game.png)](https://travis-ci.org/charleseff/hg-blame-game)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/charleseff/hg-blame-game)

hg-blame-game is an interactive command-line tool that allows you to chain multiple 'hg blame' calls together in order to drill down to the actual responsible commit.  When one `hg blame` is not enough.

## Installation:

    gem install hg-blame-game

## Usage:

    hg-blame-game --help

## Examples:

[Happy Path](https://github.com/charleseff/hg-blame-game/blob/master/features/happy_path.feature) 
    
[Other Scenarios](https://github.com/charleseff/hg-blame-game/blob/master/features/other_scenarios.feature)