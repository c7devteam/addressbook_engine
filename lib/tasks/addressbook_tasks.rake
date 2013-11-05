desc "Index Elastic Search"
require 'tire'
namespace :tire do
  namespace :import do
    task all: :environment do
      aliases = Tire::Configuration.client.get(Tire::Configuration.url + '/_aliases').body
      indexes_names = MultiJson.load(aliases).keys

      indexes_names.each do |name|
        index = Tire::Index.new name
        index.delete
        index.import Addressbook::AccountContact.all
        index.refresh
        puts "[INFO] #{name} re-indexed"
      end
    end
  end
end