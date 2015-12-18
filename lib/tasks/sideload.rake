namespace :sideload do

  desc 'Generate sideload URL'
  task :getURL, [:email, :first_name, :last_name] => :environment do |task, args|

    sha2 = Digest::SHA2.new
    hash_input = args.email + D20PRO_SECRET
    sha2.update hash_input
    hash = sha2.hexdigest

    url = "/users/sideload?email=#{args.email}&hash=#{hash}&first_name=#{args.first_name}&last_name=#{args.last_name}"

    puts url
  end

end
