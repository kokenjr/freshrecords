# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "levenshtein"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Veenstra"]
  s.date = "2012-03-16"
  s.description = "Calculates the Levenshtein distance between two byte strings."
  s.email = "levenshtein@erikveen.dds.nl"
  s.extensions = ["ext/levenshtein/extconf.rb"]
  s.files = ["ext/levenshtein/extconf.rb"]
  s.homepage = "http://www.erikveen.dds.nl/levenshtein/index.html"
  s.rdoc_options = ["README", "LICENSE", "VERSION", "CHANGELOG", "--title", "levenshtein (0.2.2)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "levenshtein"
  s.rubygems_version = "1.8.24"
  s.summary = "Calculates the Levenshtein distance between two byte strings."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
