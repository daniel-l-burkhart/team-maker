require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TeamsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Team. As you add validations to Team, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    survey = Survey.create(name: 'My Survey', start_date: DateTime.now, end_date: DateTime.now+1)
    {survey_id: survey.id}
  }

  let(:invalid_attributes) {
    {survey_id: nil}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeamsController. Be sure to keep this updated too.
  let(:valid_session) {{}}

  describe "GET #index" do
    it "assigns all teams as @teams" do
      team = Team.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:teams)).to eq([team])
    end
  end

  describe "GET #show" do
    it "assigns the requested team as @team" do
      team = Team.create! valid_attributes
      get :show, {:id => team.to_param}, valid_session
      expect(assigns(:team)).to eq(team)
    end
  end

  describe "GET #new" do
    it "assigns a new team as @team" do
      get :new, {}, valid_session
      expect(assigns(:team)).to be_a_new(Team)
    end
  end

  describe "GET #edit" do
    it "assigns the requested team as @team" do
      team = Team.create! valid_attributes
      get :edit, {:id => team.to_param}, valid_session
      expect(assigns(:team)).to eq(team)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes}, valid_session
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}, valid_session
        expect(assigns(:team)).to be_a(Team)
        expect(assigns(:team)).to be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes}, valid_session
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        post :create, {:team => invalid_attributes}, valid_session
        expect(assigns(:team)).to be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        post :create, {:team => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        survey = Survey.create(name: 'My Updated Survey', start_date: DateTime.now, end_date: DateTime.now)
        {survey_id: survey.id}
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => new_attributes}, valid_session
        team.reload

      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end

      it "redirects to the team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => valid_attributes}, valid_session
        expect(response).to redirect_to(team)
      end
    end

    context "with invalid params" do
      it "assigns the team as @team" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => invalid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end

      it "re-renders the 'edit' template" do
        team = Team.create! valid_attributes
        put :update, {:id => team.to_param, :team => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested team" do
      team = Team.create! valid_attributes
      expect {
        delete :destroy, {:id => team.to_param}, valid_session
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Team.create! valid_attributes
      delete :destroy, {:id => team.to_param}, valid_session
      expect(response).to redirect_to(teams_url)
    end
  end

end
