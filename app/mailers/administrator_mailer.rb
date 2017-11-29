class AdministratorMailer < Devise::Mailer
  default from: 'rorteammaker@gmail.edu'

  ##
  # Sends email to admin about faculty request
  ##
  def new_user_waiting_for_approval(faculty)
    @faculty = faculty

    mail(to: 'rorteammaker@gmail.com', subject: 'A new faculty member is awaiting approval!', body: 'A new faculty member is awaiting your approval!')
  end
end
