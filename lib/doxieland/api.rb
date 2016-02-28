module Doxieland
  class Api < Apidiesel::Api
    use Handlers::JSON

    config :timeout, 4000
    config :username, 'doxie'
    config :password, nil

    register_actions
  end
end