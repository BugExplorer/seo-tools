require 'pg'
require_relative '../application/classes/report_link'
require_relative '../application/classes/report'

module Storage
  class DataBaseProvider < StorageProvider
    def initialize
      db_params = {
        host: 'localhost',
        dbname: 'project',
        user: 'sinatra',
        password: 'sinatra'
      }
      @conn = PG::Connection.new(db_params)
    end

    def get_all_reports
      _reports = []
      _result = @conn.exec('SELECT id, url, time FROM reports')

      # Gets all reports to show on the index page
      _result.each do |row|
          _reports << {
            # Site url
            url: row['url'],
            # Creation time
            time: Time.at(row['time'].to_i).strftime("%e %B %Y %k:%M"),
            # Id in the data base
            guid: row['id'].to_i
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

      _id = @conn.exec("INSERT INTO reports (url, ip, time, links_count)
                        VALUES ('#{_url}', '#{_ip}', #{_time}, #{_links.size})
                        RETURNING id")
      _id = _id[0]["id"].to_i # Get report id for the next queries

      _headers.each do |key, value|
        @conn.exec("INSERT INTO headers (name, content, report_id)
                    VALUES ('#{key}', '#{value}', #{_id})")
      end

      _links.each do |_link|
        @conn.exec("INSERT INTO links (href, content, rel, target, report_id)
                    VALUES ('#{_link[0]}', '#{_link[1]}',
                    '#{_link[2]}', '#{_link[3]}', #{_id})")
      end
    end

    def select_report(id)
      _report = @conn.exec("SELECT * FROM reports WHERE id = #{id}")
      _url     = _report[0]['url']
      _ip      = _report[0]['ip']
      _time    = _report[0]['time']

      _links_count = _report[0]['links_count'].to_i
      _links = []

      _headers_report = @conn.exec "SELECT * FROM headers WHERE report_id = #{id}"
      _headers = {}

      # Create headers hash from the db data
      for row in _headers_report do
        _headers[row['name']] = row['content']
      end

      # Create Link objects array
      if _links_count > 0
        _links_arr = @conn.exec("SELECT href, content, rel, target
                                 FROM links WHERE report_id = #{id}")
        _links_count.times do |i|
          _links << ::SEOTool::ReportLink.new(_links_arr[i]['href'],
                                              _links_arr[i]['content'],
                                              _links_arr[i]['rel'],
                                              _links_arr[i]['target'])
        end
      end

      _report = ::SEOTool::Report.new(url: _url,
                                      ip: _ip,
                                      time: _time,
                                      links: _links,
                                      headers: _headers)

      render_view _report
    end

    private
      def render_view(report)
        super
      end
  end
end
