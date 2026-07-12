require "rails_helper"

RSpec.describe "Health check", type: :system do
  it "abre o endpoint em Chromium headless" do
    visit "/up"

    expect(page).to have_css("body[style='background-color: green']")
  end
end
