defmodule Vampirenumber do
  @moduledoc """
  Documentation for Vampirenumber.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Vampirenumber.hello()
      :world

  """
#   def hello do
#     :world
#   end
end


defmodule Vampireserver do
use GenServer

  #####
  # External API

  def start_link(n1,n2) do
    # IO.inspect "vf"


  	# Enum.each(Enum.to_list(n1..n2),f(n)->IO.puts n end)
    GenServer.start_link(__MODULE__, [n1, n2], name: String.to_atom(Integer.to_string(n1)))
    # GenServer.start_link(__MODULE__, [n1, n2])
    # Enum.each(1..100,fn(x)->IO.inspect n1 end)
    # # IO.inspect Enum.map(n1..n2, fn x -> Vampirenumberreturn.getvampirefangs(x) end)
    # IO.inspect Vampirenumberreturn.getvampirefangs(n1,n2)
    # IO.puts "hdfn"
  end

  def init(args) do
    state = {}
    {:ok,0}
  end

  def handleshit(pid, pid1, n1,n2,noofworkers) do

    GenServer.cast(pid, {:vamp, pid1, n1, n2,noofworkers})
  end

  # def next_number do
  #   GenServer.call __MODULE__, :next_number
  # end

  # def increment_number(delta) do
  #   GenServer.cast __MODULE__, {:increment_number, delta}
  # end

  #####
  # GenServer implementation

  # def handle_call(:vamp1, _from, current_number) do
  #   { :reply, current_number, current_number+1 }
  # end
  #

  def handle_cast({:vamp1, fang},state) do
     IO.puts fang

     # IO.inspect "casted"

    { :noreply, state}
  end

  def handle_cast({:done,noofworkers},state) do
    # IO.inspect "state is"
    # IO.inspect state
    # IO.inspect noofworkers
     if state === Kernel.trunc(noofworkers) do
       System.stop(0)
     end

     # IO.inspect "casted"

    { :noreply, state+1}
  end



  def handle_cast({:vamp, pid1,n1, n2,noofworkers},state) do
     fang = Vampirenumberreturn.find_vamps(n1,n2)
     # GenServer.cast(pid1, {:finish, count})
     if length(fang)>0 do
        GenServer.cast(pid1,{:vamp1, fang})
     end
     GenServer.cast(pid1, {:done,noofworkers})
     # IO.inspect "casted"

    { :noreply, state}
  end

  # def format_status(_reason, [ _pdict, state ]) do
  #   [data: [{'State', "My current state is '#{inspect state}', and I'm happy"}]]
end

defmodule Supervise do
  use Application

  def start(n1,n2) do
    import Supervisor.Spec, warn: false
    chunksize = 1000
    noofworkers = (n2-n1)/chunksize
    n_list = Enum.to_list n1..n2
    listoflists = Enum.chunk_every(n_list, chunksize)
  #   IO.inspect "test"
  #   IO.inspect listoflists
  #   Enum.each(listoflists, fn(x) -> IO.inspect Enum.at(x, 0)
  # IO.inspect Enum.at(x, length(x)-1) end)

  # Enum.each(listoflists, fn(x) -> Vampirenumberreturn.getvampirefangs(Enum.at(x, 0), Enum.at(x, length(x)-1)) end)
    {:ok, pid1} = Vampireserver.start_link(-1, -2)

    Enum.each(listoflists, fn(x) ->
      # IO.inspect Enum.at(x, 0)
      {:ok, pid} = Vampireserver.start_link(Enum.at(x, 0), Enum.at(x, length(x)-1))
      # IO.inspect "asd"
      # IO.inspect pid
      Vampireserver.handleshit(pid, pid1, Enum.at(x, 0), Enum.at(x, length(x)-1),noofworkers)


    end)

    # children = Enum.map(listoflists, fn(x)-> worker(Vampireserver, [Enum.at(x, 0), Enum.at(x, length(x)-1)], id: String.to_atom(Integer.to_string(Enum.at(x, 0)))) end)
    # children = [
    #   worker(Vampireserver,[n1,n2])
    # ]
    # children = Enum.map(n_list, fn(x)->worker(Vampireserver,[x]))

    # opts = [strategy: :one_for_one]
    # IO.inspect children
    #
    # {:ok, pid} = Supervisor.start_link(children, opts)
    # IO.inspect Supervisor.count_children(pid)

  end
end



defmodule Vampirenumberreturn do
  def getvampirefangs(n1, n2) do
    IO.inspect n1
    IO.inspect n2
  end



import Integer
  def permute([]), do: [[]]
  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x|y]
  end

  def get_fang(number) do
    list = permute(Integer.digits(number))
    fang_list = []
    fang_list = Enum.uniq(Enum.reduce(list,[], fn post, accl ->
      len = Kernel.trunc(length(post)/2)
      [a, b] = Enum.chunk_every(post, len)
      b_str = ""
      a_str = Enum.reduce(a,"",fn x,acc -> acc = Enum.join([acc, x], "")end)
      b_str = Enum.reduce(b,"",fn y,acc -> acc = Enum.join([acc, y], "")end)
      a_num = elem(Integer.parse(a_str), 0)
      b_num = elem(Integer.parse(b_str), 0)
      if number === a_num*b_num do
        if List.first(Integer.digits(a_num)) ===0 or List.first(Integer.digits(b_num)) ===0 do
          accl
        else
          if List.last(Integer.digits(a_num)) ===0 and List.last(Integer.digits(b_num)) ===0 do
            accl
          else
            if a_num < b_num do
            accl = [[a_num,b_num] | accl]
            else
            accl
            end
          end
        end
      else
        accl
      end
    end))
  end

  def is_vampire(num) do
    if is_even(length(Integer.digits(num))) do
      if length(Integer.digits(num)) !== 2 do
      out = ""
      out = Enum.reduce(get_fang(num)," ",fn x,acc -> acc = Enum.join([acc,Enum.reduce(x, " ",fn p,accr-> accr = Enum.join([accr, Integer.to_string(p)]," ")end)],"")end)
      # else
      #   IO.puts "not vampire!"
      end
    # else
    #   IO.puts "not vampire!"
    end
  end


  def find_vamps(num1,num2) do
    ac=""
    ac = Enum.reduce(Enum.to_list(num1..num2),"",fn p,a->
    if is_vampire(p)!==" " do
    a = Enum.join([a,Enum.join([p,is_vampire(p)],"" )],"\n")
    else
    a
    end
    end)
    ah = String.split(ac, "\n")
    [head | tail] = ah
    # IO.inspect tail
    tail
  end
end
