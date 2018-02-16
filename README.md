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
BeProtected::Configuration.setup do |config|
    config.url   = "http://be_protected.com:8907/"
    config.proxy = "http://192.168.66.1:3456/"
end
```

### Managing accounts

```ruby
credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(credentials)

# create account
response = account.create(name: "Jane", parent_uuid: '123abc')
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Uuid = " + response.uuid
    puts "Name = " + response.name
    puts "Token = " + response.token
    puts "ParentUuid = " + response.parent_uuid
else
    puts "Error #{response.error}"
end

# update account
john = account.update(response.uuid, name: "John", parent_uuid: '')
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
    puts "ParentUuid = " + response.parent_uuid
else
    puts "Error #{response.error}"
end
```

### Managing limits

```ruby
beprotected_credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(beprotected_credentials).create('Account name')

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

response = limit.decrease(gw_limit.uuid, created_at: created_at, value: value)
if response.success?
    puts response.message
else
    puts "Limit doesn't decreased!"
end
```

### Managing blacklist

```ruby
beprotected_credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(beprotected_credentials).create('Account name')

credentials = {auth_login: account.uuid, auth_password: account.token}
blacklist = BeProtected::Blacklist.new(credentials)

# add to blacklist
response = blacklist.add("some value")
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Value = " + response.value
    puts "Persisted = " + response.persisted
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end

# get value from blacklist
response = blacklist.get("some value")
if response.success?
    puts "Value = " + response.value
    puts "Persisted = " + response.persisted
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end

# delete value from blacklist
response = blacklist.delete("some value")
if response.success?
    puts "Value was deleted from blacklist"
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end
```

### Managing whitelist

```ruby
beprotected_credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(beprotected_credentials).create('Account name')

credentials = {auth_login: account.uuid, auth_password: account.token}
whitelist = BeProtected::Whitelist.new(credentials)

# add to whitelist
response = whitelist.add("some value")
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Value = " + response.value
    puts "Persisted = " + response.persisted
else
    puts "Error #{response.error}"
end

# get value from whitelist
response = whitelist.get("some value")
if response.success?
    puts "Value = " + response.value
    puts "Persisted = " + response.persisted
else
    puts "Error #{response.error}"
end

# delete value from whitelist
response = whitelist.delete("some value")
if response.success?
    puts "Value was deleted from whitelist"
else
    puts "Error #{response.error}"
end
```

### Managing rules

```ruby
credentials = { auth_login: 'login', auth_password: 'password' }
rule = BeProtected::Rule.new(credentials)

# create rule
params = {action: "reject", condition: "Unique CardHolder count more than 5 in 36 hours",
        alias: "rule_1", active: true}
response = rule.create(params)
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Uuid = " + response.uuid
    puts "Action = " + response.action
    puts "Condition = " + response.condition
    puts "Alias = " + response.alias
    puts "Active = " + response.active.to_s
    puts "Created at = " + response.created_at.to_s
else
    puts "Error #{response.error}"
end

# update rule
reject_rule = rule.update(response.uuid, action: "reject", active: false)
if reject_rule.failed?
    puts "Can't update rule: " + reject_rule.error
else
    puts "Action was successfully updated to " + reject_rule.action
end

# get rule
response = rule.get(reject_rule.uuid)
if response.success?
    puts "Uuid = " + response.uuid
    puts "Action = " + response.action
    puts "Condition = " + response.condition
    puts "Alias = " + response.alias
    puts "Active = " + response.active.to_s
    puts "Created at = " + response.created_at.to_s
else
    puts "Error #{response.error}"
end

# get all rules
rules = rule.get
if response.success?
    # rules includes Enumerable and we can use each, map & etc.
    all_aliases = rules.map {|r| r.alias }
    puts "All aliases: #{all_aliases]"

    # get all items
    items = rules.items

    rules.each_with_index do |r, index|
        puts "Rule ##{index}"
        puts "Uuid = " + r.uuid
        puts "Action = " + r.action
        puts "Condition = " + r.condition
        puts "Alias = " + r.alias
        puts "Active = " + r.active.to_s
        puts "Created at = " + response.created_at.to_s
    end
else
    puts "Error #{response.error}"
end

# delete rule
response = rule.delete(reject_rule.uuid)
if response.success?
    puts "Rule was deleted"
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end

