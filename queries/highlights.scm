;; Comments

(comment) @comment

;; Punctuation

["(" ")" "," "..." ":" ";" "=" "[" "]" "{" "}"] @punctuation

;; Literals

[(true) (false)] @boolean_literal
(char_literal [start: _ end: _] @character_literal_delimiter) @character_literal
(char_literal (escape_sequence) @character_literal_escape_sequence)
(null) @null_literal
(number_literal) @number_literal
(string_literal [start: _ end: _] @string_literal_delimiter) @string_literal
(string_literal (escape_sequence) @string_literal_escape_sequence)
(system_lib_string ["<" ">"] @string_literal_delimiter) @string_literal

;; Operators

(_ operator: _ @operator)
(init_declarator "=" @operator)
["*" "defined" "sizeof"] @operator

(call_expression (argument_list ["(" ")"] @matchfix_operator))
(cast_expression ["(" ")"] @matchfix_operator)
(subscript_expression ["[" "]"] @matchfix_operator)
(array_declarator ["[" "]"] @matchfix_operator)
(abstract_array_declarator ["[" "]"] @matchfix_operator)
(initializer_list ["{" "}"] @matchfix_operator)

(field_expression operator: _ @member_access_operator)

;; Keywords

["asm" "__asm__" "__asm" (gnu_asm_qualifier)] @keyword

["enum" "struct" "union" (type_qualifier)] @type_keyword

["if" "else" "switch" "case" "default"] @evaluation_branch
(conditional_expression ["?" ":"] @evaluation_branch)

["while" "do" "for"] @evaluation_loop

["break" "continue" "goto" "return"] @evaluation_end
(gnu_asm_qualifier "goto" @keyword)

"typedef" @declaration
(declaration (type_specifier ["enum" "struct" "union"] @declaration))
(type_definition (type_specifier ["enum" "struct" "union"] @declaration))
(labeled_statement ":" @declaration)

(storage_class_specifier) @declaration_modifier

(preproc_directive) @pragma
"#" @pragma_delimiter

;; Identifiers

(identifier) @identifier

(field_identifier) @member_variable

((identifier) @constant
 (#match? @constant "^[A-Z_][A-Z_0-9]*$"))

(type_identifier) @type

[(primitive_type) (sized_type_specifier (primitive_type))] @builtin_type

(_ label: _ @goto_label)

(call_expression [(identifier) @function
                  (field_expression field: _ @function)])
(function_declarator
 [(identifier) @function
  (parenthesized_declarator (pointer_declarator (identifier) @function))])
(preproc_function_def name: _ @function)

; HACK: Matches only up to T(*param)[…][…][…], T**(*param)(…) and T*****param
;       but higher levels of nesting are extremely rare (i.e. not found in
;       Linux's source code), so that's okay.
(function_definition
 (function_declarator
  (parameter_list
   (parameter_declaration
    [(identifier) @function_parameter
     (_ declarator:
      [(identifier) @function_parameter
       (_ declarator:
        [(identifier) @function_parameter
         (_ declarator:
          [(identifier) @function_parameter
           (_ declarator:
            [(identifier) @function_parameter
             (_ declarator: (identifier) @function_parameter)])])])])]))))
(preproc_params (identifier) @function_parameter)
(variadic_parameter "..." @special_function_parameter)
(preproc_params "..." @special_function_parameter)
