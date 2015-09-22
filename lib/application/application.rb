module SEOTool
  class Application < Sinatra::Base
    # Configuration
    set :public_folder, lambda { SEOTool.root_path.join('public').to_s }
    set :views, lambda { SEOTool.root_path.join('views').to_s }

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
  end
end
