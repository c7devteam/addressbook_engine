Addressbook::Engine.routes.draw do
  # get "address_book_group/index"

  # get "address_book_group/new"

  # get "address_book_group/edit"

  # get "address_book/index"

  # get "address_book/edit"

  # get "address_book_controller/index"

  # get "address_book_controller/edit"

  get '/' => 'address_book#index', :as => "account_contacts"
  get '/new' => 'address_book#new', :as => "new_contact"
  post '/create' => 'address_book#create'
  post '/import_vcard' => 'address_book#import_vcard'
  get '/edit/:id' => 'address_book#edit', :as =>"edit_contact"
  put '/update/:id' => 'address_book#update', :as => "contact_update"
  delete '/delete/:id' => 'address_book#delete'
  delete '/delete_attribute/' => 'address_book#delete_attribute'

  get '/group' => 'address_book_group#index', :as => "address_book_group"
  get '/group/edit/:id' => 'address_book_group#edit', :as => "address_book_group_edit"
  put '/group/update/:id' => 'address_book_group#update', :as => "address_book_group_update"
  delete '/group/delete/:id' => 'address_book_group#delete', :as => "address_book_group_delete"
  post '/group/create' => 'address_book_group#create'


end
