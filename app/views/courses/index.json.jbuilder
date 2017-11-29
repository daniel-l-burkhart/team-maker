json.array!(@courses) do |course|
  json.extract! course, :id, :name, :semester, :section
  json.url course_url(course, format: :json)
end
