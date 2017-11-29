require 'rails_helper'

RSpec.describe Question, type: :model do

  it 'has an invalid content should fail' do
    invalidQuestion = Question.create(content: nil, priority: 1)
    expect(invalidQuestion).not_to be_valid
  end

  it 'has an invalid priority and should fail' do
    invalidQuestion = Question.create(content: 'Content', priority: nil)
    expect(invalidQuestion).not_to be_valid
  end

  it 'has a valid content and priority should be valid' do
    invalidQuestion = Question.create(content: 'Content', priority: 1)
    expect(invalidQuestion).to be_valid
  end

end
