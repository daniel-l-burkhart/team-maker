require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
=begin

  before(:each) do
    @student = FactoryGirl.create(:student)
    @survey = FactoryGirl.create(:survey)
    @survey.students.push(@student)
  end


  # This should return the minimal set of attributes required to create a valid
  # Response. As you add validations to Response, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {

    {survey_id: @survey.id, student_id: @student.id, completed: true}
  }

  let(:invalid_attributes) {
    {survey_id: nil, student_id: nil, completed: nil}
  }


  describe "GET #index" do
    it "assigns all responses as @responses" do
      response = Response.create! valid_attributes
      # get :index, {}
      expect(assigns(:responses)).to eq([response])
    end
  end

  describe "GET #show" do
    it "assigns the requested response as @response" do
      response = Response.create! valid_attributes
      get :show, {:id => response.to_param}
      expect(assigns(:response)).to eq(response)
    end
  end

  describe "GET #new" do
    it "assigns a new response as @response" do
      get :new, {}
      expect(assigns(:response)).to be_a_new(Response)
    end
  end

  describe "GET #edit" do
    it "assigns the requested response as @response" do
      response = Response.create! valid_attributes
      get :edit, {:id => response.to_param}
      expect(assigns(:response)).to eq(response)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Response" do
        expect {
          post :create, {:response => valid_attributes}
        }.to change(Response, :count).by(1)
      end

      it "assigns a newly created response as @response" do
        post :create, {:response => valid_attributes}
        expect(assigns(:response)).to be_a(Response)
        expect(assigns(:response)).to be_persisted
      end

      it "redirects to the created response" do
        post :create, {:response => valid_attributes}
        expect(response).to redirect_to(Response.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved response as @response" do
        post :create, {:response => invalid_attributes}
        expect(assigns(:response)).to be_a_new(Response)
      end

      it "re-renders the 'new' template" do
        post :create, {:response => invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {survey_id: 2, student_id: 1, completed: true}
      }

      it "updates the requested response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => new_attributes}
        response.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested response as @response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => valid_attributes}
        expect(assigns(:response)).to eq(response)
      end

      it "redirects to the response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => valid_attributes}
        expect(response).to redirect_to(response)
      end
    end

    context "with invalid params" do
      it "assigns the response as @response" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => invalid_attributes}
        expect(assigns(:response)).to eq(response)
      end

      it "re-renders the 'edit' template" do
        response = Response.create! valid_attributes
        put :update, {:id => response.to_param, :response => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested response" do
      response = Response.create! valid_attributes
      expect {
        delete :destroy, {:id => response.to_param}
      }.to change(Response, :count).by(-1)
    end

    it "redirects to the responses list" do
      response = Response.create! valid_attributes
      delete :destroy, {:id => response.to_param}
      expect(response).to redirect_to(responses_url)
    end
  end
=end
end
