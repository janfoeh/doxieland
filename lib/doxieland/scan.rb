module Doxieland
  class Scan
    attr_accessor :file, :tempfile, :image_number, :file_type

    DEFAULT_NAME_FORMAT = "doxie_scan_%{date}-%{number}"

    class << self
      attr_accessor :save_path, :name_format

      def name_format
        @name_format ||= DEFAULT_NAME_FORMAT
      end

      def from_api(content, image_number)
        scan = new

        scan.image_number = image_number

        scan.tempfile = Tempfile.new(['doxie_scan', '.jpg'])
        scan.tempfile.binmode
        scan.tempfile.write(content)
        scan.tempfile.rewind

        scan
      end
    end

    def path
      self.class.save_path + Pathname.new(get_formatted_name)
    end

    def file_type
      @file_type || 'jpg'
    end

    def save(overwrite: false)
      if File.file?(path) && !overwrite
        return false
      end

      case file_type
      when 'jpg'
        @file = File.open(path, 'wb') { |f| f.write(@tempfile.read) }
      when 'pdf'
        run_command("convert #{@tempfile.path} #{path}")
        @file = File.open(path, 'r')
      end

      @tempfile.close
      @tempfile.unlink
      @tempfile = nil

      @file
    end

      protected

    def get_formatted_name
      format_string, formats =
        extract_formats_from_placeholders

      substitutions = {
        number: @image_number,
        date:   Date.today.strftime(formats[:date]),
        time:   Time.now.strftime(formats[:date])
      }

      format_string % substitutions + '.' + file_type
    end

    def extract_formats_from_placeholders
      formats = {
        date: "%d.%m.%Y",
        time: "%H:%M:%S"
      }

      format_string = self.class.name_format.gsub(/(?<=%{).*?(?=})/) do |placeholder|
        if placeholder.include?(':')
          placeholder, type_format_string = placeholder.split(':', 2)

          formats[placeholder.to_sym] = type_format_string.strip
        end

        placeholder
      end

      return format_string, formats
    end

    def run_command(command)
      stdout, stderr, exitstatus = Open3.capture3(command)

      unless exitstatus == 0
        raise "command #{command} failed: #{stderr}"
      end

      stdout
    end

  end
end