module Addressbook
  class Engine < ::Rails::Engine
    isolate_namespace Addressbook

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    config.after_initialize do |app|
      app.routes.prepend do
        mount Addressbook::Engine, at: "/addressbook"
      end
    end
  end
end
