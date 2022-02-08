# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  subject { described_class }

  context 'valid parameters' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'somePass123') }

    it 'creates a new session' do
      expect { subject.call('test@example.com', 'somePass123') }
        .to change { user.sessions(reload: true).count }.from(0).to(1)
    end

    it 'assigns session' do
      result = subject.call('test@example.com', 'somePass123')

      expect(result.session).to be_kind_of(UserSession)
    end
  end

  context 'invalid params' do
    context 'missing user' do
      it 'does not create session' do
        expect { subject.call('test@example.com', 'somePass123') }
          .not_to change { UserSession.count }
      end

      it 'adds an error' do
        result = subject.call('test@example.com', 'somePass123')

        expect(result).to be_failure
        expect(result.errors).to include("Session can't be created")
      end
    end

    context 'invalid password' do
      let!(:user) { create(:user, email: 'test@example.com', password: 'somePass123') }
  
      it 'does not create session' do
        expect { subject.call('test@example.com', 'invalid') }
          .not_to change { UserSession.count }
      end

      it 'adds an error' do
        result = subject.call('test@example.com', 'invalid')

        expect(result).to be_failure
        expect(result.errors).to include("Session can't be created")
      end
    end
  end
end
