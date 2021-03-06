class Application

  def call(env)
    res = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path == '/companies' && req.get?
      companies = Company.all
      return [
        200, 
        { 'Content-Type' => 'application/json' }, 
        [ companies.to_json ]
      ]

    elsif req.path.match(/companies/) && req.post?
      body = JSON.parse(req.body.read)
      company = Company.create(body)
      return [
        200, 
        { 'Content-Type' => 'application/json' }, 
        [ company.to_json ]
      ]

    elsif req.path == '/services' && req.get?
      services = Service.all
      
      return [
        200, 
        { 'Content-Type' => 'application/json' }, 
        [ services.to_json ]
      ]
      
    elsif req.path.match('/companies/') && req.delete?
      id = req.path.split('/')[2]
      begin
        companies = Company.find(id)
        companies.destroy
        return [200, {'Content-Type' => 'application/json'}, [{message: "Company Destroyed"}.to_json]]
      rescue
        return [404, {'Content-Type' => 'application/json'}, [{message: "Company not found"}.to_json]]
      end

    elsif req.path.match('/companies/') && req.patch?
      id = req.path.split('/')[2]
      body = JSON.parse(req.body.read)
      begin
        company = Company.find(id)
        company.update(body)
        return [202, {'Content-Type' => 'application/json'}, [company.to_json]]
      end

    elsif req.path.match(/services/) && req.get?
      id = req.path.split('/')[2]
      service = Service.find_by(id: id)
      if service
        companies = service.companies
        service_res = {
          service: service,
          companies: companies
        }
        return [
          200, 
          { 'Content-Type' => 'application/json' }, 
          [ service_res.to_json ]
        ]
      else
        return [
          204, 
          { 'Content-Type' => 'application/json' }, 
          [ { error: 'service not found' }.to_json ]
        ]
      end

    else
      res.write "Path Not Found"

    end

    res.finish
  end

end

