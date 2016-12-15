defmodule Archiver do
  def archive(url, id) do
    summary = Readability.summarize(url)
    page = summary.article_html
    File.write("priv/static/archive/#{id}.html", page)
  end
end
