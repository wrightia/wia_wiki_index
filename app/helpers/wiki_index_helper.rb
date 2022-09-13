module WikiIndexHelper
  def render_wiki_hierarchy(projects)
    bookmarked_project_ids = User.current.bookmarked_project_ids
    render_project_nested_lists(projects) do |project|
      classes = project.css_classes.split
      classes += %w(icon icon-user my-project) if User.current.member_of?(project)
      classes += %w(icon icon-bookmarked-project) if bookmarked_project_ids.include?(project.id)
      s = link_to_wiki(project, {}, :class => classes.uniq.join(' '))
      s
    end
  end

  def link_to_wiki(project, options={}, html_options = nil)
    if project.archived?
      h(project.name)
    else
      wiki_url(project, options, html_options)
    end
  end

  def wiki_url(project, options, html_options)
    wiki = Wiki.joins(:project).select('wikis.*, projects.name, projects.identifier, projects.status').where('projects.status not in (?) and wikis.project_id = ?', [5,9], project.id.to_i).first
    link_to wiki["name"], "/projects/"+ wiki["identifier"] + "/" + (wiki["start_page"] == 'Wiki' ? wiki["start_page"].downcase : 'wiki' + "/" + wiki["start_page"]), class: "project-title" 
  end
end