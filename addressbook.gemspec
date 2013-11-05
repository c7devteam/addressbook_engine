$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "addressbook/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "addressbook"
  s.version     = Addressbook::VERSION
  s.authors     = ["Alexandr Kovtunov"]
  s.email       = ["alexander.kovtunov@diatomenterprises.com"]
  s.homepage    = "http://www.cube7.com"
  s.summary     = "Summary of Addressbook."
  s.description = "Description of Addressbook."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency 'jquery-rails', '~> 2.1'
  # s.add_dependency "jquery-rails"
  s.add_dependency 'kaminari'

  s.add_dependency 'tire'

  s.add_dependency 'acts_as_paranoid'

  s.add_dependency 'carrierwave'
  s.add_dependency 'mini_magick'

  s.add_dependency 'vcardigan'

  s.add_development_dependency "pg"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.0'
end
