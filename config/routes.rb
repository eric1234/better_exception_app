Rails.application.routes.draw do
  scope :module => :better_exception_app do
    match ':status' => 'http_errors#show', :status => /\d{3}/,
      :via => :get, :as => :http_error
  end
end
