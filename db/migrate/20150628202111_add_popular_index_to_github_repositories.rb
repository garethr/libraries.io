class AddPopularIndexToGithubRepositories < ActiveRecord::Migration
  def change
    remove_index :github_repositories, :fork
    add_index :github_repositories, :fork, where: "fork = false"
    add_index :github_repositories, :private, where: "private = false"
    add_index :github_repositories, :language
    add_index :github_repositories, :license
  end
end
