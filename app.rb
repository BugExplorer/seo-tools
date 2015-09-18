class App < Sinatra::Base
  set :public_folder, 'public'
  set :show_exceptions, :after_handler

  get "/" do
    @reports = ReportsHandler.new('./public/reports/').generate
    slim :index
  end

  post "/report" do
    @report = Report.new(params[:url]).generate
    redirect "/"
  end

  error do
    'Something get wrong'
  end
end
