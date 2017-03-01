include_template 'network_template.rb'

resource :Network, 'Cfer::Examples::Network' do
  vpc_name "my-network"
  subnets 3
end

