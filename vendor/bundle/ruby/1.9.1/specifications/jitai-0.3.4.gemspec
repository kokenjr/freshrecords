# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jitai"
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kellydunn"]
  s.date = "2011-06-12"
  s.description = "CSS custom font consolidator"
  s.email = "defaultstring@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.textile"]
  s.files = ["LICENSE", "README.textile"]
  s.homepage = "http://github.com/kellydunn/jitai"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "CSS custom font consolidator"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end
