json.extract! store, :id, :name, :street, :city, :state, :zip, :phone, :active, :created_at, :updated_at
json.url store_url(store, format: :json)
