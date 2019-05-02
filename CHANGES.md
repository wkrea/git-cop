# 3.4.2 (2019-05-01)

- Updated RSpec helper examples file name.
- Updated RSpec helper to verify constant names.
- Updated to Ruby 2.6.3.

# 3.4.1 (2019-04-14)

- Fixed Netlify branch detection.
- Fixed Ruby warnings.
- Added Ruby warnings to RSpec helper.
- Refactored RSpec Git branch creation to shared context.
- Refactored RSpec Git commit file helper to shared context.

# 3.4.0 (2019-04-13)

- Fixed Rubocop layout issues.
- Fixed multpile line commit messages for specs.
- Added Git kit repo branch name and SHA functionality.
- Added Netlify build status badge to README.
- Added Netlify environment detection.
- Added Netlify environment.
- Added Rubocop Performance gem.
- Added Travis CI build status to README.
- Updated to Code Quality 4.0.0.
- Updated to Rubocop 0.67.0.
- Removed Code Climate gem.
- Refactored Git kit repo to be constructed.
- Refactored Travis CI environment to inject environment.
- Refactored branch environemnts to use Git repo.
- Refactored feature branch to inject environment.

# 3.3.0 (2019-03-16)

- Fixed Commit Trailer Collaborator Email cop email handling.
- Added Commit Author Capitalization cop.
- Added Commit Author Name cop.
- Added additional saved commit specs for raw body and trailers.
- Updated Commit Author Name Capitalization cop to deprecated status.
- Updated Commit Author Name Parts cop to deprecated status.
- Updated email validator to use URI regular expression.
- Updated to Ruby 2.6.2.
- Refactored commit specs to use commit as subject.
- Refactored commit to scrub erroneous encodings.
- Refactored style specs to use cop as subject.

# 3.2.0 (2019-03-10)

- Fixed Rubocop Style/MethodCallWithArgsParentheses issues.
- Added abstract style affected commit trailer lines.
- Added commit trailer collaborator capitalization cop.
- Added commit trailer collaborator duplication cop.
- Added commit trailer collaborator email cop.
- Added commit trailer collaborator key cop.
- Added commit trailer collaborator name cop.
- Added saved commit trailers.
- Added trailer collaborator parser.
- Added unsaved commit trailers.
- Updated Circle CI configuration to install latest Git version.
- Removed RSpec standard output/error suppression.

# 3.1.0 (2019-03-01)

- Added README Git Hook style guide.
- Added capitalization validator.
- Added email validator.
- Added name validator.
- Updated README to reference updated Runcom documentation.
- Updated to Gemsmith 13.0.0.
- Updated to Rubocop 0.65.0.
- Updated to Ruby 2.6.1.
- Removed README upgrade documentation.
- Refactored affected commit body lines to abstract class.
- Refactored commit author email cop to use validator.
- Refactored commit author name capitalization cop to use validator.
- Refactored commit author name parts cop to use validator.

# 3.0.0 (2019-01-01)

- Fixed Circle CI cache for Ruby version.
- Fixed Rubocop RSpec auto-correctable issues.
- Fixed Rubocop RSpec/ContextWording issue.
- Fixed Rubocop RSpec/ExampleLength issues.
- Fixed Rubocop RSpec/LeadingSubject issues.
- Fixed Rubocop RSpec/NamedSubject issues.
- Fixed Rubocop RSpec/SubjectStub issues.
- Fixed Rubocop RSpec/VerifiedDoubles issues.
- Added Circle CI Bundler cache.
- Added Rubocop RSpec gem.
- Added project logo.
- Added spelling mistakes to style guide.
- Updated Circle CI Code Climate test reporting.
- Updated to Refinements 6.0.0.
- Updated to Rubocop 0.62.0.
- Updated to Ruby 2.6.0.
- Updated to Runcom 4.0.0.
- Removed Rubocop Lint/Void CheckForMethodsWithNoSideEffects check.

# 2.4.0 (2018-10-01)

- Fixed Markdown ordered list numbering.
- Fixed README numbering markdown.
- Fixed Rubocop Layout/EmptyLineAfterGuardClause issues.
- Fixed Rubocop Performance/InefficientHashSearch issue.
- Fixed default configuration in README.
- Updated README style guide.
- Updated Semantic Versioning links to be HTTPS.
- Updated pull request documentation.
- Updated to Contributor Covenant Code of Conduct 1.4.1.
- Updated to RSpec 3.8.0.
- Updated to Reek 5.0.
- Updated to Rubocop 0.57.0.
- Updated to Rubocop 0.58.0.

