defmodule StreambugWeb.IndexLive do
  @moduledoc false

  use StreambugWeb, :live_view
  require Integer

  @numbers 1..100

  def mount(_params, _session, socket) do
    socket
    |> stream_configure(:numbers, dom_id: &"n-#{&1}")
    |> assign(:even_only, false)
    |> stream_numbers()
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <button phx-click="toggle-even-only">toggle even only</button>
    <div>Even Only?: <%= @even_only %></div>
    <table>
      <tbody id="tbody" phx-update="stream">
        <tr :for={{domid, number} <- @streams.numbers} id={domid}>
          <td><%= number %></td>
        </tr>
      </tbody>
    </table>
    """
  end

  def handle_event("toggle-even-only", _params, socket) do
    {:noreply,
     socket
     |> update(:even_only, &(!&1))
     |> stream_numbers(reset: true)}
  end

  def stream_numbers(socket, opts \\ []) do
    numbers =
      if socket.assigns.even_only,
        do: Enum.filter(@numbers, &Integer.is_even/1),
        else: @numbers

    stream(socket, :numbers, numbers, opts)
  end
end
