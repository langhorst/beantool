$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'beanstalk-client'
require 'beantool/administering'
require 'beantool/monitoring'

class Beantool
  NAME = 'beantool'
  VERSION = '0.3.2'

  include Beantool::Administering
  include Beantool::Monitoring

  def self.version 
    [NAME, VERSION].join(' ') 
  end

  attr_reader :pool

  def initialize(addrs)
    addrs << "0.0.0.0:11300" if addrs.empty?
    @pool = Beanstalk::Pool.new(addrs) 
    #@pool.ignore('default')
  rescue Beanstalk::NotConnected
    puts "FATAL: Unable to connect to beanstalkd"
    exit
  end
end

