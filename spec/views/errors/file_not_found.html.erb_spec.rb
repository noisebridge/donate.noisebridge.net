require 'rails_helper'

RSpec.describe "errors/file_not_found.html.erb", :type => :view do
  it 'shows 404 as h1' do
    render

    expect(rendered).to match /404/
  end
end
