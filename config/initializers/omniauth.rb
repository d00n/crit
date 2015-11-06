Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, '133055480072103', '440fdbecfb2ab654e2a7f640fbad30e6', {:scope => "email, user_birthday, user_website, user_likes, user_hometown, user_interests, user_location, publish_actions"}
  elsif Rails.env.staging?
    provider :facebook, '143894308984398', '0fe93e2d6ea19e1be5e155b37066a5c3', {:scope => "email, user_birthday, user_website, user_likes, user_hometown, user_interests, user_location, publish_actions"}
  elsif Rails.env.development?
    provider :facebook, '143701092336577', 'b2a1b5a50ff3ffba6f0a7d72e36a9a1a', {:scope => "email, user_birthday, user_website, user_likes, user_hometown, user_interests, user_location, publish_actions"}
  end


#  provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
#  provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end

