module Selenium
  class Error < Exception; end
  class NoSuchDriver < Error; end
  class NoSuchElement < Error; end
  class NoSuchFrame < Error; end
  class UnknownCommand < Error; end
  class StaleElementReference < Error; end
  class ElementNotVisible < Error; end
  class InvalidElementState < Error; end
  class UnknownError < Error; end
  class ElementIsNotSelectable < Error; end
  class JavaScriptError < Error; end
  class XPathLookupError < Error; end
  class Timeout < Error; end
  class NoSuchWindow < Error; end
  class InvalidCookieDomain < Error; end
  class UnableToSetCookie < Error; end
  class UnexpectedAlertOpen < Error; end
  class NoAlertOpenError < Error; end
  class ScriptTimeout < Error; end
  class InvalidElementCoordinates < Error; end
  class IMENotAvailable < Error; end
  class IMEEngineActivationFailed < Error; end
  class InvalidSelector < Error; end
  class SessionNotCreatedException < Error; end
  class MoveTargetOutOfBounds < Error; end

  # :nodoc:
  protected def self.error_class(status)
    case status
    when 6 then NoSuchDriver
    when 7 then NoSuchElement
    when 8 then NoSuchFrame
    when 9 then UnknownCommand
    when 10 then StaleElementReference
    when 11 then ElementNotVisible
    when 12 then InvalidElementState
    when 13 then UnknownError
    when 15 then ElementIsNotSelectable
    when 17 then JavaScriptError
    when 19 then XPathLookupError
    when 21 then Timeout
    when 23 then NoSuchWindow
    when 24 then InvalidCookieDomain
    when 25 then UnableToSetCookie
    when 26 then UnexpectedAlertOpen
    when 27 then NoAlertOpenError
    when 28 then ScriptTimeout
    when 29 then InvalidElementCoordinates
    when 30 then IMENotAvailable
    when 31 then IMEEngineActivationFailed
    when 32 then InvalidSelector
    when 33 then SessionNotCreatedException
    when 34 then MoveTargetOutOfBounds
    else         Error
    end
  end
end
