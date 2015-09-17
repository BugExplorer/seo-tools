class App < Sinatra::Base

  get "/" do
    slim :index
  end

  post "/report" do
    @report = Report.new(params[:url])
    
    View.new(@report.generate).create
   
    redirect "/"
  end
end
