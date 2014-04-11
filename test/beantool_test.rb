require 'minitest/autorun'
require File.join(File.dirname(__FILE__), '..', 'lib', 'beantool')

class BeantoolTest < MiniTest::Test
  def setup
    @beantool = Beantool::Base.new(['localhost:11300'])
  end

  def teardown
    @beantool = nil
  end

  def test_true
    assert true
  end
end

