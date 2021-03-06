require 'test_helper'

require 'hatenablog/entry'

module Hatenablog
  class EntryTest < Test::Unit::TestCase
    sub_test_case 'load the document from the XML text' do
      setup do
        File.open('test/fixture/entry.xml') do |f|
          @xml = f.read
        end
        @sut = Hatenablog::Entry.load_xml(@xml);
      end

      test 'get the entry ID' do
        assert_equal '6653458415122161047', @sut.id
      end

      test 'get the author name' do
        assert_equal 'test_user', @sut.author_name
      end

      test 'get the title' do
        assert_equal 'Test title', @sut.title
      end

      test 'get the URI' do
        assert_equal 'http://test-user.hatenablog.com/entry/2015/01/01/123456', @sut.uri
      end

      test 'get the edit URI' do
        assert_equal 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/edit/6653458415122161047', @sut.edit_uri
      end

      test 'this entry is not draft' do
        assert_false @sut.draft?
      end

      test 'get categores' do
        assert_equal ['Ruby', 'Test'], @sut.categories
      end

      test 'modified a categories array does not influence to the original categories array' do
        modified = @sut.categories
        modified << 'Rails'
        modified[1] = 'Sinatra'
        assert_not_equal modified, @sut.categories
      end

      test 'get the updated time' do
        assert_equal '2015-01-01T12:34:56+09:00', @sut.updated.iso8601
      end

      test 'get the content' do
        assert_equal 'This is the test entry.', @sut.content
      end

      test 'get the XML representation' do
        assert_equal @xml, @sut.to_xml
      end

      test 'get each category' do
        actual = []
        @sut.each_category do |category|
          actual << category
        end
        assert_equal ['Ruby', 'Test'], actual
      end

      sub_test_case 'modify an instance attributes' do
        test 'modify the author name' do
          @sut.author_name = 'test_user_2'
          assert_equal @xml.gsub('<name>test_user</name>', '<name>test_user_2</name>'), @sut.to_xml
        end

        test 'modify the title' do
          @sut.title = 'Modified title'
          assert_equal @xml.gsub('Test title', 'Modified title'), @sut.to_xml
        end

        test 'modify the URI' do
          @sut.uri = 'http://test-user.hatenablog.com/entry/2015/01/01/234567'
          assert_equal @xml.gsub('entry/2015/01/01/123456', 'entry/2015/01/01/234567'), @sut.to_xml
        end

        test 'modify the edit URI' do
          @sut.edit_uri = 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/edit/6653458415122161048'
          assert_equal @xml.gsub('edit/6653458415122161047', 'edit/6653458415122161048'), @sut.to_xml
        end

        test 'modify the content' do
          @sut.content = 'modified test entry'
          assert_equal @xml.gsub("<content type='text/x-markdown'>This is the test entry.</content>",
                                 "<content type='text/x-markdown'>modified test entry</content>"), @sut.to_xml
        end

        test 'modify the draft status' do
          @sut.draft = 'yes'
          assert_equal @xml.gsub('no', 'yes'), @sut.to_xml
        end

        test 'modify the updated time' do
          @sut.updated = '2015-02-02T12:34:56+09:00'
          assert_equal @xml.gsub('<updated>2015-01-01', '<updated>2015-02-02'), @sut.to_xml
        end

        test 'modify categories' do
          @sut.categories = ['Ruby', 'Atom']
          assert_equal @xml.gsub("term='Test'", "term='Atom'").gsub(/\s/, ''), @sut.to_xml.gsub(/\s/, '')
        end
      end
    end

    sub_test_case 'build from initialize arguments' do
      setup do
        @sut = Hatenablog::Entry.create(uri:         'http://test-user.hatenablog.com/entry/2015/01/01/123456',
                                        edit_uri:    'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047',
                                        author_name: 'test_user',
                                        title:       'Test title',
                                        content:     'This is the test entry.',
                                        draft:       'yes',
                                        categories:  ['Ruby', 'Test'],
                                        updated:     '2015-01-01T01:23:45+09:00')
      end

      test 'get the entry ID' do
        assert_equal '6653458415122161047', @sut.id
      end

      test 'get the author name' do
        assert_equal 'test_user', @sut.author_name
      end

      test 'get the title' do
        assert_equal 'Test title', @sut.title
      end

      test 'get the URI' do
        assert_equal 'http://test-user.hatenablog.com/entry/2015/01/01/123456', @sut.uri
      end

      test 'get the edit URI' do
        assert_equal 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047', @sut.edit_uri
      end

      test 'this entry is draft' do
        assert_true @sut.draft?
      end

      test 'get categores' do
        assert_equal ['Ruby', 'Test'], @sut.categories
      end

      test 'get each category' do
        actual = []
        @sut.each_category do |category|
          actual << category
        end
        assert_equal ['Ruby', 'Test'], actual
      end

      test 'get the updated datetime' do
        assert_equal '2015-01-01T01:23:45+09:00', @sut.updated.iso8601
      end
    end

    sub_test_case 'build with block' do
      setup do
        @sut = Hatenablog::Entry.create do |entry|
          entry.uri         = 'http://test-user.hatenablog.com/entry/2015/01/01/123456'
          entry.edit_uri    = 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047'
          entry.author_name = 'test_user'
          entry.title       = 'Test title'
          entry.content     = 'This is the test entry.'
          entry.draft       = 'yes'
          entry.categories  = ['Ruby', 'Test']
          entry.updated     = '2015-01-01T01:23:45+09:00'
        end
      end

      test 'get the entry ID' do
        assert_equal '6653458415122161047', @sut.id
      end

      test 'get the author name' do
        assert_equal 'test_user', @sut.author_name
      end

      test 'get the title' do
        assert_equal 'Test title', @sut.title
      end

      test 'get the URI' do
        assert_equal 'http://test-user.hatenablog.com/entry/2015/01/01/123456', @sut.uri
      end

      test 'get the edit URI' do
        assert_equal 'https://blog.hatena.ne.jp/test_user/test-user.hatenablog.com/atom/entry/6653458415122161047', @sut.edit_uri
      end

      test 'this entry is draft' do
        assert_true @sut.draft?
      end

      test 'get categores' do
        assert_equal ['Ruby', 'Test'], @sut.categories
      end

      test 'get each category' do
        actual = []
        @sut.each_category do |category|
          actual << category
        end
        assert_equal ['Ruby', 'Test'], actual
      end

      test 'get the updated datetime' do
        assert_equal '2015-01-01T01:23:45+09:00', @sut.updated.iso8601
      end
    end

    sub_test_case 'build with arguments and block' do
      setup do
        @sut = Hatenablog::Entry.create(author_name: 'test_user',
                                        categories: ['Ruby', 'Test']) do |entry|
          entry.title    = 'Test title'
          entry.content  = 'This is the test entry.'
          entry.draft    = 'yes'
          entry.updated  = '2015-01-01T01:23:45+09:00'
        end
      end

      test 'get the author name' do
        assert_equal 'test_user', @sut.author_name
      end

      test 'get the title' do
        assert_equal 'Test title', @sut.title
      end

      test 'this entry is draft' do
        assert_true @sut.draft?
      end

      test 'get categores' do
        assert_equal ['Ruby', 'Test'], @sut.categories
      end

      test 'get each category' do
        actual = []
        @sut.each_category do |category|
          actual << category
        end
        assert_equal ['Ruby', 'Test'], actual
      end

      test 'get the updated datetime' do
        assert_equal '2015-01-01T01:23:45+09:00', @sut.updated.iso8601
      end
    end
  end
end
