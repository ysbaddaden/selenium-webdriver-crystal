module Selenium
  class Alert
    private getter session : Session

    def initialize(@session)
    end

    def text
      session.get("/alert_text").as_s
    end

    def send_keys(sequence : String)
      session.post("/alert_text", {value: sequence})
    end

    def accept
      session.post("/accept_alert")
    end

    def dismiss
      session.post("/dismiss_alert")
    end
  end
end
