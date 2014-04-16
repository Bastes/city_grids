shared_examples 'it generates automatically an admin token' do |options = {}|
  options[:with_hash_base] ||= ->(instance, now) { "#{now}" }

  describe '#set_admin' do
    let(:model) { subject.class.model_name.i18n_key }

    describe 'the method itself' do
      let(:now) { Time.now }

      before { allow(Digest::MD5).to receive(:new).and_return(double().tap { |d| allow(d).to receive(:update).with(options[:with_hash_base].call(instance, now)).and_return('some hash') }) }
      before { Timecop.freeze(now) { instance.set_admin } }

      describe '#admin was empty' do
        let(:instance) { build model, admin: nil }

        it { expect(instance.admin).to eq 'some hash' }
      end

      describe 'admin was set' do
        let(:instance) { build model, admin: 'some other hash' }

        it { expect(instance.admin).to eq 'some other hash' }
      end
    end

    describe 'hooks' do
      let(:instance) { build model, admin: nil }

      it { expect { instance.save }.to change(instance, :admin) }
    end
  end
end
