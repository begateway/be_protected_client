# BeProtected

Ruby client for BeProtected system.

## Installation

Add this line to your application's Gemfile:

    gem 'be_protected_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install be_protected_client

## Usage
---------------------------

### Configuration

```ruby
BeProtected::Configuration do |config|
    config.url   = "http://be_protected.com:8907/"
    config.proxy = "http://192.168.66.1:3456/"
end
```

### Managing accounts

```ruby
    credentials = {auth_login: 'login', auth_password: 'password'}
    account = BeProtected::Account.new(credentials)

    # create account
    response = account.create(name: "Jane")

    puts "Status = " + response.status

    if response.success?
        puts "Uuid = " + response.uuid
        puts "Name = " + response.name
        puts "Token = " + response.token
    else
        puts "Error #{response.error}"
    end

    # update account
    john = account.update(name: "John")

    if john.failed?
        puts "Can't update account: " + john.error
    else
        puts "Name was successfully updated to " + john.name
    end

    # get account
    response = account.get(john.uuid)

    if response.success?
        puts "Uuid = " + response.uuid
        puts "Name = " + response.name
        puts "Token = " + response.token
    else
        puts "Error #{response.error}"
    end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
