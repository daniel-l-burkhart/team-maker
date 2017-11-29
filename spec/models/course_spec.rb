require 'rails_helper'

RSpec.describe Course, type: :model do

  it 'having a nil name should be invalid' do
    course = Course.create(name: nil, semester: 'Semester', section: 'section')
    expect(course).not_to be_valid
  end

  it 'having a nil semester should be invalid' do
    course = Course.create(name: 'Name', semester: nil, section: 'section')
    expect(course).not_to be_valid
  end

  it 'having a nil section should be invalid' do
    course = Course.create(name: 'Name', semester: 'Semester', section: nil)
    expect(course).not_to be_valid
  end

  it 'having valid attributes should pass' do
    course = Course.create(name: 'Name', semester: 'Semester', section: '3')
    expect(course).to be_valid
  end

end
