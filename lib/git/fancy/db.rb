# frozen_string_literal: true

module Git
  module Fancy
    class Db
      FILE_PATH = File.join(Dir.home, '.git-fancy.db')
      include Singleton

      attr_reader :db

      def initialize
        @db = SQLite3::Database.new FILE_PATH
        create_recent_branches_table
      end

      def create_recent_branches_table
        return if table_exists?('recent_branches')

        puts 'Creating and indexing recent_branches'
        db.execute <<~SQL
          CREATE TABLE recent_branches(
            name TEXT,
            last_accessed INTEGER,
            note TEXT
          );
        SQL
        db.execute 'CREATE UNIQUE INDEX recent_branches_branch_name ON recent_branches(name);'
        db.execute 'CREATE INDEX recent_branches_last_accessed ON recent_branches(last_accessed);'
      end

      def table_exists?(table_name)
        !db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name=?;", [table_name]).empty?
      end
    end
  end
end
