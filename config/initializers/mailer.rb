Rails.application.routes.default_url_options[:host] = 'localhost:3000' if Rails.env.development?
Rails.application.routes.default_url_options[:host] = 'your_domain.com' if Rails.env.production?
