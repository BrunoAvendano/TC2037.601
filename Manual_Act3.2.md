

# Manual de Usuario

## Módulo: Parsing.TokenList

Este módulo contiene funciones para analizar y tokenizar expresiones aritméticas.

### Función: arithmetic_lexer(string)

Esta función realiza el análisis léxico de una cadena de caracteres para la aritmética. Utiliza un autómata finito determinista (DFA) para reconocer tokens como enteros, flotantes, etc.

**Parámetros:**
- `string`: La cadena de caracteres que se va a analizar.

**Retorno:**
- Una lista de tokens que representan los componentes léxicos de la cadena de entrada.

La función `arithmetic_lexer` comienza definiendo el autómata con la función de transición, los estados de aceptación y el estado inicial. Luego, convierte la cadena en una lista de grafemas (caracteres Unicode) y evalúa el DFA.

### Funciones Auxiliares

El módulo también contiene varias funciones auxiliares que se utilizan internamente para el análisis léxico. Estas funciones incluyen `eval_dfa`, que evalúa el DFA dada una lista de caracteres y el estado actual, y `delta_arithmetic`, que define la función de transición para el autómata de la aritmética.

Además, hay varias funciones de ayuda para verificar el tipo de carácter, como `is_digit`, `is_sign`, `is_operator`, y `is_alphaN`.

#### Función: eval_dfa

Esta función evalúa el DFA dada una lista de caracteres y el estado actual. Si el estado actual es un estado de aceptación, agrega el token y limpia los resultados. Si se encuentra un token, actualiza el estado y agrega el token a la lista.

#### Función: delta_arithmetic

Esta función define la función de transición para el autómata de la aritmética. Determina el siguiente estado basado en el carácter actual.

## Uso

Para usar este módulo, simplemente importa el módulo en tu código y llama a la función `arithmetic_lexer` con la cadena que deseas analizar. Por ejemplo:

```elixir
import Parsing.TokenList

tokens = Parsing.TokenList.arithmetic_lexer("3 + 4 * 2")
IO.inspect(tokens)
```

Esto analizará la cadena "3 + 4 * 2" y devolverá una lista de tokens que representan los componentes léxicos de la cadena.

## Autor

#### Bruno Avendaño Toledo
#### A01784613