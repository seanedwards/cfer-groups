require 'cfer/groups/prefabs/sg_pair'

resource :Pair, 'Cfer::Prefabs::SecurityGroupPair' do
  vpc_id "1234"
  ports [ 1234, 'asdf' ]
end

