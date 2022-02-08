# frozen_string_literal: true

RSpec.describe UserRoutes, type: :routes do
  describe 'POST /' do
    context 'invalid params' do
      it 'returns an error' do
        post '/', name: 'test', email: 'test@example.com', password: ''

        expect(last_response.status).to eq(422)
      end
    end

    context 'valid params' do
      it 'returns created status' do
        post '/', name: 'test', email: 'test@example.com', password: 'somePass123'

        expect(last_response.status).to eq(201)
      end
    end
  end
end
