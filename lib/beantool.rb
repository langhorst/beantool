require 'rubygems'
require 'beanstalk-client'

class Beantool
  NAME = 'beantool'
  VERSION = '0.1'

  def self.version 
    [NAME, VERSION].join(' ') 
  end

  def initialize(addrs)
    @pool = Beanstalk::Pool.new(addrs) 
    #@pool.ignore('default')
  end

  def import(tube, file)
    jobs = YAML.load_file(file)
    @pool.use(tube)
    jobs.each { |job| @pool.put(job) }
  end

  def export(tube, file)
    jobs = Array.new
    @pool.watch(tube)
    job = @pool.peek_ready
    # todo: do we need to do delayed and buried jobs as well?
    while !job.nil?
      jobs << job
      @pool.reserve.delete
      job = @pool.peek_ready
    end
    File.open(file, 'a') { |f| YAML.dump(jobs, f) }
  end

  def list_tubes
    a = build_header('Tubes')
    @pool.list_tubes.each do |host, tubes|
      a << host
      tubes.each do |tube|
        a << "\t" + tube
      end
    end
    return a.join("\n")
  end

  def peek(tube)
    a = build_header("#{tube} Peek")
    @pool.use(tube)
    job = { :id => 123, :body => 'test message' }
    @pool.put(job)
    @pool.watch(tube)
    a << @pool.peek_ready.to_s
    return a.join("\n")
  end

  def purge(tube)
    a = build_header("#{tube} Purge")
    @pool.watch(tube)
    while !@pool.peek_ready.nil?
      job = @pool.reserve
      a << job.to_s
      job.delete
    end
    return a.join("\n")
  end

  def stats_raw 
    a = build_header('Raw Stats')
    raw_stats = @pool.raw_stats
    raw_stats.each do |host, stats|
      a << host
      build_stats(stats).each { |s| a << "\t" + s } 
    end
    return a.join("\n")
  end

  def stats
    a = build_header('Stats')
    a << build_stats(@pool.stats)
    return a.flatten.join("\n")
  end

  def stats_tube(tube)
    a = build_header("#{tube} Tube Stats")
    a << build_stats(@pool.stats_tube(tube))
    return a.flatten.join("\n")
  end

  def stats_tube_raw(tube)
    a = build_header("#{tube} Raw Tube Stats")
    raw_stats = @pool.raw_stats_tube(tube)
    raw_stats.each do |host, stats|
      a << host
      build_stats(stats).each { |s| a << "\t" + s }
    end
    return a.join("\n")
  end

  def peek_ready(tube)
    a = build_header("Peek Ready on #{tube}")
    @pool.watch(tube)
    a << @pool.peek_ready
    return a.join("\n")
  end

  def peek_buried(tube)
    @pool.watch(tube)
    a = build_header("Peek Buried on #{tube}")
    a << @pool.peek_buried
    return a.join("\n")
  end

  def peek_delayed(tube)
    @pool.watch(tube)
    a = build_header("Peek Delayed on #{tube}")
    a << @pool.peek_delayed
    return a.join("\n")
  end
  
  def version
    Beantool.version
  end

  private

  def build_header(title)
    a = Array.new
    a << title
    a << '-'*title.size
    return a
  end

  def build_stats(stats)
    a = Array.new
    stats.keys.sort.each { |k| a << "#{k}: #{stats[k]}" }
    return a
  end
end


