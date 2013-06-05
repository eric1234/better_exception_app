class BetterExceptionApp::StaticErrorPageGenerator < Rails::Generators::NamedBase

  desc "Generate a static error page based on the layout."

  def generate_page
    # To avoid reading the existing static files.
    BetterExceptionApp::HttpError.error_files_paths.replace []
    Rails.configuration.middleware.delete Rack::File

    status = if file_name =~ /^\d{3}$/
      file_name
    else
      Rack::Utils::SYMBOL_TO_STATUS_CODE[file_name.to_sym]
    end

    request = Rack::MockRequest.env_for "/#{status}"
    request['action_dispatch.exception'] = StandardError.new 'generator'
    status, headers, response = *BetterExceptionApp::Engine.call(request)
    create_file "public/errors/#{file_name}.html", response.body
  end

end
