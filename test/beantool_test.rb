require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'beantool')

class BeantoolTest < Test::Unit::TestCase
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

