# Git::Cop

[![Gem Version](https://badge.fury.io/rb/git-cop.svg)](http://badge.fury.io/rb/git-cop)
[![Code Climate GPA](https://codeclimate.com/github/bkuhlmann/git-cop.svg)](https://codeclimate.com/github/bkuhlmann/git-cop)
[![Code Climate Coverage](https://codeclimate.com/github/bkuhlmann/git-cop/coverage.svg)](https://codeclimate.com/github/bkuhlmann/git-cop)
[![Gemnasium Status](https://gemnasium.com/bkuhlmann/git-cop.svg)](https://gemnasium.com/bkuhlmann/git-cop)
[![Travis CI Status](https://secure.travis-ci.org/bkuhlmann/git-cop.svg)](https://travis-ci.org/bkuhlmann/git-cop)
[![Patreon](https://img.shields.io/badge/patreon-donate-brightgreen.svg)](https://www.patreon.com/bkuhlmann)

Enforces Git rebase workflow with consistent Git commits for a clean and easy to read/debug project
history.

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
  - [Install](#install)
  - [Configuration](#configuration)
- [Usage](#usage)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

- Enforces a [Git Rebase Workflow](http://www.bitsnbites.eu/a-tidy-linear-git-history).
- Enforces a consistent [Git Commit Style](https://github.com/bkuhlmann/style_guides/blob/master/tools/git.md#commits).
- Enforces good commit subjects with consistent prefixes, suffixes, and lengths.
- Enforces good commit messages where subject and body are properly separated.

# Requirements

0. [Ruby 2.4.1](https://www.ruby-lang.org)

# Setup

## Install

For a secure install, type the following (recommended):

    gem cert --add <(curl --location --silent https://www.alchemists.io/gem-public.pem)
    gem install git-cop --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification
while allowing the installation of unsigned dependencies since they are beyond the scope of this
gem.

For an insecure install, type the following (not recommended):

    gem install git-cop

## Configuration

You can configure a global configuration via the following file:

    ~/.git-coprc

The following is what the default configuration consists of:

    :commit_author_email:
      :enabled: true
    :commit_author_name_capitalization:
      :enabled: true
    :commit_author_name_parts:
      :enabled: true
      :minimum: 2
    :commit_body_bullet:
      :enabled: true
      :blacklist:
        - *
        - •
    :commit_body_leading_space:
      :enabled: true
    :commit_body_line_length:
      :enabled: true
      :length: 72
    :commit_body_phrase:
      :enabled: true
      :blacklist:
        - obviously
        - basically
        - simply
        - of course
        - just
        - everyone knows
        - however
        - easy
    :commit_subject_length:
      :enabled: true
      :length: 50
    :commit_subject_prefix:
      :enabled: true
      :prefixes:
        - Fixed
        - Added
        - Updated
        - Removed
        - Refactored
    :commit_subject_suffix:
      :enabled: true
      :suffixes:
        "."

It is also possible to configure `Git::Cop` at a per project level by adding a `.git-coprc` to the
root of your project. Doing this will override any global settings. This is also handy for
customized CI builds as well.

# Usage

From the command line, type: `git-cop --help`

    git-cop -c, [--config]        # Manage gem configuration ("~/.git-coprc").
    git-cop -h, [--help=COMMAND]  # Show this message or get help for a command.
    git-cop -p, [--police]        # Police current branch for issues.
    git-cop -v, [--version]       # Show gem version.

To check if your Git commit history is clean, run: `git-cop --police`. `Git::Cop` will exit with a
failure if at least one issue is detected (handy for CI builds).

This gem does not check commits on `master`. This is intentional as you would generally not want to
rewrite or fix commits on `master`. This gem is best used on feature branches as it automatically
detects all commits made since `master` on the feature branch and will raise errors if any of the
feature branch commits do not conform to the style guide.

Here is an example workflow, using the gem defaults where errors would be raised:

    cd example
    git checkout -b test
    printf "%s\n" "Test content." > test.txt
    git add --all .
    git commit --message "This is a bogus commit message that is also terribly long and will word wrap"
    git-cop --police

    # Output:
    error  commit_subject_prefix (62b701a5145bfca148f2ca07c6288c4dd6face40): Invalid prefix. Use: "Fixed", "Added", "Updated", "Removed", "Refactored".
    error  commit_subject_suffix (62b701a5145bfca148f2ca07c6288c4dd6face40): Invalid suffix. Use: ".".
    error  commit_subject_length (62b701a5145bfca148f2ca07c6288c4dd6face40): Invalid length. Use 50 characters or less.
    error  commit_body_leading_space (62b701a5145bfca148f2ca07c6288c4dd6face40): Missing leading space. Use space between subject and body.
    4 issues detected.

With this output, you can see 4 issues were detected. Each issue shows the cop name, commit SHA (in
parenthesis), and the error with help text.

# Tests

To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2017 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

# History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
