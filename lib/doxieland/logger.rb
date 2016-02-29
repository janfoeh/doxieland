module Doxieland
  class Logger

    LOGLEVELS = {
      debug: :white,
      info: :white,
      success: :green,
      warn: :red,
      error: :red,
      fatal: :red
    }

    def initialize(loglevel)
      @loglevel = loglevel
    end

    LOGLEVELS.each do |loglevel|
      define_method(loglevel.first) do |message|
        log(message, loglevel.first) if log?(loglevel.first)
      end

      define_method('progress_' + loglevel.first.to_s) do |message, progressbar|
        log_progress(message, loglevel.first, progressbar) if log?(loglevel.first)
      end
    end

      protected

    def log?(level)
      LOGLEVELS.keys.index(level) >= LOGLEVELS.keys.index(@loglevel)
    end

    def log(message, level)
      color = LOGLEVELS[level]
      prefix = level == :success ? '[INFO]' : "[#{level.to_s.upcase}]"

      puts prefix + " " + Rainbow(message).color(color)
    end

    def log_progress(message, level, progressbar)
      color = LOGLEVELS[level]
      prefix = level == :success ? '[INFO]' : "[#{level.to_s.upcase}]"

      progressbar.log prefix + " " + Rainbow(message).color(color)
    end
  end
end