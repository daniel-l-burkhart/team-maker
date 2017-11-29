require 'rails_helper'

##
# Controller testing for Administrator controller
##
RSpec.describe AdministratorsController, type: :controller do

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:administrator]
    sign_in FactoryGirl.create(:administrator)
  end

  let(:valid_attributes) {
    {name: 'name', phone: 'phone', department: 'department', university: 'university', email: 'email@email.com', password: 'password'}
  }

  let(:invalid_attributes) {
    {first_name: nil, last_name: nil, department: 'nil', university: nil}
  }

  describe 'Should Log in' do
    it 'should_have_current_user' do
      expect(subject.current_administrator).to_not eq(nil)
    end

    it 'should_get_index' do
      get 'index'
      expect(response).to be_success
    end
  end


  describe 'GET #index' do

    it 'assigns all administrators as @administrators' do
      administrator = Administrator.create! valid_attributes
      get :index, {}
      expect(assigns(:administrators)).to include administrator

    end
  end

  describe 'GET #show' do
    it 'assigns the requested administrator as @administrator' do
      administrator = Administrator.create! valid_attributes
      get :show, {:id => administrator.to_param}
      expect(assigns(:administrator)).to eq(administrator)
    end
  end

  describe 'GET #new' do
    it 'assigns a new administrator as @administrator' do
      get :new, {}
      expect(assigns(:administrator)).to be_a_new(Administrator)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested administrator as @administrator' do
      administrator = Administrator.create! valid_attributes
      get :edit, {:id => administrator.to_param}
      expect(assigns(:administrator)).to eq(administrator)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Administrator' do

        expect {Administrator.create! valid_attributes}.to change {Administrator.count}.by(1)

      end

      it 'assigns a newly created administrator as @administrator' do
        post :create, {:administrator => valid_attributes}
        expect(assigns(:administrator)).to be_a(Administrator)

      end


    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved administrator as @administrator' do
        post :create, {:administrator => invalid_attributes}
        expect(assigns(:administrator)).to be_a_new(Administrator)
      end

      it "re-renders the 'new' template" do
        post :create, {:administrator => invalid_attributes}
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do

      let(:new_attributes) {
        {name: 'name', phone: 'phone', department: 'department', university: 'university', email: 'email@email.com', password: 'password'}
      }

      it 'updates the requested administrator' do
        administrator = Administrator.create! valid_attributes
        put :update, {:id => administrator.to_param, :administrator => new_attributes}
        administrator.reload
      end

      it 'assigns the requested administrator as @administrator' do
        administrator = Administrator.create! valid_attributes
        put :update, {:id => administrator.to_param, :administrator => valid_attributes}
        expect(assigns(:administrator)).to eq(administrator)
      end

      it 'redirects to the administrator' do
        administrator = Administrator.create! valid_attributes
        put :update, {:id => administrator.to_param, :administrator => valid_attributes}
        expect(response).to redirect_to(administrator)
      end
    end

    context 'with invalid params' do
      it 'assigns the administrator as @administrator' do
        administrator = Administrator.create! valid_attributes
        put :update, {:id => administrator.to_param, :administrator => invalid_attributes}
        expect(assigns(:administrator)).to eq(administrator)
      end

      it "re-renders the 'edit' template" do
        administrator = Administrator.create! valid_attributes
        put :update, {:id => administrator.to_param, :administrator => invalid_attributes}
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested administrator' do
      administrator = Administrator.create! valid_attributes
      expect {
        delete :destroy, {:id => administrator.to_param}
      }.to change(Administrator, :count).by(-1)
    end

    it 'redirects to the administrators list' do
      administrator = Administrator.create! valid_attributes
      delete :destroy, {:id => administrator.to_param}
      expect(response).to redirect_to(administrators_url)
    end
  end

end
