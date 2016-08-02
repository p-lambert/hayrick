RSpec.describe Hayrick::DefaultFilterGenerator do
  subject(:filter_generator) { described_class.new }

  it { is_expected.to be_truthy }

  describe '#call' do
    subject(:filter) { filter_generator.call(field_name) }

    let(:field_name) { :foobar }

    it { is_expected.to be_a(Proc) }

    context 'when performing a search using the returned filter' do
      let(:search_relation) { double }

      before { allow(search_relation).to receive(:where) }

      it 'matches field_name against given value' do
        expect(search_relation).to receive(:where).with(foobar: :some_value)

        filter.call(search_relation, :some_value)
      end
    end
  end
end
