module Selenium
  class WebElement
    LOCATORS = {
      id: "id",
      name: "name",
      tag_name: "tag name",
      class_name: "class name",
      css: "css selector",
      link_text: "link text",
      partial_link_test: "partial link text",
      xpath: "xpath",
    }

    def self.locator_for(by)
      locator = LOCATORS[by]
      raise ArgumentError.new("Unsupported locator strategy: #{ by.inspect }") unless locator
      locator
    end

    # TODO: special keys
    #KEYS = {
    #  NULL  U+E000
    #  Cancel  U+E001
    #  Help  U+E002
    #  Back space  U+E003
    #  Tab   U+E004
    #  Clear   U+E005
    #  Return   U+E006
    #  Enter  U+E007
    #  Shift   U+E008
    #  Control   U+E009
    #  Alt   U+E00A
    #  Pause   U+E00B
    #  Escape  U+E00C

    #  Space   U+E00D
    #  Pageup  U+E00E
    #  Pagedown  U+E00F
    #  End   U+E010
    #  Home  U+E011
    #  Left arrow  U+E012
    #  Up arrow  U+E013
    #  Right arrow   U+E014
    #  Down arrow  U+E015
    #  Insert  U+E016
    #  Delete  U+E017
    #  Semicolon   U+E018
    #  Equals  U+E019

    #  Numpad 0  U+E01A
    #  Numpad 1  U+E01B
    #  Numpad 2  U+E01C
    #  Numpad 3  U+E01D
    #  Numpad 4  U+E01E
    #  Numpad 5  U+E01F
    #  Numpad 6  U+E020
    #  Numpad 7  U+E021
    #  Numpad 8  U+E022
    #  Numpad 9  U+E023
    #}

    getter id : String
    private getter session : Session

    def initialize(@session, item)
      if id = item["ELEMENT"]?
        # JsonWireProtocol (obsolete)
        @id = id.as(String)
      else
        # W3C Webdriver
        identifier = item.keys.find(&.starts_with?("element-"))
        @id = item[identifier].as(String)
      end
    end

    def find_element(by, selector)
      session.find_element(by, selector, self)
    end

    def find_elements(by, selector)
      session.find_elements(by, selector, self)
    end

    def text
      get("/text").as(String)
    end

    def name
      get("/name").as(String)
    end

    def attribute(name)
      get("/attribute/#{ name }").as(String)
    end

    def click
      post("/click")
    end

    def submit
      post("/submit")
    end

    def send_keys(sequence : String)
      send_keys [sequence]
    end

    def send_keys(sequence : Array)
      post("/value", { value: sequence })
    end

    def ==(other : WebElement)
      get("/equals/#{ other.id }").as(Bool)
    end

    def displayed?
      get("/displayed").as(Bool)
    end

    def location
      get("/location").as(Hash)
    end

    def location_in_view
      get("/location_in_view").as(Hash)
    end

    def size
      get("/size").as(Hash)
    end

    def css(property)
      get("/css/#{ property }").as(String)
    end

    def to_json(io)
      { "ELEMENT" => id }.to_json(io)
    end

    protected def get(path)
      session.get("/element/#{ id }#{ path }")
    end

    protected def post(path, body = nil)
      session.post("/element/#{ id }#{ path }", body)
    end
  end
end
