# frozen_string_literal: true

require_relative "lib/git/fancy/version"

Gem::Specification.new do |spec|
  spec.name = "git-fancy"
  spec.version = Git::Fancy::VERSION
  spec.authors = ["Sean McCleary"]
  spec.email = ["seanmcc@gmail.com"]

  spec.summary = "Fancy git branch switcher"
  spec.description = "This gem is a tool to switch between recent branches and add notes to them."
  spec.homepage = "https://github.com/mrinterweb/git-fancy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mrinterweb/git-fancy"
  spec.metadata["changelog_uri"] = "https://github.com/mrinterweb/git-fancy/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "tty-prompt"
  spec.add_dependency "tty-logger"
  spec.add_dependency "sqlite3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
