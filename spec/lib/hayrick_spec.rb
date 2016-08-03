RSpec.describe Hayrick do
  subject(:searcher) { searcher_class.new }

  let(:searcher_class) do
    Class.new do
      include Hayrick

      filter :year do |search_relation, year|
        search_relation.where("strftime('%Y', release_date) = '#{year}'")
      end

      def base_scope
        DB[:albums]
      end
    end
  end

  let!(:good) do
    create_album(
      'Good',
      'Morphine',
      Date.new(1992, 9, 8)
    )
  end

  let!(:kid_a) do
    create_album(
      'Kid A',
      'Radiohead',
      Date.new(2000, 10, 2)
    )
  end

  let!(:the_dropper) do
    create_album(
      'The Dropper',
      'Medeski, Martin & Wood',
      Date.new(2000, 10, 15)
    )
  end

  it { is_expected.to be_truthy }

  describe '#search' do
    subject(:search_results) { searcher.search(search_params) }

    let(:search_params) { { year: 2000 } }

    it { is_expected.to match_array([kid_a, the_dropper]) }

    context 'when search does not match any entries' do
      let(:search_params) { { year: 2030 } }

      it { is_expected.to be_empty }
    end

    context 'when there are no search params' do
      let(:search_params) { {} }

      it { is_expected.to eq(searcher.base_scope) }
    end

    context 'when searching using default filters' do
      let(:search_params) { { name: 'The Dropper' } }

      it { is_expected.to match_array([the_dropper]) }
    end

    context 'when search has multiple params' do
      let(:search_params) { { year: 2000, artist: 'Radiohead' } }

      it { is_expected.to match_array([kid_a]) }
    end
  end

  describe '#filter' do
    subject(:add_filter) do
      searcher_class.filter(filter_name, filter_definition)
    end

    let(:searcher_class) { Class.new { include Hayrick } }

    let(:filter_name) { :foobar }

    let(:filter_definition) { -> {} }

    let(:filter_repo) { Hayrick::FilterRepository.new }

    before do
      allow(Hayrick::FilterRepository).to receive(:new).and_return(filter_repo)
    end

    it 'calls #add on repository with given filter name and definition' do
      expect(filter_repo).to receive(:add).with(filter_name, filter_definition)

      add_filter
    end

    context 'when passing a block' do
      it 'calls #add on repository with the captured block' do
        my_block = Proc.new {}

        expect(filter_repo).to receive(:add).with(filter_name, my_block)

        searcher_class.filter(filter_name, &my_block)
      end
    end

    context 'when passing both a proc and a block' do
      it 'raises an ArgumentError' do
        my_block = Proc.new {}

        expect { searcher_class.filter(filter_name, ->{}, &my_block) }
          .to raise_error(ArgumentError)
      end
    end
  end
end
