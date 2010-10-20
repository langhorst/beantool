class Beantool
  module Administering
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
  end
end

