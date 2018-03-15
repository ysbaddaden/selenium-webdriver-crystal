require "./test_helper"
require "uuid"

class SessionTest < Minitest::Test
  def test_navigation
    session.url = "https://crystal-lang.org"
    assert_equal "https://crystal-lang.org/", session.url

    nav = session.find_element(:css, "nav[role=navigation]")

    links = nav.find_elements(:tag_name, "a").map(&.text)
    assert_includes links, "Blog"
    assert_includes links, "GitHub"
    assert_includes links, "Docs"
    assert_includes links, "API"

    session.execute <<-JAVASCRIPT
    Array.from(document.querySelectorAll("nav .menu a"))
      .forEach(function (a) { a.removeAttribute("target"); })
    JAVASCRIPT

    assert_raises(Selenium::NoSuchElement) do
      nav.find_element(:css, "a[href='/some/unknown/link']")
    end

    nav.find_element(:css, "a[href='/blog/']").click
    assert_match "https://crystal-lang.org/blog/", session.url

    session.back
    assert_equal "https://crystal-lang.org/", session.url

    session.forward
    assert_match "https://crystal-lang.org/blog/", session.url

    assert do
      session.save_screenshot("webdriver-screenshot.png")
    end
  end

  def test_input
    session.url = "https://crystal-lang.org/api"
    types_list = session.find_element(:id, "types-list")

    types = types_list.find_elements(:css, "li:not([class~='hide'])")
    count = types.size

    input = session.find_element(:css, "input[type='search']")

    input.send_keys("Cleint.., ups wrong...")
    sleep 1

    input.clear
    sleep 500.milliseconds

    input.send_keys("Client")
    sleep 1

    types = types_list.find_elements(:css, "li:not([class~='hide'])")
    refute_equal count, types.size
  end

  def test_cookies
    session.url = "https://crystal-lang.org/api"
    assert_empty session.cookies.to_a

    session_id = UUID.random.to_s
    session.cookies.set("selenium_session_id", session_id)
    session.cookies.set("selenium_username", "julien", domain: "crystal-lang.org")
    assert_raises(Selenium::InvalidCookieDomain) do
      session.cookies.set("selenium_username", "mathias", domain: "www.crystal-lang.org")
    end

    cookies = session.cookies.to_a
    assert_equal 2, cookies.size

    values = {} of String => String
    session.cookies.each { |cookie| values[cookie.name] = cookie.value }
    assert_equal session_id, values["selenium_session_id"]
    assert_equal "julien", values["selenium_username"]

    assert_equal "julien", session.cookies.get("selenium_username").value

    session.cookies.delete("selenium_username")
    assert_raises(Selenium::Error) { session.cookies.get("selenium_username") }
    assert_equal session_id, session.cookies.get("selenium_session_id").value

    session.cookies.clear
    assert_empty session.cookies.to_a
  end
end
