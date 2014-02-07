module Addressbook
  module Generators
    class Addressbook::ViewsGenerator < Rails::Generators::Base
      extend ActiveSupport::Concern
      source_root File.expand_path('../../../../../', __FILE__)

      public_task :copy_views

      desc "This generator copyies views to your project from engine.\n"

      argument :name, :required => false, :default => nil,
                         :desc => "The scope to copy views to"

      desc << <<-eos
        Example:
          "rails g addressbook:views"
            will copy all addressbook files (views and layouts)

          "rails g addressbook:views addressbook"
            will copy all addressbook views

          "rails g addressbook:views addressbook/address_book"
            will copy all addressbook views except address_book_group

          "rails g addressbook:views addressbook/address_book_group"
            will copy only address_book_group views

          "rails g addressbook:views layouts"
            will copy addressbook layouts
      eos

      def copy_views
        view_directory name.nil? ? "" : name
      end

      protected

        def view_directory(name, _target_path = nil)
          directory "app/views/#{name}", "app/views/#{name}"
        end


    end
  end
end
