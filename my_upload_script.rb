require 'tess_api_client'


content_provider = Tess::API::ContentProvider.new(
    title: 'My Organization Name',
    url: 'https://my.org.org/',
    image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Smiley.svg/2000px-Smiley.svg.png',
    description: "We're sharing our content with TeSS!")



material = Tess::API::Material.new(
    title: 'How to use TeSS API',
    url: 'http://mysite.org/tess_api',
    short_description: 'Everything you need to know to get you started using the TeSS API',
    doi: 'http://dx.doi.org/10002-20fk',
    remote_updated_date: Time.now,
    content_provider: content_provider, # The content provider is created if needed when the material is created.
    keywords: ['tutorial', 'TeSS', 'sharing'])

material.create
