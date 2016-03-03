require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.log_level = :error
end

at_exit { ChefSpec::Coverage.report! }
