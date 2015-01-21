class Download
  def self.platforms
    Repositories.descendants
      .reject { |platform| platform == Repositories::Base }
      .sort_by(&:name)
  end
  def self.total
    platforms.sum { |pm| pm.project_names.length }
  end

  def self.import
    platforms.each(&:import)
  end

  def self.keys
    platforms.flat_map(&:keys).map(&:to_s).sort.uniq
  end

  def self.github_repos
    projects = Project.with_repository_url
      .where('id NOT IN (SELECT DISTINCT(project_id) FROM github_repositories)')
      .limit(4500).offset(100)
      .select(&:github_url)
      .compact
    Parallel.each(projects, :in_threads => 10) do |project|
      ActiveRecord::Base.connection_pool.with_connection do
        project.update_github_repo
      end
    end
  end
end
