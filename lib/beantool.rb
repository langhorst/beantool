require 'rubygems'
require 'beaneater'
require File.expand_path(File.join('beantool', 'administering'), File.dirname(__FILE__))
require File.expand_path(File.join('beantool', 'monitoring'), File.dirname(__FILE__))

module Beantool; class Base
  NAME = 'beantool'
  VERSION = '0.3.2'

  include Beantool::Administering
  include Beantool::Monitoring

  def self.version 
    [NAME, VERSION].join(' ') 
  end

  attr_reader :pool

  def initialize(addrs='0.0.0.0:11300')
    @pool = Beaneater::Pool.new(Array(addrs))
    #@pool.ignore('default')
  rescue Beaneater::NotConnected
    puts "FATAL: Unable to connect to beanstalkd"
    exit
  end
end; end

