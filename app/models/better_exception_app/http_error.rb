class BetterExceptionApp::HttpError
  STATUS_CODE_TO_SYMBOL = Rack::Utils::SYMBOL_TO_STATUS_CODE.invert

  # Paths we should check for static error files
  cattr_reader :error_files_paths
  @@error_files_paths = []

  attr_reader :status, :exception

  def initialize status, exception
    @status = status.to_i
    @exception = exception
  end

  # Returns the symbol of the current status.
  # This would be :not_found for 404.
  def symbol
    STATUS_CODE_TO_SYMBOL[status]
  end

  # Can the error code and exception be deliver as a data structure
  # in the format the user requested?
  def formattable? format
    Hash.instance_methods.collect(&:to_sym).include? to_format(format)
  end

  # Will provide the status an exception message as formatted data
  # in the format the user requested.
  def formatted format
    {:status => status, :error => exception.message}.send to_format(format)
  end

  # A template in the configured error_files_paths that will satisify
  # the current symbol.
  def template
    @template ||= possible_templates.find {|t| File.exists? "#{t}.html"}
  end

  # The end-user understandable description configured by the locale
  # files. Apps can easily override these to make them more relevant
  # to their specific use case if needed. If description is not defined
  # in locale file then nil is returned.
  def description
    return @description if defined? @description
    @description = I18n.t "http.status.description.#{symbol}"
    @description = nil if @description =~ /translation missing/
    @description
  end

  private

  def to_format format
    "to_#{format.to_sym}".to_sym
  end

  def possible_templates
    self.class.error_files_paths.collect do |path|
      [
        "#{symbol}.#{I18n.locale}",
        symbol,
        "#{status}.#{I18n.locale}",
        status,
      ].collect {|file| "#{path}/#{file}"}
    end.flatten
  end

end
