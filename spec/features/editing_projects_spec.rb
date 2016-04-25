require 'rails_helper'

RSpec.feature 'User can edit projects' do
  before do
    FactoryGirl.create(:project, name: 'Sublime Text 3')

    visit '/'
    click_link 'Sublime Text 3'
    click_link 'Edit Project'
  end
  scenario 'With valid attributes' do
    fill_in 'Name', with: 'Sublime Text 4.0'
    click_button 'Update Project'

    expect(page).to have_content 'Project has been updated.'
    expect(page).to have_content 'Sublime Text 4.0'
  end

  scenario 'with invalid attributes' do
    fill_in 'Name', with: ''
    click_button 'Update Project'

    expect(page).to have_content 'Project has not been updated.'
  end
end
