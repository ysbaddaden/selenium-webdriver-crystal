module Selenium
  class Session
    class Window
      struct Rect
        JSON.mapping(
          height: Int64,
          width: Int64,
          x: Int64,
          y: Int64
        )
      end

      def initialize(@session : Session)
      end

      def rect : Rect
        Rect.from_json(@session.get("/window/rect").to_json)
      end

      def rect=(val)
        @session.post("/window/rect", val)
      end

      def resize_to(width, height)
        self.rect = {
          width: width,
          height: height,
        }
      end
    end
  end
end
