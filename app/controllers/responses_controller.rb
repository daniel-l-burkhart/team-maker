class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :update, :destroy]

  # GET /responses
  # GET /responses.json
  def index
    @responses = Response.all
  end

  # GET /responses/1
  # GET /responses/1.json
  def show
  end

  # GET /responses/new
  def new
    @survey = Survey.find(params[:survey_id])
    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
    @survey = Survey.find(params[:survey_id])
    @response = Response.find(params[:id])
    @survey.gpa_question = @survey.questions.find_by(content: Question::GPA)
    @survey.comments_question = @survey.questions.find_by(content: Question::COMMENTS)
  end

  # POST /responses
  # POST /responses.json
  def create
    @survey = Survey.find(params[:survey_id])
    @response = Response.new(response_params)

    respond_to do |format|
      if @response.save
        format.html {redirect_to student_home_path, notice: 'Response was successfully created.'}
        format.json {render :show, status: :created, location: @response}
      else
        format.html {render :new}
        format.json {render json: @response.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /responses/1
  # PATCH/PUT /responses/1.json
  def update
    @survey = Survey.find(params[:survey_id])

    answers_attributes = params[:response][:answers_attributes]
    answers_attributes.each_value do |answer|
      if answer[:content].blank?
        answer[:content] = 'N/A'
      end
    end

    @response.completed = true

    respond_to do |format|
      if @response.update(response_params)
        format.html {redirect_to student_home_path, notice: 'Response was successfully updated.'}
        format.json {render :show, status: :ok, location: @response}
      else
        format.html {render :edit}
        format.json {render json: @response.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.json
  def destroy
    @response.destroy
    respond_to do |format|
      format.html {redirect_to responses_url, notice: 'Response was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_response
    @response = Response.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def response_params
    params.require(:response).permit(:survey_id, :student_id, :completed, answers_attributes: [:id, :content, :question_id])
  end
end
