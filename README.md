# lemon
The 'lemon' Domain Specific Language (DSL).

A functional DSL designed for string and list manipulation. Created using ocamllex and ocamlyacc.

Authors:
* [tedigc](https://github.com/tedigc) 
* [gcjensen](https://github.com/gcjensen)

-------

### Types

The language supports both boolean and integer operations, and includes two other domain specific types; words and languages.

**Words** - Finite sequences of lowercase letters, or the empty word, represented by the symbol `:`

**Languages** - Collections of words, in which order matters and duplicates are permitted. Languages are defined with the syntax: `{ a, b, c, hello, : }`. Languages behave in ways similar to lists from many Lisp flavoured languages

-------

### Syntax

The language features a number of core functions for string and language manipulation, and allows the user to define their own functions with up to three parameters.

### String Operation Functions

   **concat** - concatenates two strings
   ```
   (concat "a" "b") , returns: "ab"
   ```

   **length** - returns the number of characters in a string 
   ```
   (length "hello") , returns: 5
   ```

   **kleene** - returns a language containing the kleene star of the given string, size limited to the given integer. 
   ```
   (kleene "a" 5) , returns: {:, a, aa, aaa, aaaa}
   ```

### Language Operation Functions

   **head** - returns the first word of a given language. 
   ```
   (head {a, b, c}) , returns: "a"
   ```
   
   **tail** - returns the language containing all words but the first. 
   ```
   (tail {a, b, c}) , returns: {b, c}
   ```
   
   **cons** - constructs a new language with a given word at the head of the language provided. 
   ```
   (cons "a" {b, c}), returns: {a, b, c}
   ```
   
   **sort** - creates a language containing the words of a given language, sorted lexicographically. 
   ```
   (sort {c, b, a}) , returns: {a, b, c}
   ```
   
   **uniq** - creates a language containing the words of a given language with duplicates removed. 
   ``` 
   (uniq {a, a, b}) , returns: {a, b}
   ```
   
   **cap** - creates a language containing the first k words of a given language. 
   ```
   (cap {a, b, c} 2) , returns: {a, b}
   ```
   
   **size** - returns the number of words within a given language.
   ```
   (size {a, b, c}) , returns: 3
   ```

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
