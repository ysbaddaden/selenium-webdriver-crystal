# Selenium::Webdriver

Selenium Webdriver bindings for the Crystal programming language.


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
driver = Selenium::Webdriver.new

capabilities = {
  browserName: "firefox",
  platform: "ANY"
}
session = driver.create_session(capabilities)

session.url = "https://crystal-lang.org/api"
pp session.url # => "https://crystal-lang.org/api"

input = session.find_element("input[type=search]")
input.send_keys("Client")
```


## Reference

Webdriver JSON API: <https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol>


## License

Distributed under the [Apache License, Version 2.0](https://opensource.org/licenses/Apache-2.0)


## Author

- Julien Portalier — @ysbaddaden
