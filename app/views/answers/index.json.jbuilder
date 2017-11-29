json.array!(@answers) do |answer|
  json.extract! answer, :id, :response_id, :question_id, :content
  json.url answer_url(answer, format: :json)
end
