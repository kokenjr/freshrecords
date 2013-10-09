## options.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "options"
  spec.version = "2.2.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "options"

  spec.files = ["lib", "lib/options.rb", "options.gemspec", "Rakefile", "README", "README.erb", "samples", "samples/a.rb", "samples/b.rb", "samples/c.rb", "samples/d.rb", "spec", "spec/options_spec.rb", "spec/spec_helper.rb"]
  spec.executables = []
  
  spec.require_path = "lib"

  spec.has_rdoc = true
  spec.test_files = nil
  #spec.add_dependency 'lib', '>= version'
  #spec.add_dependency 'fattr'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "http://github.com/ahoward/options/tree/master"
end
