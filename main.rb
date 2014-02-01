require 'sinatra'
require 'whois'
require 'haml'
require 'json'
require 'ostruct'

before do
  response['Access-Control-Allow-Origin'] = 'http://www.prpagerank.com'
end

helpers do

  def cache_for_day
    response['Cache-Control'] = 'public, max-age=86400'
  end

  def lookup_respose(output='', key='')
    $resp = Whois.whois(params[:url])
    $debug = params[:debug]

    if (output.empty? && key.empty?)
      $resp

    elsif (!output.empty? && key.empty?)
      if output == 'raw'
        $resp
      elsif output == 'json'
        $resp.properties
      end

    elsif (!output.empty? && !key.empty?)
      if output == 'raw'
        if $resp.respond_to?(key)
          if $debug == 'true' && $resp.send(key).nil?
            '"' + key + " : null\n" + $resp.to_s
          else
            $resp.send(key)
          end
        else
          'error_unknown_key: ' + key
        end

      elsif output == 'json'
        if $resp.respond_to?(key)
          if $debug == 'true' && $resp.send(key).nil?
            "[\n" + '{"' + key + '" : "null"}' + ",\n{\"debug_mode\" : " + $resp.to_json + '}]'
          elsif $debug != 'true' && $resp.send(key).nil?
            '{"' + key + '" : "null"}'
          else
            '{"' + key + '" : ' + $resp.send(key).to_json + '}'
          end
        else
          "[\n" + '{"error_unknown_key": "' + key + '"}' + ",\n" + JSON.pretty_generate($resp.properties) + ']'
        end
      end
    end
  end

end


get '/' do
  #cache_for_day
  haml :index
end


get '/lookup' do
  pUrl = params[:url]
  pOutput = params[:output]
  pKey = params[:key]

  if !pUrl.nil? && pOutput.nil? && pKey.nil?
    begin
      cache_for_day
      @whois = lookup_respose('raw')
      haml :lookup
    rescue Exception => e
      @error = e
      haml :error
    end

  elsif !pUrl.nil? && !pOutput.nil? && pKey.nil?
    if pOutput == 'json'
      begin
        cache_for_day
        response['Content-Type'] = 'application/json; charset=UTF-8'
        JSON.pretty_generate(lookup_respose('json'))
      rescue Exception => e
        @error = e
        {:Error => @error}.to_json
      end
    else
      begin
        cache_for_day
        response['Content-Type'] = 'text/plain; charset=UTF-8'
        lookup_respose('raw').to_s
      rescue Exception => e
        @error = e
        {:Error => @error}.inspect
      end
    end

  elsif !pUrl.nil? && !pOutput.nil? && !pKey.nil?
    if pOutput == 'json'
      begin
        cache_for_day
        response['Content-Type'] = 'application/json; charset=UTF-8'
        lookup_respose('json', pKey).to_s
      rescue Exception => e
        @error = e
        {:Error => @error}.to_json
      end
    else
      begin
        cache_for_day
        response['Content-Type'] = 'text/plain; charset=UTF-8'
        lookup_respose('raw', pKey).to_s
      rescue Exception => e
        @error = e
        {:Error => @error}.inspect
      end
    end
  end
end
