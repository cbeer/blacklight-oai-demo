namespace :oai do
  desc "Harvest new records from the OAI providers"
  task :harvest => :environment do
    Provider.all.reject { |x| x.interval.blank? }.select { |x| x.last_consumed_at.nil? or (x.last_consumed_at + x.interval) > Time.now }.each do |p|
      print "#{p.title} (#{p.id}): "
      count = p.consume!
      print "#{count} records harvested"
    end

  end
end
