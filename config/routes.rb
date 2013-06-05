BetterExceptionApp::Engine.routes.draw do
  scope :module => :better_exception_app do
    get ':status' => 'http_errors#show', :status => /\d{3}/, :as => :http_error
  end
end
