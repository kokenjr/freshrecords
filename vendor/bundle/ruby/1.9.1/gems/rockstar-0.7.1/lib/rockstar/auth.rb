module Rockstar

  # = Authentification
  #
  # There are 2 ways to get an auth token :
  #
  # == Desktop-App
  # 1. Get a new token to request authorisation:
  #     token = Rockstar::Auth.new.token
  # 2. Open a webbrowser with http://www.last.fm/api/auth/?api_key=xxxxxxxxxxx&token=xxxxxxxx
  # 3. Wait for the User to confirm that he accepted your request.
  # 4. Continue with "Get the session token"
  #
  # == Web-App
  # 1. Redirect the user to http://www.last.fm/api/auth/?api_key={YOUR_API_KEY}&amp;cb={YOUR_RETURN_URL}
  # 2. If the user accepts, lastfm will redirect to YOUR_RETURN_URL?token=TOKEN
  #     token = params[:token]
  # 3. Continue with "Get the session token"
  #
  # == Get the session token
  # 1. Use the previous token and call
  #     session = Rockstar::Auth.new.session(token)
  # 2. Store the session.key and session.username returned. The session.key will not
  #    expire. It is save to store it into your database.
  class Auth < Base

    def session(token)
      doc = self.class.fetch_and_parse("auth.getSession", {:token => token}, true)
      Rockstar::Session.new_from_xml(doc)
    end

    def token
      doc = self.class.fetch_and_parse("auth.getToken", {}, true)
      token = (doc).at(:token).inner_html if (doc).at(:token)
      token
    end
  end
end
