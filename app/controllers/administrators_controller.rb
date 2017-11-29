class AdministratorsController < ApplicationController

  before_action :authenticate_admin!
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  @unapprovedFaculty = Faculty.where(:approved => false)

  # GET /administrators
  # GET /administrators.json
  def index
    @administrators = Administrator.all

  end

  # GET /administrators/1
  # GET /administrators/1.json
  def show
  end

  def home
    @unapprovedFaculty = Faculty.where(:approved => false)

    self.approve_faculty
  end

  # GET /administrators/new
  def new
    @administrator = Administrator.new
  end

  # GET /administrators/1/edit
  def edit
  end

  def approve_faculty

    @show_table = false
    @show_empty_message = false

    @unapprovedFaculty = Faculty.where(:approved => false)

    @allFaculty = Faculty.all

    if @unapprovedFaculty.empty?
      @show_empty_message = true
    else
      @show_table = true
    end

  end

  # POST /administrators
  # POST /administrators.json
  def create
    @administrator = Administrator.new(administrator_params)

    respond_to do |format|
      if @administrator.save
        format.html {redirect_to @administrator, notice: 'Administrator was successfully created.'}
        format.json {render :show, status: :created, location: @administrator}
      else
        format.html {render :new}
        format.json {render json: @administrator.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /administrators/1
  # PATCH/PUT /administrators/1.json
  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html {redirect_to @administrator, notice: 'Administrator was successfully updated.'}
        format.json {render :show, status: :ok, location: @administrator}
      else
        format.html {render :edit}
        format.json {render json: @administrator.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.json
  def destroy
    @administrator.destroy
    respond_to do |format|
      format.html {redirect_to administrators_url, notice: 'Administrator was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_administrator
    @administrator = Administrator.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def administrator_params
    params.require(:administrator).permit(:name, :phone, :department, :university, :email, :encrypted_password, :faculty_ids => [])
  end

end
