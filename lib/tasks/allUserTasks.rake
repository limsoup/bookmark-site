desc "Tasks on all users"
task :all_user_tasks => :environment do
	User.find_each(:batch_size => 400) do |user|
		user.purge_self
		if !user.frozen?
			x = user
			x.human = true;
			x.save
		end
	end
end