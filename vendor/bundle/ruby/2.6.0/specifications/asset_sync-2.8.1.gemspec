# -*- encoding: utf-8 -*-
# stub: asset_sync 2.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "asset_sync".freeze
  s.version = "2.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Simon Hamilton".freeze, "David Rice".freeze, "Phil McClure".freeze, "Toby Osbourn".freeze]
  s.date = "2019-07-25"
  s.description = "After you run assets:precompile your compiled assets will be synchronised with your S3 bucket.".freeze
  s.email = ["shamilton@rumblelabs.com".freeze, "me@davidjrice.co.uk".freeze, "pmcclure@rumblelabs.com".freeze, "tosbourn@rumblelabs.com".freeze]
  s.homepage = "https://github.com/rumblelabs/asset_sync".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Synchronises Assets in a Rails 3 application and Amazon S3/Cloudfront and Rackspace Cloudfiles".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog-core>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<unf>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activemodel>.freeze, [">= 4.1.0"])
      s.add_runtime_dependency(%q<mime-types>.freeze, [">= 2.99"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0.7"])
      s.add_development_dependency(%q<mime-types>.freeze, [">= 3.0"])
      s.add_development_dependency(%q<fog-aws>.freeze, [">= 0"])
      s.add_development_dependency(%q<fog-azure-rm>.freeze, [">= 0"])
      s.add_development_dependency(%q<uglifier>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<fog-core>.freeze, [">= 0"])
      s.add_dependency(%q<unf>.freeze, [">= 0"])
      s.add_dependency(%q<activemodel>.freeze, [">= 4.1.0"])
      s.add_dependency(%q<mime-types>.freeze, [">= 2.99"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0.7"])
      s.add_dependency(%q<mime-types>.freeze, [">= 3.0"])
      s.add_dependency(%q<fog-aws>.freeze, [">= 0"])
      s.add_dependency(%q<fog-azure-rm>.freeze, [">= 0"])
      s.add_dependency(%q<uglifier>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<fog-core>.freeze, [">= 0"])
    s.add_dependency(%q<unf>.freeze, [">= 0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 4.1.0"])
    s.add_dependency(%q<mime-types>.freeze, [">= 2.99"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0.7"])
    s.add_dependency(%q<mime-types>.freeze, [">= 3.0"])
    s.add_dependency(%q<fog-aws>.freeze, [">= 0"])
    s.add_dependency(%q<fog-azure-rm>.freeze, [">= 0"])
    s.add_dependency(%q<uglifier>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
