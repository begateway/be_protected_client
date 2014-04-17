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
response = account.create("Jane")
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Uuid = " + response.uuid
    puts "Name = " + response.name
    puts "Token = " + response.token
else
    puts "Error #{response.error}"
end

# update account
john = account.update(response.uuid, name: "John")
if john.failed?
    puts "Can't update account: " + john.error
else
    puts "Name was successfully updated to " + john.name
end

# get account
response = account.get(john.uuid)
if response.success?
    puts "Name = " + response.name
    puts "Token = " + response.token
else
    puts "Error #{response.error}"
end
```

### Managing limits

```ruby
beprotected_credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(beprotected_credentials)

credentials = {auth_login: account.uuid, auth_password: account.token}
limit = BeProtected::Limit.new(credentials)

# create limit
response = limit.create(key: "USD_ID", volume: 1000, count: 145, max: 45)
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Uuid = " + response.uuid
    puts "Key = " + response.key
    puts "Max = " + response.max
    puts "Count = " + response.count
    puts "Volume = " + response.volume
else
    puts "Error #{response.error}"
end

# update limit
updated = limit.update(response.uuid, count: 10, volume: 450)
if updated.failed?
    puts "Can't update limit: " + updated.error
else
    puts "Count was successfully updated to "  + updated.count
    puts "Volume was successfully updated to " + updated.volume
end

# get limit
gw_limit = limit.get(updated.uuid)
if gw_limit.success?
    puts "Key = " + gw_limit.key
    puts "Max = " + gw_limit.max
    puts "Count = " + gw_limit.count
    puts "Volume = " + gw_limit.volume
else
    puts "Error #{gw_limit.error}"
end

# decrease limit
value = 10                    # transaction amount
created_at = Time.now.utc     # transaction created_at

response = limit.decrease(gw_limit.key, created_at: created_at, value: value)
if response.success?
    puts response.message
else
    puts "Limit doesn't decreased!"
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
