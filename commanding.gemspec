# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'commanding/version'

Gem::Specification.new do |spec|
  spec.name          = "commanding"
  spec.version       = Commanding::VERSION
  spec.authors       = ["从权"]
  spec.email         = ["chaoyang.zcy@alibaba-inc.com"]

  spec.summary       = %q{Manage a command line tool or .sh to make it run any directory.}
  spec.description   = %q{With this tool, any command line tool or *.sh can run anywhere, not just its
  root directory, or must remember its absolute path. **shell_file_path** should
  be relative path to current directory.}
  spec.homepage      = "https://github.com/zhzhy/commanding"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "commanding"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "claide", "~> 0.9.1"
end
