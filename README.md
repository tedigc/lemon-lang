# lemon
The 'lemon' Domain Specific Language (DSL).

A functional DSL designed for string and list manipulation. Created using ocamllex and ocamlyacc.

Authors:
* [tedigc](https://github.com/tedigc) 
* [gcjensen](https://github.com/gcjensen)

-------

#### Types

The language supports both boolean and integer operations, and includes two other domain specific types; words and languages.

**Words** - Finite sequences of lowercase letters, or the empty word, represented by the symbol `:`

**Languages** - Collections of words, in which order matters and duplicates are permitted. Languages are defined with the syntax: `{ a, b, c, hello, : }`. Languages behave in ways similar to lists from many Lisp flavoured languages

#### Syntax

The language features a number of core functions for string and language manipulation, and allows the user to define their own functions with up to three parameters.


User defined functions have the following syntax:

```
(func fact n ->      /* The keyword 'func' followed by the function name and up to 3 parameter names */
  (if (n == 0)       /* The body of the function */
    then: 1
    else: fact(n-1))
  in ( fact(10) ))   /* The 'in' keyword and the scope in which the function exists */
```

You can also define variables for use within a certain scope.

* variable definition
* `if/else` syntax
* `start/end` syntax
* reading from a file