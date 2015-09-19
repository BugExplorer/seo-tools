class App < Sinatra::Base
  set :public_folder, 'public'
  set :show_exceptions, :after_handler

  before do
    FileUtils.mkdir_p("./public/reports/") unless File
      .directory?("./public/reports/")
  end

  get "/" do
    @reports = ReportsHandler.new('./public/reports/').create
    slim :index
  end

  post "/report" do
    @report = Report.new(params[:url])
    @report.generate
    redirect "/"
  end

  error do
    'Something get wrong'
  end
end
