Airbrake.configure do |config|
  config.host = (ENV['AIRBRAKE_HOST'] or 'airbrake.io')
  config.project_id = (ENV['AIRBRAKE_PROJECT_ID'] or 1)
  config.project_key = (ENV['AIRBRAKE_PROJECT_KEY'] or ENV['AIRBRAKE_API_KEY'] or 'project_key')
  config.environment = Padrino.env
end

Airbrake.add_filter do |notice|
  notice.ignore! if notice[:errors].any? { |error| %w[Sinatra::NotFound SignalException].include?(error[:type]) }
  notice.ignore! if notice[:errors].any? { |error| error[:type] == 'ArgumentError' && error[:message] && error[:message].include?('invalid %-encoding') }
  notice.ignore! if notice[:errors].any? { |error| error[:type] == 'ThreadError' && error[:message] && error[:message].include?("can't be called from trap context") }
  notice.ignore! if notice[:errors].any? { |error| error[:type] == 'Mongoid::Errors::Validations' && error[:message] && error[:message].include?('Ticket type is full') }
end
