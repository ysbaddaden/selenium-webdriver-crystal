require "./src/selenium"

driver = Selenium::Webdriver.new

session = driver.create_session({
  browserName: ENV.fetch("BROWSER_NAME", "firefox"),
  platform: "ANY"
})

begin
  pp session.id
  pp session.capabilities

  # LOAD
  session.url = "http://crystal-lang.org"
  pp session.url

  nav = session.find_element(:css, "nav .menu")
  links = nav.find_elements(:tag_name, "a")
  puts links.map(&.text)

  # NAVIGATION
  session.execute <<-JAVASCRIPT
  Array.from(document.querySelectorAll("nav .menu a"))
    .forEach(function (a) { a.removeAttribute("target"); })
  JAVASCRIPT

  nav.find_element(:css, "a[title='API']").click
  pp session.url

  session.back
  pp session.url

  session.forward
  pp session.url

  # SEARCH FOR A TYPE
  types_list = session.find_element(:id, "types-list")

  types = types_list.find_elements(:css, "li:not([class~='hide'])")
  pp types.size

  input = session.find_element(:css, "input[type='search']")
  input.send_keys("Client")
  sleep 1

  types = types_list.find_elements(:css, "li:not([class~='hide'])")
  pp types.size
ensure
  session.stop
end
