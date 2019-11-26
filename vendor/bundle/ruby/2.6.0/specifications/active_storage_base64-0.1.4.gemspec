# -*- encoding: utf-8 -*-
# stub: active_storage_base64 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "active_storage_base64".freeze
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ricardo Cortio".freeze]
  s.date = "2019-05-08"
  s.description = "Base64 support for ActiveStorage".freeze
  s.email = "ricardo@rootstrap.com".freeze
  s.homepage = "https://github.com/rootstrap/active-storage-base64".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Base64 support for ActiveStorage".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 5.2"])
      s.add_development_dependency(%q<pry-rails>.freeze, ["~> 0.3.6"])
      s.add_development_dependency(%q<reek>.freeze, ["~> 4.8.1"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.8.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["= 1.3.13"])
    else
      s.add_dependency(%q<rails>.freeze, ["~> 5.2"])
      s.add_dependency(%q<pry-rails>.freeze, ["~> 0.3.6"])
      s.add_dependency(%q<reek>.freeze, ["~> 4.8.1"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.8.0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, ["= 1.3.13"])
    end
  else
    s.add_dependency(%q<rails>.freeze, ["~> 5.2"])
    s.add_dependency(%q<pry-rails>.freeze, ["~> 0.3.6"])
    s.add_dependency(%q<reek>.freeze, ["~> 4.8.1"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.8.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, ["= 1.3.13"])
  end
end
