# Git::Fancy

Git fancy is a command line tool that makes switching between git branches faster and easier.
It also allows you to annotate branches and quickly match branches based on either part of the branch name or notes.

Git fancy tracks branches by most recently used.

## Installation

```console
$ gem install git-fancy
```

## Usage

The `sb` command is an alias for `switch-branch`. Both commands can be used interchangeably.

To list recently used branches: (sb only tracks recently used branches when you use sb to switch branches)
```console
sb
```

To switch to a branch when you only have a portion of a branch name:
```console
sb <portion_of_branch_name>
```

To annotate the current branch you are on:
```console
sb -n "make the logo bigger"
```

List all of the branches git fancy is tracking:
```console
sb -l
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git-fancy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/git-fancy/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Git::Fancy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/git-fancy/blob/master/CODE_OF_CONDUCT.md).
