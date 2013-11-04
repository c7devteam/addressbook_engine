Addressbook::Engine.routes.draw do
  # get "address_book_group/index"

  # get "address_book_group/new"

  # get "address_book_group/edit"

  # get "address_book/index"

  # get "address_book/edit"

  # get "address_book_controller/index"

  # get "address_book_controller/edit"

  match '/' => 'address_book#index', :as => "account_contacts"
  match '/new' => 'address_book#new', :as => "new_contact"
  match '/create' => 'address_book#create'
  match '/import_vcard' => 'address_book#import_vcard'
  match '/edit/:id' => 'address_book#edit', :as =>"edit_contact"
  match '/update/:id' => 'address_book#update', :as => "contact_update"
  match '/delete/:id' => 'address_book#delete'
  match '/delete_attribute/' => 'address_book#delete_attribute'

  match '/group' => 'address_book_group#index', :as => "address_book_group"
  match '/group/edit/:id' => 'address_book_group#edit', :as => "address_book_group_edit"
  match '/group/update/:id' => 'address_book_group#update', :as => "address_book_group_update"
  match '/group/delete/:id' => 'address_book_group#delete', :as => "address_book_group_delete"
  match '/group/create' => 'address_book_group#create'


end
