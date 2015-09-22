module Storage
  class FilesProvider < StorageProvider

    def initialize
      FileUtils.mkdir_p('./public/reports/') unless File
        .directory?('./public/reports/')
    end

    def get_all_reports
      _files = Dir.entries('./public/reports/').delete_if { |x| !(x =~ /html/) }
      unless _files.empty?
        _reports = []

        _files.each do |file|
          _reports << {
            # Site url
            url: file.gsub(/_.+/, ''),
            # Creation time
            time: Time.at(file.gsub(/.+_/, '').to_i).strftime("%e %B %Y %k:%M"),
            guid: file.to_s
          }
        end

        _reports.sort_by{ |hsh| hsh[:time] }.reverse
      end
    end

    def save_report(report)
      File.open("./public/reports/#{report.url}_#{report.time}.html", 'w') do |f|
        f.write render_view(report)
      end
    end

    def select_report(guid)
      File.open("./public/reports/#{guid}", 'r')
    end

    private
      def render_view(report)
        super
      end
  end
end
