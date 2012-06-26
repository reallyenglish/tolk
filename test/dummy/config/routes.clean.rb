Dummy::Application.routes.draw do

  mount Tolk::Engine => '/tolk', :as => 'tolk'

end
