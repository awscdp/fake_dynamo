require 'spec_helper'

module FakeDynamo
  describe DB do
    let(:data) do
      {
        "TableName" => "Table1",
        "KeySchema" =>
        {"HashKeyElement" => {"AttributeName" => "AttributeName1","AttributeType" => "S"},
          "RangeKeyElement" => {"AttributeName" => "AttributeName2","AttributeType" => "N"}},
        "ProvisionedThroughput" => {"ReadCapacityUnits" => 5,"WriteCapacityUnits" => 10}
      }
    end

    it 'should not allow to create duplicate tables' do
      subject.create_table(data)
      expect { subject.create_table(data) }.to raise_error(ResourceInUseException, /duplicate/i)
    end

    it 'should fail on unknown operation' do
      expect { subject.process('unknown', data) }.to raise_error(UnknownOperationException, /unknown/i)
    end

    context 'DescribeTable' do
      subject { DB.new }

      it 'should describe table' do
        subject.create_table(data)
        subject.describe_table({'TableName' => 'Table1'})
      end
    end
  end
end
