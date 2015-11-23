command "instances" do |c|
  c.description = "List known instances"
  c.action do |args, options|
    begin
      instances = Civo::Instance.all
      Civo::Client.tabulate_flexirest instances, {id: "ID", hostname: "Hostname", size: "Size", ip_addresses: "IP Addresses", status: "Status"}
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    end
  end
end

command "instances:create" do |c|
  c.description = "Create an account"
  c.example "Creates an account called 'testuser'", 'civo instances:create testuser'
  c.action do |args, options|
    begin
      account = Civo::Instance.create(name: args.first)
      puts "Account '#{args.first}' created.  The API key is '#{account.api_key}'"
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    end
  end
end

command "instances:reset" do |c|
  c.description = "Reset the API Key for an account"
  c.example "Resets the account called 'testuser' with a new API key", 'civo instances:reset testuser'
  c.action do |args, options|
    begin
      account = Civo::Instance.reset(name: args.first)
      puts "Account '#{args.first}' reset, the new API key is '#{account.api_key}'"
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    end
  end
end

command "instances:remove" do |c|
  c.description = "Remove an account (and all instances, networks, etc)"
  c.example "Removes an account called 'testuser'", 'civo instances:remove testuser'
  c.action do |args, options|
    begin
      account = Civo::Instance.remove(name: args.first)
      if account.result == "ok"
        puts "Account '#{args.first}' has been removed."
      else
        puts "Failed to delete that account: #{account.inspect}"
      end
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    rescue Flexirest::HTTPNotFoundClientException => e
      puts "Couldn't find that account to remove, maybe it's already been removed?"
    rescue Flexirest::HTTPServerException => e
      puts "Unable to remove #{e.result.reason}"
    end
  end
end
