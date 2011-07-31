require 'test_helper'

class SqlTemplateTest < ActiveSupport::TestCase
  test "resolver should return a template with body" do
    resolver = SqlTemplate::Resolver.new
    details  = { :formats => [:html], :locale => [:en], :handlers => [:erb] }

    assert resolver.find_all("index", "posts", false, details).empty?

    SqlTemplate.create!(
      :body => "<%= 'Hi from SqlTemplate!' %>",
      :path => "posts/index",
      :format => "html",
      :locale => "en",
      :handler => "erb",
      :partial => false)

    template = resolver.find_all("index", "posts", false, details).first
    assert_kind_of ActionView::Template, template

    assert_equal "<%= 'Hi from SqlTemplate!' %>", template.source
    assert_match /SqlTemplate - \d+ - "posts\/index"/, template.identifier
    assert_equal ActionView::Template::Handlers::ERB, template.handler
    assert_equal [:html], template.formats
    assert_equal "posts/index", template.virtual_path
  end
end
