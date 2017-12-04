class CoursesController < ApplicationController
  before_action :authenticate_faculty!
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit

  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.faculty_id = current_faculty.id
    @file = params[:course][:file]

    if student_is_not_blank?
      add_single_student_to_course
    end

    if @file
      @course.parse_students(@file)
    end

    respond_to do |format|
      if @course.errors.empty? && @course.save
        format.html {redirect_to @course, notice: 'Course was successfully created.'}
        format.json {render :show, status: :created, location: @course}
      else
        format.html {render :new}
        format.json {render json: @course.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    @file = params[:course][:file]

    if student_is_not_blank?
      add_single_student_to_course
    end

    if @file
      parse_students(@file)
    end

    respond_to do |format|
      if @course.errors.empty? && @course.update(course_params)
        format.html {redirect_to @course, notice: 'Course was successfully updated.'}
        format.json {render :show, status: :ok, location: @course}
      else
        format.html {render :edit}
        format.json {render json: @course.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html {redirect_to faculty_home_path, notice: 'Course was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def send_new_survey_mail

    course = Course.find(params[:course_id])
    survey = Survey.find(params[:survey_id])

    course.students.each do |currentStudent|
      NewSurveyMailer.send_new_survey_email(currentStudent, course, survey).deliver_now
    end

    survey.update(start_date: DateTime.now)

    respond_to do |format|
      format.html {redirect_to course_path(course), notice: 'Survey was successfully released'}
      format.json {head :no_content}
    end

  end

  def delete_student_from_course

    student = Student.find(params[:student_id])
    course = Course.find(params[:course_id])
    course.delete_student(student)

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :semester, :section, :faculty_id, :file, :survey_ids => [], :student_ids => [])
  end

  def parse_students(file)
    @course.parse_students(file)
  end


  def student_is_not_blank?
    return false if params[:course][:student].nil?
    name = params[:course][:student][:name]
    student_id = params[:course][:student][:student_id]
    email = params[:course][:student][:email]

    (name != '' || student_id != '' || email != '')
  end

  ##
  # Adds a single student to a course.
  ##
  def add_single_student_to_course
    begin
      student = Student.find_by_email(params[:course][:student][:email])

      if student.nil?
        student = Student.new
        student.email = params[:course][:student][:email]

        student.student_id = params[:course][:student][:student_id]
        student.name = params[:course][:student][:name]
        student.university = Faculty.find(@course.faculty_id).university
      end

      if student.invalid?
        raise StandardError
      end

      @course.surveys.each do |survey|
        survey.students << student
      end

      @course.students << student

    rescue
      @course.errors.add(:student, 'is invalid!')
      return
    end
  end
end
