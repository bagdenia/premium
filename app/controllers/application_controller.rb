class ApplicationController < ActionController::Base
  # protect_from_forgery with: :null_session
  # curl -i -H "Content-type: application/json" -X POST -d '{"data": {"type": "movements", "attributes": {"amount": "100", "datetime": "2019-08-21 23:03:24 +0300"}}, "controller": "movements", "action": "create" }'  http://localhost:3000/users/1/movements >> tmp/1.rby

  include Error::ErrorHandler
end
