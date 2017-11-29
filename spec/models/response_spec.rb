require 'rails_helper'

RSpec.describe Response, type: :model do

  it 'has a valid survey' do

    students = []

    5.times do
      students.push(FactoryGirl.create(:student))
    end

    faculty = FactoryGirl.create(:faculty)
    course = Course.create(name: 'Name', semester: 'Semester', section: 2, faculty_id: faculty.id)

    students.each do |student|
      course.students.push(student)
    end

    course.save!

    @survey = Survey.create({name: 'SurveyName', start_date: DateTime.now, end_date: DateTime.now+1,
                             course_id: course.id, gpa_question: {id: 1, content: 'What is your GPA?', priority: 0},
                             comments_question: {id: 1, content: 'Comments', priority: 0}})

    response = Response.create(survey_id: @survey.id)

    expect(response).to be_valid
  end

end
