class WikiIndexController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :instantiate_logger

  def index
    @user = User.current
    @wikis = get_wikis
    render :index, status: :ok
  end

  def get_wikis
      result = []
      wikis = Wiki.joins(:project).select('wikis.*, projects.name, projects.identifier, projects.status').where('projects.status not in (?)', [5,9])
      wikis.each do |wiki|
        page_count = WikiPage.where("wiki_id = ?", wiki.id).count
        if page_count > 0
          wiki = wiki.attributes
          wiki['num_pages'] = page_count
          result << wiki
        end
      end
      result
  end

  def instantiate_logger
    @my_logger ||= Logger.new("#{Rails.root}/log/wiki_index.log")
    #@my_logger.info("Start opening timesheet")
  end

end
