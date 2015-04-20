require 'rails_helper'

RSpec.describe "errors/internal_server_error.html.erb", :type => :view do
  it 'shows 500 as h1' do
    render

    expect(rendered).to match /500/
  end
end
