Redmine::Plugin.register :wia_wiki_index do
  name 'Wia Wiki Index plugin'
  author 'Author name'
  description 'This is a plugin that adds a wiki index on the top main menu'
  version '0.0.2'
  url 'https://www.wrightia.com'
  author_url 'https://www.wrightia.com'

  menu :top_menu, :wiki_index, { :controller => 'wiki_index', :action => 'index' }, :caption => 'Wiki Index', :before => :administration, :if => Proc.new { !User.current.type.eql?('AnonymousUser') }

end