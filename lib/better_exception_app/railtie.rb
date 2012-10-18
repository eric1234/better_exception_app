class BetterExceptionApp::Engine < Rails::Engine
  isolate_namespace BetterExceptionApp

  initializer 'better_exception.set_paths' do
    BetterExceptionApp::HttpError.error_files_paths <<
      "#{Rails.public_path}/errors" << Rails.public_path
  end

  initializer 'better_exception_app.install_app' do
    Rails.application.config.exceptions_app = BetterExceptionApp::Engine
  end

end if defined? Rails
