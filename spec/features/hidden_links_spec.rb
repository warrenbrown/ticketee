require 'rails_helper'

RSpec.feature 'Users can only see appropriate links' do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:project) { FactoryGirl.create(:project) }

  context "non-admin users (project viewers)" do
    before do
      login_as(user)
      assign_role!(user, :viewer, project)
    end

    scenario 'Can not see new project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario 'Can not see edit project link' do
      visit project_path(project)
      expect(page).not_to have_link 'Edit Project'
    end
  end

  context 'admin users' do
    before { login_as(admin) }

    scenario 'Can see new project link' do
      visit '/'
      expect(page).to have_link "New Project"
    end

    scenario 'Can see edit project link' do
      visit project_path(project)
      expect(page).to have_link 'Edit Project'
    end
  end


  context 'regulare users' do
    before do
      login_as(user)
      assign_role!(user, :viewer, project)
    end

    scenario 'Can not see delete project link' do
      visit project_path(project)
      expect(page).not_to have_link 'Delete Project'
    end
  end

  context 'admin users' do
    before { login_as(admin) }

    scenario 'Can see delete project link' do
      visit project_path(project)
      expect(page).to have_link 'Delete Project'
    end
  end
end
