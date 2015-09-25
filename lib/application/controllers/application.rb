module SEOTool
  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        throw(:warden, message: "The username you entered does not exist.")
      elsif user.password == params['user']['password']
        puts "ok!"
        success!(user)
      else
        throw(:warden, message: "The username and password combination ")
      end
    end
  end

  class Application < Sinatra::Base
    # Configuration
    enable :sessions
    set :session_secret, "supersecret"
    set :public_folder, lambda { SEOTool.root_path.join('public').to_s }
    set :views, lambda { SEOTool.root_path.join('views').to_s }

    use Warden::Manager do |config|
      config.serialize_into_session{ |user| user.id }
      config.serialize_from_session{ |id| User.get(id) }

      config.scope_defaults :default,
        strategies: [:password],
        action: 'login/unauthenticated'
      config.failure_app = self
    end

    Warden::Manager.before_failure do |env,opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    before do
      @reports_controller = ReportsController.new
      @storage_provider = @reports_controller.storage_provider
    end

    get '/' do
      @reports = @storage_provider.get_all_reports
      slim :index
    end

    get '/report/:guid' do
      @storage_provider.select_report params[:guid]
    end

    post '/report' do
      @reports_controller.generate params[:url]
      redirect '/'
    end

    get '/login/?' do
      slim :login
    end

    post '/login/?' do
      env['warden'].authenticate!
      redirect '/'
    end

    post '/logout' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      redirect '/'
    end

    helpers do
      def gravatar_for(user, options = { size: 80 })
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
        "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      end

      def current_user
        env['warden'].user
      end

    end
  end
end
