require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  before :each do
    faculty = FactoryGirl.create(:faculty)
    course = Course.create!(name: 'MyCourse', semester: 'semester', section: 2, faculty_id: faculty.id)
    survey = Survey.create!(name: 'Survey 2', course_id: course.id, end_date: DateTime.now+2)
    @question = Question.create!(content: 'content', priority: 0)
    @myResponse = Response.create!(survey_id: survey.id)
  end

  let(:valid_attributes) {
    {response_id: @myResponse.id, question_id: @question.id, content: 'content'}
  }

  let(:invalid_attributes) {
    {response_id: nil, question_id: nil, content: nil}
  }

  let(:valid_session) {{}}

  describe 'GET #index' do
    it 'assigns all answers as @answers' do
      answer = Answer.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:answers)).to eq([answer])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested answer as @answer' do
      answer = Answer.create! valid_attributes
      get :show, {:id => answer.to_param}, valid_session
      expect(assigns(:answer)).to eq(answer)
    end
  end

  describe 'GET #new' do
    it 'assigns a new answer as @answer' do
      get :new, {}, valid_session
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested answer as @answer' do
      answer = Answer.create! valid_attributes
      get :edit, {:id => answer.to_param}, valid_session
      expect(assigns(:answer)).to eq(answer)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Answer' do
        expect {
          post :create, {:answer => valid_attributes}, valid_session
        }.to change(Answer, :count).by(1)
      end

      it 'assigns a newly created answer as @answer' do
        post :create, {:answer => valid_attributes}, valid_session
        expect(assigns(:answer)).to be_a(Answer)
        expect(assigns(:answer)).to be_persisted
      end

    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved answer as @answer' do
        post :create, {:answer => invalid_attributes}, valid_session
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        post :create, {:answer => invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {response_id: @myResponse.id, question_id: @question.id, content: 'content'}
      }

      it 'updates the requested answer' do
        answer = Answer.create! valid_attributes
        answerID = answer.id
        put :update, {:id => answer.to_param, :answer => new_attributes}, valid_session

        answer.reload
        expect(answer.id).to eq(answerID)
      end

      it 'assigns the requested answer as @answer' do
        answer = Answer.create! valid_attributes
        put :update, {:id => answer.to_param, :answer => valid_attributes}, valid_session
        expect(assigns(:answer)).to eq(answer)
      end

      it 'redirects to the answer' do
        answer = Answer.create! valid_attributes
        put :update, {:id => answer.to_param, :answer => valid_attributes}, valid_session
        expect(response).to redirect_to(answer)
      end
    end

    context 'with invalid params' do
      it 'assigns the answer as @answer' do
        answer = Answer.create! valid_attributes
        put :update, {:id => answer.to_param, :answer => invalid_attributes}, valid_session
        expect(assigns(:answer)).to eq(answer)
      end

      it "re-renders the 'edit' template" do
        answer = Answer.create! valid_attributes
        put :update, {:id => answer.to_param, :answer => invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested answer' do
      answer = Answer.create! valid_attributes
      expect {
        delete :destroy, {:id => answer.to_param}, valid_session
      }.to change(Answer, :count).by(-1)
    end

    it 'redirects to the answers list' do
      answer = Answer.create! valid_attributes
      delete :destroy, {:id => answer.to_param}, valid_session
      expect(response).to redirect_to(answers_url)
    end
  end

end
