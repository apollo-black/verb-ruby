# verb.sh [Ruby Client]

The official Ruby Client for the [Verb](https://verb.sh) messaging platform.

## Installation

```sh
gem install verb-rb
```

#### Requirements

- *[Ruby 2.3.0+](https://www.ruby-lang.org/)*

### Configuration

```ruby
Verb.configure(token: '<Project API Key>')
```

The API is non-blocking so you can simply send and forget. The processing happens in the background on a highly efficient queue system.

### Sending Email Messages

```ruby
msg = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

msg.send
```

### Attaching Files

Files can only be attached to email messages (this is also dependent on the service you are using to send the emails). Only pass the path to the file.

```ruby
msg = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

msg.attach('file.pdf')

# OR

msg.attach(['file1.pdf', 'file2.pdf'])

# OR

msg.attach('file1.pdf')
msg.attach('file2.pdf')
msg.attach('file3.pdf')

msg.send

```

### Restricted File Types:

These file types are generally not allowed and will be blocked.

vbs, exe, bin, bat, chm, com, cpl,
crt, hlp, hta, inf, ins, isp, jse,
lnk, mdb, pcd, pif, reg, scr, sct,
shs, vbe, vba, wsf, wsh, wsl, msc,
msi, msp, mst

### Scheduling Messages

Verb has a built-in scheduler that allows you schedule emails in the future. These are quite useful in the sense that you can target future user behavior or events.

```ruby
msg = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

msg.send(in: '1h')
```

Schedule Examples:

- `'1h'    # 1 hour`
- `'1h20m' # 1 hour 20 minutes`
- `'3Y2W'  # 3 years 2 weeks`

Available Date Tokens:

- 's' seconds
- 'h' hours
- 'm' minutes
- 'D' days
- 'M' months
- 'W' weeks
- 'Y' years

### Sending SMS Messages

```ruby
msg = Verb.sms({
  to: '+20830000000', text: 'SMS Text'
})

msg.send(in: '1h')
```

### Re-usable Templates

Templates are a powerful way to add reusable message (SMS / Email) templates on the server side where you can edit content without requiring direct access to source code or perform re-deployments.

Templates are available for the following message types:

- Email Messages
- SMS Messages

Example: 

```ruby
msg = Verb.sms({
  template: 'welcome-sms-template', to: '+20830000000', data: { name: 'My Name', other: 'More data' }
})

msg.send(in: '20m')
```

Templates are created in the [Verb](https://verb.sh) admin dashboard using Text, HTML or [Mustache](https://mustache.github.io/). If your template contains variables, you can specify these by adding a `data: {}` field into the parameters list.

### Other API/SDK Methods

The SDK has purposely been kept simple to use in attempt to keep code as minimal as possible. There are however two additional methods that can be used to determine if messages were sent successfully.

```ruby
puts msg.status  # Integer, the response code from the API
puts msg.sent?   # Boolean, based on if the message was sent or not
puts msg.error   # Hash, contains all the error details from the API if a message was not delivered
```

#### Running the tests

To test the current stable version of verb-sh, simply run:

    rake test

#### License

Please see [LICENSE](https://github.com/apollo-black/verb-ruby/blob/master/LICENSE) for licensing details.

#### Author

Sean Nieuwoudt, [@seannieuwoudt](https://twitter.com/seannieuwoudt)
