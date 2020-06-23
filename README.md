# Selenium::Webdriver

Selenium Webdriver bindings for the Crystal programming language.

WARNING: this shard initialy implemented the now obsolete
[JsonWireProtocol](https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol),
but should be compatible with the
[W3C Webdriver](https://w3c.github.io/webdriver/webdriver-spec.html) spec.

Known working combinations are Selenium 2.48.2 and Firefox 34 (JSONWireProtocol),
as well as Selenium 3.5.3, Firefox 55 and the now required Geckodriver 0.18.0
(W3C Webdriver).

See https://github.com/matthewmcgarvey/selenium.cr for an up-to-date library (as
of June 2020) that implements the W3C Webdriver spec directly.

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

search_list = session.find_element(:class_name, "search-list")
types = search_list.find_elements(:css, "li.search-result--type")
pp count = types.size # => 6

session.stop
```


## Reference

- [JSON Wire Protocol](https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol)
- [W3C Webdriver](https://w3c.github.io/webdriver/webdriver-spec.html)


## License

Distributed under the [Apache License, Version 2.0](https://opensource.org/licenses/Apache-2.0)


## Author

- Julien Portalier — @ysbaddaden
