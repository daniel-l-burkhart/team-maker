class Faculties::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  #def new
  # super
  #end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do

      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:faculty])
        if @confirmable.valid? and @confirmable.password_match?
          do_confirm
        else
          do_show
          @confirmable.errors.clear #so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'faculties/confirmations/new'
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do

      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    unless @confirmable.errors.empty?
      self.resource = @confirmable
      render 'faculties/confirmations/new'
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = Faculty.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    unless @confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'faculties/confirmations/show'
  end

  def do_confirm
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
