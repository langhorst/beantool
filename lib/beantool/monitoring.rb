require 'pp'

class Beantool
  module Monitoring
    def list_tubes
      a = [] 
      @pool.list_tubes.each do |host, tubes|
        a << host
        tubes.each { |tube| a << "\t" + tube }
      end
      return a.join("\n")
    end

    def stats
      return build_stats(@pool.stats).join("\n")
    end

    def raw_stats 
      a = []
      raw_stats = @pool.raw_stats
      raw_stats.each do |host, stats|
        a << host
        build_stats(stats).each { |s| a << "\t" + s } 
      end
      return a.join("\n")
    end

    def tube_stats(tube)
      return build_stats(@pool.stats_tube(tube)).join("\n")
    rescue => e
      return e.message
    end

    def raw_tube_stats(tube)
      a = []
      raw_stats = @pool.raw_stats_tube(tube)
      raw_stats.each do |host, stats|
        a << host
        build_stats(stats).each { |s| a << "\t" + s }
      end
      return a.join("\n")
    rescue => e
      return e.message
    end

    def peek_ready(tube)
      a = []
      @pool.watch(tube)
      return build_peek(@pool.peek_ready)
    end

    def peek_buried(tube)
      @pool.watch(tube)
      job = @pool.peek_buried
      return build_peek(@pool.peek_buried)
    end

    def peek_delayed(tube)
      @pool.watch(tube)
      return build_peek(@pool.peek_delayed)
    end
   
    private

    def build_stats(stats)
      a = []
      stats.keys.sort.each { |k| a << "#{k}: #{stats[k]}" }
      return a
    end

    def build_peek(job)
      a = []
      unless job.nil?
        a << PP.pp(job, '')
        a << PP.pp(job.body, '')
      end
      return a.join("\n")
    end
  end
end

