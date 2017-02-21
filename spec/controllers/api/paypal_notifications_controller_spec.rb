require "rails_helper"

describe Api::PaypalNotificationsController, type: :controller do
  context 'POST #create' do
    it 'verifies the raw_post from the request' do
      expect(PaypalNotification).to receive(:verify_raw_payload)
        .once
        .with('raw')
        .and_return(true)

      allow(PaypalNotification).to receive(:create_from_payload)

      post :create, body: 'raw'

      expect(response.success?).to eq(true)
    end

    it 'returns UNVERIFIED with status 400 if the validation fails' do
      expect(PaypalNotification).to receive(:verify_raw_payload).and_return(false)
      post :create

      expect(response.success?).to eq(false)
      expect(response.status).to eq(400)
      expect(response.body).to eq("UNVERIFIED")
    end

    it 'creates a local PaypalNotification record if validation succeeds' do
      expect(PaypalNotification).to receive(:verify_raw_payload).and_return(true)

      expect {
        post :create, params: { 'txn_id' => '123' }
      }.to change(PaypalNotification, :count).by(1)

      expect(response.success?).to eq(true)
      expect(PaypalNotification.find_by(notification_id: '123').present?).to eq(true)
    end

    it 'returns INVALID with 400 upon duplicate notification requests' do
      expect(PaypalNotification).to receive(:verify_raw_payload).and_return(true)
      PaypalNotification.create!(notification_id: '123', payload: { key: 'value' })

      expect {
        post :create, params: { 'txn_id' => '123' }
      }.to_not change(PaypalNotification, :count)

      expect(response.success?).to eq(false)
      expect(response.status).to eq(400)
      expect(response.body).to eq('INVALID')
    end
  end
end
