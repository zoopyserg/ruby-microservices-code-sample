# frozen_string_literal: true

RSpec.describe Auth::FetchUserService do
  subject { described_class }

  context 'valid params' do
    let(:session) { create(:user_session) }

    it 'assigns user' do
      result = subject.call(session.uuid)

      expect(result.user).to eq(session.user)
    end
  end

  context 'invalid params' do
    it 'does not assign user' do
      result = subject.call('invalid')

      expect(result.user).to be_nil
    end

    it 'returns an error' do
      result = subject.call('invalid')

      expect(result).to be_failure
      expect(result.errors).to include('Access forbidden')
    end
  end
end