# 2.3.0 (2018-05-01)

- Added Runcom examples for project specific usage.
- Updated README documentation.
- Updated project changes to use semantic versions.
- Updated to Gemsmith 12.0.0.
- Updated to Refinements 5.2.0.
- Updated to Runcom 3.1.0.

# 2.2.0 (2018-04-01)

- Added gemspec metadata for source, changes, and issue tracker URLs.
- Updated gem dependencies.
- Updated to Refinements 5.1.0.
- Updated to Rubocop 0.53.0.
- Updated to Ruby 2.5.1.
- Updated to Runcom 3.0.0.
- Removed Circle CI Bundler cache.
- Refactored Git repository shared example test data.
- Refactored temp dir shared context as a pathname.

# 2.1.0 (2018-02-18)

- Fixed Git commit encoding issues.
- Fixed SHA utility method for unsaved comment.
- Fixed colorized terminal output for CI builds.
- Fixed gemspec issues with missing gem signing key/certificate.
- Updated README license information.
- Updated to Circle CI 2.0.0 configuration.
- Removed Gemnasium support.
- Removed Patreon badge from README.

# 2.0.1 (2018-01-01)

- Updated to Gemsmith 11.0.0.

# 2.0.0 (2018-01-01)

- Fixed Rubocop Style/FormatStringToken issues.
- Fixed typo in default configuration of README.md.
- Added additional commit body phrases to exclude list.
- Added Commit Body Bullet Delimiter cop.
- Added specs for default cop settings.
- Added upgrade section to README.
- Updated Code Climate badges.
- Updated Code Climate configuration to Version 2.0.0.
- Updated to Apache 2.0 license.
- Updated to Rubocop 0.52.0.
- Updated to Ruby 2.4.3.
- Updated to Ruby 2.5.0.
- Removed black/white lists (use include/exclude lists instead).
- Removed deprecated Commit Body Leading Space cop.
- Removed documentation for secure installs.
- Refactored `Graylist` as `FilterList` object.
- Refactored abstract cop prefix deletion.
- Refactored code to use Ruby 2.5.0 `Array#append` syntax.

# 1.7.1 (2017-11-18)

- Fixed issue with mismatched gem certificate public key.
- Updated to Rake 12.3.0.

# 1.7.0 (2017-11-05)

- Fixed 'Git Hooks' URL.
- Fixed Reek issues.
- Fixed false positive when checking unsaved, verbose commits.
- Fixed false positives with commit body phrases.
- Updated Fury URL to use HTTPS.
- Updated commit body phrases to be alpha-sorted.
- Refactored commit object equality methods.

# 1.6.2 (2017-10-29)

- Added Bundler Audit gem.
- Updated to Rubocop 0.50.0.
- Updated to Rubocop 0.51.0.
- Updated to Ruby 2.4.2.

# 1.6.1 (2017-09-09)

- Fixed commit subject length calculation with fixup/squash prefixes.
- Removed Pry State gem.

# 1.6.0 (2017-08-20)

- Fixed README default configuration by removing trailing commas.
- Added dynamic formatting of RSpec output.
- Updated to Runcom 1.3.0.

# 1.5.0 (2017-07-30)

- Fixed CLI spec when running on a feature branch.
- Fixed issue line numbering.
- Fixed line reporting of multi-line paragraphs.
- Added issue line builder.
- Added paragraph reporter.
- Added sentence reporter.
- Updated cop reporter to end label with period.
- Updated hint wording.
- Removed issue label.
- Refactored line reporter default indent.

# 1.4.1 (2017-07-26)

- Fixed Travis CI pull request build hook.
- Fixed saved commit initialization with invalid SHA.
- Added Git commit SHA error.

# 1.4.0 (2017-07-23)

- Fixed feature branch Git repository detection.
- Added Git Kit with repository detection.
- Added ability to answer commit body paragraphs.
- Added commit body bullet capitalization cop.
- Added commit body issue tracker link cop.
- Added commit body paragraph capitalization cop.
- Added commit body single bullet cop.
- Updated commit body leading line cop to specify quantity.
- Updated cop warning/error report format.
- Updated graylist to always be a list of regular expressions.
- Updated graylist to always cast list to array.
- Updated line report to quote affected lines.
- Updated to Gemsmith 10.2.0.
- Refactored specs to use consistent issue testing.

# 1.3.0 (2017-07-16)

