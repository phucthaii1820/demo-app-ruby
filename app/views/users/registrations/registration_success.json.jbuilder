json.status do
  json.code 200
  json.message "Signed up successfully."
  json.data do
    json.user do
      json.id current_user.id
      json.email current_user.email
      json.name current_user.name
    end
  end
end

=begin
{
    "status":{
        "code":200,
        "message":"Signed up successfully.",
        "data":{
            "id":1,
            "email":"test@email.com",
            "name":"tom"
        }
    }
}
=end
