user = User.create!(name: 'Admin', email: 'admin@example.com', password: 'iamRails2021',
                    password_confirmation: 'admin0987')
api_key = ApiKey.create!(user: user)
puts api_key.access_token
