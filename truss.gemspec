
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "truss/version"

Gem::Specification.new do |spec|
  spec.name          = "truss"
  spec.version       = Truss::VERSION
  spec.authors       = ["Patricia Arbona"]
  spec.email         = ["arbonap@gmail.com"]

  spec.summary       = %q{Parse and normalizes CSV files for Truss' take-home Software Engineer Challenge.}
  spec.description   = %q{Ingests, parses, and normalizes CSVs.}
  spec.homepage      = "https://www.github.com/arbonap/truss."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://www.rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://www.github.com/arbonap/truss."
    spec.metadata["changelog_uri"] = "https://www.github.com/arbonap/truss/changelog"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "artii"
  spec.add_development_dependency "thor", "0.20.0"
end
