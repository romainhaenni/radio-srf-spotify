Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, '80d40cf15de4422f9f464e72a5428634', '08034c48821a4bc1a53d71e054f48730', scope: 'playlist-modify-private playlist-modify-public'
end