# add data for rules
response = rule.add_data(ip_address: "211.10.9.8", email: "john@example.com", amount: 100, currency: "USD",
    pan: "sha(salt with pan)", pan_name: "Jane Doe", status: "failed",
    type: "Payment", created_at: "2014-09-09 06:21:24",  device_id: "uno",
    billing_address: "111 1st Street", bin: "420000", ip_country: "US",
    bin_country: "CA", customer_name: "Smith", phone_number: "123456",
    billing_address_country: "CA")
if response.success?
    puts response.message
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end
```

### Managing sets

```ruby
credentials = { auth_login: 'login', auth_password: 'password' }
set = BeProtected::Set.new(credentials)

# create set
params = {name:"AllowedTypes", value: ["Payment", "Refund"]}
response = set.create(params)
puts "Response HTTP Status = " + response.status
if response.success?
    puts "Uuid = " + response.uuid
    puts "AccountUuid = " + response.account_uuid
    puts "Name = " + response.name
    puts "Value = " + response.value
else
    puts "Error #{response.error}"
end

# update set
allowed_types = set.update(response.uuid, value: ["Authorization", "Capture", "Void"])
if allowed_types.failed?
    puts "Can't update set: " + allowed_types.error
else
    puts "Allowed types was update to" + allowed_types.value
end

# get set
response = set.get(allowed_types.uuid)
if response.success?
    puts "Uuid = " + response.uuid
    puts "AccountUuid = " + response.account_uuid
    puts "Name = " + response.name
    puts "Value = " + response.value
else
    puts "Error #{response.error}"
end

# get all sets
sets = set.get
if response.success?
    sets.each_with_index do |s, index|
        puts "Set ##{index}"
        puts "Uuid = " + s.uuid
        puts "AccountUuid = " + s.account_uuid
        puts "Name = " + s.name
        puts "Value = " + s.value
    end
else
    puts "Error #{response.error}"
end

# delete set
response = set.delete(allowed_types.uuid)
if response.success?
    puts "Set was deleted"
else
    puts "Error #{response.error}"
    puts "Raw response: #{response.raw}"
end
```

### Verifications

```ruby
beprotected_credentials = {auth_login: 'login', auth_password: 'password'}
account = BeProtected::Account.new(beprotected_credentials).create('Account name')

headers = {'RequestID' => 'some-your-request-id'}
beprotected_options = {auth_login: account.uuid, auth_password: account.token, headers: headers}
verification = BeProtected::Verification.new(beprotected_options)

# verify
verification_params = {
    limit: {
        key: 'USD_567',
        value: 585     # transaction amount
    },
    white_black_list: {
        ip: '127.0.0.',
        email: 'john@example.com',
        card_number: 'stampnumberofcard'
    },
    rules: {
        ip: '127.0.0.8', card_number: '4200000000000000',
        amount: 250, currency: 'USD'
    }
}
result = verification.verify(verification_params)
if result.success?
    if result.passed?
        puts "All verifications was passed."
        puts "Current volume: " + result.limit.current_volume
        puts "Current count: "  + result.limit.current_count
    else
        puts "Some verifications wasn't passed."
        puts "Transaction volume per month exceed: " + result.limit.volume  # true or false
        puts "Transaction count per month exceed: "  + result.limit.count   # true or false
        puts "Max amount per transaction: "          + result.limit.max     # true or false
    end

    if result.white_black_list.passed?
        puts "WhiteBlackList does not include passed items"
    else
        puts "Ip in: " + result.white_black_list.ip                   # 'white','black' or 'absent'
        puts "Email in: " + result.white_black_list.email             # 'white','black' or 'absent'
        puts "Card number in: " + result.white_black_list.card_number # 'white','black' or 'absent'
    end

    if result.rules.passed?
        puts "All rules was passed"
    else
        puts "Some rules was rejected: #{result.rules.to_hash}"
    end

    if result.error?
        puts "Some errors: " + result.error_messages
    end
end


# you can verify value in white black list
result = verification.white_black_list_verify('any value')
case result
when 'absent' then "Value is absent in white and black list"
when 'white'  then "Value is included in whitelist"
when 'black'  then "Value is included in blacklist"
else                "can't verify (may be service is not available)"
end

puts "Response as hash:"
result.to_hash # => {
#  limit:
#    {volume: true, count: true, max: true, current_volume: 200, current_count: 15},
#  white_black_list:
#    {ip: 'white', email: 'black', card_number: 'absent'},
#  rules:
#    {'parent account' => {
#        'alias 1' => {'Transaction amount more than 100 EUR' => 'review'},
#        'alias 2' => {'Transaction amount more than 400 EUR' => 'reject'}},
#     'child account'  => {'alias 5' => {'Transaction amount more than 90 USD'  => 'skipped'}}
#    }
#
#}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
