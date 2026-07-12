require "capybara/rspec"
require "selenium/webdriver"

Capybara.register_driver :headless_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    binary: ENV.fetch("CHROME_BIN", "/usr/bin/chromium")
  )
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :headless_chromium
  end
end
