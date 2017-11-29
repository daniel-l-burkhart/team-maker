json.array!(@faculties) do |faculty|
  json.extract! faculty, :id, :name, :phone, :department, :university, :password
  json.url faculty_url(faculty, format: :json)
end
