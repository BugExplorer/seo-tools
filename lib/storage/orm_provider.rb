module Storage
  class ORMProvider < StorageProvider
    def get_all_reports
      _reports = []
      _result = Report.all

      # Gets all reports to show on the index page
      _result.each do |row|
        _reports << {
          # Site url
          url: row.url,
          # Creation time
          time: Time.at(row.time.to_i).strftime("%e %B %Y %k:%M"),
          # Id in the data base
          guid: row.id.to_i
        }
      end

      _reports.sort_by{ |hsh| hsh[:time] }.reverse
    end


    def save_report(report)
      _url     = report.url
      _ip      = report.ip
      _time    = Time.now.to_i
      _links   = report.links
      _headers = report.headers

      _report = Report.create(url:         _url,
                              ip:          _ip,
                              time:        _time,
                              links_count: _links.size)

      _headers.each do |key, value|
        _report.headers.create(name: key, text: value)
      end

      _links.each do |_link|
        _report.links.create(href:    _link[0],
                             content: _link[1],
                             rel:     _link[2].nil? ? 'None'  : _link[2],
                             target:  _link[3].nil? ? '_self' : _link[3])
      end
    end

    def select_report(id)
      _report = Report.get(id)
      _url     = _report.url
      _ip      = _report.ip
      _time    = _report.time

      _links = _report.links

      _headers_report = _report.headers
      _headers = {}

      # Create headers hash from the db data
      for row in _headers_report do
        _headers[row.name] = row.text
      end

      # Load up data in one object
      _report = ::SEOTool::Report.new(url: _url,
                                      ip: _ip,
                                      time: _time,
                                      links: _links,
                                      headers: _headers)

      # Use this object variables in the slim
      render_view _report
    end

    private
      def render_view(report)
        super
      end
  end
end

