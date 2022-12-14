defmodule Issues.CLI do
  @default_count(4)

  @moduledocs """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a table
  of issues
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
    |> sort_issues()
  end

  @doc """
    `argv` can be -h or --help, which returns :help.
      Otherwise it is a github user name, project name, and (optionally)
      the number of entries to format.
    Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1) #Grap first item of the args
    |> internal_value()
  end

  def internal_value([ user, project, count ]), do: { user, project, String.to_integer(count) }
  def internal_value([ user, project ]), do: { user, project, @default_count }
  def internal_value(_), do: :help

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({ user, project, _count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
  end

  def decode_response({ :ok, body }), do: body
  def decode_response({ :error, error }) do
    IO.puts "Error fetching from Github: #{error["message"]}"
    System.halt(2)
  end

  def sort_issues(issues) do
    issues
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end
end
