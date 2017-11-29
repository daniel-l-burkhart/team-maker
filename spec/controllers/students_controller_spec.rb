require 'rails_helper'

##
# Controller testing for Student controller
##
RSpec.describe StudentsController, type: :controller do

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:student]
    sign_in FactoryGirl.create(:student)
  end

  let(:valid_attributes) {
    {name: 'name', phone: 'phone', student_id: 'studentId', university: 'university', email: 'email@email.com', password: 'password'}
  }

  let(:invalid_attributes) {
    {name: nil, university: nil, student_id: nil, email: nil, password: nil}
  }

  describe 'Should Log in' do
    it 'should_have_current_user' do
      expect(subject.current_student).to_not eq(nil)
    end

    it 'should_get_index' do
      get 'index'
      expect(response).to be_success
    end
  end

  describe 'GET #index' do
    it 'assigns all students as @students' do
      student = Student.create! valid_attributes

      get :index, {}
      expect(assigns(:students)).to include student
    end
  end

  describe 'GET #show' do
    it 'assigns the requested student as @student' do
      student = Student.create! valid_attributes
      get :show, {:id => student.to_param}
      expect(assigns(:student)).to eq(student)
    end
  end

  describe 'GET #new' do
    it 'assigns a new student as @student' do
      get :new, {}
      expect(assigns(:student)).to be_a_new(Student)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested student as @student' do
      student = Student.create! valid_attributes
      get :edit, {:id => student.to_param}
      expect(assigns(:student)).to eq(student)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Student' do
        expect {Student.create! valid_attributes}.to change {Student.count}.by(1)

      end

      it 'assigns a newly created student as @student' do
        post :create, {:student => valid_attributes}
        expect(assigns(:student)).to be_a(Student)
      end

      it 'redirects to the created student' do
        post :create, {:student => valid_attributes}
        expect(response).to be_success
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved student as @student' do
        post :create, {:student => invalid_attributes}
        expect(assigns(:student)).to be_a_new(Student)
      end

      it "re-renders the 'new' template" do
        post :create, {:student => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {

        {name: 'Newname', phone: 'phone', student_id: 'studentId', university: 'university', email: 'email@email.com', password: 'password'}
      }

      it 'updates the requested student' do
        student = Student.create! valid_attributes
        put :update, {:id => student.to_param, :student => new_attributes}
        student.reload

      end

      it 'assigns the requested student as @student' do
        student = Student.create! valid_attributes
        put :update, {:id => student.to_param, :student => valid_attributes}
        expect(assigns(:student)).to eq(student)
      end

      it 'redirects to the student' do
        student = Student.create! valid_attributes
        put :update, {:id => student.to_param, :student => valid_attributes}
        expect(response).to redirect_to(student)
      end
    end

    context 'with invalid params' do
      it 'assigns the student as @student' do
        student = Student.create! valid_attributes
        put :update, {:id => student.to_param, :student => invalid_attributes}
        expect(assigns(:student)).to eq(student)
      end

      it "re-renders the 'edit' template" do
        student = Student.create! valid_attributes
        put :update, {:id => student.to_param, :student => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested student' do
      student = Student.create! valid_attributes
      expect {
        delete :destroy, {:id => student.to_param}
      }.to change(Student, :count).by(-1)
    end

    it 'redirects to the students list' do
      student = Student.create! valid_attributes
      delete :destroy, {:id => student.to_param}
      expect(response).to redirect_to(students_url)
    end
  end

end
