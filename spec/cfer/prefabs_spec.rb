require "spec_helper"

describe 'Cfer::Prefabs' do
  it 'Cfer::Prefabs::SecurityGroupPair' do
    stack = Cfer::stack_from_file('spec/support/stacks/prefabs/sg_pair.rb')
    expect(stack["Resources"]).to eq({
      "PairServerSG" => {
        "Type" => "AWS::EC2::SecurityGroup",
        "Properties" => {
          "VpcId" => "1234"
        }
      },
      "PairClientSG" => {
        "Type" => "AWS::EC2::SecurityGroup",
        "Properties" => {
          "VpcId" => "1234"
        }
      },
      "PairServerSGClientIngress0" => {
        "Type" => "AWS::EC2::SecurityGroupIngress",
        "Properties" => {
          "GroupId" => { "Ref" => "PairServerSG" },
          "IpProtocol" => "tcp",
          "FromPort" => 1234,
          "ToPort" => 1234,
          "SourceSecurityGroupId" => { "Ref" => "PairClientSG" }
        }
      },
      "PairServerSGClientIngress1" => {
        "Type" => "AWS::EC2::SecurityGroupIngress",
        "Properties" => {
          "GroupId" => { "Ref" => "PairServerSG" },
          "IpProtocol" => "tcp",
          "FromPort" => "asdf",
          "ToPort" => "asdf",
          "SourceSecurityGroupId" => { "Ref" => "PairClientSG" }
        }
      },
      "Pair" => {
        "Type" => "AWS::CloudFormation::WaitConditionHandle",
        "DependsOn" => ["PairClientSG", "PairServerSG", "PairServerSGClientIngress0", "PairServerSGClientIngress1"],
        "Properties" => {},
        "Metadata" => {
          "Type" => "Cfer::Prefabs::SecurityGroupPair",
          "Properties" => {
            "VpcId" => "1234",
            "Ports" => [ 1234, 'asdf' ]
          }
        }
      }
    })
  end
end


