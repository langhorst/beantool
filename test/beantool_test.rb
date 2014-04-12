require 'minitest/autorun'
require File.expand_path(File.join('..', 'lib', 'beantool'), File.dirname(__FILE__))

class BeantoolTest < MiniTest::Test
  def setup
    @beantool = Beantool.new(['localhost:11300'])
  end

  def teardown
    @beantool = nil
  end

  def test_true
    assert true
  end
end

