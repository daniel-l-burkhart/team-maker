require 'rails_helper'

RSpec.describe SurveysController, type: :controller do

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:faculty]
    sign_in FactoryGirl.create(:faculty)
  end

  let(:valid_attributes) {
    {name: 'SurveyName', end_date: DateTime.now+1, gpa_question: {id: 1, content: 'What is your GPA?', priority: '1'},
     comments_question: {id: 1, content: 'Comments'}}
  }

  let(:invalid_attributes) {
    {name: nil, end_date: DateTime.now+5, gpa_question: {id: nil, content: nil, priority: nil},
     comments_question: {id: nil, content: nil}}
  }

  describe 'GET #index' do
    it 'assigns all surveys as @surveys' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)

      survey = Survey.create! valid_attributes
      get :index, :course_id => myCourse.id
      expect(assigns(:surveys)).to eq([survey])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested survey as @survey' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)

      survey = Survey.create! valid_attributes
      get :show, {:id => survey.to_param, :course_id => myCourse.id}
      expect(assigns(:survey)).to eq(survey)
    end
  end

  describe 'GET #new' do
    it 'assigns a new survey as @survey' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)

      get :new, :course_id => myCourse.id
      expect(assigns(:survey)).to be_a_new(Survey)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested survey as @survey' do

      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)

      survey = Survey.create! valid_attributes
      get :edit, {:id => survey.to_param, :course_id => myCourse.id}
      expect(assigns(:survey)).to eq(survey)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)


      it 'creates a new Survey' do
        expect {
          post :create, {:survey => valid_attributes, :course_id => myCourse.id}
        }.to change(Survey, :count).by(1)
      end

      it 'assigns a newly created survey as @survey' do
        post :create, {:survey => valid_attributes, :course_id => myCourse.id}
        expect(assigns(:survey)).to be_a(Survey)
        expect(assigns(:survey)).to be_persisted
      end

      it 'redirects to the created survey' do
        post :create, {:survey => valid_attributes, :course_id => myCourse.id}
        expect(response).to redirect_to(myCourse)
      end
    end

    context 'with invalid params' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)


      it 'assigns a newly created but unsaved survey as @survey' do
        post :create, {:survey => invalid_attributes, :course_id => myCourse.id}
        expect(assigns(:survey)).to be_a_new(Survey)
      end

      it "re-renders the 'new' template" do
        post :create, {:survey => invalid_attributes, :course_id => myCourse.id}
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)


      let(:new_attributes) {
        {name: 'newSurveyName', end_date: DateTime.now+4, gpa_question: {id: 1, content: 'What is your GPA?', priority: '1'}, comments_question: {id: 1, content: 'Comments'}}
      }

      it 'updates the requested survey' do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => new_attributes, :course_id => myCourse.id}
        survey.reload
      end

      it 'assigns the requested survey as @survey' do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => valid_attributes, :course_id => myCourse.id}
        expect(assigns(:survey)).to eq(survey)
      end

      it 'redirects to the survey' do
        survey = Survey.create! valid_attributes
        put :update, {:id => survey.to_param, :survey => valid_attributes, :course_id => myCourse.id}
        expect(response).to redirect_to(myCourse)
      end
    end

  end

  describe 'DELETE #destroy' do
    myCourse = Course.create(name: 'Name', semester: 'semester', section: 2)

    it 'destroys the requested survey' do
      survey = Survey.create! valid_attributes
      expect {
        delete :destroy, {:id => survey.to_param, :course_id => myCourse.id}
      }.to change(Survey, :count).by(-1)
    end

    it 'redirects to the surveys list' do
      survey = Survey.create! valid_attributes
      delete :destroy, {:id => survey.to_param, :course_id => myCourse.id}
      expect(response).to redirect_to(myCourse)
    end
  end


  describe 'Make teams similar' do

    it 'should create 0 teams when no priorities are set' do
      students = []
      responses = []


      10.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 0))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'B'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'C'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'D'))

      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'F'))

      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 2)

      expect(remaining.size).to eq(10)

    end

    it 'should create 5 even teams of two on first priority' do
      students = []
      responses = []


      10.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'B'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'C'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'D'))

      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'F'))

      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 2)

      expect(remaining.size).to eq(0)

    end


    it 'should create 5 even teams of two on second priority' do

      students = []
      responses = []


      10.times do
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

      @survey.save!

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.questions.push(Question.create(content: 'What is your grade is CS 3212?', survey_id: @survey.id, priority: 2))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[1].id, content: 'A'))

      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[1].id, content: 'B'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[1].id, content: 'C'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[1].id, content: 'D'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[1].id, content: 'D'))

      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[1].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[1].id, content: 'F'))

      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 2)

      expect(remaining.size).to eq(0)

    end


    it 'should create 4 even teams of two and three remaining on first priority because there is no second priority' do

      students = []
      responses = []


      11.times do
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

      @survey.save!

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'B'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'C'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'D'))

      # These responses should be put into the remaining because they cannot break the three way tie since there is only one priority.
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'F'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 2)

      expect(remaining.size).to eq(3)

    end


    it 'should create 4 even teams with team size of 3 and 12 students on first priority.' do

      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'B'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'C'))

      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'F'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 3)

      expect(remaining.size).to eq(0)

    end

    it 'should create 4 even teams of 3 out of 12 students based on second priority' do
      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.questions.push(Question.create(content: 'What is your grade in CS 3212?', survey_id: @survey.id, priority: 2))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[1].id, content: 'A'))

      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[1].id, content: 'B'))

      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[1].id, content: 'C'))

      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[1].id, content: 'D'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[1].id, content: 'D'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[1].id, content: 'D'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 3)

      expect(remaining.size).to eq(0)
    end

    it 'should create 3 even teams of 4 out of 12 students based on second priority' do
      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.questions.push(Question.create(content: 'What is your grade in CS 3212?', survey_id: @survey.id, priority: 2))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[1].id, content: 'A'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[1].id, content: 'B'))

      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[1].id, content: 'C'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 4)
      expect(remaining.size).to eq(0)

    end

    it 'should create 3 even teams of 4 out of 12 students based on first priority' do
      students = []
      responses = []

      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'B'))

      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'C'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Similar', 4)
      expect(remaining.size).to eq(0)

    end

  end


  describe 'Make Teams Dissimilar' do

    it 'should make 1 team of 4 out of 12 students with 8 remaining on first priority' do
      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))

      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'A'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 4)
      expect(remaining.size).to eq(8)
    end


    it 'should make 1 team of 4 with 8 remaining on second priority' do

      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.questions.push(Question.create(content: 'What is your grade in CS 3212?', survey_id: @survey.id, priority: 2))
      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[1].id, content: 'B'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[1].id, content: 'C'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[1].id, content: 'D'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[1].id, content: 'A'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 4)
      expect(remaining.size).to eq(8)

    end

    it 'should make 3 teams of 3 from 12 students with 3 remaining on first priority' do
      students = []
      responses = []


      12.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))
      @survey.questions.push(Question.create(content: 'What is your grade in CS 3212?', survey_id: @survey.id, priority: 2))

      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[0].id, content: 'F'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[0].id, content: 'A'))

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[5].answers.push(Answer.create(response_id: responses[5].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[6].answers.push(Answer.create(response_id: responses[6].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[7].answers.push(Answer.create(response_id: responses[7].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[8].answers.push(Answer.create(response_id: responses[8].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[9].answers.push(Answer.create(response_id: responses[9].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[10].answers.push(Answer.create(response_id: responses[10].id, question_id: @survey.questions[1].id, content: 'A'))
      responses[11].answers.push(Answer.create(response_id: responses[11].id, question_id: @survey.questions[1].id, content: 'A'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 3)
      expect(remaining.size).to eq(3)
    end


    it 'should make 2 dissimilar teams of 2 and one remaining' do
      students = []
      responses = []


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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))

      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'D'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'F'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 2)
      expect(remaining.size).to eq(1)
    end


    it 'should make 0 teams if all students have the same answer' do
      students = []
      responses = []


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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))

      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[4].answers.push(Answer.create(response_id: responses[4].id, question_id: @survey.questions[0].id, content: 'A'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 2)
      expect(remaining.size).to eq(5)
    end

    it 'should make 2 teams of 2 students with 0 remaining on first priority' do
      students = []
      responses = []


      4.times do
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

      @survey.questions.push(Question.create(content: 'What is your grade in CS 3202?', survey_id: @survey.id, priority: 1))

      @survey.save!

      course.students.each do |student|
        responses.push(Response.create(survey_id: @survey.id, student_id: student.id, completed: true))
      end

      responses[0].answers.push(Answer.create(response_id: responses[0].id, question_id: @survey.questions[0].id, content: 'A'))
      responses[1].answers.push(Answer.create(response_id: responses[1].id, question_id: @survey.questions[0].id, content: 'B'))
      responses[2].answers.push(Answer.create(response_id: responses[2].id, question_id: @survey.questions[0].id, content: 'C'))
      responses[3].answers.push(Answer.create(response_id: responses[3].id, question_id: @survey.questions[0].id, content: 'D'))


      @survey.responses = responses
      @survey.save!

      remaining = controller.create_test_teams(@survey, 'Dissimilar', 2)
      expect(remaining.size).to eq(0)
    end

  end

end
