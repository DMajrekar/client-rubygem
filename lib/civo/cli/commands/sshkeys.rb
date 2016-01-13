command "sshkeys" do |c|
  c.description = "List the SSH public keys you've uploaded"
  c.action do |args, options|
    begin
      sshkeys = Civo::SshKey.all
      Civo::Client.tabulate_flexirest sshkeys, {name: "Name", label: "SSH Key Label"}
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    end
  end
end
alias_command "sshkey", "sshkeys"

command "sshkeys:upload" do |c|
  c.description = "Upload an SSH public key for installing in to new instances"
  c.example "Uploads an SSH public key, calling it 'default' from file '~/.ssh/id_rsa.pub'", 'civo sshkeys:upload default ~/.ssh/id_rsa.pub'
  c.action do |args, options|
    pub_key = File.read(File.expand_path(args[1]))
    begin
      Civo::SshKey.create(name: args.first, public_key: pub_key)
      puts "SSH key '#{args.first}' uploaded."
    rescue Flexirest::HTTPUnauthorisedClientException, Flexirest::HTTPForbiddenClientException
      puts "Access denied to your default token, ensure it's set correctly with 'civo tokens'"
    end
  end
end
alias_command "sshkeys:create", "sshkeys:upload"
alias_command "sshkey:upload", "sshkeys:upload"
alias_command "sshkey:create", "sshkeys:upload"

command "sshkeys:remove" do |c|
  c.description = "Remove an SSH public key from the list you've uploaded"
  c.example "Removes an SSH public key called 'testuser'", 'civo sshkeys:remove testuser'
  c.action do |args, options|
    begin
      key = Civo::SshKey.remove(name: args.first)
      if key.result == "ok"
        puts "SSH public key '#{args.first}' has been removed."
      else
        puts "Failed to delete that SSH key: #{key.inspect}"
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
alias_command "sshkey:remove", "sshkeys:remove"
alias_command "sshkey:delete", "sshkeys:remove"
alias_command "sshkeys:delete", "sshkeys:remove"
