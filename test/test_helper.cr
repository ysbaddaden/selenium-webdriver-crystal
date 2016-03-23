require "uri"
require "minitest/autorun"
require "../src/selenium"

class Minitest::Test
  def driver
    self.class.driver
  end

  def self.driver
    @@driver ||= begin
      uri = URI.parse(ENV.fetch("SELENIUM_URL", "http://localhost:4444"))
      Selenium::Webdriver.new(uri.host.not_nil!, uri.port || 4444)
    end
  end

  def session
    self.class.session
  end

  def self.session
    @@session ||= begin
      session = driver.create_session({
        browserName: ENV.fetch("BROWSER_NAME", "firefox"),
        platform: "ANY",
      })
      session.url = "about:blank"
      Minitest.after_run { session.stop }
      session
    end
  end
end
