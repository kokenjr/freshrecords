desc "Purge dead rows"
task :purge_rows => :environment do
  Record.where("release_date <= ?", 3.months.ago).each do |record|
    if record.users.blank?
      record.delete
    end
  end
end
