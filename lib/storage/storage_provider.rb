module Storage
  class StorageProvider

    def get_all_reports; end
    def save_report; end
    def select_report; end

    def render_view(report)
      # Create new template object with the layout
      _l = File.open('./views/layout.slim', 'rb').read
      _layout = Slim::Template.new { _l }
      _r = File.open('./views/report.slim', 'rb').read
      _content = Slim::Template.new { _r }.render(report)

      _layout.render { _content }
    end

  end
end
