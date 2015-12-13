require "uri"
require "minitest/autorun"
require "../src/selenium"

begin
  uri = URI.parse(ENV.fetch("SELENIUM_URL", "http://localhost:4444"))
  $driver = Selenium::Webdriver.new(uri.host.not_nil!, uri.port || 4444)

  $session = $driver.create_session({
    browserName: ENV.fetch("BROWSER_NAME", "firefox"),
    platform: "ANY",
  })
  $session.url = "about:blank"
end

class Minitest::Test
  def driver
    $driver
  end

  def session
    $session
  end
end

Minitest.after_run { $session.stop }
