# v1.5.0 (2017-07-30)

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

# v1.4.1 (2017-07-26)

- Fixed Travis CI pull request build hook.
- Fixed saved commit initialization with invalid SHA.
- Added Git commit SHA error.

# v1.4.0 (2017-07-23)

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

# v1.3.0 (2017-07-16)

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

# v1.2.0 (2017-07-09)

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

# v1.1.0 (2017-06-19)

- Updated README headers.
- Updated command line usage in CLI specs.
- Updated to Gemsmith 10.0.0.
- Removed Thor+ gem.
- Refactored CLI version/help specs.

# v1.0.0 (2017-06-17)

- Fixed gem configuration CLI options.
- Updated README usage configuration documenation.

# v0.4.0 (2017-06-11)

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

# v0.3.0 (2017-06-06)

- Fixed generated report to include gem label.
- Added Climate Control gem.
- Added Git branch support.
- Updated Git repo shared context to use HTTPS.
- Refactored Runner to use Branch object.

# v0.2.0 (2017-06-04)

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

# v0.1.0 (2017-05-29)

- Initial version.
