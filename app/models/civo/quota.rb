module Civo
  class Quota < Base
    get :current, "/v1/quota"
    put :update, "/v1/quota/:name"
  end
end
