Rails.application.routes.draw do

  mount Addressbook::Engine => "/addressbook"
end
