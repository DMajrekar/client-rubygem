module Civo
  class Instance < Base
    get :all, "/v1/instances"
    post :create, "/v1/instances", requires: [:hostname, :size, :region, :ssh_key],
      defaults: {public_ip: true, template: "ubuntu-14.04", initial_user: "civo"}
    delete :remove, "/v1/instances/:id"

    def ip_addresses
      self._attributes[:ip_addresses].items rescue ""
    end
  end
end
