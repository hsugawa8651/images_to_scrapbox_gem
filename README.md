# ImagesToScrapbox

Scrapbox http://scrapbox.io is a novel note-taking service for teams.

This tool converts local image files to json file suitable for import to scrapbox.

## Installation

This tool, written in Ruby, is distributed via rubygem. https://rubygems.org/gems/images_to_scrapbox

To install, invoke gem install command:

```ruby
gem install images_to_scrapbox
```

## Usage

Input files are local image files. (file extension = .gif, .jpg, .png )

Invoke this tool by:

```ruby
    $ bundle exec images_to_scrapbox convert FILES > scrapbox.json
```

You can specify GLOBS instead of FILES.

Example 1: Collects all image files in the current directory.

```ruby
    $ bundle exec images_to_scrapbox convert * > scrapbox.json
```

Example 2: Collects all image files in the subdirectories of the current directory.
```ruby
    $ bundle exec images_to_scrapbox convert **/* > scrapbox.json
```

To import `scrapbox.json` to scrapbox, follow the instruction of "import pages" tool of "scrapbox" at the url:
    https://scrapbox.io/help/Importing_and_exporting_data

Specify `scrapbox.json` created by this tool.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hsugawa8651/images_to_scrapbox_gem.

## Code of Conduct

Everyone interacting in the ImagesToScrapboxGem project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hsugawa8651/images_to_scrapbox_gem/blob/master/CODE_OF_CONDUCT.md).
