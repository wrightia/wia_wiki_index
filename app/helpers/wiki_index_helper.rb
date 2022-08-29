module WikiIndexHelper
  def load_pages_for_index
    @pages = @wiki.pages.with_updated_on.
              includes(:wiki => :project).
              includes(:parent).
              to_a

    @pages_by_parent_id = @pages.group_by(&:parent_id)
    @my_logger.info('pages')
    @my_logger.info(@pages)

  end

  def find_wiki(project_id)
    @project = Project.find(project_id)
    @wiki = @project.wiki
    @my_logger.info('test')
    @my_logger.info(@project.inspect)
    @my_logger.info(@wiki.inspect)
    render_404 unless @wiki
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end