require 'rails_helper'

RSpec.feature 'users can view tickets' do
  before do
    pat = FactoryGirl.create(:project, name: 'Project Pat')
    FactoryGirl.create(:ticket, project: pat,
      name: 'Make it shiny!', description: 'Gradients starburst oh my!!!')

    ie = FactoryGirl.create(:project, name: 'Internet Explorer')
    FactoryGirl.create(:ticket, project: ie, name: 'Standard compliance', description: 'Is not a joke')

    visit '/'
  end

  scenario 'for a givein project' do
    click_link 'Project Pat'

    expect(page).to have_content 'Make it shiny!'
    expect(page).to_not have_content 'Standard compliance'

    click_link 'Make it shiny!'
    within("#ticket h2") do
      expect(page).to have_content 'Make it shiny!'
    end
    expect(page).to have_content 'Gradients starburst oh my!!!'
  end
end
