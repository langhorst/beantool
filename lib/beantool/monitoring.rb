require 'pp'

class Beantool
  module Monitoring
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

    def stats
      a = build_header('Stats')
      a << build_stats(@pool.stats)
      return a.flatten.join("\n")
    end

    def raw_stats 
      a = build_header('Raw Stats')
      raw_stats = @pool.raw_stats
      raw_stats.each do |host, stats|
        a << host
        build_stats(stats).each { |s| a << "\t" + s } 
      end
      return a.join("\n")
    end

    def tube_stats(tube)
      a = build_header("Tube Stats for #{tube}")
      a << build_stats(@pool.stats_tube(tube))
      return a.flatten.join("\n")
    end

    def raw_tube_stats(tube)
      a = build_header("Raw Tube Stats for #{tube}")
      raw_stats = @pool.raw_stats_tube(tube)
      raw_stats.each do |host, stats|
        a << host
        build_stats(stats).each { |s| a << "\t" + s }
      end
      return a.join("\n")
    end

    def peek_ready(tube)
      a = []
      @pool.watch(tube)
      return build_peek(@pool.peek_ready)
    end

    def peek_buried(tube)
      @pool.watch(tube)
      job = @pool.peek_buried
      return job.nil? ? 'NOT FOUND' : [:buried, job, [:body, job.body]]
    end

    def peek_delayed(tube)
      @pool.watch(tube)
      job = @pool.peek_delayed
      return job.nil? ? 'NOT FOUND' : [:delayed, job, [:body, job.body]]
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

    def build_peek(job)
      a = []
      unless job.nil?
        a << PP.pp(job, '')
        a << PP.pp(job.body, '')
      end
      return a.empty? ? '' : a.join("\n")
    end
  end
end
