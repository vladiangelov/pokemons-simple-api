##
# Configuring rack-attack gem for mallicious requests and behaviour
#
class Rack::Attack
  # Allow requests from test and development
  safelist('allow for test and dev env') do |_req|
    ENV['RAILS_ENV'] == 'test' || ENV['RAILS_ENV'] == 'development'
  end

  # rubocop:disable Style/SymbolProc
  throttle("requests by ip", limit: 60, period: 1.minute) do |request|
    request.ip
  end
  # rubocop:enable Style/SymbolProc
end
