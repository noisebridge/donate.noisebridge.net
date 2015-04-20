require 'rails_helper'

RSpec.describe "errors/unprocessable.html.erb", :type => :view do
  it 'shows 422 as h1' do
    render

    expect(rendered).to match /422/
  end
end
