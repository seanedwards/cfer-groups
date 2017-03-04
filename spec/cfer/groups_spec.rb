require "spec_helper"

describe Cfer::Groups do
  it 'works with simple groups' do
    stack = Cfer::stack_from_file('spec/support/stacks/simple_group.rb')
    expect(stack["Resources"]).to eq({
      "TestResourceTest" => {
        "Type" => "Cfer::TestResource",
        "Properties" => {
          "TestProperty" => 1234
        }
      },
      "TestResource" => {
        "Type" => "AWS::CloudFormation::WaitConditionHandle",
        "Properties" => {},
        "DependsOn" => ["TestResourceTest"],
        "Metadata" => {
          "Type" => "Cfer::Groups::SimpleGroup",
          "Properties" => {
            "TestValue" => 1234
          }
        }
      }
    })
  end

  it 'works with functions' do
    stack = Cfer::stack_from_file('spec/support/stacks/functions.rb')
    expect(stack["Resources"]).to eq({
      "TestResourceTestA" => {
        "Type" => "Cfer::TestResource",
        "Properties" => {
          "TestProperty" => 1234
        }
      },
      "TestResourceTestB" => {
        "Type" => "Cfer::TestResource",
        "Properties" => {
          "TestA" => { "Ref" => "TestResourceTestA" },
          "TestAtt" => { "Fn::GetAtt" => ["TestResourceTestA", "TestAtt"] },
          "TestName" => "TestResourceTestA"
        }
      },
      "TestResource" => {
        "Type" => "AWS::CloudFormation::WaitConditionHandle",
        "Properties" => {},
        "DependsOn" => ["TestResourceTestA", "TestResourceTestB"],
        "Metadata" => {
          "Type" => "Cfer::Groups::SimpleGroup",
          "Properties" => {
            "TestValue" => 1234
          }
        }
      }
    })
  end

  it 'works with nested groups' do
    stack = Cfer::stack_from_file('spec/support/stacks/nested_group.rb')
    expect(stack["Parameters"]).to eq({
      "OuterInnerParameter" => { "Type" => "String" }
    })
    expect(stack["Outputs"]).to eq({
      "OuterInnerOutput" => { "Value" => "OutputValue" }
    })
    expect(stack["Resources"]).to eq({
      "OuterInnerRoot" => {
        "Type" => "Cfer::TestResource",
        "Properties" => {
          "TestReference" => { "Ref" => "OuterInnerParameter" },
          "TestProperty" => 1234
        }
      },
      "OuterInner" => {
        "Type" => "AWS::CloudFormation::WaitConditionHandle",
        "Properties" => {},
        "DependsOn" => ["OuterInnerRoot"],
        "Metadata" => {
          "Type" => "Cfer::Groups::InnerGroup",
          "Properties" => {
            "TestProperty" => 1234
          }
        }
      },
      "Outer" => {
        "Type" => "AWS::CloudFormation::WaitConditionHandle",
        "Properties" => {},
        "DependsOn" => ["OuterInner"],
        "Metadata" => {
          "Type" => "Cfer::Groups::OuterGroup",
          "Properties" => {
            "TestValue" => 1234
          }
        }
      }
    })
  end
end

