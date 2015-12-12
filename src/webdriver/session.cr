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

    getter :driver, :id, :capabilities

    def initialize(@driver : Webdriver, @desired_capabilities, @required_capabilities)
    end

    def start
      body = {} of String => Hash(String | Symbol, JSON::Type)

      if caps = @desired_capabilities
        body["desiredCapabilities"] = caps
      end
      if caps = @required_capabilities
        body["requiredCapabilities"] = caps
      end

      response = driver.post("/session", body)
      @id = response["sessionId"] as String
      @capabilities = response["value"] as Hash
      self
    end

    def stop
      delete
    end

    def timeouts=(script = nil : Int, implicit = nil : Int, page_load = nil : Int)
      body = {} of Symbol => String | Nil
      body[:script] = script if script
      body[:implicit] = implicit if implicit
      body[:page_load] = page_load if page_load
      post("/timeouts", body)
    end

    def url
      get("/url") as String
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

    #def screenshot
    #  # TODO: decode Base64
    #  post("/screenshot")
    #end

    def find_element(by, selector, parent = nil : WebElement)
      url = parent ? "/element/#{ parent.id }/element" : "/element"
      value = post(url, {
        using: WebElement.locator_for(by),
        value: selector
      })
      WebElement.new(self, value as Hash)
    end

    def find_elements(by, selector, parent = nil : WebElement)
      url = parent ? "/element/#{ parent.id }/elements" : "/elements"
      value = post(url, {
        using: WebElement.locator_for(by),
        value: selector
      }) as Array
      value.map { |item| WebElement.new(self, item as Hash) }
    end

    def active_element
      value = post("/element/active")
      WebElement.new(self, value as Hash)
    end

    def orientation
      get("/orientation") as String
    end

    def orientation=(value)
      raise ArgumentError.new unless %i(portrait landscape).includes?(value)
      post("/orientation", { orientation: value.to_s.upcase })
    end

    def alert
      @alert ||= Alert.new(self)
    end

    def move_to(x, y, element = nil : WebElement)
      body = {} of String => Int | Float | WebElement | Nil
      body["xoffset"] = x
      body["yoffset"] = y
      body["element"] = element if element
      post("/moveto", body)
    end

    def click(button = MouseButton::LEFT : MouseButton)
      post("/click", { button: button.value })
    end

    def double_click(button = MouseButton::Left : MouseButton)
      post("/doubleclick", { button: button.value })
    end

    def button_down(button = MouseButton::Left : MouseButton)
      post("/buttondown", { button: button.value })
    end

    def button_up(button = MouseButton::Left : MouseButton)
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
