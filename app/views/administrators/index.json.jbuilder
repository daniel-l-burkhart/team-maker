json.array!(@administrators) do |administrator|
  json.extract! administrator, :id, :name, :phone, :department, :university, :password
  json.url administrator_url(administrator, format: :json)
end
