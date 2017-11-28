# Verb Ruby Client

The official Ruby Client for the [Verb](https://verb.sh) messaging web service.

## Installation

```sh
gem install verb-sh
```

#### Requirements

- **[Ruby 2.4.1](https://www.ruby-lang.org/)**

###Configuration

```ruby
Verb.configure(token: '<token>')
```

### Sending Email Messages

```ruby
@message = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

@message.send
```

#### Attaching Files

Files can only be attached to email messages (this is also dependent on the service you are using to send the emails). Only pass the path to the file.

```ruby
@message = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

@message.attach('file.pdf')

# OR

@message.attach(['file1.pdf', 'file2.pdf'])

# OR

@message.attach('file1.pdf')
@message.attach('file2.pdf')
@message.attach('file3.pdf')

@message.send

```

#### Restricted File Types:

These file types are generally not allowed and will be blocked.

- vbs
- exe
- bin
- bat
- chm
- com
- cpl
- crt
- hlp
- hta
- inf
- ins
- isp
- jse
- lnk
- mdb
- pcd
- pif
- reg
- scr
- sct
- shs
- vbe
- vba
- wsf
- wsh
- wsl
- msc
- msi
- msp
- mst

#### Scheduling Messages

Verb has a built-in scheduler on the server that allows you schedule emails in the future. These are quite useful in the sense that you can target future user behavior or events.

```ruby
@message = Verb.email({
  to: 'me@me.com', text: 'Email Text', html: 'Email HTML'
})

@message.send(in: '1h')
```


### Sending SMS Messages

```ruby
@message = Verb.sms({
  to: '+20830000000', text: 'SMS Text'
})

@message.send(in: '1h')
```


### Re-usable Templates

Templates are a powerful way to add reusable message (sms / email) templates on the server side where you can edit content without requiring direct access to source code or perform re-deployments.

Templates are available for:

- Email Messages
- SMS Messages

```ruby
@message = Verb.sms({
  template: 'welcome-sms-template', to: '+20830000000', data: { name: 'My Name', other: 'More data' }
})

@message.send(in: '20m')
```
Templates are created in the [Verb](https://verb.sh) admin dashboard using Text, HTML or [mustache](https://mustache.github.io/). If your template contains variables, you can specify these by adding a `data: {}` field into the parameters.


### Using Lists

With Verb, lists are really easy to create or add to. It's as simple and similar to using a tag with similar mechanics in the backend. You simply add `list: '<list-name>'` to your method params.

```ruby
@message = Verb.sms({
  template: 'welcome-sms-template', to: '+20830000000', list: 'list-slug', data: { name: 'My Name', other: 'More data' }
})
```

### Other API/SDK Methods

The SDK has purposely been kept simple to use in attempt to keep code as minimal as possible. There are however two additional methods that can be used to determine if messages were sent successfully.

```ruby
puts @message.status  # Integer, the response code from the API
puts @message.sent?   # Boolean, based on if the message was sent or not
puts @message.error   # Hash, contains all the error details from the API if a message was not delivered
```

#### Running the tests

To test the current stable version of verb-sh, simply run:

    rake test

#### License

Please see [LICENSE](https://github.com/Craaft/verb-ruby/blob/master/LICENSE) for licensing details.

#### Author

Sean Nieuwoudt, [@seannieuwoudt](https://twitter.com/seannieuwoudt)
