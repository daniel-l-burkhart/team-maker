require 'rails_helper'
include Devise::TestHelpers

##
# Controller testing for Faculty controller
##
RSpec.describe FacultiesController, type: :controller do

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:faculty]
    sign_in FactoryGirl.create(:faculty)

    @request.env['devise.mapping'] = Devise.mappings[:administrator]
    sign_in FactoryGirl.create(:administrator)
  end

  let(:valid_attributes) {
    {name: 'name', phone: 'phone', department: 'department', university: 'university', email: 'email@email.com', password: 'password', approved: true}
  }

  let(:invalid_attributes) {
    {name: nil, phone: nil, department: nil, university: nil, email: nil, password: nil, approved: true}}


  describe 'Should Log in' do
    it 'should_have_current_user' do
      expect(subject.current_faculty).to_not eq(nil)
    end

    it 'should_get_index' do
      get 'index'
      expect(response).to be_success
    end
  end

  describe 'GET #index' do
    it 'assigns all faculties as @faculties' do
      faculty = Faculty.create! valid_attributes
      get :index, {}
      expect(assigns(:faculties)).to include(faculty)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested faculty as @faculty' do
      faculty = Faculty.create! valid_attributes
      get :show, {:id => faculty.to_param}
      expect(assigns(:faculty)).to eq(faculty)

    end
  end

  describe 'GET #new' do
    it 'assigns a new faculty as @faculty' do
      get :new, {}
      expect(assigns(:faculty)).to be_a_new(Faculty)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested faculty as @faculty' do
      faculty = Faculty.create! valid_attributes
      get :edit, {:id => faculty.to_param}
      expect(assigns(:faculty)).to eq(faculty)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Faculty' do

        expect {Faculty.create! valid_attributes}.to change {Faculty.count}.by(1)

      end

      it 'assigns a newly created faculty as @faculty' do
        post :create, {:faculty => valid_attributes}
        expect(assigns(:faculty)).to be_a(Faculty)
      end

      it 'redirects to the created faculty' do
        post :create, {:faculty => valid_attributes}
        expect(response).to be_success
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved faculty as @faculty' do
        post :create, {:faculty => invalid_attributes}
        expect(assigns(:faculty)).to be_a_new(Faculty)
      end

      it "re-renders the 'new' template" do
        post :create, {:faculty => invalid_attributes}
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {name: 'newName', phone: 'newPhone', department: 'newDepartment', university: 'newUniversity', email: 'newEmail@email.com', password: 'newPassword'}
      }

      it 'updates the requested faculty' do
        faculty = Faculty.create! valid_attributes
        put :update, {:id => faculty.to_param, :faculty => new_attributes}
        faculty.reload
      end

      it 'assigns the requested faculty as @faculty' do
        faculty = Faculty.create! valid_attributes
        put :update, {:id => faculty.to_param, :faculty => valid_attributes}
        expect(assigns(:faculty)).to eq(faculty)
      end

      it 'redirects to the faculty' do
        @request.env['devise.mapping'] = Devise.mappings[:administrator]
        sign_in FactoryGirl.create(:administrator)
        faculty = Faculty.create! valid_attributes
        put :update, {:id => faculty.to_param, :faculty => valid_attributes}
        expect(response).to redirect_to('/admin/home')
      end
    end

    context 'with invalid params' do

      it 'assigns the faculty as @faculty' do
        faculty = Faculty.create! valid_attributes
        put :update, {:id => faculty.to_param, :faculty => invalid_attributes}
        expect(assigns(:faculty)).to eq(faculty)
      end

      it "re-renders the 'edit' template" do

        faculty = Faculty.create! valid_attributes
        put :update, {:id => faculty.to_param, :faculty => invalid_attributes}
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested faculty' do
      faculty = Faculty.create! valid_attributes
      expect {
        delete :destroy, {:id => faculty.to_param}
      }.to change(Faculty, :count).by(-1)
    end

    it 'redirects to the faculties list' do
      faculty = Faculty.create! valid_attributes
      delete :destroy, {:id => faculty.to_param}
      expect(response).to redirect_to(faculties_url)
    end
  end

end
