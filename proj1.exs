defmodule Main do
  def foo() do
    foo()
  end

  def mainfunc(arg) do
    n1 = Enum.at(arg,0)
    n2 = Enum.at(arg,1)
    n11 = String.to_integer(n1)
    n22 = String.to_integer(n2)
    Supervise.start(n11,n22)
    foo()


  end
end

Main.mainfunc(System.argv())
