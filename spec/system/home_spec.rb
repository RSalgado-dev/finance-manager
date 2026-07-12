require "rails_helper"

RSpec.describe "Página inicial", type: :system do
  it "permite navegar pela página institucional" do
    visit root_path

    expect(page).to have_css("main#main-content", count: 1)
    expect(page).to have_css("h1", text: "Finance Manager")
    expect(page).to have_link("Início", href: root_path)

    click_link "Início"

    expect(page).to have_current_path(root_path)
  end

  it "não cria overflow horizontal nas larguras principais" do
    [ [ 360, 800 ], [ 768, 900 ], [ 1280, 900 ] ].each do |width, height|
      page.current_window.resize_to(width, height)
      visit root_path

      has_overflow = page.evaluate_script("document.documentElement.scrollWidth > document.documentElement.clientWidth")
      overflow_elements = page.evaluate_script(<<~JAVASCRIPT)
        Array.from(document.querySelectorAll("body *"))
          .filter((element) => element.getBoundingClientRect().right > document.documentElement.clientWidth)
          .slice(0, 5)
          .map((element) => `${element.tagName}.${element.className}: ${Math.round(element.getBoundingClientRect().right)}px`)
      JAVASCRIPT
      dimensions = page.evaluate_script(<<~JAVASCRIPT)
        (() => {
          const main = document.querySelector("main");
          const style = getComputedStyle(main);
          return {
            innerWidth: window.innerWidth,
            clientWidth: document.documentElement.clientWidth,
            bodyWidth: document.body.getBoundingClientRect().width,
            mainWidth: main.getBoundingClientRect().width,
            boxSizing: style.boxSizing,
            paddingLeft: style.paddingLeft,
            paddingRight: style.paddingRight
          };
        })()
      JAVASCRIPT

      expect(has_overflow).to be(false), "overflow horizontal detectado em #{width}px: #{dimensions}; #{overflow_elements.join(", ")}"
    end
  end
end
