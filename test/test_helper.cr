require "uri"
require "minitest/autorun"
require "../src/selenium"

class Minitest::Test
  def self.driver
    @@driver ||= begin
      uri = URI.parse(ENV.fetch("SELENIUM_URL", "http://localhost:4444"))
      Selenium::Webdriver.new(uri.host.not_nil!, uri.port || 4444)
    end
  end

  def self.session
    @@session ||= begin
      capabilities = {
        "browserName" => ENV.fetch("BROWSER_NAME", "firefox"),
        "platform" => "ANY",
      }
      Selenium::Session.new(driver, capabilities, url: "about:blank")
    end
  end

  def self.session?
    !!@@session
  end

  def driver
    Minitest::Test.driver
  end

  def session
    Minitest::Test.session
  end
end

Minitest.after_run { Minitest::Test.session.stop }
