class DeviseMailer < MandrillMailer::TemplateMailer
  include Rails.application.routes.url_helpers
  default from: 'donotreply@fresh-records.com'
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def reset_password_instructions(user, token)
    mandrill_mail(
      template: 'default',
      subject: "Password Recovery",
      to: user.email,
        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: true,
      template_content: {'main' => "<p>Hello #{user.email}!</p>
        <p>Someone has requested a link to change your password. You can do this through the link below.</p>
        <p><a href=\"#{edit_password_url(user, reset_password_token: token)}\">Change my password</a></p>
        <p>If you didn't request this, please ignore this email.</p>
        <p>Your password won't change until you access the link above and create a new one.</p>"}
     )
  end

  def confirmation_instructions(user, token)
    mandrill_mail(
      template: 'default',
      subject: "Welcome to Fresh Records",
      to: user.email,
        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: true,
      template_content: {'main' => "<p>Welcome #{user.email}!</p>
        <p>You can confirm your account email through the link below:</p>
        <p><a href=\"#{confirmation_url(user, confirmation_token: token)}\">Confirm my account</a></p>"}
     )
  end

  def main_app
    Rails.application.class.routes.url_helpers
  end

  test_setup_for :reset_password_instructions do |mailer, options|
    user = User.new(email: options[:email],
                    username: 'foobar',
                    reset_password_token: rand(900000..1000000) )

    mailer.reset_password_instructions(user, token).deliver
  end

end
