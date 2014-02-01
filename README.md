#About Ruby Whois

Ruby Whois is forked from WhoIz, its a simple WHOIS lookup application. It's built on Sinatra and Heroku friendly.

###API Usage

view complete API Usage documentation on http://ruby-whois.org/manual/usage/

Property | Returns
-------- | -------
disclaimer | String / Nil
domain | String / Nil
domain_id | String / Nil
status | String / Nil
registered? | Boolean
available? | Boolean
created_on | Time / Nil
updated_on | Time / Nil
expires_on | Time / Nil
registrar | Whois::Record::Registrar / Nil
registrant_contacts | Array\<Whois::Record::Contact\>
admin_contacts | Array\<Whois::Record::Contact\>
technical_contacts | Array\<Whois::Record::Contact\>
nameservers | Array\<Whois::Record::Nameserver\>

###Filtering Output


Property | Value
-------- | -----
output | raw, json
key | see table above
debug | true
    
###Use It

    ## Main App
    http://yourwebsite/
    
    ## HTML Output
    http://yourwebsite/lookup?url=prpagerank.com
    
    ## JSON Output    
    http://yourwebsite/lookup?url=prpagerank.com&output=json
    
    ## JSON Output  and only return Creation Date   
    http://yourwebsite/lookup?url=prpagerank.com&output=json&key=created_on
    
    ## Raw/Text Output    
    http://yourwebsite/lookup?url=prpagerank.com&output=raw
    
    ## Raw/Text Output and only return Expires Date   
    http://yourwebsite/lookup?url=prpagerank.com&output=raw&key=expires_on

###Debug and Error Handling

sometimes "key" like "created_on" will return null even the domain is registered to debug or view raw response data just use "debug=true" in the URL

    ## Debug Raw Response  
    http://yourwebsite/lookup?url=prpagerank.com&output=raw&key=expires_on&debug=true
    
    ## Debug JSON Response  
    http://yourwebsite/lookup?url=prpagerank.com&output=json&key=expires_on&debug=true

#####Example Debug Output "created_on" for Google.co.id

    [{"created_on" : "null"},
    {"debug_mode" : "\n\nDomain ID:PANDI-DO246796\nDomain Name:GOOGLE.CO.ID\nCreated On:18-Dec-2004 13:33:21 UTC\nLast
    Updated On:20-Sep-2013 23:24:51 UTC\nExpiration Date:01-Sep-2014 23:59:59 UTC.....}]

###Clone It

    git clone https://github.com/ewwink/ruby-whois.git


###Restrict It

Edit

    main.rb

Change this

    before do
      response['Access-Control-Allow-Origin'] = '*'
    end

To this

    before do
      response['Access-Control-Allow-Origin'] = 'http://yourwebsite.com'
    end


Deploy It
===
    heroku create
    git push heroku master
    heroku open



Supported by
------------
prpagerank.com provide all in one SEO Tools like for [Check Pagerank](http://www.prpagerank.com) of websites and more.
