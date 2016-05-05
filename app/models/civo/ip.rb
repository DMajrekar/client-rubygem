module Civo
  class Ip < Base
    post :create, "/v#{ENV["CIVO_API_VERSION"] || "1"}/instances/:id/ip", requires: [:id], defaults: {public: true}
    delete :remove, "/v#{ENV["CIVO_API_VERSION"] || "1"}/instances/:id/ip/:ip_address", requires: [:id, :ip_address]
    put :connect, "/v#{ENV["CIVO_API_VERSION"] || "1"}/instances/:id/ip/:ip_address", requires: [:id, :ip_address, :private_ip]
  end
end
