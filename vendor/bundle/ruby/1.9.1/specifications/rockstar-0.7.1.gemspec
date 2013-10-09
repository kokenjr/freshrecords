# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rockstar"
  s.version = "0.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bodo Tasche"]
  s.date = "2013-02-19"
  s.description = "This gem is an updated version of jnunemakers scrobbler gem. Rockstar uses v2.0 of the last.fm api."
  s.email = "bodo@putpat.tv"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://github.com/putpat/rockstar"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "wrapper for audioscrobbler (last.fm) web services"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.4.2"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 1.4.2"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0.4.86"])
      s.add_dependency(%q<activesupport>, [">= 1.4.2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0.4.86"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 1.4.2"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0.4.86"])
    s.add_dependency(%q<activesupport>, [">= 1.4.2"])
  end
end
