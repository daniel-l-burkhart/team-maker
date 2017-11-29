class NewSurveyMailer < Devise::Mailer

  default from: 'rorteammaker@gmail.com'

  def send_new_survey_email(student, course, survey)

    @student = student
    @course = course
    @survey = survey


    mail(to: @student.email, subject: 'New survey available!') do |format|
      format.html {render 'send_new_survey_email'
      }
    end
  end
end
