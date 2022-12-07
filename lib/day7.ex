defmodule Day7 do

  defmodule Node do
    @type t :: %Node{ name: String.t, parent: nil | t, children: [], dir: boolean, size: non_neg_integer() }
    defstruct [:name, :parent, children: [], dir: false, size: 0]

    @spec new(String.t, nil | t) :: t
    def new(name, parent, opts \\ []) do
      %Node {
        name:     name,
        parent:   parent,
        dir:      Keyword.get(opts, :dir, false),
        size:     Keyword.get(opts, :size, nil),
        children: Keyword.get(opts, :children, [])
      }
    end

    @spec add_child(t, t) :: t
    def add_child(parent, child) do
      Node.new(
        parent.name,
        parent.parent,
        dir: parent.dir,
        size: parent.size,
        children: [child.name | parent.children]
      )
    end
  end

  defimpl String.Chars, for: Node do
    def to_string(node) when is_nil(node), do: "(null)"
    def to_string(node) do
      "#{node.name} (children = #{length(node.children)})"
    end
  end

  @spec parse(list(String.t)) :: Node.t
  def parse(lines) do
    root = Node.new("", "", dir: true)
    items = %{ "" => root }

    {items, _ } = Enum.reduce(lines, {items, root}, fn (line, {items, node}) ->
      if String.starts_with?(line, "$ ") do
        process_cmd(line, node, items)
      else
        process_output(line, node, items)
      end
    end)

    items
  end

  def populate_sizes(items, path) do
    node = items[path]
    unless is_nil(node.size) do
      {items, node.size}
    else
      items = Enum.reduce(node.children, items, fn path, items ->
        {items, size} = populate_sizes(items, path)
        #        IO.puts("calculated #{path} to be #{size}")
        Map.merge(items, %{ path => Map.merge(items[path], %{ size: size }) })
      end)

      size = items[path].children
      |> Enum.map(&(items[&1].size))
      |> Enum.sum

      {Map.merge(items, %{ path => Map.merge(items[path], %{ size: size }) }), size }
    end
  end

  def process_cmd("$ " <> command, node, items) do
    #IO.puts("command is #{command} node is #{node}")
    case command do
      "cd /"  -> {items, items[""]}
      "cd .." -> {items, items[node.parent]}
      "ls"    -> {items, node}
      "cd " <> which -> {items, items["#{node.name}/#{which}"]}
      cmd -> raise "Giving Up on command #{cmd}"
    end
  end

  def process_output("dir " <> dir, node, items) do
    child = Node.new("#{node.name}/#{dir}", node.name, dir: true)
    node = Node.add_child(node, child)
    items = Map.merge(items, %{ child.name => child, node.name => node })
    { items, node }
  end

  def process_output(line, node, items) do
    [size, file] = String.split(line, " ")
    size = String.to_integer(size, 10)
    child = Node.new("#{node.name}/#{file}", node.name, dir: false, size: size)
    node = Node.add_child(node, child)
    items = Map.merge(items, %{ child.name => child, node.name => node })
    { items, node }
  end
end