- Fixed CLI errors to always abort program.
- Fixed Commit Body Presence cop fixup commit issues.
- Fixed Commit Subject Prefix cop fixup and squash commit issues.
- Fixed issues with commented body lines in commits.
- Fixed issues with reporting valid cops.
- Fixed issues with running against a non-Git repository.
- Fixed printing of regular expression escape characters in cop hints.
- Added Commit Body Leading Line cop.
- Added Commit Body Leading Space deprecation warnings.
- Added Pastel gem.
- Added ability to answer commits on feature branch.
- Added colorized strings to branch reporter.
- Added colorized strings to cop reporter.
- Added commit fixup and squash detection.
- Added commit message Git Hook.
- Added shared examples for fixup and squash commits.
- Added string fixup and squash prefix detection.
- Added string refinements.
- Added unsaved commit.
- Updated graylist to answer hint text.
- Refactored CLI warning spec.
- Refactored branch objects.
- Refactored commit as saved commit.
- Refactored runner to run with commits instead of SHAs.
- Refactored use of build environment variables.
- Refactored use of gem-specific string methods.

# 1.2.0 (2017-07-09)

- Fixed spec issues with CI environments.
- Added Circle CI branch environment.
- Added Commit Body Present cop to table of contents.
- Added Git Hook documentation.
- Added GitHub project rebase documentation.
- Added README Git style guide.
- Added README cop descriptions.
- Added Travis CI branch environment.
- Added Travis CI build support for project.
- Added `--commits` option to `--police` command.
- Added base error class.
- Added branch reporter.
- Added commit reporter.
- Added commit_body_present cop
- Added cop graylist regular expression support.
- Added cop reporter.
- Added cop severity support to collector.
- Added cop severity support.
- Added graylist hook.
- Added graylist support.
- Added invalid, warning, and error support to abstract class.
- Added line reporter.
- Added local branch environment.
- Added minimum for Commit Body Present cop
- Added number of commit inspected.
- Added severity error.
- Added string pluralization support.
- Updated CLI to rescue gem-related errors.
- Updated CONTRIBUTING documentation.
- Updated Commit Body Presence cop name.
- Updated GitHub templates.
- Updated collector to collect valid and invalid cops.
- Updated cop issue to answer a hash.
- Updated runner to process custom commits.
- Updated to Climate Control 0.2.0.
- Removed collector reporting behavior.
- Refactored CLI to use reporter.
- Refactored Git utilities to `Kit` module.
- Refactored branch kit to use branch environments.
- Refactored calculation of string pluralization.
- Refactored cop error as issue.
- Refactored reporter as collector.
- Refactored runner to fail with gem base error.
- Refactored runner to use collector modifications.
- Refactored severity levels to abstract style class.

# 1.1.0 (2017-06-19)

- Updated README headers.
- Updated command line usage in CLI specs.
- Updated to Gemsmith 10.0.0.
- Removed Thor+ gem.
- Refactored CLI version/help specs.

# 1.0.0 (2017-06-17)

- Fixed gem configuration CLI options.
- Updated README usage configuration documenation.

# 0.4.0 (2017-06-11)

- Fixed Reek method missing issue.
- Fixed commit body bullet cop with blank lines.
- Fixed style abstract descendants implementation.
- Added Circle CI support.
- Added commit author date (relative).
- Added cop labels.
- Updated commit to be a value object.
- Updated reporter to use commit details.
- Updated reporter to use cop labels.
- Updated to Runcom 1.0.0.
- Removed Gemsmith support (temporary).
- Removed Travis CI support.
- Removed abstract class commit sha method.
- Removed extra carriage return from affected line errors.
- Refactored runner implementation.

# 0.3.0 (2017-06-06)

- Fixed generated report to include gem label.
- Added Climate Control gem.
- Added Git branch support.
- Updated Git repo shared context to use HTTPS.
- Refactored Runner to use Branch object.

# 0.2.0 (2017-06-04)

- Fixed Code Climate Rubocop configuration.
- Fixed commit body leading space cop false positive with empty body.
- Added Rake support.
- Added commit author email cop.
- Added commit author name capitalization cop.
- Added commit author name parts cop.
- Added commit body bullet cop.
- Added commit body line length cop.
- Added commit body lines support.
- Added commit body phrase cop.
- Updated commit subject length to equal body length.
- Updated commit subject prefix cop to use whitelist.
- Updated commit subject suffix cop to use whitelist.
- Updated reporter to capture errors by commit SHA.
- Removed `.id` from style subclasses.
- Removed double colon from gem label.

# 0.1.0 (2017-05-29)

- Initial version.
