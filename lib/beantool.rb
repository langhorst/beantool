require 'rubygems'
require 'beaneater'

class Beantool
  NAME = 'beantool'
  VERSION = '0.4.0'

  def self.version 
    [NAME, VERSION].join(' ') 
  end

  attr_reader :beanstalk

  def initialize(addrs='0.0.0.0:11300')
    @beanstalk = Beaneater::Pool.new(Array(addrs))
  end

  #
  # Monitoring
  #

  def tubes
    beanstalk.tubes.all.map{|t| t.name}.join("\n")
  end

  def stats
    beanstalk.stats.keys.map{|stat| "#{stat}: #{beanstalk.stats.send(stat)}"}.join("\n")
  end

  def tube_stats(name)
    tube = beanstalk.tubes.find(name)
    tube.stats.keys.map{|stat| "#{stat}: #{tube.stats.send(stat)}"}.join("\n")
  rescue Beaneater::NotFoundError
    "#{name} not found"
  end

  def inspect_job(id)
    job = beanstalk.jobs.peek(id)
    return "job #{id} not found" if job.nil?
    job.stats.keys.map{|stat| "#{stat}: #{job.stats.send(stat)}"}.concat(["body: #{job.body.inspect}"]).join("\n")
  end

  def peek(name, state)
    job = beanstalk.tubes.find(name).peek(state.to_sym)
    return "job not found" if job.nil?
    ["id: #{job.id}", "body: #{job.body.inspect}"].join("\n")
  rescue Beaneater::NotFoundError
    "#{name} not found"
  end

  #
  # Administering
  #

  def kick(num)
    beanstalk.tubes.all.each{|tube| tube.kick(num)}
  end

  def import(tubename, filename)
    tube = beanstalk.tubes.find(tubename)
    YAML.load_file(filename).each { |job| tube.put(job) }
  end

  def export(tubename, filename)
    jobs = Array.new 
    tube = beanstalk.tubes.find(tubename)
    while tube.peek(:ready)
      job = tube.reserve
      jobs << job.body
      job.delete
    end
    File.open(filename, 'a') { |f| YAML.dump(jobs, f) }
  end

  def create(job, tubename)
    beanstalk.tubes.find(tubename).put(job)
  end

  def move(from, to)
    source = beanstalk.tubes.find(from)
    destination = beanstalk.tubes.find(to)
    while source.peek(:ready)
      job = source.reserve
      destination.put(job.body)
      job.delete
    end
  end

  def purge(tubenames)
    tubenames.each { |tube| beanstalk.tubes.find(tube).clear }
  end
end
