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
      key: "rack.session.3rd",
      memcache_server: "localhost:11211",
      expire_after: 3600

  set :root, File.dirname(__FILE__)
  set :public, Proc.new { File.join(root, "public") }
  set :oauth_client, OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, { :site => 'http://localhost:9292', :token_url => '/oauth/access_token' })

  helpers do

  end

  get '/' do
    <<-_HTML_
<h3>App info => id: #{CLIENT_ID}, name: #{MY_DISP_NAME}</h3>
<a href="/get/me" target="_blank">Get me</a><br />
    _HTML_
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  get '/get/me' do
    redirect_uri = "http://localhost:#{APP_PORT}/oauth/callback"
    redirect settings.oauth_client.auth_code.authorize_url(:redirect_uri => redirect_uri)
  end

  get '/oauth/callback' do
    if params[:error]
      params[:error]
    elsif params[:code]
      obj_access_token = settings.oauth_client.auth_code.get_token(params[:code],
        { :redirect_uri => "http://localhost:#{APP_PORT}/oauth/callback", :parse => :json }, { :header_format => "OAuth %s" }
      )

      puts obj_access_token.token
      obj_access_token.get("/u/name").body
    end
  end

end

__END__
      #args = { :site => 'http://localhost:9292', :token_url => '/oauth/access_token' }
      #client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, args)

      # {"access_token"=>"fc7700506ad12cbb5cbe6529e3ad37e500e0c2a4611e7ba41e1ff87141aac5ea", "scope"=>""}
      # 1. auth_code => get_token(code, params={}, opts={})
      # 2. client => get_token(params, opts)  opts => access_token_options
      # 3. AccessToken.from_hash(self, response.parsed.merge(access_token_opts))
