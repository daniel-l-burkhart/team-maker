class SurveysController < ApplicationController
  before_action :set_survey, only: [:show, :edit, :update, :destroy]
  before_action :create_survey, only: [:create]
  before_action :update_survey, only: [:update]
  before_action :authenticate_higher_level!


  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    @course = Course.find(params[:course_id])
  end

  # GET /surveys/new
  def new
    @course = Course.find(params[:course_id])
    @survey = @course.surveys.build
    @survey.gpa_question = Question.new(content: Question::GPA)
    @survey.comments_question = Question.new(content: Question::COMMENTS)
  end

  # GET /surveys/1/edit
  def edit
    @course = Course.find(params[:course_id])
    @survey.gpa_question = Question.find_by(survey_id: @survey.id, content: Question::GPA)
    @survey.comments_question = Question.find_by(survey_id: @survey.id, content: Question::COMMENTS)
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey.start_date = nil

    if @survey.errors.empty?
      add_student_to_survey
      @survey.questions << @survey.gpa_question
      @survey.questions << @survey.comments_question
    end

    @survey.start_date = nil

    respond_to do |format|
      if @survey.errors.empty? && @survey.save
        format.html {redirect_to course_path(@course), notice: 'Survey was successfully created.'}
        format.json {render :show, status: :created, location: @survey}
      else
        format.html {render :new}
        format.json {render json: @survey.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    respond_to do |format|
      if @survey.errors.empty? && @survey.update(survey_params)
        format.html {redirect_to course_path(@course), notice: 'Survey was successfully updated.'}
        format.json {render :show, status: :ok, location: @survey}
      else
        flash[:error] = @survey.errors
        format.html {redirect_to :back}
        format.json {render json: @survey.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @course = Course.find(params[:course_id])
    @survey.destroy
    respond_to do |format|
      format.html {redirect_to @course, notice: 'Survey was successfully destroyed.'}
      format.json {head :no_content}
    end
  end


  def get_remaining
    @remaining.length
  end


  def create_teams


    @survey = Survey.find(params[:survey_id])

    $teams = Array.new
    @@teams = Array.new
    @instance_teams = Array.new

    @remaining = Array.new

    $remaining = Array.new

    $last_index = 0

    @responses = @survey.responses.select {|response| response.completed?}

    incomplete_responses = @survey.responses.select {|response| !response.completed?}
    team_size = params[:team_size].to_i
    preference = params[:team_creation_preference]

    incomplete_responses.each do |response|
      @remaining << response.student
    end

    if preference == 'Similar'
      create_teams_similar(1, @responses, team_size)

      $last_index = $teams.size-1

      create_teams_dissimilar(team_size)

    elsif preference == 'Dissimilar'

      create_teams_dissimilar(team_size)

      $last_index = $teams.size - 1
      create_teams_similar(1, @responses, team_size)
    end

    @responses.each do |response|
      @remaining << response.student
      $remaining << response.student
    end

    redirect_to course_survey_show_created_teams_path
  end

  def create_test_teams(survey, preference, team_size)

    @survey = survey


    $teams = Array.new
    @@teams = Array.new
    @instance_teams = Array.new
    @remaining = Array.new

    $remaining = Array.new

    @responses = @survey.responses.select {|response| response.completed?}

    incomplete_responses = @survey.responses.select {|response| !response.completed?}
    incomplete_responses.each do |response|
      @remaining << response.student
      $remaining << response.student
    end

    if preference == 'Similar'
      create_teams_similar(1, @responses, team_size)

    elsif preference == 'Dissimilar'
      create_teams_dissimilar(team_size)

    end

    @responses.each do |response|
      @remaining << response.student
      $remaining << response.student
    end
    return @remaining
  end

  def create_teams_similar(priority, responses, team_size)

    if responses.empty? || priority > Survey::PRIORITY_MAX
      return
    end

    question_array = @survey.questions.select {|question| question.priority == priority}
    if (!question_array.nil?) && (!question_array.empty?)
      create_similar_from_priority(priority, question_array, responses, team_size)
    end
  end

  def create_similar_from_priority(priority, question_array, responses, team_size)

    question = question_array[0]
    responses_answers = question.answers.select {|answer| responses.include? answer.response}
    grouped_answers = responses_answers.group_by {|answer| answer.content}

    grouped_answers.each_value do |answers|
      if answers.count > team_size

        answers_responses = []
        answers.each {|answer| answers_responses << answer.response}
        create_teams_similar(priority+1, answers_responses, team_size)
        answers.delete_if {|answer| !answers_responses.include? answer.response}
      end

      if answers.count == team_size

        team_answers = answers.shift(team_size)
        team = Team.new(survey_id: @survey.id)

        team_answers.each do |answer|
          team.students << answer.response.student
          responses.delete(answer.response)
          @responses.delete(answer.response)

        end

        @@teams << team
        $teams << team
        @instance_teams << team

      end
    end
  end

  def create_teams_dissimilar(team_size)
    questions = @survey.questions.select {|question| question.priority != 0}
    questions.sort_by! {|question| question.priority}
    potential_teammates = []
    current_teammates = []
    tie_break = []
    counter = 0
    tie_break_depth = 0
    termination_count = @responses.size

    while @responses.size >= team_size && counter <= termination_count
      counter += 1

      current_teammates << 0

      questions_responses = create_questions_responses(questions, @responses)

      q = 0
      while q < questions_responses.size

        # Get the potential teammates for anyone currently on the team.
        questions_responses[q].size.times do |r|
          current_answer = questions_responses[q][r]

          current_teammates.each do |index|
            team_answer = questions_responses[q][index]

            if current_answer == (team_answer - 1) || current_answer == (team_answer + 1)
              potential_teammates << r
            end
          end
        end

        tie_break_depth += 1 unless tie_break.empty?

        # Filter potential_teammates by current_teammates
        filter_by_current_teammates(potential_teammates, current_teammates, q, questions_responses)

        # Filter potential_teammates by tie_break
        filter_by_tie_break(potential_teammates, tie_break) unless tie_break.empty?

        if potential_teammates.empty?
          unless tie_break.empty?
            current_teammates << tie_break[0]
            tie_break.clear
            q -= (1 + tie_break_depth)
            tie_break_depth = 0
          end

        elsif potential_teammates.size == 1
          current_teammates << potential_teammates[0]
          tie_break.clear
          q -= (1 + tie_break_depth)
          tie_break_depth = 0

        elsif potential_teammates.size > 1
          tie_break.clear

          potential_groups = potential_teammates.group_by {|teammate| questions_responses[q][teammate]}
          potential_groups.each_key do |key|
            group = potential_groups[key]

            if group.size == 1
              current_teammates << group[0]
              potential_teammates.delete(group[0])
              teammates_to_delete = []

              potential_teammates.each do |teammate|
                if questions_responses[q-1][teammate] == questions_responses[q-1][group[0]]
                  teammates_to_delete << teammate
                end
              end

              teammates_to_delete.each do |teammate|
                potential_teammates.delete(teammate)
                potential_groups.each_value do |values|
                  values.delete(teammate)
                end
              end

              potential_groups.delete(key)
            end

            if current_teammates.size == team_size
              break
            end
          end

          if all_greater_than_one(potential_groups)
            potential_groups.each_value do |value|
              tie_break = tie_break + value
            end
          end
        end

        if current_teammates.size == team_size
          team = Team.new(survey_id: @survey.id)

          current_teammates.each do |teammate|
            team.students << @responses[teammate].student
          end

          $teams << team
          remove_multiple_from_responses(current_teammates, questions_responses)
          current_teammates.clear
          tie_break.clear
          break
        end

        potential_teammates.clear

        q += 1

      end

      current_teammates.clear
      potential_teammates.clear

      unless current_teammates.empty?
        $remaining << @responses.delete_at(current_teammates[0]).student
        current_teammates.clear
      end
    end
  end

  def all_greater_than_one(potential_groups)
    greater_than_one = true

    if potential_groups.empty?
      greater_than_one = false
    else
      potential_groups.each_value do |group|
        if group.size < 2
          greater_than_one = false
        end
      end
    end

    greater_than_one
  end

  def remove_multiple_from_responses(indices_to_remove, questions_responses)
    responses_to_remove = []

    indices_to_remove.each do |index|
      responses_to_remove << @responses[index]
      questions_responses.each do |question|
        question.delete_at(index)
      end
    end

    responses_to_remove.each do |response|
      @responses.delete(response)
    end
  end

  def filter_by_tie_break(potential_teammates, tie_break)
    responses_to_remove = []

    potential_teammates.each do |teammate|
      unless tie_break.include? teammate
        responses_to_remove << teammate
      end
    end

    responses_to_remove.each do |response|
      potential_teammates.delete(response)
    end
  end

  def filter_by_current_teammates(potential_teammates, current_teammates, q, questions_responses)
    responses_to_remove = []
    grades_to_remove = []

    current_teammates.each do |teammate|
      grades_to_remove << questions_responses[q][teammate]
    end

    potential_teammates.each do |teammate|
      if current_teammates.include?(teammate) || grades_to_remove.include?(questions_responses[q][teammate])
        responses_to_remove << teammate
      end
    end

    responses_to_remove.each do |response|
      potential_teammates.delete(response)
    end

  end

  def create_questions_responses(questions, responses)
    questions_responses = []

    questions.each do |question|
      questions_responses << Array.new
      responses.each do |response|
        answer = question.answers.select {|answer| answer.response == response}[0]

        if answer.content.ord == 70
          questions_responses.last << 69
        else
          questions_responses.last << answer.content.ord
        end

      end
    end

    questions_responses
  end

  def edit_teams

    begin

      @remainderStudents = $remaining

      $team_id = params[:team_id]

      @edited_team = $teams[$team_id.to_i]

      puts @edited_team.students

    rescue

      respond_to do |format|
        format.html {redirect_to root_path, notice: 'Something went wrong. Please try again'}
        format.json {render :show, status: :created, location: @survey}

      end
    end
  end

  def show_created_teams

    begin

      @teams = $teams
      @remaining = $remaining

    rescue
      redirect_to root_path, notice: 'Something went wrong. Probably a refresh. Please try again'
    end

  end

  def create_new_team

    begin

      $teams.push(Team.new(survey_id: params[:survey_id]))
      @@teams.push(Team.new(survey_id: params[:survey_id]))

      redirect_to course_survey_show_created_teams_path, notice: 'New Team added!!!'


    rescue
      redirect_to root_path, notice: 'Something went wrong. Probably a refresh. Please try again'
    end

  end

  def delete_team

    $teams.delete_at(params[:team_id].to_i)
    redirect_to course_survey_show_created_teams_path, notice: 'Team Deleted'

  end

  def save_team

    redirect_to course_survey_show_created_teams_path, notice: 'Team successfully saved!'


  end


  def remove_student

    student = Student.find(params[:student_id])

    $teams[$team_id.to_i].remove_student(student)
    @@teams[$team_id.to_i].remove_student(student)

    $remaining.push(student)

    respond_to do |format|

      format.html {redirect_to course_survey_edit_team_path(course_id: params[:course_id],
                                                            survey_id: params[:survey_id],
                                                            team_id: $team_id),
                               notice: 'Student removed'}
    end

  end


  def add_student_to_team_from_form

    student = Student.find_by_email(params[:selected_student][:selected_student_email])

    $teams[$team_id.to_i].addStudent(student)


    $remaining.delete(student)

    respond_to do |format|
      format.html {
        redirect_to course_survey_edit_team_path(course_id: params[:course_id],
                                                 survey_id: params[:survey_id],
                                                 team_id: $team_id),
                    notice: 'Student Added'}
    end

  end


  def release_teams

    $teams.each do |team|
      if team.students.size == 0
        $teams.delete(team)
      end
    end

    $teams.each do |single_team|

      single_team.students.each do |student|

        ReleaseTeamsMailer.release_new_teams_mailer(student).deliver_now

      end

      single_team.released = true
      single_team.save!
    end

    respond_to do |format|
      format.html {redirect_to faculty_home_path, notice: 'Survey teams were successfully released.'}
    end

  end

  private

  def add_student_to_survey
    @course.students.each do |student|
      @survey.students << student
    end
  end

  def update_survey
    @course = Course.find(params[:course_id])
    update_gpa_question
  end

  def update_gpa_question
    content = params[:survey][:gpa_question][:content]
    priority = params[:survey][:gpa_question][:priority]

    @survey.questions.each do |question|
      if question.content == content
        question.priority = priority
      end
    end
  end

  def create_survey
    @course = Course.find(params[:course_id])
    @survey = Survey.new(survey_params)
    @survey.course_id = @course.id
    create_gpa_question
    create_comments_question
  end

  def create_comments_question
    content = params[:survey][:comments_question][:content]
    @survey.comments_question = Question.new(content: content, priority: 0)
  end

  def create_gpa_question
    content = params[:survey][:gpa_question][:content]
    priority = params[:survey][:gpa_question][:priority]
    @survey.gpa_question = Question.new(content: content, priority: priority)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def survey_params
    params.require(:survey).permit(:selected_student, :student_id, :team_creation_preference, :team_size, :name, :start_date, :end_date,
                                   :course_id, gpa_question: [:id, :content, :priority],
                                   comments_question: [:id, :content],
                                   questions_attributes: [:id, :content, :_destroy, :priority],
                                   :response_ids => [], :student_ids => [])
  end
end
