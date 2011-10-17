# encoding: utf-8
require_relative "init"

class App < Sinatra::Base
  if development?
    reset!
    use Rack::Reloader, 0
    #use Rack::Logger
  end

  set :sessions, true
  set :show_exceptions, true
  use Rack::Session::Memcache,
      key: "rack.session.application.#{ENV.fetch("RACK_ENV")}",
      memcache_server: "localhost:11211",
      expire_after: 3600

  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }
  set :oauth_client, OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, { :site => 'http://localhost:9292', :token_url => '/oauth/access_token' })

  helpers do
    def current_user
      if session[:user_id]
        User.get(session[:user_id])
      else
        false
      end
    end

    def logged_in?
      !!current_user
    end

    # TODO refactor this method should be within a gem or module
    # before call, register a Sinatra extension
    def user_authorized?
      unless logged_in?
        redirect '/'
        return
      end

      app_connection = current_user.app_connections.first(user_id: current_user.id, client_id: CLIENT_ID)
      access_token = OAuth2::AccessToken.new(settings.oauth_client, app_connection.access_token, { :header_format => "OAuth %s" })
      access_token.get("/user/authorized").body == "true"
    end

  end

  get '/' do
    str = <<-_HTML_
<h3>App info => id: #{CLIENT_ID}, name: #{MY_DISP_NAME}</h3>
<h5>User logged in?: #{logged_in? ? "yes" : "no"}</h5><br />
<a href="/documents" >my documents resources</a><br />
    _HTML_
    if logged_in?
      str << "<a href=/logout>Logout</a>"
    else
str << <<-_FORM
<label>Login</label>
<form action="http://localhost:9292/u/auth" method="post" target="_blank">
<label>mail:</label><input type="text" name="login" />
<label>password:</label><input type="password" name="password" />
<button>Login</button>
</form>
      _FORM
    end
    str
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  get "/documents" do
    if user_authorized?
      documents = current_user.documents
      documents.collect do |document|
        "<li>#{document.name}, belongs to user: #{document.user.name}</li>"
      end.join("\n")
    else
      "un authorized!"
    end
  end



end