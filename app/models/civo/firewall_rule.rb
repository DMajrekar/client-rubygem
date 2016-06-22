module Civo
  class FirewallRule < Base
    if ENV["CIVO_API_VERSION"] == "2"
      get :all, "/v2/firewalls/:firewall_id/rules", required: [:firewall_id]
      post :create, "/v2/firewalls/:firewall_id/rules", required: [:firewall_id, :protocol, :start_port,
        :cidr, :direction]
      delete :remove, "/v2/firewalls/:firewall_id/rules/:id", required: [:firewall_id, :id]
    else
      get :all, "/v#{ENV["CIVO_API_VERSION"] || "1"}/firewalls/:name/rules", required: [:name]
      post :create, "/v#{ENV["CIVO_API_VERSION"] || "1"}/firewalls/:name/rules", required: [:name, :protocol, :start_port,
        :cidr, :direction]
      delete :remove, "/v#{ENV["CIVO_API_VERSION"] || "1"}/firewalls/:name/rules/:id", required: [:name, :id]
    end
  end
end
