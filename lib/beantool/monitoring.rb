require 'pp'

module Beantool; module Monitoring
  def tubes
    pool.tubes.all.map{|t| t.name}.join("\n")
  end

  def stats
    build_stats(pool.stats).join("\n")
  end

  def tube_stats(name)
    tube = pool.tubes.find(name)
    tube.stats.keys.map{|stat| "#{stat}: #{tube.stats.send(stat)}"}.join("\n")
  rescue Beaneater::NotFoundError
    "#{name.inspect} not found"
  end

  def kick(num)
    pool.open_connections.each { |conn| conn.kick(num) }
  end

  def inspect_job(id)
    job = pool.jobs.peek(id)
    return "job id #{id} not found" if job.nil?
    job.stats.keys.map{|stat| "#{stat}: #{job.stats.send(stat)}"}.concat(["body: #{job.body.inspect}"]).join("\n")
  end

  def peek(name, state)
    job = pool.tubes.find(name).peek(state.to_sym)
    return "job not found" if job.nil?
    ["id: #{job.id}", "body: #{job.body.inspect}"].join("\n")
  rescue Beaneater::NotFoundError
    "#{name.inspect} not found"
  end
end; end
