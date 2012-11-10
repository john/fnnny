FriendlyId.defaults do |config|
  config.use :reserved
  config.reserved_words = %w(show edit create update destroy)
end