# frozen_string_literal: true

RSpec.describe UserSessionRoutes, type: :routes do
  describe 'POST /' do
    context 'invalid params' do
      it 'returns an error' do
        post '/', email: 'test@example.com', password: ''

        expect(last_response.status).to eq(422)
      end

      it 'returns an error' do
        post '/', email: 'test@example.com', password: 'invalid'

        expect(last_response.status).to eq(401)
        expect(response_body['errors']).to include('detail' => "Session can't be created")
      end
    end

    context 'valid params' do
      let(:token) { 'jwt_token' }

      before do
        create(:user, email: 'test@example.com', password: 'somePass123')

        allow(JWT).to receive(:encode).and_return(token)
      end

      it 'returns created status' do
        post '/', email: 'test@example.com', password: 'somePass123'

        expect(last_response.status).to eq(201)
        expect(response_body['meta']).to eq('token' => token)
      end
    end
  end
end
