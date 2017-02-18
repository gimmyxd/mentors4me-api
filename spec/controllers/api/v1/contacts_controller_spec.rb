describe Api::V1::ContactsController do
  let(:format) { :json }
  let(:http_method) { :post }
  let(:action) { :create }
  before do
    stub_request(:post, 'https://api.sendgrid.com/v3/mail/send')
      .to_return(status: 200, body: '', headers: {})
  end
  it 'returns 200' do
    send_request(http_method, action, {}, format)
    expect(response.status).to eq(200)
  end
end
