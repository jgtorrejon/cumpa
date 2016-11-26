json.extract! client, :id, :name, :last_name, :picture, :sender_id, :created_at, :updated_at
json.url client_url(client, format: :json)