module Selenium
  class Session
    struct Cookie
      @json : JSON::Any

      def initialize(json)
        @json = json
      end

      def name
        @json["name"].as_s
      end

      def value
        @json["value"].as_s
      end

      def domain
        @json["domain"].as_s
      end

      def path
        @json["path"].as_s
      end

      def expiry
        if timestamp = @json["expiry"]?
          Time.epoch(timestamp.as_i64)
        end
      end

      def http_only
        @json["httpOnly"].as_bool
      end

      def secure
        @json["secure"].as_bool
      end
    end

    struct Cookies
      def initialize(@session : Session)
      end

      def clear
        @session.delete("/cookie")
      end

      def delete(name)
        @session.delete("/cookie/#{name}")
      end

      def each(&block)
        @session.get("/cookie")
          .as_a
          .each { |json| yield Cookie.new(json) }
      end

      def get(name)
        Cookie.new(@session.get("/cookie/#{name}"))
      end

      def set(name, value, domain = nil, path = "/", http_only = false, secure = false)
        cookie = {
          "name"     => name,
          "value"    => value,
          "path"     => path,
          "httpOnly" => http_only,
          "secure"   => secure,
        }
        cookie["domain"] = domain if domain
        @session.post("/cookie", {cookie: cookie})
      end

      def to_a
        @session.get("/cookie")
          .as_a
          .map { |json| Cookie.new(json) }
      end

      private def to_cookie(json)
        if timestamp = json["expiry"]?
          expiry = Time.epoch(timestamp.as(Int64))
        end
        {
          name:      json["name"].as(String),
          value:     json["value"].as(String),
          domain:    json["domain"].as(String),
          path:      json["path"].as(String),
          expiry:    expiry,
          http_only: json["httpOnly"].as(Bool),
          secure:    json["secure"].as(Bool),
        }
      end
    end
  end
end
