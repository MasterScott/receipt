describe Receipt::Pdf do
  subject(:receipt) { described_class.new(params) }

  let(:params) do
    {
      id: 1,
      date: date,
      amount: 100.0,
      currency: '$',
      payer: 'Chucky Norris',
      receiver: 'Fernando Almeida',
      description: 'transaction #123',
      logo: 'logo.png',
      location: 'Sao Paulo',
      locale: :en
    }
  end

  let(:date) { Date.new(2015, 03, 10) }

  describe '#initialize' do
    it { expect(receipt.id).to eq(1) }
    it { expect(receipt.date).to eq(date) }
    it { expect(receipt.amount).to eq(100.0) }
    it { expect(receipt.currency).to eq('$') }
    it { expect(receipt.payer).to eq('Chucky Norris') }
    it { expect(receipt.receiver).to eq('Fernando Almeida') }
    it { expect(receipt.description).to eq('transaction #123') }
    it { expect(receipt.logo).to eq('logo.png') }
    it { expect(receipt.location).to eq('Sao Paulo') }
  end

  describe '#valid?' do
    it { expect(receipt.valid?).to be_truthy }

    context 'when is not valid' do
      before { params.delete(:id) }

      it { expect(receipt.valid?).to be_falsy }

      [:id, :amount, :payer, :receiver, :description].each do |p|
        it "validates the presence of #{p}" do
          params.delete(p)
          receipt.valid?

          expect(receipt.errors).to include(p)
        end
      end
    end
  end

  describe '#data' do
    subject(:data) { receipt.data }

    let(:strings) { PDF::Inspector::Text.analyze(subject).strings.join }
    let(:pages) { PDF::Inspector::Page.analyze(subject).pages }

    it { expect(data).to be_truthy }
    it { expect(pages.size).to eq(1) }
    it { expect(strings).to include('RECEIPT') }
    it { expect(strings).to include('Number: 1') }
    it { expect(strings).to include('Amount: $ 100.0') }
    it { expect(strings).to include('Received from Chucky Norris') }
    it { expect(strings).to include('the amount of $ 100.0') }
    it { expect(strings).to include('relating to transaction #123') }
    it { expect(strings).to include('Sao Paulo, March 10, 2015') }
    it { expect(strings).to include('Fernando Almeida') }
  end
      end
    end
  end
end