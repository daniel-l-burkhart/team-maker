require 'rails_helper'

RSpec.describe Answer, type: :model do

  it 'having an invalid content should fail' do
    answer = Answer.create(content: nil)
    expect(answer).not_to be_valid
  end

  it 'having an invalid response id should fail' do
    answer = Answer.create(response_id: nil)
    expect(answer).not_to be_valid
  end

  it 'having an invalid question id should fail' do
    answer = Answer.create(question_id: nil)
    expect(answer).not_to be_valid
  end

  it 'having valid attributes should be valid' do

    question = Question.create(content: 'Content', priority: 1)
    response = Response.create
    answer = Answer.create(content: 'content', response_id: response.id, question_id: question.id)

    expect(answer).to be_valid

  end

end
