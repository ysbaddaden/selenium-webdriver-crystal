require "./test_helper"

class SessionTest < Minitest::Test
  def test_navigation
    session.url = "http://crystal-lang.org"
    assert_equal "http://crystal-lang.org/", session.url

    nav = session.find_element(:css, "nav .menu")

    links = nav.find_elements(:tag_name, "a")
    assert_equal ["GITHUB", "DOCS", "API"], links.map(&.text)

    session.execute <<-JAVASCRIPT
    Array.from(document.querySelectorAll("nav .menu a"))
      .forEach(function (a) { a.removeAttribute("target"); })
    JAVASCRIPT

    nav.find_element(:css, "a[title='API']").click
    assert_equal "http://crystal-lang.org/api/", session.url

    session.back
    assert_equal "http://crystal-lang.org/", session.url

    session.forward
    assert_equal "http://crystal-lang.org/api/", session.url
  end

  def test_input
    session.url = "http://crystal-lang.org/api"
    types_list = session.find_element(:id, "types-list")

    types = types_list.find_elements(:css, "li:not([class~='hide'])")
    count = types.size

    input = session.find_element(:css, "input[type='search']")
    input.send_keys("Client")
    sleep 1

    types = types_list.find_elements(:css, "li:not([class~='hide'])")
    refute_equal count, types.size
  end
end
