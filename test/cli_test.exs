defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help option" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three arguments returned if given three" do
    assert parse_args(["one", "two", "99"]) == { "one", "two", 99 }
  end

  test "count is defaulted if given two arguments" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort in descencing order of dates" do
    result = sort_issues(fake_issues)
  end
end
