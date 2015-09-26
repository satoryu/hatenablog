# coding: utf-8

require 'test/unit'

require './blog_entry'

module Hatena
  class BlogEntryTest < Test::Unit::TestCase
    class << self
      def startup
        @@xml = <<XML
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:app='http://www.w3.org/2007/app' xmlns='http://www.w3.org/2005/Atom'>
<id>tag:blog.hatena.ne.jp,2013:blog-test_user-6653458415121899222-6653458415122161047</id>
<link href='https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047' rel='edit'/>
<link href='http://test-user.hatenablog.com/entry/2015/01/01/123456' rel='alternate' type='text/html'/>
<author><name>test_user</name></author>
<title>Test title</title>
<updated>2015-01-01T12:34:56+09:00</updated>
<published>2015-01-01T12:34:56+09:00</published>
<app:edited>2015-01-01T12:34:56+09:00</app:edited>
<summary type='text'>This is the test entry.</summary>
<content type='text/x-markdown'>This is the test entry.</content>
<hatena:formatted-content xmlns:hatena='http://www.hatena.ne.jp/info/xmlns#' type='text/html'>&lt;p&gt;This is the test entry.&lt;/p&gt;
</hatena:formatted-content>

<category term='Ruby'/>

<category term='Test'/>

<app:control>
  <app:draft>no</app:draft>
</app:control>

</entry>
XML
        @@sut = BlogEntry.new(@@xml);
      end

      def shutdown
      end
    end

    def setup
    end

    def teardown
    end

    test 'get the entry ID' do
      assert_equal '6653458415122161047', @@sut.id
    end

    test 'get the author name' do
      assert_equal 'test_user', @@sut.author_name
    end

    test 'get the title' do
      assert_equal 'Test title', @@sut.title
    end

    test 'get the URI' do
      assert_equal 'http://test-user.hatenablog.com/entry/2015/01/01/123456', @@sut.uri
    end

    test 'get the edit URI' do
      assert_equal 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047', @@sut.edit_uri
    end

    test 'this entry is not draft' do
      assert_false @@sut.draft?
    end

    test 'get categores' do
      assert_equal ['Ruby', 'Test'], @@sut.categories
    end

    test 'changing categories array does not influence to the original categories array' do
      cats = @@sut.categories
      cats << 'Rails'
      cats[1] = 'Sinatra'
      assert_not_equal cats, @@sut.categories
    end

    test 'get the content' do
      assert_equal 'This is the test entry.', @@sut.content
    end

    test 'get the XML representation' do
      assert_equal @@xml, @@sut.to_xml
    end
  end
end
