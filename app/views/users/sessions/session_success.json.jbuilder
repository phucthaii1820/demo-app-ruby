json.status do
  json.code 200
  json.message "Logged in successfully......"
  json.data do
    json.user do
      json.id current_user.id
      json.email current_user.email
      json.name current_user.name
      # return token in the body instead of response header but it's not recommended
      # token: request.env['warden-jwt_auth.token']
    end
  end
end
