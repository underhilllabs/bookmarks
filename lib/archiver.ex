defmodule Archiver do
  def archive(url, user_id, bookmark_id) do
    summary = Readability.summarize(url)
    page = summary.article_html
    path = "priv/static/archive/#{user_id}"
    unless File.exists?(path) do
      File.mkdir(path)
    end
    File.write("#{path}/#{bookmark_id}.html", page)
  end
end
