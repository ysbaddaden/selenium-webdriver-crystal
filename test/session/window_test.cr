require "../test_helper"

class SessionWindowTest < Minitest::Test
  def test_get_rect
    rect = session.window.rect
    rect.width = 13
    rect.height = 11
    session.window.rect = rect

    assert_equal rect, session.window.rect
    session.window.resize_to 7, 5

    rect = session.window.rect
    assert_equal 7, rect.width
    assert_equal 5, rect.height
  end
end
