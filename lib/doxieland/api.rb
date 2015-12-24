module Doxieland
  class Api < Apidiesel::Api
    use Handlers::JSON

    config :timeout, 4000

    register_actions
  end
end