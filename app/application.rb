class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path == '/services' && req.get?
      services = Service.all
      return [
        200,
         { 'Content-Type' => 'application/json' }, 
         [ services.to_json ]
        ]

    elsif req.path == '/companies' && req.get?
          companies = Company.all
          return [
            200,
             { 'Content-Type' => 'application/json' }, 
             [ companies.to_json ]
            ]

          elsif req.path.match(/companies/) && req.get?
            id = req.path.split('/')[2]
            company = Company.find_by(id: id)
            if company
              return [
                200,
                 { 'Content-Type' => 'application/json' }, 
                 [ company.to_json ]
                ]
              elsif
                [
                  404,
                   { 'Content-Type' => 'application/json' }, 
                   [ { error: 'Company not found'}.to_json ]
                  ]
                end

    else
      resp.write "Path Not Found"
     
    end

    resp.finish
  end

end
