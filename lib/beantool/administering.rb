class Beantool
  module Administering
    def import(tube, file)
      jobs = YAML.load_file(file)
      @pool.use(tube)
      jobs.each { |job| @pool.put(job) }
    end

    def export(tube, file, move=nil)
      jobs = Array.new
      @pool.watch(tube)
      @pool.use(move) unless move.nil?
      @pool.stats_tube(tube)['current-jobs-ready'].times do
        job = @pool.reserve
        jobs << job
        @pool.put(job) unless move.nil?
        job.delete
      end
      File.open(file, 'a') { |f| YAML.dump(jobs, f) }
    end

    def create(job, tube)
      @pool.use(tube)
      @pool.put(job)
    end

    def move(from, to)
      @pool.watch(from)
      @pool.use(to)
      @pool.stats_tube(from)['current-jobs-ready'].times do
        job = @pool.reserve
        @pool.put(job)
        job.delete
      end
    end

    def purge(tube)
      @pool.watch(tube)
      @pool.stats_tube(tube)['current-jobs-ready'].times do
        @pool.reserve.delete
      end
    end
  end
end

