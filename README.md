# Selenium::Webdriver

Selenium Webdriver bindings for the Crystal programming language.

WARNING: this implements the now obsolete
[JsonWireProtocol](https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol)
the [W3C Webdriver spec](https://w3c.github.io/webdriver/webdriver-spec.html).
Your selenium and browser mileages may not be supported until the new protocol
is implemented.

Latest known working combination is Selenium 2.48.2 and Firefox 34. A
combination known to NOT WORK is Selenium 3.5.3, Firefox 55 and the now required
Geckodriver 0.18.0.


## Usage

Only the Remote driver is available, so you need to download the release
[Selenium Standalone Server](http://docs.seleniumhq.org/download/) then start
it (adjust the version):

```
$ java -jar selenium-server-standalone-2.48.2.jar
```

You may now start a session, which will launch a browser, and start interacting
with it:

```crystal
require "selenium/webdriver"

capabilities = {
  browserName: "firefox",
  platform: "ANY"
}
driver = Selenium::Webdriver.new
session = Selenium::Session.new(driver, capabilities)

session.url = "http://crystal-lang.org/api"
pp session.url # => "http://crystal-lang.org/api"

input = session.find_element(:css, "input[type=search]")
input.send_keys("Client")
sleep 1

types_list = session.find_element(:id, "types-list")
types = types_list.find_elements(:css, "li:not([class~='hide'])")
pp count = types.size # => 5

session.stop
```


## Reference

Webdriver JSON API: <https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol>


## License

Distributed under the [Apache License, Version 2.0](https://opensource.org/licenses/Apache-2.0)


## Author

- Julien Portalier — @ysbaddaden
