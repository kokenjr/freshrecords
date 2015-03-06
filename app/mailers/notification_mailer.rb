class NotificationMailer < MandrillMailer::TemplateMailer
  include Rails.application.routes.url_helpers
  default from: 'donotreply@fresh-records.com'

  def wish_list(user, record)

    mandrill_mail(
      template: 'default',
      subject: "#{record.name} Released",
      to: user.email,
        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: true,
      template_content: {'main' => "<p>The record, <b>#{record.name}</b>, in your wish list has released.<p><a href=\"#{wish_list_url(filterrific: {search_query: record.name})}\">Check it out</a></p>"}
     )
  end

  def artist_release(user, artist, record)
    mandrill_mail(
      template: 'default',
      subject: "New Release for #{artist.name}",
      to: user.email,
        # to: invitation.email,
        # to: { email: invitation.email, name: 'Honored Guest' },
      important: true,
      inline_css: true,
      template_content: {'main' => "<p>The artist you've been following, <b>#{artist.name}</b>, released a new record: <b>#{record.name}</b>.<p><a href=\"#{root_url(filterrific: {search_query: record.name })}\">Check it out</a></p>"}
     )
  end
end
