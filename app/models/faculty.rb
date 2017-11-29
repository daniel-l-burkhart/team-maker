class Faculty < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  belongs_to :administrator
  has_many :courses

  validates :name, presence: true
  validates :phone, presence: true
  validates :department, presence: true
  validates :university, presence: true

  ##
  # Active for authentication
  ##
  def active_for_authentication?
    super && approved?
  end

  ##
  # Inactive message
  ##
  def inactive_message
    if approved?
      super # Use whatever other message
    end
  end

  after_create :send_admin_mail

  ##
  # Sends email to admin
  ##
  def send_admin_mail
    AdministratorMailer.new_user_waiting_for_approval(self).deliver_now
  end

  after_update :send_faculty_confirmation

  ##
  # Sends confiramtion to faculty
  ##
  def send_faculty_confirmation

    if approved?
      if self.confirmation_token.nil?
        self.send_confirmation_instructions
      end
    end
  end

  ##
  # new function to set the password without knowing the current password used in our confirmation controller.
  ##
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  ##
  # Password match
  ##
  def password_match?
    self.password == self.password_confirmation
  end

  ##
  # new function to return whether a password has been set
  ##
  def has_no_password?
    self.password.blank?
  end

  ##
  # new function to provide access to protected method unless_confirmed
  ##
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  ##
  # Password required?
  ##
  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  protected

  ##
  # Confirmation not required at first
  ##
  def confirmation_required?
    false
  end
end
