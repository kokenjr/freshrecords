# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "amazon-ecs"
  s.version = "2.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Herryanto Siatono"]
  s.date = "2012-01-01"
  s.description = "Generic Amazon Product Advertising Ruby API."
  s.email = "herryanto@gmail.com"
  s.homepage = "https://github.com/jugend/amazon-ecs"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Generic Amazon Product Advertising Ruby API."

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_runtime_dependency(%q<ruby-hmac>, ["~> 0.3"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<ruby-hmac>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<ruby-hmac>, ["~> 0.3"])
  end
end
