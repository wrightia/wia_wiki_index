class WikiIndexController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :instantiate_logger

  def index
    @user = User.current
    @projects = get_projects_with_wiki
    render :index, status: :ok
  end

  def get_projects_with_wiki
      projects_list = []
      wikis = Wiki.joins(:project).select('wikis.*, projects.name, projects.identifier, projects.status').where('projects.status not in (?)', [5,9])
      wikis.each do |wiki|
        project = Project.where('identifier = ?', wiki.identifier).first
        if project && project.id && User.current.logged? && User.current.allowed_to?(:view_project, project) && !(EnabledModule.where('project_id = ? and name = ?', project.id, 'wiki').first.nil?)
          page_count = WikiPage.where("wiki_id = ?", wiki.id).count
          if page_count > 0
            if ((Project.find(wiki.project_id).parent_id) != nil)
              projects_list << Project.find(Project.find(wiki.project_id).parent_id).id
            end

            projects_list << wiki.project_id
          end
        end
      end
      Project.where('projects.id in (?)', projects_list)
  end

  def instantiate_logger
    @my_logger ||= Logger.new("#{Rails.root}/log/wiki_index.log")
    #@my_logger.info("Start opening timesheet")
  end

end
