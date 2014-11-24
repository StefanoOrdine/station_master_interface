module Services
  module Base
    def call(*args)
      new(*args).call!
    end
  end
end

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/services")
Dir.glob("#{File.dirname(__FILE__)}/services/*.rb") { |service|
  require File.basename(service, '.*')
}