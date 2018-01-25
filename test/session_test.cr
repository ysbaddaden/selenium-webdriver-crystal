require "./test_helper"

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
      session.screenshot
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
    input.send_keys("Client")
    sleep 1

    types = types_list.find_elements(:css, "li:not([class~='hide'])")
    refute_equal count, types.size
  end
end
