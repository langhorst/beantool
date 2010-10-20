$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'beanstalk-client'
require 'beantool/administering'
require 'beantool/monitoring'

class Beantool
  NAME = 'beantool'
  VERSION = '0.2'

  include Beantool::Administering
  include Beantool::Monitoring

  def self.version 
    [NAME, VERSION].join(' ') 
  end

  def initialize(addrs)
    @pool = Beanstalk::Pool.new(addrs) 
    #@pool.ignore('default')
  end
end

