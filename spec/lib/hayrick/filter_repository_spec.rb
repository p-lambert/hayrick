RSpec.describe Hayrick::FilterRepository do
  subject(:repository) { described_class.new(fallback_generator) }

  let(:fallback_generator) { double(call: default_filter) }

  let(:default_filter) { -> {} }

  it { is_expected.to be_truthy }

  describe '#all' do
    subject(:all) { repository.all }

    let(:filter1) { -> {} }
    let(:filter2) { -> {} }

    before do
      repository.add(:filter1, filter1)
      repository.add(:filter2, filter2)
    end

    it { is_expected.to include(filter1: filter1, filter2: filter2) }
  end

  describe '#[]' do
    subject(:returned_filter) { repository[filter_name] }

    let(:filter_name) { :foobar }

    let(:foobar_filter) do
      -> (rel, search_term) { rel.where(foobar: search_term) }
    end

    before { repository.add(:foobar, foobar_filter) }

    it { is_expected.to eq(foobar_filter) }

    context 'when there is no filter with given name' do
      let(:filter_name) { :shazam }

      it { is_expected.to eq(default_filter) }
    end
  end

  describe '#add' do
    subject(:add) { -> { repository.add(keyword, custom_filter) } }

    let(:keyword) { :custom_filter }
    let(:custom_filter) { -> {} }

    it { is_expected.to change { repository.all.size }.from(0).to(1) }

    context 'when custom filter is a callable object' do
      let(:custom_filter) do
        Class.new do
          def call; end
        end
      end

      it { is_expected.to change { repository.all.size }.from(0).to(1) }
    end

    context 'when custom filter is a class that does not respond to #call' do
      let(:custom_filter) do
        Class.new do
          def foo; end
        end
      end

      it { is_expected.to raise_error(ArgumentError) }
    end
  end
end
