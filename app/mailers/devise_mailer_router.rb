class DeviseMailerRouter < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def reset_password_instructions(record, token, opts={})
    # @token = token
    # devise_mail(record, :reset_password_instructions, opts)
    DeviseMailer.reset_password_instructions(record, token).deliver
  end

  def confirmation_instructions(record, token, opts={})
    # @token = token
    # devise_mail(record, :confirmation_instructions, opts)
    DeviseMailer.confirmation_instructions(record, token).deliver
  end
end
