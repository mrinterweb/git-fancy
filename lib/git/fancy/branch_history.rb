# frozen_string_literal: true

require_relative 'db'
require 'tty-logger'

module Git
  module Fancy
    # SQLite3 database to keep track of recent branches
    class BranchHistory
      Branch = Struct.new(:name, :last_accessed, :note)

      attr_reader :logger

      def logger
        @logger ||= TTY::Logger.new
      end

      def db = Db.instance.db

      def local_branch_names
        `git branch --sort='-*authordate' --format='%(refname:short)'`.split("\n")
      end

      def local_branches
        to_branches(local_branch_names)
      end

      def recent_branches(limit: 10, include_current: false)
        if include_current
          sql = <<~SQL
            SELECT name, last_accessed, note FROM recent_branches ORDER BY last_accessed DESC LIMIT ?
          SQL
          return to_branches db.execute(sql, [limit])
        end

        sql = <<~SQL
          SELECT name, last_accessed, note FROM recent_branches WHERE name != ? ORDER BY last_accessed DESC LIMIT ?
        SQL
        to_branches db.execute(sql, [current_branch, limit])
      end

      def add_branch(branch_name)
        sql = <<~SQL
          INSERT INTO recent_branches (name, last_accessed) VALUES (?, ?)
            ON CONFLICT DO UPDATE SET last_accessed=?
        SQL
        time = Time.now.to_i
        db.execute(sql, [branch_name, time, time])
      end

      # Removes branches in the db that no longer exist locally
      def clean_missing_branches
        sql = <<~SQL
          select name from recent_branches where name NOT IN (#{local_branch_names.map { |b| "'#{b}'" }.join(',')})
        SQL
        missing_branch_names = db.execute(sql).flatten

        del_sql = "DELETE FROM recent_branches WHERE name IN (#{missing_branch_names.map { |b| "'#{b}'" }.join(',')})"

        return if missing_branch_names.empty?

        db.execute(del_sql)
        logger.info "Removed missing local branches: #{missing_branch_names.join(', ')} branches from database"
      end

      def add_note(note, branch_name = nil)
        branch_name ||= current_branch

        sql = <<~SQL
          UPDATE recent_branches SET note = ? WHERE name = ?
        SQL
        db.execute(sql, [note, branch_name])
      end

      def branches_matching_notes(search_term)
        sql = <<~SQL
          SELECT name, last_accessed, note
          FROM recent_branches
          WHERE note IS NOT NULL
            AND LOWER(note) LIKE ?
          ORDER BY last_accessed DESC
        SQL
        to_branches db.execute(sql, ["%#{search_term.downcase}%"])
      end

      def purge_history!
        db.execute('DROP TABLE recent_branches')
      end

      def inspect_history
        db.execute('SELECT * FROM recent_branches ORDER BY last_accessed DESC')
      end

      def current_branch
        `git branch --show-current`.chomp
      end

      private

      def to_branches(rows)
        rows.map { |r| Branch.new(*r) }
      end
    end
  end
end

