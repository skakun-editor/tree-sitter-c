;; Scopes

(function_definition) @local.scope

;; Definitions

; HACK: Matches only up to T(*param)[…][…][…], T**(*param)(…) and T*****param
;       but higher levels of nesting are extremely rare (i.e. not found in
;       Linux's source code), so it's okay.
(function_definition
 (function_declarator
  (parameter_list
   (parameter_declaration
    [(identifier) @local.definition
     (_ declarator:
      [(identifier) @local.definition
       (_ declarator:
        [(identifier) @local.definition
         (_ declarator:
          [(identifier) @local.definition
           (_ declarator:
            [(identifier) @local.definition
             (_ declarator: (identifier) @local.definition)])])])])]))))

;; References

(identifier) @local.reference
