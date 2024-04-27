#Bruno Avendaño Toledo
#A01784613

#Actividad 3.2


defmodule Parsing.TokenList do
  # Esta función realiza el análisis léxico de una cadena de caracteres para la aritmética.
  # Utiliza un autómata finito determinista (DFA) para reconocer tokens como enteros, flotantes, etc.
  def arithmetic_lexer(string) do
    # Definición del autómata con la función de transición, los estados de aceptación y el estado inicial.
    automata = {&delta_arithmetic/2, [:int, :float, :par_open, :par_close, :var, :nspace], :start}
    
    # Convierte la cadena en una lista de grafemas (caracteres Unicode) y evalúa el DFA.
    string
    |> String.graphemes()
    |> eval_dfa(automata, [], [])
  end

  # Función interna que evalúa el DFA dada una lista de caracteres y el estado actual.
  defp eval_dfa([], {_delta, accept, state}, tokens, characters) do
    # Función auxiliar para limpiar los tokens y remover espacios en blanco.
    clean_tuple = fn {key, value} -> {key, String.trim(value)} end
    
    # Filtra los tokens rechazando los espacios en blanco.
    tokens = Enum.reject(tokens, &match?({:nspace, _}, &1))
    
    # Si el estado actual es un estado de aceptación, agrega el token y limpia los resultados.
    if Enum.member?(accept, state) do
      [{state, Enum.reverse(characters) |> Enum.join("")} | tokens]
      |> Enum.reverse()
      |> Enum.map(clean_tuple)
      |> Enum.reject(&match?({:nspace, _}, &1))
    else
      false
    end
  end

  # Función interna que realiza la transición en el DFA dado un nuevo carácter.
  defp eval_dfa([char | tail], {delta, accept, state}, tokens, characters) do
    [new_state , found] = delta.(state, char)
    up_characters = [char | characters]
    
    # Si se encuentra un token, actualiza el estado y agrega el token a la lista.
    if found == false do
      eval_dfa(tail, {delta, accept, new_state}, tokens, up_characters)
    else
      new_token = {found, Enum.reverse(tl(up_characters)) |> Enum.join("")}
      eval_dfa(tail, {delta, accept, new_state}, [new_token | tokens], [hd(up_characters)])
    end
  end

  # Función que define la función de transición para el autómata de la aritmética.
  defp delta_arithmetic(start, char) do
    case start do
      # Estado inicial: determina el siguiente estado basado en el carácter actual.
      :start -> cond do
        is_sign(char) -> [:sign, false]
        is_digit(char) -> [:int, false]
        char == "(" -> [:par_open, false]
        char == " " -> [:space, false]
        is_alphaN(char) -> [:var, false]
        true -> [:fail, false] # Estado de error si no se reconoce el carácter.
      end
      # Otros estados: determinan la transición basada en el carácter actual.
      :int -> cond do
        is_digit(char) -> [:int, false]
        is_operator(char) -> [:oper, :int]
        char == "." -> [:dot, false]
        char == ")" -> [:par_close, :int]
        char == " " -> [:nspace, :int]
        true -> [:fail, false]
      end
      :dot -> cond do
        is_digit(char) -> [:float, false]
        true -> [:fail, false]
      end

      :float -> cond do
        is_digit(char) -> [:float, false]
        is_operator(char) -> [:oper, :float]
        char == " " -> [:nspace, :float]
        true -> [:fail, false]
      end

      :oper -> cond do
        is_sign(char) -> [:sign, :oper]
        is_digit(char) -> [:int, :oper]
        is_alphaN(char) -> [:var, :oper]
        char == "(" -> [:par_open, :oper]
        char == " " -> [:space, :oper]
        true -> [:fail, false]
      end

      :sign -> cond do
        is_digit(char) -> [:int, false]
        char == "(" -> [:par_open, false]
        true -> [:fail, false]
      end

      :e -> cond do 
        is_alphaN(char) -> [:var, false]
        is_sign(char) -> [:esign, false]
        true -> [:fail, false]
      end


      :par_open -> cond do
        is_digit(char) -> [:int, :par_open]
        is_operator(char) -> [:oper, :par_open]
        is_alphaN(char) -> [:var, :par_open]
        char == "(" -> [:par_open, :par_open]
        char == " " -> [:space, :par_open]
        true -> [:fail, false]
      end

      :par_close -> cond do
        is_operator(char) -> [:oper, :par_close]
        char == "(" -> [:par_open, :par_open]
        char == " " -> [:nspace, :par_close]
        true -> [:fail, false]
      end
      :var -> cond do
        is_digit(char) -> [:var, false]
        is_operator(char) -> [:oper, :var]
        is_alphaN(char) -> [:var, false]
        char == ")" -> [:par_close, :var]
        char == " " -> [:nspace, :var]
        true -> [:fail, false]
      end

      :nspace -> cond do
        char == " " -> [:nspace, false]
        char == ")" -> [:par_close, false]
        is_operator(char) -> [:oper, false]
        true -> [:fail, false]
      end

      :space -> cond do
        char == " " -> [:space, false]
        is_sign(char) -> [:sign, false]
        is_digit(char) -> [:int, false]
        is_alphaN(char) -> [:var, false]
        is_operator(char) -> [:oper, false]
        char == "(" -> [:par_open, false]
        true -> [:start, false]
      end

      :fail -> [:fail, false]
    end
  end

  # Funciones de ayuda para verificar el tipo de carácter.
  defp is_digit(char), do: Enum.member?("0123456789" |> String.graphemes(), char)
  defp is_sign(char), do: Enum.member?(["+", "-"], char)
  defp is_operator(char), do: Enum.member?(["+", "-", "*", "/", "%", "^", "="], char)
  defp is_alphaN(char), do: Enum.member?(Enum.map(?a..?z, &<<&1::utf8>>) ++ Enum.map(?A..?Z, &<<&1::utf8>>) ++ ["_"], char)
end
