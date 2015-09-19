class App < Sinatra::Base
  set :public_folder, 'public'
  set :show_exceptions, false

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

  not_found do
    status 404
    slim :error
  end

  error do
    slim :error
  end
end
