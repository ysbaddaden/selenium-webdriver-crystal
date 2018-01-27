require "./web_element"
require "./alert"

module Selenium
  class Session
    enum MouseButton
      LEFT
      MIDDLE
      RIGHT
    end

    # TODO: IME inputs
    # TODO: Windows (handles, size, position, ...)
    # TODO: Cookies
    # TODO: Touch Actions
    # TODO: Location (geo)
    # TODO: Storage (local, session)
    # TODO: Log

    getter driver : Webdriver
    getter! id : String
    getter! capabilities : Hash(String, JSON::Type)

    def initialize(@driver, desired_capabilities = Webdriver::CAPABILITIES, required_capabilities = Webdriver::CAPABILITIES, url = "about:blank")
      body = {
        "desiredCapabilities" => desired_capabilities,
        "requiredCapabilities" => required_capabilities,
      }
      response = driver.post("/session", body)

      @id = response["sessionId"].as(String)
      @capabilities = response["value"].as(Hash)

      if url
        self.url = url
      end
    end

    def stop
      delete
    end

    def timeouts(script : Int? = nil, implicit : Int? = nil, page_load : Int? = nil)
      body = {} of Symbol => Int32?
      body[:script] = script.to_i if script
      body[:implicit] = implicit.to_i if implicit
      body[:page_load] = page_load.to_i if page_load
      post("/timeouts", body)
    end

    def url
      get("/url").as(String)
    end

    def url=(url)
      post("/url", { url: url })
    end

    def forward
      post("/forward")
    end

    def back
      post("/back")
    end

    def refresh
      post("/refresh")
    end

    def title
      post("/title")
    end

    def source
      post("/source")
    end

    def execute(script, *args)
      post("/execute", { script: script, args: args })
    end

    def execute_async(script, *args)
      post("/execute", { script: script, args: args })
    end

    def frame(identifier)
      post("/frame", { id: identifier })
    end

    def parent_frame
      post("/frame/parent")
    end

    def screenshot
      data = get("/screenshot").as(String)
      Base64.decode(data)
    end

    def save_screenshot(path)
      data = get("/screenshot").as(String)
      File.open(path, "w") { |file| Base64.decode(data, file) }
    end

    def find_element(by, selector, parent : WebElement? = nil)
      url = parent ? "/element/#{ parent.id }/element" : "/element"
      value = post(url, {
        using: WebElement.locator_for(by),
        value: selector
      })
      WebElement.new(self, value.as(Hash))
    end

    def find_elements(by, selector, parent : WebElement? = nil)
      url = parent ? "/element/#{ parent.id }/elements" : "/elements"
      value = post(url, {
        using: WebElement.locator_for(by),
        value: selector
      }).as(Array)
      value.map { |item| WebElement.new(self, item.as(Hash)) }
    end

    def active_element
      value = post("/element/active")
      WebElement.new(self, value.as(Hash))
    end

    def orientation
      get("/orientation").as(String)
    end

    def orientation=(value)
      raise ArgumentError.new unless %i(portrait landscape).includes?(value)
      post("/orientation", { orientation: value.to_s.upcase })
    end

    def alert
      @alert ||= Alert.new(self)
    end

    def move_to(x, y, element : WebElement = nil)
      body = {} of String => Int | Float | WebElement | Nil
      body["xoffset"] = x
      body["yoffset"] = y
      body["element"] = element if element
      post("/moveto", body)
    end

    def click(button : MouseButton = MouseButton::LEFT)
      post("/click", { button: button.value })
    end

    def double_click(button : MouseButton = MouseButton::Left)
      post("/doubleclick", { button: button.value })
    end

    def button_down(button : MouseButton = MouseButton::Left)
      post("/buttondown", { button: button.value })
    end

    def button_up(button : MouseButton = MouseButton::Left)
      post("/buttonup", { button: button.value })
    end

    protected def get(path = "")
      body = driver.get("/session/#{ id }#{ path }")
      body["value"]
    end

    protected def post(path, body = nil)
      body = driver.post("/session/#{ id }#{ path }", body)
      body["value"]
    end

    protected def delete(path = "")
      driver.delete("/session/#{ id }#{ path }")
    end
  end
end
