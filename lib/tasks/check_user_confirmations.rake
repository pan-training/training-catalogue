namespace :tess do
  #shadowbans users that haven't confirmed their mail for over 4 days.
  desc 'Check all users confirmations'
  task check_user_confirmations: :environment do
    User.all.each do |user|
      if user.confirmed_at
          puts "user confirmed his account"
      else
          puts "user hasn't confirmed his account"
          if (user.confirmation_sent_at+4.days)<Time.now.to_datetime
              user_id = user.id
              Ban.create(banner_id:10,user_id:user_id)
          end
      end
    end
  end
end
