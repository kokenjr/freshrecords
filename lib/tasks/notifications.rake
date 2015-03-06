desc "User Notifications"
task :notify_users => :environment do
  records = Record.where(release_date: Date.today)
  records.each do |record|
    record.users.each do |user|
      if user.wishlist_notification
        NotificationMailer.wish_list(user, record).deliver
      end
    end
    artist = record.artist
    artist.users.each do |user|
      if user.artist_notification
        NotificationMailer.artist_release(user, artist, record).deliver
      end
    end
  end
end
