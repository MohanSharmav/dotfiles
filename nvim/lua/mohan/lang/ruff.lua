local lang = require("mohan.lang").lang

local M = {}

---Ensure translations are always in the order: es, pt-br, and fr
M.translate_ruff_message = function(code, message)
  if lang ~= "en" then
    if code == "F401" then
      local name = message:match("([^ ]+) imported but unused")
      if lang == "es" then
        return string.format(
          "%s importado pero nunca usado; considera usar `importlib.util.find_spec` para probar la disponibilidad",
          name
        )
      elseif lang == "pt-br" then
        return string.format(
          "%s importado mas nunca usado; considere usar `importlib.util.find_spec` para testar a disponibilidade",
          name
        )
      elseif lang == "fr" then
        return string.format(
          "%s importé mais jamais utilisé; considérez utiliser `importlib.util.find_spec` pour tester la disponibilité",
          name
        )
      elseif lang == "it" then
        return string.format(
          "%s importato ma mai usato; considera di utilizzare `importlib.util.find_spec` per testare la disponibilità",
          name
        )
      end
    elseif code == "F402" then
      -- message: Import {name} from {row} shadowed by loop variable
      local name, row = message:match("Import ([^ ]+) from line ([0-9]+) shadowed by loop variable")
      if lang == "es" then
        return string.format("Importación de %s desde la línea %s sombreada por variable de bucle", name, row)
      elseif lang == "pt-br" then
        return string.format("Importação de %s da linha %s sombreada por variável de loop", name, row)
      elseif lang == "fr" then
        return string.format("Importation de %s depuis la ligne %s masquée par une variable de boucle", name, row)
      elseif lang == "it" then
        return string.format("Importazione di %s dalla linea %s oscurata dalla variabile del ciclo", name, row)
      end
    elseif code == "F403" then
      -- message = `from {name} import *` used; unable to detect undefined names
      local name = message:match("from ([^ ]+) import")
      if lang == "es" then
        return string.format("`from %s import *` usado; incapaz de detectar nombres indefinido", name)
      elseif lang == "pt-br" then
        return string.format("`from %s import *` usado; incapaz de detectar nomes indefinidos", name)
      elseif lang == "fr" then
        return string.format("`from %s import *` utilisé; impossible de détecter les noms indéfinis", name)
      elseif lang == "it" then
        return string.format("`from %s import *` usato; impossibile rilevare i nomi non definiti", name)
      end
    elseif code == "F404" then
      -- `from __future__` imports must occur at the beginning of the file
      if lang == "es" then
        return "Las importaciones de `from __future__` deben ocurrir al principio del archivo"
      elseif lang == "pt-br" then
        return "As importações `from __future__` devem ocorrer no início do arquivo"
      elseif lang == "fr" then
        return "Les importations `from __future__` doivent se produire au début du fichier"
      elseif lang == "it" then
        return "Le importazioni `from __future__` devono avvenire all'inizio del file"
      end
    elseif code == "F405" then
      -- {name} may be undefined, or defined from star imports
      local name = message:match("([^ ]+) may be undefined")
      if lang == "es" then
        return string.format("%s puede ser indefinido, o definido desde importaciones de estrella", name)
      elseif lang == "pt-br" then
        return string.format("%s pode ser indefinido, ou definido a partir de importações de estrela", name)
      elseif lang == "fr" then
        return string.format("%s peut être indéfini, ou défini à partir d'importations d'étoiles", name)
      elseif lang == "it" then
        return string.format("%s potrebbe essere non definito, o definito da importazioni di stella", name)
      end
    elseif code == "F406" then
      -- from {name} import * only allowed at module level
      local name = message:match("from ([^ ]+) import")
      if lang == "es" then
        return string.format("`from %s import *` solo permitido a nivel de módulo", name)
      elseif lang == "pt-br" then
        return string.format("`from %s import *` permitido apenas no nível do módulo", name)
      elseif lang == "fr" then
        return string.format("`from %s import *` autorisé uniquement au niveau du module", name)
      elseif lang == "it" then
        return string.format("`from %s import *` consentito solo a livello di modulo", name)
      end
    elseif code == "F407" then
      -- Future feature {name} is not defined
      local name = message:match("Future feature ([^ ]+) is not defined")
      if lang == "es" then
        return string.format("La característica futura %s no está definida", name)
      elseif lang == "pt-br" then
        return string.format("O recurso futuro %s não está definido", name)
      elseif lang == "fr" then
        return string.format("La fonctionnalité future %s n'est pas définie", name)
      elseif lang == "it" then
        return string.format("La funzionalità futura %s non è definita", name)
      end
    elseif code == "F501" then
      -- %-format string has invalid format string: {message}
      local mes = message:match("string has invalid format string: (.*)")
      if lang == "es" then
        return string.format("Cadena de formato %% tiene una cadena de formato inválida: %s", mes)
      elseif lang == "pt-br" then
        return string.format("A string de formato %% tem uma string de formato inválida: %s", mes)
      elseif lang == "fr" then
        return string.format("La chaîne de format %% a une chaîne de format invalide: %s", mes)
      elseif lang == "it" then
        return string.format("La stringa di formato %% ha una stringa di formato non valida: %s", mes)
      end
    elseif code == "F502" then
      if lang == "es" then
        return "Cadena de formato %% esperaba un mapeo pero obtuvo una secuencia"
      elseif lang == "pt-br" then
        return "A string de formato %% esperava um mapeamento mas obteve uma sequência"
      elseif lang == "fr" then
        return "La chaîne de format %% attendait une carte mais a obtenu une séquence"
      elseif lang == "it" then
        return "La stringa di formato %% si aspettava una mappatura ma ha ottenuto una sequenza"
      end
    elseif code == "F503" then
      if lang == "es" then
        return "Cadena de formato %% esperaba una secuencia pero obtuvo un mapeo"
      elseif lang == "pt-br" then
        return "A string de formato %% esperava uma sequência mas obteve um mapeamento"
      elseif lang == "fr" then
        return "La chaîne de format %% attendait une séquence mais a obtenu une carte"
      elseif lang == "it" then
        return "La stringa di formato %% si aspettava una sequenza ma ha ottenuto una mappatura"
      end
    elseif code == "F504" then
      -- %-format string has unused named argument(s): {message}
      local mes = message:match("string has unused named argument[(]s[)]: (.*)")
      if lang == "es" then
        return string.format("Cadena de formato %% tiene argumento(s) con nombre no usado: %s", mes)
      elseif lang == "pt-br" then
        return string.format("A string de formato %% tem argumento(s) com nome não usado: %s", mes)
      elseif lang == "fr" then
        return string.format("La chaîne de format %% a des argument(s) nommé(s) non utilisé(s): %s", mes)
      elseif lang == "it" then
        return string.format("La stringa di formato %% ha argomento(i) con nome non utilizzato(i): %s", mes)
      end
    elseif code == "F505" then
      -- %-format string is missing argument(s) for placeholder(s): {message}
      local mes = message:match("string is missing argument[(]s[)] for placeholder[(]s[)]: (.*)")
      if lang == "es" then
        return string.format("Cadena de formato %% falta argumento(s) para marcador(es): %s", mes)
      elseif lang == "pt-br" then
        return string.format("A string de formato %% está faltando argumento(s) para marcador(es): %s", mes)
      elseif lang == "fr" then
        return string.format("La chaîne de format %% manque d'argument(s) pour le(s) marqueur(s): %s", mes)
      elseif lang == "it" then
        return string.format("La stringa di formato %% manca di argomento(i) per il(i) segnaposto: %s", mes)
      end
    elseif code == "F506" then
      if lang == "es" then
        return "Cadena de formato %% tiene marcadores posicionales y con nombre mezclados"
      elseif lang == "pt-br" then
        return "A string de formato %% tem marcadores posicionais e com nome misturados"
      elseif lang == "fr" then
        return "La chaîne de format %% a des marqueurs positionnels et nommés mélangés"
      elseif lang == "it" then
        return "La stringa di formato %% ha marcatori posizionali e con nome mescolati"
      end
    elseif code == "F507" then
      -- %-format string has {wanted} placeholder(s) but {got} substitution(s)
      local wanted, got = message:match("string has ([0-9]+) placeholder[(]s[)] but ([0-9]+) substitution[(]s[)]")
      if lang == "es" then
        return string.format("Cadena de formato %% tiene %s marcador(es) pero %s sustitución(es)", wanted, got)
      elseif lang == "pt-br" then
        return string.format("A string de formato %% tem %s marcador(es) mas %s substituição(ões)", wanted, got)
      elseif lang == "fr" then
        return string.format("La chaîne de format %% a %s marqueur(s) mais %s substitution(s)", wanted, got)
      elseif lang == "it" then
        return string.format("La stringa di formato %% ha %s segnaposto ma %s sostituzione(i)", wanted, got)
      end
    elseif code == "F508" then
      if lang == "es" then
        return "Cadena de formato %% con especificador * requiere secuencia"
      elseif lang == "pt-br" then
        return "A string de formato %% com especificador * requer uma sequência"
      elseif lang == "fr" then
        return "La chaîne de format %% avec un spécificateur * nécessite une séquence"
      elseif lang == "it" then
        return "La stringa di formato %% con specificatore * richiede una sequenza"
      end
    elseif code == "F509" then
      -- %-format string has unsupported format character {char}
      local char = message:match("string has unsupported format character (.*)")
      if lang == "es" then
        return string.format("Cadena de formato %% tiene carácter de formato %s no soportado", char)
      elseif lang == "pt-br" then
        return string.format("A string de formato %% tem caractere de formato %s não suportado", char)
      elseif lang == "fr" then
        return string.format("La chaîne de format %% a un caractère de format %s non pris en charge", char)
      elseif lang == "it" then
        return string.format("La stringa di formato %% ha un carattere di formato %s non supportato", char)
      end
    elseif code == "F521" then
      -- 🔗🐍 [F521]	string-dot-format-invalid-format	.format call has invalid format string: {message}	✔️ 🛠️
      local mes = message:match("call has invalid format string: (.*)")
      if lang == "es" then
        return string.format("`.format` tiene una cadena de formato inválida: %s", mes)
      elseif lang == "pt-br" then
        return string.format("`.format` tem uma string de formato inválida: %s", mes)
      elseif lang == "fr" then
        return string.format("`.format` a une chaîne de format invalide: %s", mes)
      elseif lang == "it" then
        return string.format("`.format` ha una stringa di formato non valida: %s", mes)
      end
    elseif code == "F522" then
      -- 🔗🐍 [F522]	string-dot-format-extra-named-arguments	.format call has unused named argument(s): {message}	✔️ 🛠️
      local mes = message:match("call has unused named argument[(]s[)]: (.*)")
      if lang == "es" then
        return string.format("`.format` tiene argumento(s) con nombre no usado: %s", mes)
      elseif lang == "pt-br" then
        return string.format("`.format` tem argumento(s) com nome não usado: %s", mes)
      elseif lang == "fr" then
        return string.format("`.format` a des argument(s) nommé(s) non utilisé(s): %s", mes)
      elseif lang == "it" then
        return string.format("`.format` ha argomento(i) con nome non utilizzato(i): %s", mes)
      end
    elseif code == "F523" then
      -- 🔗🐍 [F523]	string-dot-format-extra-positional-arguments	.format call has unused arguments at position(s): {message}	✔️ 🛠️
      local mes = message:match("call has unused arguments at position[(]s[)]: (.*)")
      if lang == "es" then
        return string.format("`.format` tiene argumento(s) no usado en posición(es): %s", mes)
      elseif lang == "pt-br" then
        return string.format("`.format` tem argumento(s) não usado em posição(ões): %s", mes)
      elseif lang == "fr" then
        return string.format("`.format` a des argument(s) non utilisé(s) à la/aux position(s): %s", mes)
      elseif lang == "it" then
        return string.format("`.format` ha argomento(i) non utilizzato(i) in posizione(i): %s", mes)
      end
    elseif code == "F524" then
      -- 🔗🐍 [F524]	string-dot-format-missing-arguments	.format call is missing argument(s) for placeholder(s): {message}	✔️ 🛠️
      local mes = message:match("call is missing argument[(]s[)] for placeholder[(]s[)]: (.*)")
      if lang == "es" then
        return string.format("`.format` falta argumento(s) para marcador(es): %s", mes)
      elseif lang == "pt-br" then
        return string.format("`.format` está faltando argumento(s) para marcador(es): %s", mes)
      elseif lang == "fr" then
        return string.format("`.format` manque d'argument(s) pour le(s) marqueur(s): %s", mes)
      elseif lang == "it" then
        return string.format("`.format` manca di argomento(i) per il(i) segnaposto: %s", mes)
      end
    elseif code == "F525" then
      -- 🔗🐍 [F525]	string-dot-format-mixing-automatic	.format string mixes automatic and manual numbering	✔️ 🛠️
      if lang == "es" then
        return "Cadena de formato `.format` mezcla numeración automática y manual"
      elseif lang == "pt-br" then
        return "A string de formato `.format` mistura numeração automática e manual"
      elseif lang == "fr" then
        return "La chaîne de format `.format` mélange numérotation automatique et manuelle"
      elseif lang == "it" then
        return "La stringa di formato `.format` mescola numerazione automatica e manuale"
      end
    elseif code == "F541" then
      -- 🔗🐍 [F541]	f-string-missing-placeholders	f-string without any placeholders	✔️ 🛠️
      if lang == "es" then
        return "f-cadena sin marcadores"
      elseif lang == "pt-br" then
        return "f-string sem marcadores"
      elseif lang == "fr" then
        return "f-chaîne sans aucun marqueur"
      elseif lang == "it" then
        return "f-string senza segnaposti"
      end
    -- 🔗🐍 [F601]	multi-value-repeated-key-literal	Dictionary key literal {name} repeated	✔️ 🛠️
    elseif code == "F601" then
      -- 🔗🐍 [F601]	multi-value-repeated-key-literal	Dictionary key literal {name} repeated	✔️ 🛠️
      local name = message:match("Dictionary key literal ([^ ]+) repeated")
      if lang == "es" then
        return string.format("Clave literal de diccionario %s repetida", name)
      elseif lang == "pt-br" then
        return string.format("Chave literal de dicionário %s repetida", name)
      elseif lang == "fr" then
        return string.format("Clé littérale de dictionnaire %s répétée", name)
      elseif lang == "it" then
        return string.format("Chiave letterale del dizionario %s ripetuta", name)
      end
    -- 🔗🐍 [F602]	multi-value-repeated-key-variable	Dictionary key {name} repeated	✔️ 🛠️
    -- 🔗🐍 [F621]	expressions-in-star-assignment	Too many expressions in star-unpacking assignment	✔️ 🛠️
    -- 🔗🐍 [F622]	multiple-starred-expressions	Two starred expressions in assignment	✔️ 🛠️
    -- 🔗🐍 [F631]	assert-tuple	Assert test is a non-empty tuple, which is always True	✔️ 🛠️
    -- 🔗🐍 [F632]	is-literal	Use == to compare constant literals	✔️ 🛠️
    -- 🔗🐍 [F633]	invalid-print-syntax	Use of >> is invalid with print function	✔️ 🛠️
    -- 🔗🐍 [F634]	if-tuple	If test is a tuple, which is always True	✔️ 🛠️
    -- 🔗🐍 [F701]	break-outside-loop	break outside loop	✔️ 🛠️
    -- 🔗🐍 [F702]	continue-outside-loop	continue not properly in loop	✔️ 🛠️
    -- 🔗🐍 [F704]	yield-outside-function	{keyword} statement outside of a function	✔️ 🛠️
    -- 🔗🐍 [F706]	return-outside-function	return statement outside of a function/method	✔️ 🛠️
    -- 🔗🐍 [F707]	default-except-not-last	An except block as not the last exception handler	✔️ 🛠️
    -- 🔗🐍 [F722]	forward-annotation-syntax-error	Syntax error in forward annotation: {body}	✔️ 🛠️
    elseif code == "F811" then
      -- 🔗🐍 [F811]	redefined-while-unused	Redefinition of unused {name} from {row}	✔️ 🛠️
      local name, row = message:match("Redefinition of unused ([^ ]+) from line ([0-9]+)")
      if lang == "es" then
        return string.format("Redefinición de %s no usado desde la línea %s", name, row)
      elseif lang == "pt-br" then
        return string.format("Redefinição de %s não usado da linha %s", name, row)
      elseif lang == "fr" then
        return string.format("Redéfinition de %s inutilisé depuis la ligne %s", name, row)
      elseif lang == "it" then
        return string.format("Ridefinizione di %s non utilizzato dalla linea %s", name, row)
      end
    elseif code == "F821" then
      -- 🔗🐍 [F821]	undefined-name	Undefined name {name}	✔️ 🛠️
      local name = message:match("Undefined name ([^ ]+)")
      if lang == "es" then
        return string.format("Nombre %s indefinido", name)
      elseif lang == "pt-br" then
        return string.format("Nome %s indefinido", name)
      elseif lang == "fr" then
        return string.format("Nom %s indéfini", name)
      elseif lang == "it" then
        return string.format("Nome %s non definito", name)
      end
    elseif code == "F822" then
      -- 🔗🐍 [F822]	undefined-export	Undefined name {name} in __all__	✔️ 🛠️
      local name = message:match("Undefined name ([^ ]+) in")
      if lang == "es" then
        return string.format("Nombre %s indefinido en `__all__`", name)
      elseif lang == "pt-br" then
        return string.format("Nome %s indefinido em `__all__`", name)
      elseif lang == "fr" then
        return string.format("Nom %s indéfini dans `__all__`", name)
      elseif lang == "it" then
        return string.format("Nome %s non definito in `__all__`", name)
      end
    elseif code == "F823" then
      -- 🔗🐍 [F823]	undefined-local	Local variable {name} referenced before assignment	✔️ 🛠️
      local name = message:match("Local variable ([^ ]+) referenced before assignment")
      if lang == "es" then
        return string.format("Variable local %s referenciada antes de asignación", name)
      elseif lang == "pt-br" then
        return string.format("Variável local %s referenciada antes da atribuição", name)
      elseif lang == "fr" then
        return string.format("Variable locale %s référencée avant l'assignation", name)
      elseif lang == "it" then
        return string.format("Variabile locale %s referenziata prima dell'assegnazione", name)
      end
    elseif code == "F841" then
      -- 🔗🐍 [F841]	unused-variable	Local variable {name} is assigned to but never used	✔️ 🛠️
      local name = message:match("Local variable ([^ ]+) is assigned to but never used")
      if lang == "es" then
        return string.format("Variable local %s asignada pero nunca usada", name)
      elseif lang == "pt-br" then
        return string.format("Variável local %s atribuída mas nunca usada", name)
      elseif lang == "fr" then
        return string.format("Variable locale %s assignée mais jamais utilisée", name)
      elseif lang == "it" then
        return string.format("Variabile locale %s assegnata ma mai usata", name)
      end
    elseif code == "F842" then
      -- 🔗🐍 [F842]	unused-annotation	Local variable {name} is annotated but never used	✔️ 🛠️
      local name = message:match("Local variable ([^ ]+) is annotated but never used")
      if lang == "es" then
        return string.format("Variable local %s anotada pero nunca usada", name)
      elseif lang == "pt-br" then
        return string.format("Variável local %s anotada mas nunca usada", name)
      elseif lang == "fr" then
        return string.format("Variable locale %s annotée mais jamais utilisée", name)
      elseif lang == "it" then
        return string.format("Variabile locale %s annotata ma mai usata", name)
      end
    elseif code == "F901" then
      -- 🔗🐍 [F901]	raise-not-implemented	raise NotImplemented should be raise NotImplementedError
      if lang == "es" then
        return "`raise NotImplemented` debería ser `raise NotImplementedError`"
      elseif lang == "pt-br" then
        return "`raise NotImplemented` deveria ser `raise NotImplementedError`"
      elseif lang == "fr" then
        return "`raise NotImplemented` devrait être `raise NotImplementedError`"
      elseif lang == "it" then
        return "`raise NotImplemented` dovrebbe essere `raise NotImplementedError`"
      end
    -- 🔗🐍 [E101]	mixed-spaces-and-tabs	Indentation contains mixed spaces and tabs	✔️ 🛠️
    -- 🔗🐍 [E111]	indentation-with-invalid-multiple	Indentation is not a multiple of {indent_width}	🧪 🛠️
    -- 🔗🐍 [E112]	no-indented-block	Expected an indented block	🧪 🛠️
    -- 🔗🐍 [E113]	unexpected-indentation	Unexpected indentation	🧪 🛠️
    -- 🔗🐍 [E114]	indentation-with-invalid-multiple-comment	Indentation is not a multiple of {indent_width} (comment)	🧪 🛠️
    -- 🔗🐍 [E115]	no-indented-block-comment	Expected an indented block (comment)	🧪 🛠️
    -- 🔗🐍 [E116]	unexpected-indentation-comment	Unexpected indentation (comment)	🧪 🛠️
    -- 🔗🐍 [E117]	over-indented	Over-indented (comment)	🧪 🛠️
    -- 🔗🐍 [E201]	whitespace-after-open-bracket	Whitespace after '{symbol}'	🧪 🛠️
    -- 🔗🐍 [E202]	whitespace-before-close-bracket	Whitespace before '{symbol}'	🧪 🛠️
    -- 🔗🐍 [E203]	whitespace-before-punctuation	Whitespace before '{symbol}'	🧪 🛠️
    -- 🔗🐍 [E211]	whitespace-before-parameters	Whitespace before '{bracket}'	🧪 🛠️
    -- 🔗🐍 [E221]	multiple-spaces-before-operator	Multiple spaces before operator	🧪 🛠️
    -- 🔗🐍 [E222]	multiple-spaces-after-operator	Multiple spaces after operator	🧪 🛠️
    -- 🔗🐍 [E223]	tab-before-operator	Tab before operator	🧪 🛠️
    -- 🔗🐍 [E224]	tab-after-operator	Tab after operator	🧪 🛠️
    -- 🔗🐍 [E225]	missing-whitespace-around-operator	Missing whitespace around operator	🧪 🛠️
    -- 🔗🐍 [E226]	missing-whitespace-around-arithmetic-operator	Missing whitespace around arithmetic operator	🧪 🛠️
    -- 🔗🐍 [E227]	missing-whitespace-around-bitwise-or-shift-operator	Missing whitespace around bitwise or shift operator	🧪 🛠️
    -- 🔗🐍 [E228]	missing-whitespace-around-modulo-operator	Missing whitespace around modulo operator	🧪 🛠️
    -- 🔗🐍 [E231]	missing-whitespace	Missing whitespace after '{token}'	🧪 🛠️
    -- 🔗🐍 [E241]	multiple-spaces-after-comma	Multiple spaces after comma	🧪 🛠️
    -- 🔗🐍 [E242]	tab-after-comma	Tab after comma	🧪 🛠️
    -- 🔗🐍 [E251]	unexpected-spaces-around-keyword-parameter-equals	Unexpected spaces around keyword / parameter equals	🧪 🛠️
    -- 🔗🐍 [E252]	missing-whitespace-around-parameter-equals	Missing whitespace around parameter equals	🧪 🛠️
    -- 🔗🐍 [E261]	too-few-spaces-before-inline-comment	Insert at least two spaces before an inline comment	🧪 🛠️
    -- 🔗🐍 [E262]	no-space-after-inline-comment	Inline comment should start with #	🧪 🛠️
    -- 🔗🐍 [E265]	no-space-after-block-comment	Block comment should start with #	🧪 🛠️
    -- 🔗🐍 [E266]	multiple-leading-hashes-for-block-comment	Too many leading # before block comment	🧪 🛠️
    -- 🔗🐍 [E271]	multiple-spaces-after-keyword	Multiple spaces after keyword	🧪 🛠️
    -- 🔗🐍 [E272]	multiple-spaces-before-keyword	Multiple spaces before keyword	🧪 🛠️
    -- 🔗🐍 [E273]	tab-after-keyword	Tab after keyword	🧪 🛠️
    -- 🔗🐍 [E274]	tab-before-keyword	Tab before keyword	🧪 🛠️
    -- 🔗🐍 [E275]	missing-whitespace-after-keyword	Missing whitespace after keyword	🧪 🛠️
    -- 🔗🐍 [E301]	blank-line-between-methods	Expected {BLANK_LINES_NESTED_LEVEL:?} blank line, found 0	🧪 🛠️
    -- 🔗🐍 [E302]	blank-lines-top-level	Expected {expected_blank_lines:?} blank lines, found {actual_blank_lines}	🧪 🛠️
    -- 🔗🐍 [E303]	too-many-blank-lines	Too many blank lines ({actual_blank_lines})	🧪 🛠️
    -- 🔗🐍 [E304]	blank-line-after-decorator	Blank lines found after function decorator ({lines})	🧪 🛠️
    -- 🔗🐍 [E305]	blank-lines-after-function-or-class	Expected 2 blank lines after class or function definition, found ({blank_lines})	🧪 🛠️
    -- 🔗🐍 [E306]	blank-lines-before-nested-definition	Expected 1 blank line before a nested definition, found 0	🧪 🛠️
    -- 🔗🐍 [E401]	multiple-imports-on-one-line	Multiple imports on one line	✔️ 🛠️
    elseif code == "E401" then
      if lang == "es" then
        return "Múltiples importaciones en una línea"
      elseif lang == "pt-br" then
        return "Múltiplas importações em uma linha"
      elseif lang == "fr" then
        return "Importations multiples sur une ligne"
      elseif lang == "it" then
        return "Importazioni multiple in una riga"
      end
    -- 🔗🐍 [E402]	module-import-not-at-top-of-file	Module level import not at top of cell	✔️ 🛠️
    elseif code == "E402" then
      if lang == "es" then
        return "Importación a nivel de módulo no al principio del archivo"
      elseif lang == "pt-br" then
        return "Importação de nível de módulo não no início do arquivo"
      elseif lang == "fr" then
        return "Importation de niveau de module pas au début du fichier"
      elseif lang == "it" then
        return "Importazione a livello di modulo non all'inizio del file"
      end
    elseif code == "E501" then
      local width, limit = message:match("Line too long %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Línea demasiado larga (%s > %s)", width, limit)
      elseif lang == "pt-br" then
        return string.format("Linha muito longa (%s > %s)", width, limit)
      elseif lang == "fr" then
        return string.format("Ligne trop longue (%s > %s)", width, limit)
      elseif lang == "it" then
        return string.format("Riga troppo lunga (%s > %s)", width, limit)
      end
    elseif code == "E502" then
      if lang == "es" then
        return "Barra invertida redundante"
      elseif lang == "pt-br" then
        return "Barra invertida redundante"
      elseif lang == "fr" then
        return "Barre oblique inversée redondante"
      elseif lang == "it" then
        return "Barra rovesciata ridondante"
      end
    elseif code == "E701" then
      if lang == "es" then
        return "Múltiples declaraciones en una línea (dos puntos)"
      elseif lang == "pt-br" then
        return "Múltiplas declarações em uma linha (dois pontos)"
      elseif lang == "fr" then
        return "Déclarations multiples sur une ligne (deux points)"
      elseif lang == "it" then
        return "Dichiarazioni multiple in una riga (due punti)"
      end
    elseif code == "E702" then
      if lang == "es" then
        return "Múltiples declaraciones en una línea (punto y coma)"
      elseif lang == "pt-br" then
        return "Múltiplas declarações em uma linha (ponto e vírgula)"
      elseif lang == "fr" then
        return "Déclarations multiples sur une ligne (point-virgule)"
      elseif lang == "it" then
        return "Dichiarazioni multiple in una riga (punto e virgola)"
      end
    elseif code == "E703" then
      if lang == "es" then
        return "La declaración termina con un punto y coma innecesario"
      elseif lang == "pt-br" then
        return "Declaração termina com ponto e vírgula desnecessário"
      elseif lang == "fr" then
        return "La déclaration se termine par un point-virgule inutile"
      elseif lang == "it" then
        return "La dichiarazione termina con un punto e virgola non necessario"
      end
    elseif code == "E711" then
      if lang == "es" then
        return "Comparación a `None` debería ser `cond is None`"
      elseif lang == "pt-br" then
        return "Comparação a `None` deveria ser `cond is None`"
      elseif lang == "fr" then
        return "La comparaison à `None` devrait être `cond is None`"
      elseif lang == "it" then
        return "Il confronto con `None` dovrebbe essere `cond is None`"
      end
    elseif code == "E712" then
      local cond = message:match("use `if (.*):` for truth checks")
      if lang == "es" then
        return string.format(
          "Evita comparaciones de igualdad a `True`; usa `if %s:` para comprobaciones de verdad",
          cond
        )
      elseif lang == "pt-br" then
        return string.format(
          "Evite comparações de igualdade a `True`; use `if %s:` para verificações de verdade",
          cond
        )
      elseif lang == "fr" then
        return string.format(
          "Évitez les comparaisons d'égalité à `True`; utilisez `if %s:` pour les vérifications de vérité",
          cond
        )
      elseif lang == "it" then
        return string.format("Evita confronti di uguaglianza a `True`; usa `if %s:` per controlli di verità", cond)
      end
    -- 🔗🐍 [E713]	not-in-test	Test for membership should be not in	✔️ 🛠️
    elseif code == "E713" then
      if lang == "es" then
        return "Prueba de membresía debería ser `not in`"
      elseif lang == "pt-br" then
        return "Teste de associação deveria ser `not in`"
      elseif lang == "fr" then
        return "Le test d'appartenance devrait être `not in`"
      elseif lang == "it" then
        return "Il test di appartenenza dovrebbe essere `not in`"
      end
    -- 🔗🐍 [E714]	not-is-test	Test for object identity should be is not	✔️ 🛠️
    elseif code == "E714" then
      if lang == "es" then
        return "Prueba de identidad de objeto debería ser `is not`"
      elseif lang == "pt-br" then
        return "Teste de identidade de objeto deveria ser `is not`"
      elseif lang == "fr" then
        return "Le test d'identité d'objet devrait être `is not`"
      elseif lang == "it" then
        return "Il test di identità dell'oggetto dovrebbe essere `is not`"
      end
    -- 🔗🐍 [E721]	type-comparison	Do not compare types, use isinstance()	✔️ 🛠️
    elseif code == "E721" then
      if lang == "es" then
        return "No compares tipos, usa `isinstance()`"
      elseif lang == "pt-br" then
        return "Não compare tipos, use `isinstance()`"
      elseif lang == "fr" then
        return "Ne comparez pas les types, utilisez `isinstance()`"
      elseif lang == "it" then
        return "Non confrontare i tipi, usa `isinstance()`"
      end
    -- 🔗🐍 [E722]	bare-except	Do not use bare except	✔️ 🛠️
    elseif code == "E722" then
      if lang == "es" then
        return "No uses `except` sin especificar la excepción"
      elseif lang == "pt-br" then
        return "Não use `except` sem especificar a exceção"
      elseif lang == "fr" then
        return "N'utilisez pas `except` sans spécifier l'exception"
      elseif lang == "it" then
        return "Non usare `except` senza specificare l'eccezione"
      end
    -- 🔗🐍 [E731]	lambda-assignment	Do not assign a lambda expression, use a def	✔️ 🛠️
    elseif code == "E731" then
      if lang == "es" then
        return "No asignes una expresión lambda, usa un `def`"
      elseif lang == "pt-br" then
        return "Não atribua uma expressão lambda, use um `def`"
      elseif lang == "fr" then
        return "N'attribuez pas une expression lambda, utilisez un `def`"
      elseif lang == "it" then
        return "Non assegnare un'espressione lambda, usa un `def`"
      end
    -- 🔗🐍 [E741]	ambiguous-variable-name	Ambiguous variable name: {name}	✔️ 🛠️
    elseif code == "E741" then
      local name = message:match("Ambiguous variable name: (.*)")
      if lang == "es" then
        return string.format("Nombre de variable ambiguo: %s", name)
      elseif lang == "pt-br" then
        return string.format("Nome de variável ambíguo: %s", name)
      elseif lang == "fr" then
        return string.format("Nom de variable ambigu: %s", name)
      elseif lang == "it" then
        return string.format("Nome di variabile ambiguo: %s", name)
      end
    -- 🔗🐍 [E742]	ambiguous-class-name	Ambiguous class name: {name}	✔️ 🛠️
    elseif code == "E742" then
      local name = message:match("Ambiguous class name: (.*)")
      if lang == "es" then
        return string.format("Nombre de clase ambiguo: %s", name)
      elseif lang == "pt-br" then
        return string.format("Nome de classe ambíguo: %s", name)
      elseif lang == "fr" then
        return string.format("Nom de classe ambigu: %s", name)
      elseif lang == "it" then
        return string.format("Nome di classe ambiguo: %s", name)
      end
    elseif code == "E743" then
      -- 🔗🐍 [E743]	ambiguous-function-name	Ambiguous function name: {name}	✔️ 🛠️
      local name = message:match("Ambiguous function name: (.*)")
      if lang == "es" then
        return string.format("Nombre de función ambiguo: %s", name)
      elseif lang == "pt-br" then
        return string.format("Nome de função ambíguo: %s", name)
      elseif lang == "fr" then
        return string.format("Nom de fonction ambigu: %s", name)
      elseif lang == "it" then
        return string.format("Nome di funzione ambiguo: %s", name)
      end
    -- 🔗🐍 [E902]	io-error	{message}	✔️ 🛠️
    -- 🔗🐍 [E999]	syntax-error	SyntaxError: {message}

    -- 🔗🐍 [W191]	tab-indentation	Indentation contains tabs	✔️ 🛠️
    -- 🔗🐍 [W291]	trailing-whitespace	Trailing whitespace	✔️ 🛠️
    -- 🔗🐍 [W292]	missing-newline-at-end-of-file	No newline at end of file	✔️ 🛠️
    -- 🔗🐍 [W293]	blank-line-with-whitespace	Blank line contains whitespace	✔️ 🛠️
    -- 🔗🐍 [W391]	too-many-newlines-at-end-of-file	Too many newlines at end of file	🧪 🛠️
    -- 🔗🐍 [W505]	doc-line-too-long	Doc line too long ({width} > {limit})	✔️ 🛠️
    -- 🔗🐍 [W605]	invalid-escape-sequence	Invalid escape sequence: \{ch}	✔️ 🛠️
    -- 🔗🐍 [C901]	complex-structure	{name} is too complex ({complexity} > {max_complexity})
    -- 🔗🐍 [I001]	unsorted-imports	Import block is un-sorted or un-formatted	✔️ 🛠️
    -- 🔗🐍 [I002]	missing-required-import	Missing required import: {name}	✔️ 🛠️
    -- 🔗🐍 [N801]	invalid-class-name	Class name {name} should use CapWords convention	✔️ 🛠️
    -- 🔗🐍 [N802]	invalid-function-name	Function name {name} should be lowercase	✔️ 🛠️
    -- 🔗🐍 [N803]	invalid-argument-name	Argument name {name} should be lowercase	✔️ 🛠️
    -- 🔗🐍 [N804]	invalid-first-argument-name-for-class-method	First argument of a class method should be named cls	✔️ 🛠️
    elseif code == "N804" then
      if lang == "es" then
        return "El primer argumento de un método debería llamarse `cls`"
      elseif lang == "pt-br" then
        return "O primeiro argumento de um método deveria ser chamado `cls`"
      elseif lang == "fr" then
        return "Le premier argument d'une méthode devrait être nommé `cls`"
      elseif lang == "it" then
        return "Il primo argomento di un metodo dovrebbe essere chiamato `cls`"
      end
    -- 🔗🐍 [N805]	invalid-first-argument-name-for-method	First argument of a method should be named self	✔️ 🛠️
    elseif code == "N805" then
      if lang == "es" then
        return "El primer argumento de un método debería llamarse `self`"
      elseif lang == "pt-br" then
        return "O primeiro argumento de um método deveria ser chamado `self`"
      elseif lang == "fr" then
        return "Le premier argument d'une méthode devrait être nommé `self`"
      elseif lang == "it" then
        return "Il primo argomento di un metodo dovrebbe essere chiamato `self`"
      end
    -- 🔗🐍 [N806]	non-lowercase-variable-in-function	Variable {name} in function should be lowercase	✔️ 🛠️
    -- 🔗🐍 [N807]	dunder-function-name	Function name should not start and end with __	✔️ 🛠️
    -- 🔗🐍 [N811]	constant-imported-as-non-constant	Constant {name} imported as non-constant {asname}	✔️ 🛠️
    -- 🔗🐍 [N812]	lowercase-imported-as-non-lowercase	Lowercase {name} imported as non-lowercase {asname}	✔️ 🛠️
    -- 🔗🐍 [N813]	camelcase-imported-as-lowercase	Camelcase {name} imported as lowercase {asname}	✔️ 🛠️
    -- 🔗🐍 [N814]	camelcase-imported-as-constant	Camelcase {name} imported as constant {asname}	✔️ 🛠️
    -- 🔗🐍 [N815]	mixed-case-variable-in-class-scope	Variable {name} in class scope should not be mixedCase	✔️ 🛠️
    -- 🔗🐍 [N816]	mixed-case-variable-in-global-scope	Variable {name} in global scope should not be mixedCase	✔️ 🛠️
    -- 🔗🐍 [N817]	camelcase-imported-as-acronym	CamelCase {name} imported as acronym {asname}	✔️ 🛠️
    -- 🔗🐍 [N818]	error-suffix-on-exception-name	Exception name {name} should be named with an Error suffix	✔️ 🛠️
    -- 🔗🐍 [N999]	invalid-module-name	Invalid module name: '{name}'	✔️ 🛠️
    -- 🔗🐍 [D100]	undocumented-public-module	Missing docstring in public module	✔️ 🛠️
    -- 🔗🐍 [D101]	undocumented-public-class	Missing docstring in public class	✔️ 🛠️
    -- 🔗🐍 [D102]	undocumented-public-method	Missing docstring in public method	✔️ 🛠️
    -- 🔗🐍 [D103]	undocumented-public-function	Missing docstring in public function	✔️ 🛠️
    -- 🔗🐍 [D104]	undocumented-public-package	Missing docstring in public package	✔️ 🛠️
    -- 🔗🐍 [D105]	undocumented-magic-method	Missing docstring in magic method	✔️ 🛠️
    -- 🔗🐍 [D106]	undocumented-public-nested-class	Missing docstring in public nested class	✔️ 🛠️
    -- 🔗🐍 [D107]	undocumented-public-init	Missing docstring in __init__	✔️ 🛠️
    -- 🔗🐍 [D200]	fits-on-one-line	One-line docstring should fit on one line	✔️ 🛠️
    elseif code == "D200" then
      if lang == "es" then
        return "Docstring de una línea debería caber en una línea"
      elseif lang == "pt-br" then
        return "Docstring de uma linha deveria caber em uma linha"
      elseif lang == "fr" then
        return "La docstring d'une ligne devrait tenir sur une ligne"
      elseif lang == "it" then
        return "La docstring di una riga dovrebbe stare in una riga"
      end
    -- 🔗🐍 [D201]	no-blank-line-before-function	No blank lines allowed before function docstring (found {num_lines})	✔️ 🛠️
    elseif code == "D201" then
      local num_lines = message:match("No blank lines allowed before function docstring %(found ([0-9]+)%)")
      if lang == "es" then
        return string.format(
          "No se permiten líneas en blanco antes de la docstring de la función (encontrado %s)",
          num_lines
        )
      elseif lang == "pt-br" then
        return string.format(
          "Não são permitidas linhas em branco antes da docstring da função (encontrado %s)",
          num_lines
        )
      elseif lang == "fr" then
        return string.format(
          "Aucune ligne vide n'est autorisée avant la docstring de la fonction (trouvée %s)",
          num_lines
        )
      elseif lang == "it" then
        return string.format(
          "Nessuna riga vuota è consentita prima della docstring della funzione (trovata %s)",
          num_lines
        )
      end
    -- 🔗🐍 [D202]	no-blank-line-after-function	No blank lines allowed after function docstring (found {num_lines})	✔️ 🛠️
    elseif code == "D202" then
      local num_lines = message:match("No blank lines allowed after function docstring %(found ([0-9]+)%)")
      if lang == "es" then
        return string.format(
          "No se permiten líneas en blanco después de la docstring de la función (encontrado %s)",
          num_lines
        )
      elseif lang == "pt-br" then
        return string.format(
          "Não são permitidas linhas em branco após a docstring da função (encontrado %s)",
          num_lines
        )
      elseif lang == "fr" then
        return string.format(
          "Aucune ligne vide n'est autorisée après la docstring de la fonction (trouvée %s)",
          num_lines
        )
      elseif lang == "it" then
        return string.format(
          "Nessuna riga vuota è consentita dopo la docstring della funzione (trovata %s)",
          num_lines
        )
      end
    -- 🔗🐍 [D203]	one-blank-line-before-class	1 blank line required before class docstring	✔️ 🛠️
    elseif code == "D203" then
      if lang == "es" then
        return "Se requiere 1 línea en blanco antes de la docstring de la clase"
      elseif lang == "pt-br" then
        return "É necessário 1 linha em branco antes da docstring da classe"
      elseif lang == "fr" then
        return "1 ligne vide requise avant la docstring de la classe"
      elseif lang == "it" then
        return "È richiesta 1 riga vuota prima della docstring della classe"
      end
    -- 🔗🐍 [D204]	one-blank-line-after-class	1 blank line required after class docstring	✔️ 🛠️
    elseif code == "D204" then
      if lang == "es" then
        return "Se requiere 1 línea en blanco después de la docstring de la clase"
      elseif lang == "pt-br" then
        return "É necessário 1 linha em branco depois da docstring da classe"
      elseif lang == "fr" then
        return "1 ligne vide requise après la docstring de la classe"
      elseif lang == "it" then
        return "È richiesta 1 riga vuota dopo la docstring della classe"
      end
    -- 🔗🐍 [D205]	blank-line-after-summary	1 blank line required between summary line and description	✔️ 🛠️
    elseif code == "D205" then
      if lang == "es" then
        return "Se requiere 1 línea en blanco entre la línea de resumen y la descripción"
      elseif lang == "pt-br" then
        return "É necessário 1 linha em branco entre a linha de resumo e a descrição"
      elseif lang == "fr" then
        return "1 ligne vide requise entre la ligne de résumé et la description"
      elseif lang == "it" then
        return "È richiesta 1 riga vuota tra la riga di riepilogo e la descrizione"
      end
    -- 🔗🐍 [D206]	indent-with-spaces	Docstring should be indented with spaces, not tabs	✔️ 🛠️
    elseif code == "D206" then
      if lang == "es" then
        return "La docstring debería estar indentada con espacios, no con tabulaciones"
      elseif lang == "pt-br" then
        return "A docstring deveria ser indentada com espaços, não com tabulações"
      elseif lang == "fr" then
        return "La docstring devrait être indentée avec des espaces, pas des tabulations"
      elseif lang == "it" then
        return "La docstring dovrebbe essere indentata con spazi, non con tabulazioni"
      end
    -- 🔗🐍 [D207]	under-indentation	Docstring is under-indented	✔️ 🛠️
    elseif code == "D207" then
      if lang == "es" then
        return "Docstring está sub-indentada"
      elseif lang == "pt-br" then
        return "Docstring está sub-indentada"
      elseif lang == "fr" then
        return "Docstring est sous-indentée"
      elseif lang == "it" then
        return "Docstring è sotto-indentata"
      end
    -- 🔗🐍 [D208]	over-indentation	Docstring is over-indented	✔️ 🛠️
    elseif code == "D208" then
      if lang == "es" then
        return "Docstring está sobre-indentada"
      elseif lang == "pt-br" then
        return "Docstring está sobre-indentada"
      elseif lang == "fr" then
        return "Docstring est sur-indentée"
      elseif lang == "it" then
        return "Docstring è sovra-indentata"
      end
    -- 🔗🐍 [D209]	new-line-after-last-paragraph	Multi-line docstring closing quotes should be on a separate line	✔️ 🛠️
    elseif code == "D209" then
      if lang == "es" then
        return "Las comillas de cierre de la docstring de varias líneas deberían estar en una línea separada"
      elseif lang == "pt-br" then
        return "As aspas de fechamento da docstring de várias linhas deveriam estar em uma linha separada"
      elseif lang == "fr" then
        return "Les guillemets de fermeture de la docstring multi-lignes devraient être sur une ligne séparée"
      elseif lang == "it" then
        return "Le virgolette di chiusura della docstring multi-riga dovrebbero essere su una riga separata"
      end
    -- 🔗🐍 [D210]	surrounding-whitespace	No whitespaces allowed surrounding docstring text	✔️ 🛠️
    elseif code == "D210" then
      if lang == "es" then
        return "No se permiten espacios en blanco alrededor del texto de la docstring"
      elseif lang == "pt-br" then
        return "Não são permitidos espaços em branco ao redor do texto da docstring"
      elseif lang == "fr" then
        return "Aucun espace blanc autorisé autour du texte de la docstring"
      elseif lang == "it" then
        return "Non sono ammessi spazi bianchi attorno al testo della docstring"
      end
    -- 🔗🐍 [D211]	blank-line-before-class	No blank lines allowed before class docstring	✔️ 🛠️
    elseif code == "D211" then
      if lang == "es" then
        return "No se permiten líneas en blanco antes de la docstring de la clase"
      elseif lang == "pt-br" then
        return "Não são permitidas linhas em branco antes da docstring da classe"
      elseif lang == "fr" then
        return "Aucune ligne vide autorisée avant la docstring de la classe"
      elseif lang == "it" then
        return "Non sono ammesse righe vuote prima della docstring della classe"
      end
    -- 🔗🐍 [D212]	multi-line-summary-first-line	Multi-line docstring summary should start at the first line	✔️ 🛠️
    elseif code == "D212" then
      if lang == "es" then
        return "El resumen de la docstring de varias líneas debería empezar en la primera línea"
      elseif lang == "pt-br" then
        return "O resumo da docstring de várias linhas deveria começar na primeira linha"
      elseif lang == "fr" then
        return "Le résumé de la docstring multi-lignes devrait commencer à la première ligne"
      elseif lang == "it" then
        return "Il riepilogo della docstring multi-riga dovrebbe iniziare alla prima riga"
      end
    -- 🔗🐍 [D213]	multi-line-summary-second-line	Multi-line docstring summary should start at the second line	✔️ 🛠️
    elseif code == "D213" then
      if lang == "es" then
        return "El resumen de la docstring de varias líneas debería empezar en la segunda línea"
      elseif lang == "pt-br" then
        return "O resumo da docstring de várias linhas deveria começar na segunda linha"
      elseif lang == "fr" then
        return "Le résumé de la docstring multi-lignes devrait commencer à la deuxième ligne"
      elseif lang == "it" then
        return "Il riepilogo della docstring multi-riga dovrebbe iniziare alla seconda riga"
      end
    -- 🔗🐍 [D214]	section-not-over-indented	Section is over-indented ("{name}")	✔️ 🛠️
    elseif code == "D214" then
      local name = message:match('Section is over-indented %("(.*)"%)')
      if lang == "es" then
        return string.format("La sección está sobre-indentada (%s)", name)
      elseif lang == "pt-br" then
        return string.format("A seção está sobre-indentada (%s)", name)
      elseif lang == "fr" then
        return string.format("La section est sur-indentée (%s)", name)
      elseif lang == "it" then
        return string.format("La sezione è sovra-indentata (%s)", name)
      end
    -- 🔗🐍 [D215]	section-underline-not-over-indented	Section underline is over-indented ("{name}")	✔️ 🛠️
    elseif code == "D215" then
      local name = message:match('Section underline is over-indented %("(.*)"%)')
      if lang == "es" then
        return string.format("La subrayado de la sección está sobre-indentado (%s)", name)
      elseif lang == "pt-br" then
        return string.format("O sublinhado da seção está sobre-indentado (%s)", name)
      elseif lang == "fr" then
        return string.format("Le soulignement de la section est sur-indenté (%s)", name)
      elseif lang == "it" then
        return string.format("Il sottolineato della sezione è sovra-indentato (%s)", name)
      end
    -- 🔗🐍 [D300]	triple-single-quotes	Use triple double quotes """	✔️ 🛠️
    elseif code == "D300" then
      if lang == "es" then
        return 'Usa comillas triples dobles `"""`'
      elseif lang == "pt-br" then
        return 'Use aspas triplas duplas `"""`'
      elseif lang == "fr" then
        return 'Utilisez des triples guillemets doubles `"""`'
      elseif lang == "it" then
        return 'Usa virgolette doppie triple `"""`'
      end
    -- 🔗🐍 [D301]	escape-sequence-in-docstring	Use r""" if any backslashes in a docstring	✔️ 🛠️
    elseif code == "D301" then
      if lang == "es" then
        return 'Usa `r"""` si hay barras invertidas en una docstring'
      end
    -- 🔗🐍 [D400]	ends-in-period	First line should end with a period	✔️ 🛠️
    elseif code == "D400" then
      if lang == "es" then
        return "La primera línea debería terminar con un punto"
      elseif lang == "pt-br" then
        return "A primeira linha deveria terminar com um ponto"
      elseif lang == "fr" then
        return "La première ligne devrait se terminer par un point"
      elseif lang == "it" then
        return "La prima riga dovrebbe terminare con un punto"
      end
    -- 🔗🐍 [D401]	non-imperative-mood	First line of docstring should be in imperative mood: "{first_line}"	✔️ 🛠️
    elseif code == "D401" then
      local first_line = message:match('First line of docstring should be in imperative mood: "(.*)"')
      if lang == "es" then
        return string.format('La primera línea de la docstring debería estar en modo imperativo: "%s"', first_line)
      elseif lang == "pt-br" then
        return string.format('A primeira linha da docstring deveria estar no modo imperativo: "%s"', first_line)
      elseif lang == "fr" then
        return string.format('La première ligne de la docstring devrait être à l\'impératif: "%s"', first_line)
      elseif lang == "it" then
        return string.format('La prima riga della docstring dovrebbe essere in modo imperativo: "%s"', first_line)
      end
    -- 🔗🐍 [D402]	no-signature	First line should not be the function's signature	✔️ 🛠️
    elseif code == "D402" then
      if lang == "es" then
        return "La primera línea no debería ser la firma de la función"
      elseif lang == "pt-br" then
        return "A primeira linha não deveria ser a assinatura da função"
      elseif lang == "fr" then
        return "La première ligne ne devrait pas être la signature de la fonction"
      elseif lang == "it" then
        return "La prima riga non dovrebbe essere la firma della funzione"
      end
    -- 🔗🐍 [D403]	first-line-capitalized	First word of the first line should be capitalized: {} -> {}	✔️ 🛠️
    elseif code == "D403" then
      local first_word, capitalized = message:match("First word of the docstring should be capitalized: (.*) -> (.*)")
      if lang == "es" then
        return string.format(
          "La primera palabra de la primera línea debería estar capitalizada: %s -> %s",
          first_word,
          capitalized
        )
      elseif lang == "pt-br" then
        return string.format(
          "A primeira palavra da primeira linha deveria estar capitalizada: %s -> %s",
          first_word,
          capitalized
        )
      elseif lang == "fr" then
        return string.format(
          "Le premier mot de la première ligne devrait être capitalisé: %s -> %s",
          first_word,
          capitalized
        )
      elseif lang == "it" then
        return string.format(
          "La prima parola della prima riga dovrebbe essere capitalizzata: %s -> %s",
          first_word,
          capitalized
        )
      end
    -- 🔗🐍 [D404]	docstring-starts-with-this	First word of the docstring should not be "This"	✔️ 🛠️
    elseif code == "D404" then
      if lang == "es" then
        return 'La primera palabra de la docstring no debería ser "This"'
      elseif lang == "pt-br" then
        return 'A primeira palavra da docstring não deveria ser "This"'
      elseif lang == "fr" then
        return 'Le premier mot de la docstring ne devrait pas être "This"'
      elseif lang == "it" then
        return 'La prima parola della docstring non dovrebbe essere "This"'
      end
    -- 🔗🐍 [D405]	capitalize-section-name	Section name should be properly capitalized ("{name}")	✔️ 🛠️
    elseif code == "D405" then
      local name = message:match('Section name should be properly capitalized %("(.*)"%)')
      if lang == "es" then
        return string.format("El nombre de la sección debería estar capitalizado correctamente (%s)", name)
      elseif lang == "pt-br" then
        return string.format("O nome da seção deveria estar capitalizado corretamente (%s)", name)
      elseif lang == "fr" then
        return string.format("Le nom de la section devrait être correctement capitalisé (%s)", name)
      elseif lang == "it" then
        return string.format("Il nome della sezione dovrebbe essere correttamente capitalizzato (%s)", name)
      end
    -- 🔗🐍 [D406]	new-line-after-section-name	Section name should end with a newline ("{name}")	✔️ 🛠️
    elseif code == "D406" then
      local name = message:match('Section name should end with a newline %("(.*)"%)')
      if lang == "es" then
        return string.format("El nombre de la sección debería terminar con una nueva línea (%s)", name)
      elseif lang == "pt-br" then
        return string.format("O nome da seção deveria terminar com uma nova linha (%s)", name)
      elseif lang == "fr" then
        return string.format("Le nom de la section devrait se terminer par une nouvelle ligne (%s)", name)
      elseif lang == "it" then
        return string.format("Il nome della sezione dovrebbe terminare con una nuova riga (%s)", name)
      end
    -- 🔗🐍 [D407]	dashed-underline-after-section	Missing dashed underline after section ("{name}")	✔️ 🛠️
    elseif code == "D407" then
      local name = message:match('Missing dashed underline after section %("(.*)"%)')
      if lang == "es" then
        return string.format("Falta subrayado punteado después de la sección (%s)", name)
      elseif lang == "pt-br" then
        return string.format("Falta sublinhado pontilhado após a seção (%s)", name)
      elseif lang == "fr" then
        return string.format("Soulignement en pointillés manquant après la section (%s)", name)
      elseif lang == "it" then
        return string.format("Manca il sottolineato tratteggiato dopo la sezione (%s)", name)
      end
    -- 🔗🐍 [D408]	section-underline-after-name	Section underline should be in the line following the section's name ("{name}")	✔️ 🛠️
    elseif code == "D408" then
      local name = message:match('Section underline should be in the line following the section\'s name %("(.*)"%)')
      if lang == "es" then
        return string.format(
          "El subrayado de la sección debería estar en la línea siguiente al nombre de la sección (%s)",
          name
        )
      elseif lang == "pt-br" then
        return string.format("O sublinhado da seção deveria estar na linha seguinte ao nome da seção (%s)", name)
      elseif lang == "fr" then
        return string.format(
          "Le soulignement de la section devrait être à la ligne suivant le nom de la section (%s)",
          name
        )
      elseif lang == "it" then
        return string.format(
          "Il sottolineato della sezione dovrebbe essere nella riga successiva al nome della sezione (%s)",
          name
        )
      end
    -- 🔗🐍 [D409]	section-underline-matches-section-length	Section underline should match the length of its name ("{name}")	✔️ 🛠️
    elseif code == "D409" then
      local name = message:match('Section underline should match the length of its name %("(.*)"%)')
      if lang == "es" then
        return string.format("El subrayado de la sección debería coincidir con la longitud de su nombre (%s)", name)
      elseif lang == "pt-br" then
        return string.format("O sublinhado da seção deveria coincidir com o comprimento do seu nome (%s)", name)
      elseif lang == "fr" then
        return string.format("Le soulignement de la section devrait correspondre à la longueur de son nom (%s)", name)
      elseif lang == "it" then
        return string.format(
          "Il sottolineato della sezione dovrebbe corrispondere alla lunghezza del suo nome (%s)",
          name
        )
      end
    -- 🔗🐍 [D410]	no-blank-line-after-section	Missing blank line after section ("{name}")	✔️ 🛠️
    elseif code == "D410" then
      local name = message:match('Missing blank line after section %("(.*)"%)')
      if lang == "es" then
        return string.format("Falta línea en blanco después de la sección (%s)", name)
      elseif lang == "pt-br" then
        return string.format("Falta linha em branco após a seção (%s)", name)
      elseif lang == "fr" then
        return string.format("Ligne vide manquante après la section (%s)", name)
      elseif lang == "it" then
        return string.format("Manca una riga vuota dopo la sezione (%s)", name)
      end
    -- 🔗🐍 [D411]	no-blank-line-before-section	Missing blank line before section ("{name}")	✔️ 🛠️
    elseif code == "D411" then
      local name = message:match('Missing blank line before section %("(.*)"%)')
      if lang == "es" then
        return string.format("Falta línea en blanco antes de la sección (%s)", name)
      elseif lang == "pt-br" then
        return string.format("Falta linha em branco antes da seção (%s)", name)
      elseif lang == "fr" then
        return string.format("Ligne vide manquante avant la section (%s)", name)
      elseif lang == "it" then
        return string.format("Manca una riga vuota prima della sezione (%s)", name)
      end
    -- 🔗🐍 [D412]	blank-lines-between-header-and-content	No blank lines allowed between a section header and its content ("{name}")	✔️ 🛠️
    elseif code == "D412" then
      local name = message:match('No blank lines allowed between a section header and its content %("(.*)"%)')
      if lang == "es" then
        return string.format(
          "No se permiten líneas en blanco entre un encabezado de sección y su contenido (%s)",
          name
        )
      elseif lang == "pt-br" then
        return string.format(
          "Não são permitidas linhas em branco entre um cabeçalho de seção e seu conteúdo (%s)",
          name
        )
      elseif lang == "fr" then
        return string.format("Aucune ligne vide autorisée entre un en-tête de section et son contenu (%s)", name)
      elseif lang == "it" then
        return string.format(
          "Non sono ammesse righe vuote tra un'intestazione di sezione e il suo contenuto (%s)",
          name
        )
      end
    -- 🔗🐍 [D413]	blank-line-after-last-section	Missing blank line after last section ("{name}")	✔️ 🛠️
    elseif code == "D413" then
      local name = message:match('Missing blank line after last section %("(.*)"%)')
      if lang == "es" then
        return string.format("Falta línea en blanco después de la última sección (%s)", name)
      elseif lang == "pt-br" then
        return string.format("Falta linha em branco após a última seção (%s)", name)
      elseif lang == "fr" then
        return string.format("Ligne vide manquante après la dernière section (%s)", name)
      elseif lang == "it" then
        return string.format("Manca una riga vuota dopo l'ultima sezione (%s)", name)
      end
    -- 🔗🐍 [D414]	empty-docstring-section	Section has no content ("{name}")	✔️ 🛠️
    elseif code == "D414" then
      local name = message:match('Section has no content %("(.*)"%)')
      if lang == "es" then
        return string.format("La sección no tiene contenido (%s)", name)
      elseif lang == "pt-br" then
        return string.format("A seção não tem conteúdo (%s)", name)
      elseif lang == "fr" then
        return string.format("La section n'a pas de contenu (%s)", name)
      elseif lang == "it" then
        return string.format("La sezione non ha contenuto (%s)", name)
      end
    -- 🔗🐍 [D415]	ends-in-punctuation	First line should end with a period, question mark, or exclamation point	✔️ 🛠️
    elseif code == "D415" then
      if lang == "es" then
        return "La primera línea debería terminar con un punto, signo de interrogación o signo de exclamación"
      elseif lang == "pt-br" then
        return "A primeira linha deve terminar com um ponto, ponto de interrogação ou ponto de exclamação"
      elseif lang == "fr" then
        return "La première ligne doit se terminer par un point, un point d'interrogation ou un point d'exclamation"
      elseif lang == "it" then
        return "La prima riga dovrebbe terminare con un punto, un punto interrogativo o un punto esclamativo"
      end
    -- 🔗🐍 [D416]	section-name-ends-in-colon	Section name should end with a colon ("{name}")	✔️ 🛠️
    elseif code == "D416" then
      local name = message:match('Section name should end with a colon %("(.*)"%)')
      if lang == "es" then
        return string.format("El nombre de la sección debería terminar con dos puntos (%s)", name)
      elseif lang == "pt-br" then
        return string.format("O nome da seção deveria terminar com dois pontos (%s)", name)
      elseif lang == "fr" then
        return string.format("Le nom de la section devrait se terminer par deux points (%s)", name)
      elseif lang == "it" then
        return string.format("Il nome della sezione dovrebbe terminare con i due punti (%s)", name)
      end
    -- 🔗🐍 [D417]	undocumented-param	Missing argument description in the docstring for {definition}: {name}	✔️ 🛠️
    elseif code == "D417" then
      local definition, name = message:match("Missing argument description in the docstring for ([^:]+): (.*)")
      if lang == "es" then
        return string.format("Descripción de argumento faltante en la docstring para %s: %s", definition, name)
      elseif lang == "pt-br" then
        return string.format("Descrição de argumento faltante na docstring para %s: %s", definition, name)
      elseif lang == "fr" then
        return string.format("Description d'argument manquante dans la docstring pour %s: %s", definition, name)
      elseif lang == "it" then
        return string.format("Descrizione dell'argomento mancante nella docstring per %s: %s", definition, name)
      end
    -- 🔗🐍 [D418]	overload-with-docstring	Function decorated with @overload shouldn't contain a docstring	✔️ 🛠️
    elseif code == "D418" then
      if lang == "es" then
        return "La función decorada con `@overload` no debería contener una docstring"
      elseif lang == "pt-br" then
        return "A função decorada com `@overload` não deveria conter uma docstring"
      elseif lang == "fr" then
        return "La fonction décorée avec `@overload` ne devrait pas contenir de docstring"
      elseif lang == "it" then
        return "La funzione decorata con `@overload` non dovrebbe contenere una docstring"
      end
    -- 🔗🐍 [D419]	empty-docstring	Docstring is empty	✔️ 🛠️
    elseif code == "D419" then
      if lang == "es" then
        return "Docstring está vacía"
      elseif lang == "pt-br" then
        return "Docstring está vazia"
      elseif lang == "fr" then
        return "La docstring est vide"
      elseif lang == "it" then
        return "La docstring è vuota"
      end
    -- 🔗🐍 [UP001]	useless-metaclass-type	__metaclass__ = type is implied	✔️ 🛠️
    -- 🔗🐍 [UP003]	type-of-primitive	Use {} instead of type(...)	✔️ 🛠️
    -- 🔗🐍 [UP004]	useless-object-inheritance	Class {name} inherits from object	✔️ 🛠️
    -- 🔗🐍 [UP005]	deprecated-unittest-alias	{alias} is deprecated, use {target}	✔️ 🛠️
    -- 🔗🐍 [UP006]	non-pep585-annotation	Use {to} instead of {from} for type annotation	✔️ 🛠️
    -- 🔗🐍 [UP007]	non-pep604-annotation	Use X | Y for type annotations	✔️ 🛠️
    -- 🔗🐍 [UP008]	super-call-with-parameters	Use super() instead of super(__class__, self)	✔️ 🛠️
    -- 🔗🐍 [UP009]	utf8-encoding-declaration	UTF-8 encoding declaration is unnecessary	✔️ 🛠️
    -- 🔗🐍 [UP010]	unnecessary-future-import	Unnecessary __future__ import {import} for target Python version	✔️ 🛠️
    -- 🔗🐍 [UP011]	lru-cache-without-parameters	Unnecessary parentheses to functools.lru_cache	✔️ 🛠️
    -- 🔗🐍 [UP012]	unnecessary-encode-utf8	Unnecessary call to encode as UTF-8	✔️ 🛠️
    -- 🔗🐍 [UP013]	convert-typed-dict-functional-to-class	Convert {name} from TypedDict functional to class syntax	✔️ 🛠️
    -- 🔗🐍 [UP014]	convert-named-tuple-functional-to-class	Convert {name} from NamedTuple functional to class syntax	✔️ 🛠️
    -- 🔗🐍 [UP015]	redundant-open-modes	Unnecessary open mode parameters	✔️ 🛠️
    elseif code == "UP015" then
      if lang == "es" then
        return "Parámetros de modo de apertura innecesarios"
      elseif lang == "pt-br" then
        return "Parâmetros de modo de abertura desnecessários"
      elseif lang == "fr" then
        return "Paramètres de mode d'ouverture inutiles"
      elseif lang == "it" then
        return "Parametri di modalità di apertura non necessari"
      end
    -- 🔗🐍 [UP017]	datetime-timezone-utc	Use datetime.UTC alias	✔️ 🛠️
    -- 🔗🐍 [UP018]	native-literals	Unnecessary {literal_type} call (rewrite as a literal)	✔️ 🛠️
    -- 🔗🐍 [UP019]	typing-text-str-alias	typing.Text is deprecated, use str	✔️ 🛠️
    -- 🔗🐍 [UP020]	open-alias	Use builtin open	✔️ 🛠️
    -- 🔗🐍 [UP021]	replace-universal-newlines	universal_newlines is deprecated, use text	✔️ 🛠️
    -- 🔗🐍 [UP022]	replace-stdout-stderr	Prefer capture_output over sending stdout and stderr to PIPE	✔️ 🛠️
    -- 🔗🐍 [UP023]	deprecated-c-element-tree	cElementTree is deprecated, use ElementTree	✔️ 🛠️
    -- 🔗🐍 [UP024]	os-error-alias	Replace aliased errors with OSError	✔️ 🛠️
    -- 🔗🐍 [UP025]	unicode-kind-prefix	Remove unicode literals from strings	✔️ 🛠️
    -- 🔗🐍 [UP026]	deprecated-mock-import	mock is deprecated, use unittest.mock	✔️ 🛠️
    -- 🔗🐍 [UP027]	unpacked-list-comprehension	Replace unpacked list comprehension with a generator expression	✔️ 🛠️
    -- 🔗🐍 [UP028]	yield-in-for-loop	Replace yield over for loop with yield from	✔️ 🛠️
    -- 🔗🐍 [UP029]	unnecessary-builtin-import	Unnecessary builtin import: {import}	✔️ 🛠️
    -- 🔗🐍 [UP030]	format-literals	Use implicit references for positional format fields	✔️ 🛠️
    -- 🔗🐍 [UP031]	printf-string-formatting	Use format specifiers instead of percent format	✔️ 🛠️
    -- 🔗🐍 [UP032]	f-string	Use f-string instead of format call	✔️ 🛠️
    -- 🔗🐍 [UP033]	lru-cache-with-maxsize-none	Use @functools.cache instead of @functools.lru_cache(maxsize=None)	✔️ 🛠️
    -- 🔗🐍 [UP034]	extraneous-parentheses	Avoid extraneous parentheses	✔️ 🛠️
    -- 🔗🐍 [UP035]	deprecated-import	Import from {target} instead: {names}	✔️ 🛠️
    elseif code == "UP035" then
      local target, names = message:match("Import from (.*) instead: (.*)")
      if target == nil then
        names, target = message:match("(.*) is deprecated, use (.*) instead")
        if lang == "es" then
          return string.format("%s está obsoleto, usa %s en su lugar", names, target)
        elseif lang == "pt-br" then
          return string.format("%s está obsoleto, use %s em seu lugar", names, target)
        elseif lang == "fr" then
          return string.format("%s est obsolète, utilisez %s à la place", names, target)
        elseif lang == "it" then
          return string.format("%s è deprecato, usa %s al suo posto", names, target)
        end
      end

      if lang == "es" then
        return string.format("Importa desde %s en lugar de: %s", target, names)
      elseif lang == "pt-br" then
        return string.format("Importe de %s em vez de: %s", target, names)
      elseif lang == "fr" then
        return string.format("Importez depuis %s à la place de: %s", target, names)
      elseif lang == "it" then
        return string.format("Importa da %s invece di: %s", target, names)
      end
    -- 🔗🐍 [UP036] outdated-version-block Version block is outdated for minimum Python version ✔️ 🛠️
    -- 🔗🐍 [UP037] quoted-annotation Remove quotes from type annotation ✔️ 🛠️
    -- 🔗🐍 [UP038] non-pep604-isinstance Use X | Y in {} call instead of (X, Y) ✔️ 🛠️
    -- 🔗🐍 [UP039] unnecessary-class-parentheses Unnecessary parentheses after class definition ✔️ 🛠️
    -- 🔗🐍 [UP040] non-pep695-type-alias Type alias {name} uses TypeAlias annotation instead of the type keyword ✔️ 🛠️
    -- 🔗🐍 [UP041] timeout-error-alias Replace aliased errors with TimeoutError ✔️ 🛠️
    -- 🔗🐍 [UP042] replace-str-enum Class {name} inherits from both str and enum.Enum 🧪 🛠️
    -- 🔗🐍 [YTT101] sys-version-slice3 sys.version[:3] referenced (python3.10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [YTT102] sys-version2 sys.version[2] referenced (python3.10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [YTT103] sys-version-cmp-str3 sys.version compared to string (python3.10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [YTT201] sys-version-info0-eq3 sys.version_info[0] == 3 referenced (python4), use >= ✔️ 🛠️
    -- 🔗🐍 [YTT202] six-py3 six.PY3 referenced (python4), use not six.PY2 ✔️ 🛠️
    -- 🔗🐍 [YTT203] sys-version-info1-cmp-int sys.version_info[1] compared to integer (python4), compare sys.version_info to tuple ✔️ 🛠️
    -- 🔗🐍 [YTT204] sys-version-info-minor-cmp-int sys.version_info.minor compared to integer (python4), compare sys.version_info to tuple ✔️ 🛠️
    -- 🔗🐍 [YTT301] sys-version0 sys.version[0] referenced (python10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [YTT302] sys-version-cmp-str10 sys.version compared to string (python10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [YTT303] sys-version-slice1 sys.version[:1] referenced (python10), use sys.version_info ✔️ 🛠️
    -- 🔗🐍 [ANN001] missing-type-function-argument Missing type annotation for function argument {name} ✔️ 🛠️
    -- 🔗🐍 [ANN002] missing-type-args Missing type annotation for *{name} ✔️ 🛠️
    -- 🔗🐍 [ANN003] missing-type-kwargs Missing type annotation for **{name} ✔️ 🛠️
    -- 🔗🐍 [ANN101] missing-type-self Missing type annotation for {name} in method ⚠️ 🛠️
    -- 🔗🐍 [ANN102] missing-type-cls Missing type annotation for {name} in classmethod ⚠️ 🛠️
    -- 🔗🐍 [ANN201] missing-return-type-undocumented-public-function Missing return type annotation for public function {name} ✔️ 🛠️
    -- 🔗🐍 [ANN202] missing-return-type-private-function Missing return type annotation for private function {name} ✔️ 🛠️
    -- 🔗🐍 [ANN204] missing-return-type-special-method Missing return type annotation for special method {name} ✔️ 🛠️
    -- 🔗🐍 [ANN205] missing-return-type-static-method Missing return type annotation for staticmethod {name} ✔️ 🛠️
    -- 🔗🐍 [ANN206] missing-return-type-class-method Missing return type annotation for classmethod {name} ✔️ 🛠️
    -- 🔗🐍 [ANN401] any-type Dynamically typed expressions (typing.Any) are disallowed in {name} ✔️ 🛠️
    -- 🔗🐍 [ASYNC100] blocking-http-call-in-async-function Async functions should not call blocking HTTP methods ✔️ 🛠️
    -- 🔗🐍 [ASYNC101] open-sleep-or-subprocess-in-async-function Async functions should not call open, time.sleep, or subprocess methods ✔️ 🛠️
    -- 🔗🐍 [ASYNC102] blocking-os-call-in-async-function Async functions should not call synchronous os methods ✔️ 🛠️
    -- 🔗🐍 [TRIO100] trio-timeout-without-await A with {method_name}(...): context does not contain any await statements. This makes it pointless, as the timeout can only be triggered by a checkpoint. ✔️ 🛠️
    -- 🔗🐍 [TRIO105] trio-sync-call Call to {method_name} is not immediately awaited ✔️ 🛠️
    -- 🔗🐍 [TRIO109] trio-async-function-with-timeout Prefer trio.fail_after and trio.move_on_after over manual async timeout behavior ✔️ 🛠️
    -- 🔗🐍 [TRIO110] trio-unneeded-sleep Use trio.Event instead of awaiting trio.sleep in a while loop ✔️ 🛠️
    -- 🔗🐍 [TRIO115] trio-zero-sleep-call Use trio.lowlevel.checkpoint() instead of trio.sleep(0) ✔️ 🛠️
    -- 🔗🐍 [S101] assert Use of assert detected ✔️ 🛠️
    -- 🔗🐍 [S102] exec-builtin Use of exec detected ✔️ 🛠️
    -- 🔗🐍 [S103] bad-file-permissions os.chmod setting a permissive mask {mask:#o} on file or directory ✔️ 🛠️
    -- 🔗🐍 [S104] hardcoded-bind-all-interfaces Possible binding to all interfaces ✔️ 🛠️
    -- 🔗🐍 [S105] hardcoded-password-string Possible hardcoded password assigned to: "{}" ✔️ 🛠️
    -- 🔗🐍 [S106] hardcoded-password-func-arg Possible hardcoded password assigned to argument: "{}" ✔️ 🛠️
    -- 🔗🐍 [S107] hardcoded-password-default Possible hardcoded password assigned to function default: "{}" ✔️ 🛠️
    -- 🔗🐍 [S108] hardcoded-temp-file Probable insecure usage of temporary file or directory: "{}" ✔️ 🛠️
    -- 🔗🐍 [S110] try-except-pass try-except-pass detected, consider logging the exception ✔️ 🛠️
    -- 🔗🐍 [S112] try-except-continue try-except-continue detected, consider logging the exception ✔️ 🛠️
    -- 🔗🐍 [S113] request-without-timeout Probable use of requests call without timeout ✔️ 🛠️
    -- 🔗🐍 [S201] flask-debug-true Use of debug=True in Flask app detected ✔️ 🛠️
    -- 🔗🐍 [S202] tarfile-unsafe-members Uses of tarfile.extractall() ✔️ 🛠️
    -- 🔗🐍 [S301] suspicious-pickle-usage pickle and modules that wrap it can be unsafe when used to deserialize untrusted data, possible security issue ✔️ 🛠️
    -- 🔗🐍 [S302] suspicious-marshal-usage Deserialization with the marshal module is possibly dangerous ✔️ 🛠️
    -- 🔗🐍 [S303] suspicious-insecure-hash-usage Use of insecure MD2, MD4, MD5, or SHA1 hash function ✔️ 🛠️
    -- 🔗🐍 [S304] suspicious-insecure-cipher-usage Use of insecure cipher, replace with a known secure cipher such as AES ✔️ 🛠️
    -- 🔗🐍 [S305] suspicious-insecure-cipher-mode-usage Use of insecure block cipher mode, replace with a known secure mode such as CBC or CTR ✔️ 🛠️
    -- 🔗🐍 [S306] suspicious-mktemp-usage Use of insecure and deprecated function (mktemp) ✔️ 🛠️
    -- 🔗🐍 [S307] suspicious-eval-usage Use of possibly insecure function; consider using ast.literal_eval ✔️ 🛠️
    -- 🔗🐍 [S308] suspicious-mark-safe-usage Use of mark_safe may expose cross-site scripting vulnerabilities ✔️ 🛠️
    -- 🔗🐍 [S310] suspicious-url-open-usage Audit URL open for permitted schemes. Allowing use of file: or custom schemes is often unexpected. ✔️ 🛠️
    -- 🔗🐍 [S311] suspicious-non-cryptographic-random-usage Standard pseudo-random generators are not suitable for cryptographic purposes ✔️ 🛠️
    -- 🔗🐍 [S312] suspicious-telnet-usage Telnet-related functions are being called. Telnet is considered insecure. Use SSH or some other encrypted protocol. ✔️ 🛠️
    -- 🔗🐍 [S313] suspicious-xmlc-element-tree-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S314] suspicious-xml-element-tree-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S315] suspicious-xml-expat-reader-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S316] suspicious-xml-expat-builder-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S317] suspicious-xml-sax-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S318] suspicious-xml-mini-dom-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S319] suspicious-xml-pull-dom-usage Using xml to parse untrusted data is known to be vulnerable to XML attacks; use defusedxml equivalents ✔️ 🛠️
    -- 🔗🐍 [S320] suspicious-xmle-tree-usage Using lxml to parse untrusted data is known to be vulnerable to XML attacks ✔️ 🛠️
    -- 🔗🐍 [S321] suspicious-ftp-lib-usage FTP-related functions are being called. FTP is considered insecure. Use SSH/SFTP/SCP or some other encrypted protocol. ✔️ 🛠️
    -- 🔗🐍 [S323] suspicious-unverified-context-usage Python allows using an insecure context via the _create_unverified_context that reverts to the previous behavior that does not validate certificates or perform hostname checks. ✔️ 🛠️
    -- 🔗🐍 [S324] hashlib-insecure-hash-function Probable use of insecure hash functions in {library}: {string} ✔️ 🛠️
    -- 🔗🐍 [S401] suspicious-telnetlib-import telnetlib and related modules are considered insecure. Use SSH or another encrypted protocol. 🧪 🛠️
    -- 🔗🐍 [S402] suspicious-ftplib-import ftplib and related modules are considered insecure. Use SSH, SFTP, SCP, or another encrypted protocol. 🧪 🛠️
    -- 🔗🐍 [S403] suspicious-pickle-import pickle, cPickle, dill, and shelve modules are possibly insecure 🧪 🛠️
    -- 🔗🐍 [S404] suspicious-subprocess-import subprocess module is possibly insecure 🧪 🛠️
    -- 🔗🐍 [S405] suspicious-xml-etree-import xml.etree methods are vulnerable to XML attacks 🧪 🛠️
    -- 🔗🐍 [S406] suspicious-xml-sax-import xml.sax methods are vulnerable to XML attacks 🧪 🛠️
    -- 🔗🐍 [S407] suspicious-xml-expat-import xml.dom.expatbuilder is vulnerable to XML attacks 🧪 🛠️
    -- 🔗🐍 [S408] suspicious-xml-minidom-import xml.dom.minidom is vulnerable to XML attacks 🧪 🛠️
    -- 🔗🐍 [S409] suspicious-xml-pulldom-import xml.dom.pulldom is vulnerable to XML attacks 🧪 🛠️
    -- 🔗🐍 [S410] suspicious-lxml-import lxml is vulnerable to XML attacks ❌ 🛠️
    -- 🔗🐍 [S411] suspicious-xmlrpc-import XMLRPC is vulnerable to remote XML attacks 🧪 🛠️
    -- 🔗🐍 [S412] suspicious-httpoxy-import httpoxy is a set of vulnerabilities that affect application code running inCGI, or CGI-like environments. The use of CGI for web applications should be avoided 🧪 🛠️
    -- 🔗🐍 [S413] suspicious-pycrypto-import pycrypto library is known to have publicly disclosed buffer overflow vulnerability 🧪 🛠️
    -- 🔗🐍 [S415] suspicious-pyghmi-import An IPMI-related module is being imported. Prefer an encrypted protocol over IPMI. 🧪 🛠️
    -- 🔗🐍 [S501] request-with-no-cert-validation Probable use of {string} call with verify=False disabling SSL certificate checks ✔️ 🛠️
    -- 🔗🐍 [S502] ssl-insecure-version Call made with insecure SSL protocol: {protocol} ✔️ 🛠️
    -- 🔗🐍 [S503] ssl-with-bad-defaults Argument default set to insecure SSL protocol: {protocol} ✔️ 🛠️
    -- 🔗🐍 [S504] ssl-with-no-version ssl.wrap_socket called without an `ssl_version`` ✔️ 🛠️
    -- 🔗🐍 [S505] weak-cryptographic-key {cryptographic_key} key sizes below {minimum_key_size} bits are considered breakable ✔️ 🛠️
    -- 🔗🐍 [S506] unsafe-yaml-load Probable use of unsafe loader {name} with yaml.load. Allows instantiation of arbitrary objects. Consider yaml.safe_load. ✔️ 🛠️
    -- 🔗🐍 [S507] ssh-no-host-key-verification Paramiko call with policy set to automatically trust the unknown host key ✔️ 🛠️
    -- 🔗🐍 [S508] snmp-insecure-version The use of SNMPv1 and SNMPv2 is insecure. Use SNMPv3 if able. ✔️ 🛠️
    -- 🔗🐍 [S509] snmp-weak-cryptography You should not use SNMPv3 without encryption. noAuthNoPriv & authNoPriv is insecure. ✔️ 🛠️
    -- 🔗🐍 [S601] paramiko-call Possible shell injection via Paramiko call; check inputs are properly sanitized ✔️ 🛠️
    -- 🔗🐍 [S602] subprocess-popen-with-shell-equals-true subprocess call with shell=True seems safe, but may be changed in the future; consider rewriting without shell ✔️ 🛠️
    -- 🔗🐍 [S603] subprocess-without-shell-equals-true subprocess call: check for execution of untrusted input ✔️ 🛠️
    -- 🔗🐍 [S604] call-with-shell-equals-true Function call with shell=True parameter identified, security issue ✔️ 🛠️
    -- 🔗🐍 [S605] start-process-with-a-shell Starting a process with a shell: seems safe, but may be changed in the future; consider rewriting without shell ✔️ 🛠️
    -- 🔗🐍 [S606] start-process-with-no-shell Starting a process without a shell ✔️ 🛠️
    -- 🔗🐍 [S607] start-process-with-partial-path Starting a process with a partial executable path ✔️ 🛠️
    -- 🔗🐍 [S608] hardcoded-sql-expression Possible SQL injection vector through string-based query construction ✔️ 🛠️
    -- 🔗🐍 [S609] unix-command-wildcard-injection Possible wildcard injection in call due to * usage ✔️ 🛠️
    -- 🔗🐍 [S610] django-extra Use of Django extra can lead to SQL injection vulnerabilities 🧪 🛠️
    -- 🔗🐍 [S611] django-raw-sql Use of RawSQL can lead to SQL injection vulnerabilities ✔️ 🛠️
    -- 🔗🐍 [S612] logging-config-insecure-listen Use of insecure logging.config.listen detected ✔️ 🛠️
    -- 🔗🐍 [S701] jinja2-autoescape-false Using jinja2 templates with autoescape=False is dangerous and can lead to XSS. Ensure autoescape=True or use the select_autoescape function. ✔️ 🛠️
    -- 🔗🐍 [S702] mako-templates Mako templates allow HTML and JavaScript rendering by default and are inherently open to XSS attacks ✔️ 🛠️
    -- 🔗🐍 [BLE001] blind-except Do not catch blind exception: {name} ✔️ 🛠️
    -- 🔗🐍 [FBT001]	boolean-type-hint-positional-argument	Boolean-typed positional argument in function definition	✔️ 🛠️
    elseif code == "FBT001" then
      if lang == "es" then
        return "Argumento posicional de tipo booleano en la definición de la función"
      elseif lang == "pt-br" then
        return "Argumento posicional de tipo booleano na definição da função"
      elseif lang == "fr" then
        return "Argument positionnel de type booléen dans la définition de la fonction"
      elseif lang == "it" then
        return "Argomento posizionale di tipo booleano nella definizione della funzione"
      end
    -- 🔗🐍 [FBT002]	boolean-default-value-positional-argument	Boolean default positional argument in function definition	✔️ 🛠️
    elseif code == "FBT002" then
      if lang == "es" then
        return "Argumento posicional predeterminado booleano en la definición de la función"
      elseif lang == "pt-br" then
        return "Argumento posicional padrão booleano na definição da função"
      elseif lang == "fr" then
        return "Argument positionnel par défaut booléen dans la définition de la fonction"
      elseif lang == "it" then
        return "Argomento posizionale predefinito booleano nella definizione della funzione"
      end
    -- 🔗🐍 [FBT003]	boolean-positional-value-in-call	Boolean positional value in function call	✔️ 🛠️
    elseif code == "FBT003" then
      if lang == "es" then
        return "Valor posicional booleano en la llamada de función"
      elseif lang == "pt-br" then
        return "Valor posicional booleano na chamada de função"
      elseif lang == "fr" then
        return "Valeur booléenne positionnelle dans l'appel de fonction"
      elseif lang == "it" then
        return "Valore posizionale booleano nella chiamata della funzione"
      end

    -- 🔗🐍 [B002]	unary-prefix-increment-decrement	Python does not support the unary prefix increment operator (++)	✔️ 🛠️
    -- 🔗🐍 [B003]	assignment-to-os-environ	Assigning to os.environ doesn't clear the environment	✔️ 🛠️
    -- 🔗🐍 [B004]	unreliable-callable-check	Using hasattr(x, "__call__") to test if x is callable is unreliable. Use callable(x) for consistent results.	✔️ 🛠️
    -- 🔗🐍 [B005]	strip-with-multi-characters	Using .strip() with multi-character strings is misleading	✔️ 🛠️
    -- 🔗🐍 [B006]	mutable-argument-default	Do not use mutable data structures for argument defaults	✔️ 🛠️
    elseif code == "B006" then
      if lang == "es" then
        return "No uses estructuras de datos mutables para argumentos predeterminados"
      elseif lang == "pt-br" then
        return "Não use estruturas de dados mutáveis para argumentos padrão"
      elseif lang == "fr" then
        return "N'utilisez pas de structures de données mutables pour les arguments par défaut"
      elseif lang == "it" then
        return "Non utilizzare strutture dati mutabili per gli argomenti predefiniti"
      end
    -- 🔗🐍 [B007]	unused-loop-control-variable	Loop control variable {name} not used within loop body	✔️ 🛠️
    elseif code == "B007" then
      local name = message:match("Loop control variable ([^']+) not used within loop body")
      if lang == "es" then
        return string.format("El variable de control del bucle %s no se usa dentro del cuerpo del bucle", name)
      elseif lang == "pt-br" then
        return string.format("A variável de controle do loop %s não é usada dentro do corpo do loop", name)
      elseif lang == "fr" then
        return string.format(
          "La variable de contrôle de la boucle %s n'est pas utilisée dans le corps de la boucle",
          name
        )
      elseif lang == "it" then
        return string.format(
          "La variabile di controllo del ciclo %s non è utilizzata all'interno del corpo del ciclo",
          name
        )
      end
      -- 🔗🐍 [B008]	function-call-in-default-argument	Do not perform function call {name} in argument defaults; instead, perform the call within the function, or read the default from a module-level singleton variable	✔️ 🛠️
      -- 🔗🐍 [B009]	get-attr-with-constant	Do not call getattr with a constant attribute value. It is not any safer than normal property access.	✔️ 🛠️
      -- 🔗🐍 [B010]	set-attr-with-constant	Do not call setattr with a constant attribute value. It is not any safer than normal property access.	✔️ 🛠️
      -- 🔗🐍 [B011]	assert-false	Do not assert False (python -O removes these calls), raise AssertionError()	✔️ 🛠️
      -- 🔗🐍 [B012]	jump-statement-in-finally	{name} inside finally blocks cause exceptions to be silenced	✔️ 🛠️
      -- 🔗🐍 [B013]	redundant-tuple-in-exception-handler	A length-one tuple literal is redundant in exception handlers	✔️ 🛠️
      -- 🔗🐍 [B014]	duplicate-handler-exception	Exception handler with duplicate exception: {name}	✔️ 🛠️
      -- 🔗🐍 [B015]	useless-comparison	Pointless comparison. Did you mean to assign a value? Otherwise, prepend assert or remove it.	✔️ 🛠️
      -- 🔗🐍 [B016]	raise-literal	Cannot raise a literal. Did you intend to return it or raise an Exception?	✔️ 🛠️
      -- 🔗🐍 [B017]	assert-raises-exception	{assertion}({exception}) should be considered evil	✔️ 🛠️
      -- 🔗🐍 [B018]	useless-expression	Found useless expression. Either assign it to a variable or remove it.	✔️ 🛠️
    elseif code == "B018" then
      if lang == "es" then
        return "Se encontró una expresión inútil. Asígnala a una variable o elimínala."
      elseif lang == "pt-br" then
        return "Expressão inútil encontrada. Atribua-a a uma variável ou remova-a."
      elseif lang == "fr" then
        return "Expression inutile trouvée. Attribuez-la à une variable ou supprimez-la."
      elseif lang == "it" then
        return "Espressione inutile trovata. Assegnala a una variabile o rimuovila."
      end
      -- 🔗🐍 [B019]	cached-instance-method	Use of functools.lru_cache or functools.cache on methods can lead to memory leaks	✔️ 🛠️
      -- 🔗🐍 [B020]	loop-variable-overrides-iterator	Loop control variable {name} overrides iterable it iterates	✔️ 🛠️
      -- 🔗🐍 [B021]	f-string-docstring	f-string used as docstring. Python will interpret this as a joined string, rather than a docstring.	✔️ 🛠️
      -- 🔗🐍 [B022]	useless-contextlib-suppress	No arguments passed to contextlib.suppress. No exceptions will be suppressed and therefore this context manager is redundant	✔️ 🛠️
      -- 🔗🐍 [B023]	function-uses-loop-variable	Function definition does not bind loop variable {name}	✔️ 🛠️
      -- 🔗🐍 [B024]	abstract-base-class-without-abstract-method	{name} is an abstract base class, but it has no abstract methods	✔️ 🛠️
      -- 🔗🐍 [B025]	duplicate-try-block-exception	try-except block with duplicate exception {name}	✔️ 🛠️
      -- 🔗🐍 [B026]	star-arg-unpacking-after-keyword-arg	Star-arg unpacking after a keyword argument is strongly discouraged	✔️ 🛠️
      -- 🔗🐍 [B027]	empty-method-without-abstract-decorator	{name} is an empty method in an abstract base class, but has no abstract decorator	✔️ 🛠️
      -- 🔗🐍 [B028]	no-explicit-stacklevel	No explicit stacklevel keyword argument found	✔️ 🛠️
      -- 🔗🐍 [B029]	except-with-empty-tuple	Using except (): with an empty tuple does not catch anything; add exceptions to handle	✔️ 🛠️
      -- 🔗🐍 [B030]	except-with-non-exception-classes	except handlers should only be exception classes or tuples of exception classes	✔️ 🛠️
      -- 🔗🐍 [B031]	reuse-of-groupby-generator	Using the generator returned from itertools.groupby() more than once will do nothing on the second usage	✔️ 🛠️
      -- 🔗🐍 [B032]	unintentional-type-annotation	Possible unintentional type annotation (using :). Did you mean to assign (using =)?	✔️ 🛠️
      -- 🔗🐍 [B033]	duplicate-value	Sets should not contain duplicate item {value}	✔️ 🛠️
      -- 🔗🐍 [B034]	re-sub-positional-args	{method} should pass {param_name} and flags as keyword arguments to avoid confusion due to unintuitive argument positions	✔️ 🛠️
      -- 🔗🐍 [B035]	static-key-dict-comprehension	Dictionary comprehension uses static key: {key}	✔️ 🛠️
      -- 🔗🐍 [B904]	raise-without-from-inside-except	Within an except clause, raise exceptions with raise ... from err or raise ... from None to distinguish them from errors in exception handling	✔️ 🛠️
      -- 🔗🐍 [B905]	zip-without-explicit-strict	zip() without an explicit strict= parameter	✔️ 🛠️
    elseif code == "B905" then
      if lang == "es" then
        return "`zip()` sin un parámetro `strict=` explícito"
      elseif lang == "pt-br" then
        return "`zip()` sem um parâmetro `strict=` explícito"
      elseif lang == "fr" then
        return "`zip()` sans un paramètre `strict=` explicite"
      elseif lang == "it" then
        return "`zip()` senza un parametro `strict=` esplicito"
      end
    -- 🔗🐍 [B909]	loop-iterator-mutation	Mutation to loop iterable {name} during iteration	🧪 🛠️
    -- 🔗🐍 [A001]	builtin-variable-shadowing	Variable {name} is shadowing a Python builtin	✔️ 🛠️
    -- 🔗🐍 [A002]	builtin-argument-shadowing	Argument {name} is shadowing a Python builtin	✔️ 🛠️
    -- 🔗🐍 [A003]	builtin-attribute-shadowing	Python builtin is shadowed by class attribute {name} from {row}	✔️ 🛠️
    -- 🔗🐍 [COM812]	missing-trailing-comma	Trailing comma missing	✔️ 🛠️
    -- 🔗🐍 [COM818]	trailing-comma-on-bare-tuple	Trailing comma on bare tuple prohibited	✔️ 🛠️
    -- 🔗🐍 [COM819]	prohibited-trailing-comma	Trailing comma prohibited	✔️ 🛠️
    -- 🔗🐍 [CPY001]	missing-copyright-notice	Missing copyright notice at top of file	🧪 🛠️
    -- 🔗🐍 [C400]	unnecessary-generator-list	Unnecessary generator (rewrite using list())	✔️ 🛠️
    elseif code == "C400" then
      if lang == "es" then
        return "Generador innecesario (reescribe usando `list()`)"
      elseif lang == "pt-br" then
        return "Gerador desnecessário (reescreva usando `list()`)"
      elseif lang == "fr" then
        return "Générateur inutile (réécrire en utilisant `list()`)"
      elseif lang == "it" then
        return "Generatore non necessario (riscrivi usando `list()`)"
      end
    -- 🔗🐍 [C401]	unnecessary-generator-set	Unnecessary generator (rewrite using set()	✔️ 🛠️
    elseif code == "C401" then
      if lang == "es" then
        return "Generador innecesario (reescribe usando `set()`)"
      elseif lang == "pt-br" then
        return "Gerador desnecessário (reescreva usando `set()`)"
      elseif lang == "fr" then
        return "Générateur inutile (réécrire en utilisant `set()`)"
      elseif lang == "it" then
        return "Generatore non necessario (riscrivi usando `set()`)"
      end
    -- 🔗🐍 [C402]	unnecessary-generator-dict	Unnecessary generator (rewrite as a dict comprehension)	✔️ 🛠️
    elseif code == "C402" then
      if lang == "es" then
        return "Generador innecesario (reescribe como una comprensión de diccionario)"
      elseif lang == "pt-br" then
        return "Gerador desnecessário (reescreva como uma compreensão de dicionário)"
      elseif lang == "fr" then
        return "Générateur inutile (réécrire comme une compréhension de dictionnaire)"
      elseif lang == "it" then
        return "Generatore non necessario (riscrivi come una comprensione di dizionario)"
      end
    -- 🔗🐍 [C403]	unnecessary-list-comprehension-set	Unnecessary list comprehension (rewrite as a set comprehension)	✔️ 🛠️
    elseif code == "C403" then
      if lang == "es" then
        return "Comprensión de lista innecesaria (reescribe como una comprensión de conjunto)"
      elseif lang == "pt-br" then
        return "Compreensão de lista desnecessária (reescreva como uma compreensão de conjunto)"
      elseif lang == "fr" then
        return "Compréhension de liste inutile (réécrire comme une compréhension d'ensemble)"
      elseif lang == "it" then
        return "Comprensione di lista non necessaria (riscrivi come una comprensione di insieme)"
      end
    -- 🔗🐍 [C404]	unnecessary-list-comprehension-dict	Unnecessary list comprehension (rewrite as a dict comprehension)	✔️ 🛠️
    elseif code == "C404" then
      if lang == "es" then
        return "Comprensión de lista innecesaria (reescribe como una comprensión de diccionario)"
      elseif lang == "pt-br" then
        return "Compreensão de lista desnecessária (reescreva como uma compreensão de dicionário)"
      elseif lang == "fr" then
        return "Compréhension de liste inutile (réécrire comme une compréhension de dictionnaire)"
      elseif lang == "it" then
        return "Comprensione di lista non necessaria (riscrivi come una comprensione di dizionario)"
      end
    -- 🔗🐍 [C405]	unnecessary-literal-set	Unnecessary {obj_type} literal (rewrite as a set literal)	✔️ 🛠️
    -- 🔗🐍 [C406]	unnecessary-literal-dict	Unnecessary {obj_type} literal (rewrite as a dict literal)	✔️ 🛠️
    -- 🔗🐍 [C408]	unnecessary-collection-call	Unnecessary {obj_type} call (rewrite as a literal)	✔️ 🛠️
    -- 🔗🐍 [C409]	unnecessary-literal-within-tuple-call	Unnecessary {literal} literal passed to tuple() (rewrite as a tuple literal)	✔️ 🛠️
    -- 🔗🐍 [C410]	unnecessary-literal-within-list-call	Unnecessary {literal} literal passed to list() (remove the outer call to list())	✔️ 🛠️
    -- 🔗🐍 [C411]	unnecessary-list-call	Unnecessary list call (remove the outer call to list())	✔️ 🛠️
    -- 🔗🐍 [C413]	unnecessary-call-around-sorted	Unnecessary {func} call around sorted()	✔️ 🛠️
    -- 🔗🐍 [C414]	unnecessary-double-cast-or-process	Unnecessary {inner} call within {outer}()	✔️ 🛠️
    -- 🔗🐍 [C415]	unnecessary-subscript-reversal	Unnecessary subscript reversal of iterable within {func}()	✔️ 🛠️
    -- 🔗🐍 [C416]	unnecessary-comprehension	Unnecessary {obj_type} comprehension (rewrite using {obj_type}())	✔️ 🛠️
    -- 🔗🐍 [C417]	unnecessary-map	Unnecessary map usage (rewrite using a {object_type})	✔️ 🛠️
    -- 🔗🐍 [C418]	unnecessary-literal-within-dict-call	Unnecessary dict {kind} passed to dict() (remove the outer call to dict())	✔️ 🛠️
    -- 🔗🐍 [C419]	unnecessary-comprehension-in-call	Unnecessary list comprehension	✔️ 🛠️
    -- 🔗🐍 [DTZ001]	call-datetime-without-tzinfo	datetime.datetime() called without a tzinfo argument	✔️ 🛠️
    -- 🔗🐍 [DTZ002]	call-datetime-today	datetime.datetime.today() used	✔️ 🛠️
    -- 🔗🐍 [DTZ003]	call-datetime-utcnow	datetime.datetime.utcnow() used	✔️ 🛠️
    -- 🔗🐍 [DTZ004]	call-datetime-utcfromtimestamp	datetime.datetime.utcfromtimestamp() used	✔️ 🛠️
    -- 🔗🐍 [DTZ005]	call-datetime-now-without-tzinfo	datetime.datetime.now() called without a tz argument	✔️ 🛠️
    -- 🔗🐍 [DTZ006]	call-datetime-fromtimestamp	datetime.datetime.fromtimestamp() called without a tz argument	✔️ 🛠️
    -- 🔗🐍 [DTZ007]	call-datetime-strptime-without-zone	Naive datetime constructed using datetime.datetime.strptime() without %z	✔️ 🛠️
    -- 🔗🐍 [DTZ011]	call-date-today	datetime.date.today() used	✔️ 🛠️
    -- 🔗🐍 [DTZ012]	call-date-fromtimestamp	datetime.date.fromtimestamp() used	✔️ 🛠️
    -- 🔗🐍 [T100]	debugger	Trace found: {name} used	✔️ 🛠️
    -- 🔗🐍 [DJ001]	django-nullable-model-string-field	Avoid using null=True on string-based fields such as {field_name}	✔️ 🛠️
    -- 🔗🐍 [DJ003]	django-locals-in-render-function	Avoid passing locals() as context to a render function	✔️ 🛠️
    -- 🔗🐍 [DJ006]	django-exclude-with-model-form	Do not use exclude with ModelForm, use fields instead	✔️ 🛠️
    -- 🔗🐍 [DJ007]	django-all-with-model-form	Do not use __all__ with ModelForm, use fields instead	✔️ 🛠️
    -- 🔗🐍 [DJ008]	django-model-without-dunder-str	Model does not define __str__ method	✔️ 🛠️
    -- 🔗🐍 [DJ012]	django-unordered-body-content-in-model	Order of model's inner classes, methods, and fields does not follow the Django Style Guide: {element_type} should come before {prev_element_type}	✔️ 🛠️
    -- 🔗🐍 [DJ013]	django-non-leading-receiver-decorator	@receiver decorator must be on top of all the other decorators	✔️ 🛠️
    -- 🔗🐍 [EM101]	raw-string-in-exception	Exception must not use a string literal, assign to variable first	✔️ 🛠️
    -- 🔗🐍 [EM102]	f-string-in-exception	Exception must not use an f-string literal, assign to variable first	✔️ 🛠️
    -- 🔗🐍 [EM103]	dot-format-in-exception	Exception must not use a .format() string directly, assign to variable first	✔️ 🛠️
    -- 🔗🐍 [EXE001]	shebang-not-executable	Shebang is present but file is not executable	✔️ 🛠️
    -- 🔗🐍 [EXE002]	shebang-missing-executable-file	The file is executable but no shebang is present	✔️ 🛠️
    -- 🔗🐍 [EXE003]	shebang-missing-python	Shebang should contain python	✔️ 🛠️
    -- 🔗🐍 [EXE004]	shebang-leading-whitespace	Avoid whitespace before shebang	✔️ 🛠️
    -- 🔗🐍 [EXE005]	shebang-not-first-line	Shebang should be at the beginning of the file	✔️ 🛠️
    -- 🔗🐍 [FA100]	future-rewritable-type-annotation	Missing from __future__ import annotations, but uses {name}	✔️ 🛠️
    -- 🔗🐍 [FA102]	future-required-type-annotation	Missing from __future__ import annotations, but uses {reason}	✔️ 🛠️
    -- 🔗🐍 [ISC001]	single-line-implicit-string-concatenation	Implicitly concatenated string literals on one line	✔️ 🛠️
    -- 🔗🐍 [ISC002]	multi-line-implicit-string-concatenation	Implicitly concatenated string literals over multiple lines	✔️ 🛠️
    -- 🔗🐍 [ISC003]	explicit-string-concatenation	Explicitly concatenated string should be implicitly concatenated	✔️ 🛠️
    -- 🔗🐍 [ICN001]	unconventional-import-alias	{name} should be imported as {asname}	✔️ 🛠️
    -- 🔗🐍 [ICN002]	banned-import-alias	{name} should not be imported as {asname}	✔️ 🛠️
    -- 🔗🐍 [ICN003]	banned-import-from	Members of {name} should not be imported explicitly	✔️ 🛠️
    -- 🔗🐍 [LOG001]	direct-logger-instantiation	Use logging.getLogger() to instantiate loggers	✔️ 🛠️
    -- 🔗🐍 [LOG002]	invalid-get-logger-argument	Use __name__ with logging.getLogger()	✔️ 🛠️
    -- 🔗🐍 [LOG007]	exception-without-exc-info	Use of logging.exception with falsy exc_info	✔️ 🛠️
    -- 🔗🐍 [LOG009]	undocumented-warn	Use of undocumented logging.WARN constant	✔️ 🛠️
    -- 🔗🐍 [G001]	logging-string-format	Logging statement uses str.format	✔️ 🛠️
    -- 🔗🐍 [G002]	logging-percent-format	Logging statement uses %	✔️ 🛠️
    -- 🔗🐍 [G003]	logging-string-concat	Logging statement uses +	✔️ 🛠️
    -- 🔗🐍 [G004]	logging-f-string	Logging statement uses f-string	✔️ 🛠️
    -- 🔗🐍 [G010]	logging-warn	Logging statement uses warn instead of warning	✔️ 🛠️
    -- 🔗🐍 [G101]	logging-extra-attr-clash	Logging statement uses an extra field that clashes with a LogRecord field: {key}	✔️ 🛠️
    -- 🔗🐍 [G201]	logging-exc-info	Logging .exception(...) should be used instead of .error(..., exc_info=True)	✔️ 🛠️
    -- 🔗🐍 [G202]	logging-redundant-exc-info	Logging statement has redundant exc_info	✔️ 🛠️
    -- 🔗🐍 [INP001]	implicit-namespace-package	File {filename} is part of an implicit namespace package. Add an __init__.py.	✔️ 🛠️
    elseif code == "INP001" then
      local filename = message:match("File ([^ ]+) is part of an implicit namespace package")
      if lang == "es" then
        return string.format(
          "El archivo %s es parte de un paquete de espacio de nombres implícito. Agrega un `__init__.py`.",
          filename
        )
      elseif lang == "pt-br" then
        return string.format(
          "O arquivo %s faz parte de um pacote de espaço de nomes implícito. Adicione um `__init__.py`.",
          filename
        )
      elseif lang == "fr" then
        return string.format(
          "Le fichier %s fait partie d'un package d'espace de noms implicite. Ajoutez un `__init__.py`.",
          filename
        )
      elseif lang == "it" then
        return string.format(
          "Il file %s fa parte di un pacchetto di spazio dei nomi implicito. Aggiungi un `__init__.py`.",
          filename
        )
      end
    -- 🔗🐍 [PIE790]	unnecessary-placeholder	Unnecessary pass statement	✔️ 🛠️
    -- 🔗🐍 [PIE794]	duplicate-class-field-definition	Class field {name} is defined multiple times	✔️ 🛠️
    -- 🔗🐍 [PIE796]	non-unique-enums	Enum contains duplicate value: {value}	✔️ 🛠️
    -- 🔗🐍 [PIE800]	unnecessary-spread	Unnecessary spread **	✔️ 🛠️
    -- 🔗🐍 [PIE804]	unnecessary-dict-kwargs	Unnecessary dict kwargs	✔️ 🛠️
    -- 🔗🐍 [PIE807]	reimplemented-container-builtin	Prefer {container} over useless lambda	✔️ 🛠️
    -- 🔗🐍 [PIE808]	unnecessary-range-start	Unnecessary start argument in range	✔️ 🛠️
    -- 🔗🐍 [PIE810]	multiple-starts-ends-with	Call {attr} once with a tuple	✔️ 🛠️
    -- 🔗🐍 [T201]	print	print found	✔️ 🛠️
    elseif code == "T201" then
      if lang == "es" then
        return "`print` encontrado"
      elseif lang == "pt-br" then
        return "`print` encontrado"
      elseif lang == "fr" then
        return "`print` trouvé"
      elseif lang == "it" then
        return "`print` trovato"
      end
    -- 🔗🐍 [T203] p-print	pprint found	✔️ 🛠️
    elseif code == "T203" then
      if lang == "es" then
        return "`pprint` encontrado"
      elseif lang == "pt-br" then
        return "`pprint` encontrado"
      elseif lang == "fr" then
        return "`pprint` trouvé"
      elseif lang == "it" then
        return "`pprint` trovato"
      end

    -- 🔗🐍 [SIM101]	duplicate-isinstance-call	Multiple isinstance calls for {name}, merge into a single call	✔️ 🛠️
    -- 🔗🐍 [SIM102]	collapsible-if	Use a single if statement instead of nested if statements	✔️ 🛠️
    -- 🔗🐍 [SIM103]	needless-bool	Return the condition {condition} directly	✔️ 🛠️
    -- 🔗🐍 [SIM105]	suppressible-exception	Use contextlib.suppress({exception}) instead of try-except-pass	✔️ 🛠️
    -- 🔗🐍 [SIM107]	return-in-try-except-finally	Don't use return in try-except and finally	✔️ 🛠️
    -- 🔗🐍 [SIM108]	if-else-block-instead-of-if-exp	Use ternary operator {contents} instead of if-else-block	✔️ 🛠️
    -- 🔗🐍 [SIM109]	compare-with-tuple	Use {replacement} instead of multiple equality comparisons	✔️ 🛠️
    -- 🔗🐍 [SIM110]	reimplemented-builtin	Use {replacement} instead of for loop	✔️ 🛠️
    -- 🔗🐍 [SIM112]	uncapitalized-environment-variables	Use capitalized environment variable {expected} instead of {actual}	✔️ 🛠️
    -- 🔗🐍 [SIM113]	enumerate-for-loop	Use enumerate() for index variable {index} in for loop	✔️ 🛠️
    -- 🔗🐍 [SIM114]	if-with-same-arms	Combine if branches using logical or operator	✔️ 🛠️
    -- 🔗🐍 [SIM115]	open-file-with-context-handler	Use a context manager for opening files	✔️ 🛠️
    -- 🔗🐍 [SIM116]	if-else-block-instead-of-dict-lookup	Use a dictionary instead of consecutive if statements	✔️ 🛠️
    -- 🔗🐍 [SIM117]	multiple-with-statements	Use a single with statement with multiple contexts instead of nested with statements	✔️ 🛠️
    -- 🔗🐍 [SIM118]	in-dict-keys	Use key {operator} dict instead of key {operator} dict.keys()	✔️ 🛠️
    elseif code == "SIM118" then
      print(message)
      local operator = message:match("key (.*) dict` instead of")
      if lang == "es" then
        return string.format("Usa `clave %s dict` en lugar de `clave %s dict.keys()`", operator, operator)
      elseif lang == "pt-br" then
        return string.format("Use `chave %s dict` em vez de `chave %s dict.keys()`", operator, operator)
      elseif lang == "fr" then
        return string.format("Utilisez `clé %s dict` au lieu de la `clé %s dict.keys()`", operator, operator)
      elseif lang == "it" then
        return string.format("Usa `chiave %s dict` invece di `chiave %s dict.keys()`", operator, operator)
      end
    -- 🔗🐍 [SIM201]	Use {left} != {right} instead of not {left} == {right}	✔️ 🛠️
    -- 🔗🐍 [SIM202]	Use {left} == {right} instead of not {left} != {right}	✔️ 🛠️
    -- 🔗🐍 [SIM208]	Use {expr} instead of not (not {expr})	✔️ 🛠️
    -- 🔗🐍 [SIM210]	Remove unnecessary True if ... else False	✔️ 🛠️
    -- 🔗🐍 [SIM211]	Use not ... instead of False if ... else True	✔️ 🛠️
    -- 🔗🐍 [SIM212]	Use {expr_else} if {expr_else} else {expr_body} instead of {expr_body} if not {expr_else} else {expr_else}	✔️ 🛠️
    -- 🔗🐍 [SIM220]	Use False instead of {name} and not {name}	✔️ 🛠️
    -- 🔗🐍 [SIM221]	Use True instead of {name} or not {name}	✔️ 🛠️
    -- 🔗🐍 [SIM222]	Use {expr} instead of {replaced}	✔️ 🛠️
    -- 🔗🐍 [SIM223]	Use {expr} instead of {replaced}	✔️ 🛠️
    -- 🔗🐍 [SIM300]	Yoda condition detected	✔️ 🛠️
    -- 🔗🐍 [SIM401]	Use {contents} instead of an if block	✔️ 🛠️
    -- 🔗🐍 [SIM910]	Use {expected} instead of {actual}	✔️ 🛠️
    -- 🔗🐍 [SIM911]	Use {expected} instead of {actual}	✔️ 🛠️
    -- 🔗🐍 [TID251]	banned-api	{name} is banned: {message}	✔️ 🛠️
    elseif code == "TID251" then
      local name, msg = message:match("(.*) is banned: (.*)")
      if lang == "es" then
        return string.format("%s está prohibido: %s", name, msg)
      elseif lang == "pt-br" then
        return string.format("%s está banido: %s", name, msg)
      elseif lang == "fr" then
        return string.format("%s est interdit: %s", name, msg)
      elseif lang == "it" then
        return string.format("%s è vietato: %s", name, msg)
      end
    -- 🔗🐍 [TID252]	relative-imports	Prefer absolute imports over relative imports from parent modules	✔️ 🛠️
    elseif code == "TID252" then
      if lang == "es" then
        return "Prefiere importaciones absolutas sobre importaciones relativas desde módulos padres"
      elseif lang == "pt-br" then
        return "Prefira importações absolutas sobre importações relativas de módulos pais"
      elseif lang == "fr" then
        return "Préférez les importations absolues aux importations relatives des modules parents"
      elseif lang == "it" then
        return "Preferisci importazioni assolute rispetto a importazioni relative dai moduli genitori"
      end
    -- 🔗🐍 [TID253]	banned-module-level-imports	{name} is banned at the module level
    elseif code == "TID253" then
      local name = message:match("(.*) is banned at the module level")
      if lang == "es" then
        return string.format("%s está prohibido a nivel de módulo", name)
      elseif lang == "pt-br" then
        return string.format("%s está banido no nível do módulo", name)
      elseif lang == "fr" then
        return string.format("%s est interdit au niveau du module", name)
      elseif lang == "it" then
        return string.format("%s è vietato a livello di modulo", name)
      end
    -- 🔗🐍 [PTH100]	os-path-abspath	os.path.abspath() should be replaced by Path.resolve()	✔️ 🛠️
    elseif code == "PTH100" then
      if lang == "es" then
        return "`os.path.abspath()` debería ser reemplazado por `Path.resolve()`"
      elseif lang == "pt-br" then
        return "`os.path.abspath()` deve ser substituído por `Path.resolve()`"
      elseif lang == "fr" then
        return "`os.path.abspath()` devrait être remplacé par `Path.resolve()`"
      elseif lang == "it" then
        return "`os.path.abspath()` dovrebbe essere sostituito da `Path.resolve()`"
      end
    -- 🔗🐍 [PTH101]	os-chmod	os.chmod() should be replaced by Path.chmod()	✔️ 🛠️
    elseif code == "PTH101" then
      if lang == "es" then
        return "`os.chmod()` debería ser reemplazado por `Path.chmod()`"
      elseif lang == "pt-br" then
        return "`os.chmod()` deve ser substituído por `Path.chmod()`"
      elseif lang == "fr" then
        return "`os.chmod()` devrait être remplacé par `Path.chmod()`"
      elseif lang == "it" then
        return "`os.chmod()` dovrebbe essere sostituito da `Path.chmod()`"
      end
    -- 🔗🐍 [PTH102]	os-mkdir	os.mkdir() should be replaced by Path.mkdir()	✔️ 🛠️
    elseif code == "PTH102" then
      if lang == "es" then
        return "`os.mkdir()` debería ser reemplazado por `Path.mkdir()`"
      elseif lang == "pt-br" then
        return "`os.mkdir()` deve ser substituído por `Path.mkdir()`"
      elseif lang == "fr" then
        return "`os.mkdir()` devrait être remplacé par `Path.mkdir()`"
      elseif lang == "it" then
        return "`os.mkdir()` dovrebbe essere sostituito da `Path.mkdir()`"
      end
    -- 🔗🐍 [PTH103]	os-makedirs	os.makedirs() should be replaced by Path.mkdir(parents=True)	✔️ 🛠️
    elseif code == "PTH103" then
      if lang == "es" then
        return "`os.makedirs()` debería ser reemplazado por `Path.mkdir(parents=True)`"
      elseif lang == "pt-br" then
        return "`os.makedirs()` deve ser substituído por `Path.mkdir(parents=True)`"
      elseif lang == "fr" then
        return "`os.makedirs()` devrait être remplacé par `Path.mkdir(parents=True)`"
      elseif lang == "it" then
        return "`os.makedirs()` dovrebbe essere sostituito da `Path.mkdir(parents=True)`"
      end
    -- 🔗🐍 [PTH104]	os-rename	os.rename() should be replaced by Path.rename()	✔️ 🛠️
    elseif code == "PTH104" then
      if lang == "es" then
        return "`os.rename()` debería ser reemplazado por `Path.rename()`"
      elseif lang == "pt-br" then
        return "`os.rename()` deve ser substituído por `Path.rename()`"
      elseif lang == "fr" then
        return "`os.rename()` devrait être remplacé par `Path.rename()`"
      elseif lang == "it" then
        return "`os.rename()` dovrebbe essere sostituito da `Path.rename()`"
      end
    -- 🔗🐍 [PTH105]	os-replace	os.replace() should be replaced by Path.replace()	✔️ 🛠️
    -- 🔗🐍 [PTH106]	os-rmdir	os.rmdir() should be replaced by Path.rmdir()	✔️ 🛠️
    elseif code == "PTH106" then
      if lang == "es" then
        return "`os.rmdir()` debería ser reemplazado por `Path.rmdir()`"
      elseif lang == "pt-br" then
        return "`os.rmdir()` deve ser substituído por `Path.rmdir()`"
      elseif lang == "fr" then
        return "`os.rmdir()` devrait être remplacé par `Path.rmdir()`"
      elseif lang == "it" then
        return "`os.rmdir()` dovrebbe essere sostituito da `Path.rmdir()`"
      end
    -- 🔗🐍 [PTH107]	os-remove	os.remove() should be replaced by Path.unlink()	✔️ 🛠️
    elseif code == "PTH107" then
      if lang == "es" then
        return "`os.remove()` debería ser reemplazado por `Path.unlink()`"
      elseif lang == "pt-br" then
        return "`os.remove()` deve ser substituído por `Path.unlink()`"
      elseif lang == "fr" then
        return "`os.remove()` devrait être remplacé par `Path.unlink()`"
      elseif lang == "it" then
        return "`os.remove()` dovrebbe essere sostituito da `Path.unlink()`"
      end
    -- 🔗🐍 [PTH108]	os-unlink	os.unlink() should be replaced by Path.unlink()	✔️ 🛠️
    elseif code == "PTH108" then
      if lang == "es" then
        return "`os.unlink()` debería ser reemplazado por `Path.unlink()`"
      elseif lang == "pt-br" then
        return "`os.unlink()` deve ser substituído por `Path.unlink()`"
      elseif lang == "fr" then
        return "`os.unlink()` devrait être remplacé par `Path.unlink()`"
      elseif lang == "it" then
        return "`os.unlink()` dovrebbe essere sostituito da `Path.unlink()`"
      end
    -- 🔗🐍 [PTH109]	os-getcwd	os.getcwd() should be replaced by Path.cwd()	✔️ 🛠️
    elseif code == "PTH109" then
      if lang == "es" then
        return "`os.getcwd()` debería ser reemplazado por `Path.cwd()`"
      elseif lang == "pt-br" then
        return "`os.getcwd()` deve ser substituído por `Path.cwd()`"
      elseif lang == "fr" then
        return "`os.getcwd()` devrait être remplacé par `Path.cwd()`"
      elseif lang == "it" then
        return "`os.getcwd()` dovrebbe essere sostituito da `Path.cwd()`"
      end
    -- 🔗🐍 [PTH110]	os-path-exists	os.path.exists() should be replaced by Path.exists()	✔️ 🛠️
    elseif code == "PTH110" then
      if lang == "es" then
        return "`os.path.exists()` debería ser reemplazado por `Path.exists()`"
      elseif lang == "pt-br" then
        return "`os.path.exists()` deve ser substituído por `Path.exists()`"
      elseif lang == "fr" then
        return "`os.path.exists()` devrait être remplacé par `Path.exists()`"
      elseif lang == "it" then
        return "`os.path.exists()` dovrebbe essere sostituito da `Path.exists()`"
      end
    -- 🔗🐍 [PTH111]	os-path-expanduser	os.path.expanduser() should be replaced by Path.expanduser()	✔️ 🛠️
    elseif code == "PTH111" then
      if lang == "es" then
        return "`os.path.expanduser()` debería ser reemplazado por `Path.expanduser()`"
      elseif lang == "pt-br" then
        return "`os.path.expanduser()` deve ser substituído por `Path.expanduser()`"
      elseif lang == "fr" then
        return "`os.path.expanduser()` devrait être remplacé par `Path.expanduser()`"
      elseif lang == "it" then
        return "`os.path.expanduser()` dovrebbe essere sostituito da `Path.expanduser()`"
      end
    -- 🔗🐍 [PTH112]	os-path-isdir	os.path.isdir() should be replaced by Path.is_dir()	✔️ 🛠️
    elseif code == "PTH112" then
      if lang == "es" then
        return "`os.path.isdir()` debería ser reemplazado por `Path.is_dir()`"
      elseif lang == "pt-br" then
        return "`os.path.isdir()` deve ser substituído por `Path.is_dir()`"
      elseif lang == "fr" then
        return "`os.path.isdir()` devrait être remplacé par `Path.is_dir()`"
      elseif lang == "it" then
        return "`os.path.isdir()` dovrebbe essere sostituito da `Path.is_dir()`"
      end
    -- 🔗🐍 [PTH113]	os-path-isfile	os.path.isfile() should be replaced by Path.is_file()	✔️ 🛠️
    elseif code == "PTH113" then
      if lang == "es" then
        return "`os.path.isfile()` debería ser reemplazado por `Path.is_file()`"
      elseif lang == "pt-br" then
        return "`os.path.isfile()` deve ser substituído por `Path.is_file()`"
      elseif lang == "fr" then
        return "`os.path.isfile()` devrait être remplacé par `Path.is_file()`"
      elseif lang == "it" then
        return "`os.path.isfile()` dovrebbe essere sostituito da `Path.is_file()`"
      end
    -- 🔗🐍 [PTH114]	os-path-islink	os.path.islink() should be replaced by Path.is_symlink()	✔️ 🛠️
    elseif code == "PTH114" then
      if lang == "es" then
        return "`os.path.islink()` debería ser reemplazado por `Path.is_symlink()`"
      elseif lang == "pt-br" then
        return "`os.path.islink()` deve ser substituído por `Path.is_symlink()`"
      elseif lang == "fr" then
        return "`os.path.islink()` devrait être remplacé par `Path.is_symlink()`"
      elseif lang == "it" then
        return "`os.path.islink()` dovrebbe essere sostituito da `Path.is_symlink()`"
      end
    -- 🔗🐍 [PTH115]	os-readlink	os.readlink() should be replaced by Path.readlink()	✔️ 🛠️
    elseif code == "PTH115" then
      if lang == "es" then
        return "`os.readlink()` debería ser reemplazado por `Path.readlink()`"
      elseif lang == "pt-br" then
        return "`os.readlink()` deve ser substituído por `Path.readlink()`"
      elseif lang == "fr" then
        return "`os.readlink()` devrait être remplacé par `Path.readlink()`"
      elseif lang == "it" then
        return "`os.readlink()` dovrebbe essere sostituito da `Path.readlink()`"
      end
    -- 🔗🐍 [PTH116]	os-stat	os.stat() should be replaced by Path.stat(), Path.owner(), or Path.group()	✔️ 🛠️
    elseif code == "PTH116" then
      if lang == "es" then
        return "`os.stat()` debería ser reemplazado por `Path.stat()`, `Path.owner()`, o `Path.group()`"
      elseif lang == "pt-br" then
        return "`os.stat()` deve ser substituído por `Path.stat()`, `Path.owner()`, ou `Path.group()`"
      elseif lang == "fr" then
        return "`os.stat()` devrait être remplacé par `Path.stat()`, `Path.owner()`, ou `Path.group()`"
      elseif lang == "it" then
        return "`os.stat()` dovrebbe essere sostituito da `Path.stat()`, `Path.owner()`, o `Path.group()`"
      end
    -- 🔗🐍 [PTH117]	os-path-isabs	os.path.isabs() should be replaced by Path.is_absolute()	✔️ 🛠️
    elseif code == "PTH117" then
      if lang == "es" then
        return "`os.path.isabs()` debería ser reemplazado por `Path.is_absolute()`"
      elseif lang == "pt-br" then
        return "`os.path.isabs()` deve ser substituído por `Path.is_absolute()`"
      elseif lang == "fr" then
        return "`os.path.isabs()` devrait être remplacé par `Path.is_absolute()`"
      elseif lang == "it" then
        return "`os.path.isabs()` dovrebbe essere sostituito da `Path.is_absolute()`"
      end
    -- 🔗🐍 [PTH118]	os-path-join	os.{module}.join() should be replaced by Path with / operator	✔️ 🛠️
    elseif code == "PTH118" then
      if lang == "es" then
        return "`os.path.join()` debería ser reemplazado por `Path` con el operador `/`"
      elseif lang == "pt-br" then
        return "`os.path.join()` deve ser substituído por `Path` com o operador `/`"
      elseif lang == "fr" then
        return "`os.path.join()` devrait être remplacé par `Path` avec l'opérateur `/`"
      elseif lang == "it" then
        return "`os.path.join()` dovrebbe essere sostituito da `Path` con l'operatore `/`"
      end
    -- 🔗🐍 [PTH119]	os-path-basename	os.path.basename() should be replaced by Path.name	✔️ 🛠️
    elseif code == "PTH119" then
      if lang == "es" then
        return "`os.path.basename()` debería ser reemplazado por `Path.name`"
      elseif lang == "pt-br" then
        return "`os.path.basename()` deve ser substituído por `Path.name`"
      elseif lang == "fr" then
        return "`os.path.basename()` devrait être remplacé par `Path.name`"
      elseif lang == "it" then
        return "`os.path.basename()` dovrebbe essere sostituito da `Path.name`"
      end
    -- 🔗🐍 [PTH120]	os-path-dirname	os.path.dirname() should be replaced by Path.parent	✔️ 🛠️
    elseif code == "PTH120" then
      if lang == "es" then
        return "`os.path.dirname()` debería ser reemplazado por `Path.parent`"
      elseif lang == "pt-br" then
        return "`os.path.dirname()` deve ser substituído por `Path.parent`"
      elseif lang == "fr" then
        return "`os.path.dirname()` devrait être remplacé par `Path.parent`"
      elseif lang == "it" then
        return "`os.path.dirname()` dovrebbe essere sostituito da `Path.parent`"
      end
    -- 🔗🐍 [PTH121]	os-path-samefile	os.path.samefile() should be replaced by Path.samefile()	✔️ 🛠️
    elseif code == "PTH121" then
      if lang == "es" then
        return "`os.path.samefile()` debería ser reemplazado por `Path.samefile()`"
      elseif lang == "pt-br" then
        return "`os.path.samefile()` deve ser substituído por `Path.samefile()`"
      elseif lang == "fr" then
        return "`os.path.samefile()` devrait être remplacé par `Path.samefile()`"
      elseif lang == "it" then
        return "`os.path.samefile()` dovrebbe essere sostituito da `Path.samefile()`"
      end
    -- 🔗🐍 [PTH122]	os-path-splitext	os.path.splitext() should be replaced by Path.suffix, Path.stem, and Path.parent	✔️ 🛠️
    elseif code == "PTH122" then
      if lang == "es" then
        return "`os.path.splitext()` debería ser reemplazado por `Path.suffix`, `Path.stem`, y `Path.parent`"
      elseif lang == "pt-br" then
        return "`os.path.splitext()` deve ser substituído por `Path.suffix`, `Path.stem`, e `Path.parent`"
      elseif lang == "fr" then
        return "`os.path.splitext()` devrait être remplacé par `Path.suffix`, `Path.stem`, et `Path.parent`"
      elseif lang == "it" then
        return "`os.path.splitext()` dovrebbe essere sostituito da `Path.suffix`, `Path.stem`, e `Path.parent`"
      end
    -- 🔗🐍 [PTH123]	builtin-open	open() should be replaced by Path.open()	✔️ 🛠️
    elseif code == "PTH123" then
      if lang == "es" then
        return "`open()` debería ser reemplazado por `Path.open()`"
      elseif lang == "pt-br" then
        return "`open()` deve ser substituído por `Path.open()`"
      elseif lang == "fr" then
        return "`open()` devrait être remplacé par `Path.open()`"
      elseif lang == "it" then
        return "`open()` dovrebbe essere sostituito da `Path.open()`"
      end
    -- 🔗🐍 [PTH124]	py-path	py.path is in maintenance mode, use pathlib instead	✔️ 🛠️
    elseif code == "PTH124" then
      if lang == "es" then
        return "`py.path` está en modo de mantenimiento, use `pathlib` en su lugar"
      elseif lang == "pt-br" then
        return "`py.path` está em modo de manutenção, use `pathlib` em vez disso"
      elseif lang == "fr" then
        return "`py.path` est en mode de maintenance, utilisez `pathlib` à la place"
      elseif lang == "it" then
        return "`py.path` è in modalità di manutenzione, usa `pathlib` invece"
      end
    -- 🔗🐍 [PTH201]	path-constructor-current-directory	Do not pass the current directory explicitly to Path	✔️ 🛠️
    elseif code == "PTH201" then
      if lang == "es" then
        return "No pase el directorio actual explícitamente a `Path`"
      elseif lang == "pt-br" then
        return "Não passe o diretório atual explicitamente para `Path`"
      elseif lang == "fr" then
        return "Ne passez pas le répertoire courant explicitement à `Path`"
      elseif lang == "it" then
        return "Non passare la directory corrente esplicitamente a `Path`"
      end
    -- 🔗🐍 [PTH202]	os-path-getsize	os.path.getsize should be replaced by Path.stat().st_size	✔️ 🛠️
    elseif code == "PTH202" then
      if lang == "es" then
        return "`os.path.getsize` debería ser reemplazado por `Path.stat().st_size`"
      elseif lang == "pt-br" then
        return "`os.path.getsize` deve ser substituído por `Path.stat().st_size`"
      elseif lang == "fr" then
        return "`os.path.getsize` devrait être remplacé par `Path.stat().st_size`"
      elseif lang == "it" then
        return "`os.path.getsize` dovrebbe essere sostituito da `Path.stat().st_size`"
      end
    -- 🔗🐍 [PTH203]	os-path-getatime	os.path.getatime should be replaced by Path.stat().st_atime	✔️ 🛠️
    elseif code == "PTH203" then
      if lang == "es" then
        return "`os.path.getatime` debería ser reemplazado por `Path.stat().st_atime`"
      elseif lang == "pt-br" then
        return "`os.path.getatime` deve ser substituído por `Path.stat().st_atime`"
      elseif lang == "fr" then
        return "`os.path.getatime` devrait être remplacé par `Path.stat().st_atime`"
      elseif lang == "it" then
        return "`os.path.getatime` dovrebbe essere sostituito da `Path.stat().st_atime`"
      end
    -- 🔗🐍 [PTH204]	os-path-getmtime	os.path.getmtime should be replaced by Path.stat().st_mtime	✔️ 🛠️
    elseif code == "PTH204" then
      if lang == "es" then
        return "`os.path.getmtime` debería ser reemplazado por `Path.stat().st_mtime`"
      elseif lang == "pt-br" then
        return "`os.path.getmtime` deve ser substituído por `Path.stat().st_mtime`"
      elseif lang == "fr" then
        return "`os.path.getmtime` devrait être remplacé par `Path.stat().st_mtime`"
      elseif lang == "it" then
        return "`os.path.getmtime` dovrebbe essere sostituito da `Path.stat().st_mtime`"
      end
    -- 🔗🐍 [PTH205]	os-path-getctime	os.path.getctime should be replaced by Path.stat().st_ctime	✔️ 🛠️
    elseif code == "PTH205" then
      if lang == "es" then
        return "`os.path.getctime` debería ser reemplazado por `Path.stat().st_ctime`"
      elseif lang == "pt-br" then
        return "`os.path.getctime` deve ser substituído por `Path.stat().st_ctime`"
      elseif lang == "fr" then
        return "`os.path.getctime` devrait être remplacé par `Path.stat().st_ctime`"
      elseif lang == "it" then
        return "`os.path.getctime` dovrebbe essere sostituito da `Path.stat().st_ctime`"
      end
    -- 🔗🐍 [PTH206]	os-sep-split	Replace .split(os.sep) with Path.parts	✔️ 🛠️
    elseif code == "PTH206" then
      if lang == "es" then
        return "Reemplace `.split(os.sep)` con `Path.parts`"
      elseif lang == "pt-br" then
        return "Substitua `.split(os.sep)` por `Path.parts`"
      elseif lang == "fr" then
        return "Remplacez `.split(os.sep)` par `Path.parts`"
      elseif lang == "it" then
        return "Sostituisci `.split(os.sep)` con `Path.parts`"
      end
    -- 🔗🐍 [PTH207]	glob	Replace {function} with Path.glob or Path.rglob	✔️ 🛠️
    elseif code == "PTH207" then
      local function_name = message:match("Replace `(.*)` with")
      if lang == "es" then
        return string.format("Reemplace `%s` con `Path.glob` o `Path.rglob`", function_name)
      elseif lang == "pt-br" then
        return string.format("Substitua `%s` por `Path.glob` ou `Path.rglob`", function_name)
      elseif lang == "fr" then
        return string.format("Remplacez `%s` par `Path.glob` ou `Path.rglob`", function_name)
      elseif lang == "it" then
        return string.format("Sostituisci `%s` con `Path.glob` o `Path.rglob`", function_name)
      end
    -- 🔗🐍 [PLC0105]	type-name-incorrect-variance	{kind} name "{param_name}" does not reflect its {variance}; consider renaming it to "{replacement_name}"	✔️ 🛠️
    -- 🔗🐍 [PLC0131]	type-bivariance	{kind} cannot be both covariant and contravariant	✔️ 🛠️
    -- 🔗🐍 [PLC0132]	type-param-name-mismatch	{kind} name {param_name} does not match assigned variable name {var_name}	✔️ 🛠️
    -- 🔗🐍 [PLC0205]	single-string-slots	Class __slots__ should be a non-string iterable	✔️ 🛠️
    -- 🔗🐍 [PLC0206]	dict-index-missing-items	Extracting value from dictionary without calling .items()	🧪 🛠️
    -- 🔗🐍 [PLC0208]	iteration-over-set	Use a sequence type instead of a set when iterating over values	✔️ 🛠️
    -- 🔗🐍 [PLC0414]	useless-import-alias	Import alias does not rename original package	✔️ 🛠️
    -- 🔗🐍 [PLC0415]	import-outside-top-level	import should be at the top-level of a file	🧪 🛠️
    -- 🔗🐍 [PLC1901]	compare-to-empty-string	{existing} can be simplified to {replacement} as an empty string is falsey	🧪 🛠️
    -- 🔗🐍 [PLC2401]	non-ascii-name	{kind} name {name} contains a non-ASCII character	✔️ 🛠️
    -- 🔗🐍 [PLC2403]	non-ascii-import-name	Module alias {name} contains a non-ASCII character	✔️ 🛠️
    -- 🔗🐍 [PLC2701]	import-private-name	Private name import {name} from external module {module}	🧪 🛠️
    -- 🔗🐍 [PLC2801]	unnecessary-dunder-call	Unnecessary dunder call to {method}. {replacement}.	🧪 🛠️
    -- 🔗🐍 [PLC3002]	unnecessary-direct-lambda-call	Lambda expression called directly. Execute the expression inline instead.	✔️
    -- 🔗🐍 [PLE0100]	yield-in-init	__init__ method is a generator	✔️ 🛠️
    -- 🔗🐍 [PLE0101]	return-in-init	Explicit return in __init__	✔️ 🛠️
    -- 🔗🐍 [PLE0115]	nonlocal-and-global	Name {name} is both nonlocal and global	✔️ 🛠️
    -- 🔗🐍 [PLE0116]	continue-in-finally	continue not supported inside finally clause	✔️ 🛠️
    -- 🔗🐍 [PLE0117]	nonlocal-without-binding	Nonlocal name {name} found without binding	✔️ 🛠️
    -- 🔗🐍 [PLE0118]	load-before-global-declaration	Name {name} is used prior to global declaration on {row}	✔️ 🛠️
    -- 🔗🐍 [PLE0237]	non-slot-assignment	Attribute {name} is not defined in class's __slots__	✔️ 🛠️
    -- 🔗🐍 [PLE0241]	duplicate-bases	Duplicate base {base} for class {class}	✔️ 🛠️
    -- 🔗🐍 [PLE0302]	unexpected-special-method-signature	The special method {} expects {}, {} {} given	✔️ 🛠️
    -- 🔗🐍 [PLE0303]	invalid-length-return-type	__len__ does not return a non-negative integer	✔️ 🛠️
    -- 🔗🐍 [PLE0304]	invalid-bool-return-type	__bool__ does not return bool	🧪 🛠️
    -- 🔗🐍 [PLE0305]	invalid-index-return-type	__index__ does not return an integer	✔️ 🛠️
    -- 🔗🐍 [PLE0307]	invalid-str-return-type	__str__ does not return str	✔️ 🛠️
    -- 🔗🐍 [PLE0308]	invalid-bytes-return-type	__bytes__ does not return bytes	✔️ 🛠️
    -- 🔗🐍 [PLE0309]	invalid-hash-return-type	__hash__ does not return an integer	✔️ 🛠️
    -- 🔗🐍 [PLE0604]	invalid-all-object	Invalid object in __all__, must contain only strings	✔️ 🛠️
    -- 🔗🐍 [PLE0605]	invalid-all-format	Invalid format for __all__, must be tuple or list	✔️ 🛠️
    -- 🔗🐍 [PLE0643]	potential-index-error	Expression is likely to raise IndexError	✔️ 🛠️
    -- 🔗🐍 [PLE0704]	misplaced-bare-raise	Bare raise statement is not inside an exception handler	✔️ 🛠️
    -- 🔗🐍 [PLE1132]	repeated-keyword-argument	Repeated keyword argument: {duplicate_keyword}	✔️ 🛠️
    -- 🔗🐍 [PLE1141]	dict-iter-missing-items	Unpacking a dictionary in iteration without calling .items()	🧪 🛠️
    -- 🔗🐍 [PLE1142]	await-outside-async	await should be used within an async function	✔️ 🛠️
    -- 🔗🐍 [PLE1205]	logging-too-many-args	Too many arguments for logging format string	✔️ 🛠️
    elseif code == "PLE1205" then
      if lang == "es" then
        return "Demasiados argumentos para la cadena de formato de registro"
      elseif lang == "pt-br" then
        return "Muitos argumentos para a string de formato de log"
      elseif lang == "fr" then
        return "Trop d'arguments pour la chaîne de format de journalisation"
      elseif lang == "it" then
        return "Troppi argomenti per la stringa di formato di registrazione"
      end
    -- 🔗🐍 [PLE1206]	logging-too-few-args	Not enough arguments for logging format string	✔️ 🛠️
    elseif code == "PLE1206" then
      if lang == "es" then
        return "No hay suficientes argumentos para la cadena de formato de registro"
      elseif lang == "pt-br" then
        return "Argumentos insuficientes para a string de formato de log"
      elseif lang == "fr" then
        return "Pas assez d'arguments pour la chaîne de format de journalisation"
      elseif lang == "it" then
        return "Argomenti insufficienti per la stringa di formato di registrazione"
      end
    -- 🔗🐍 [PLE1300]	bad-string-format-character	Unsupported format character '{format_char}'	✔️ 🛠️
    elseif code == "PLE1300" then
      local format_char = message:match("Unsupported format character '(.*)'")
      if lang == "es" then
        return string.format("Carácter de formato no soportado '%s'", format_char)
      elseif lang == "pt-br" then
        return string.format("Caractere de formato não suportado '%s'", format_char)
      elseif lang == "fr" then
        return string.format("Caractère de format non pris en charge '%s'", format_char)
      elseif lang == "it" then
        return string.format("Carattere di formato non supportato '%s'", format_char)
      end
    -- 🔗🐍 [PLE1307]	bad-string-format-type	Format type does not match argument type	✔️ 🛠️
    -- 🔗🐍 [PLE1310]	bad-str-strip-call	String {strip} call contains duplicate characters (did you mean {removal}?)	✔️ 🛠️
    -- 🔗🐍 [PLE1507]	invalid-envvar-value	Invalid type for initial os.getenv argument; expected str	✔️ 🛠️
    -- 🔗🐍 [PLE1519]	singledispatch-method	@singledispatch decorator should not be used on methods	✔️ 🛠️
    -- 🔗🐍 [PLE1520]	singledispatchmethod-function	@singledispatchmethod decorator should not be used on non-method functions	✔️ 🛠️
    -- 🔗🐍 [PLE1700]	yield-from-in-async-function	yield from statement in async function; use async for instead	✔️ 🛠️
    -- 🔗🐍 [PLE2502]	bidirectional-unicode	Contains control characters that can permit obfuscated code	✔️ 🛠️
    -- 🔗🐍 [PLE2510]	invalid-character-backspace	Invalid unescaped character backspace, use "\b" instead	✔️ 🛠️
    -- 🔗🐍 [PLE2512]	invalid-character-sub	Invalid unescaped character SUB, use "\x1A" instead	✔️ 🛠️
    -- 🔗🐍 [PLE2513]	invalid-character-esc	Invalid unescaped character ESC, use "\x1B" instead	✔️ 🛠️
    -- 🔗🐍 [PLE2514]	invalid-character-nul	Invalid unescaped character NUL, use "\0" instead	✔️ 🛠️
    -- 🔗🐍 [PLE2515]	invalid-character-zero-width-space	Invalid unescaped character zero-width-space, use "\u200B" instead	✔️ 🛠️
    -- 🔗🐍 [PLE4703]	modified-iterating-set	Iterated set {name} is modified within the for loop	🧪 🛠️
    -- 🔗🐍 [PLR0124]	comparison-with-itself	Name compared with itself, consider replacing {actual}	✔️ 🛠️
    -- 🔗🐍 [PLR0133]	comparison-of-constant	Two constants compared in a comparison, consider replacing {left_constant} {op} {right_constant}	✔️ 🛠️
    -- 🔗🐍 [PLR0202]	no-classmethod-decorator	Class method defined without decorator	🧪 🛠️
    -- 🔗🐍 [PLR0203]	no-staticmethod-decorator	Static method defined without decorator	🧪 🛠️
    -- 🔗🐍 [PLR0206]	property-with-parameters	Cannot have defined parameters for properties	✔️ 🛠️
    -- 🔗🐍 [PLR0402]	manual-from-import	Use from {module} import {name} in lieu of alias	✔️ 🛠️
    -- 🔗🐍 [PLR0904]	too-many-public-methods	Too many public methods ({methods} > {max_methods})	🧪 🛠️
    elseif code == "PLR0904" then
      local methods, max_methods = message:match("Too many public methods %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiados métodos públicos (%s > %s)", methods, max_methods)
      elseif lang == "pt-br" then
        return string.format("Muitos métodos públicos (%s > %s)", methods, max_methods)
      elseif lang == "fr" then
        return string.format("Trop de méthodes publiques (%s > %s)", methods, max_methods)
      elseif lang == "it" then
        return string.format("Troppi metodi pubblici (%s > %s)", methods, max_methods)
      end
    -- 🔗🐍 [PLR0911]	too-many-return-statements	Too many return statements ({returns} > {max_returns})	✔️ 🛠️
    elseif code == "PLR0911" then
      local returns, max_returns = message:match("Too many return statements %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiadas declaraciones de retorno (%s > %s)", returns, max_returns)
      elseif lang == "pt-br" then
        return string.format("Muitas declarações de retorno (%s > %s)", returns, max_returns)
      elseif lang == "fr" then
        return string.format("Trop de déclarations de retour (%s > %s)", returns, max_returns)
      elseif lang == "it" then
        return string.format("Troppe dichiarazioni di ritorno (%s > %s)", returns, max_returns)
      end
    -- 🔗🐍 [PLR0912]	too-many-branches	Too many branches ({branches} > {max_branches})	✔️ 🛠️
    elseif code == "PLR0912" then
      local brances, max_branches = message:match("Too many branches %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiadas ramas (%s > %s)", brances, max_branches)
      elseif lang == "pt-br" then
        return string.format("Muitos ramos (%s > %s)", brances, max_branches)
      elseif lang == "fr" then
        return string.format("Trop de branches (%s > %s)", brances, max_branches)
      elseif lang == "it" then
        return string.format("Troppe diramazioni (%s > %s)", brances, max_branches)
      end
    -- 🔗🐍 [PLR0913]	too-many-arguments	Too many arguments in function definition ({c_args} > {max_args})	✔️ 🛠️
    elseif code == "PLR0913" then
      local c_args, max_args = message:match("Too many arguments in function definition %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiados argumentos en la definición de la función (%s > %s)", c_args, max_args)
      elseif lang == "pt-br" then
        return string.format("Muitos argumentos na definição da função (%s > %s)", c_args, max_args)
      elseif lang == "fr" then
        return string.format("Trop d'arguments dans la définition de la fonction (%s > %s)", c_args, max_args)
      elseif lang == "it" then
        return string.format("Troppi argomenti nella definizione della funzione (%s > %s)", c_args, max_args)
      end
    -- 🔗🐍 [PLR0914]	too-many-locals	Too many local variables ({current_amount}/{max_amount})	🧪 🛠️
    elseif code == "PLR0914" then
      local current_amount, max_amount = message:match("Too many local variables %((%d+)/(%d+)%)")
      if lang == "es" then
        return string.format("Demasiadas variables locales (%s/%s)", current_amount, max_amount)
      elseif lang == "pt-br" then
        return string.format("Muitas variáveis locais (%s/%s)", current_amount, max_amount)
      elseif lang == "fr" then
        return string.format("Trop de variables locales (%s/%s)", current_amount, max_amount)
      elseif lang == "it" then
        return string.format("Troppe variabili locali (%s/%s)", current_amount, max_amount)
      end
    -- 🔗🐍 [PLR0915]	too-many-statements	Too many statements ({statements} > {max_statements})	✔️ 🛠️
    elseif code == "PLR0915" then
      local statements, max_statements = message:match("Too many statements %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiadas declaraciones (%s > %s)", statements, max_statements)
      elseif lang == "pt-br" then
        return string.format("Muitas declarações (%s > %s)", statements, max_statements)
      elseif lang == "fr" then
        return string.format("Trop de déclarations (%s > %s)", statements, max_statements)
      elseif lang == "it" then
        return string.format("Troppe dichiarazioni (%s > %s)", statements, max_statements)
      end
    -- 🔗🐍 [PLR0916]	too-many-boolean-expressions	Too many Boolean expressions ({expressions} > {max_expressions})	🧪 🛠️
    elseif code == "PLR0916" then
      local expressions, max_expressions = message:match("Too many Boolean expressions %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiadas expresiones booleanas (%s > %s)", expressions, max_expressions)
      elseif lang == "pt-br" then
        return string.format("Muitas expressões booleanas (%s > %s)", expressions, max_expressions)
      elseif lang == "fr" then
        return string.format("Trop d'expressions booléennes (%s > %s)", expressions, max_expressions)
      elseif lang == "it" then
        return string.format("Troppe espressioni booleane (%s > %s)", expressions, max_expressions)
      end
    -- 🔗🐍 [PLR0917]	too-many-positional-arguments	Too many positional arguments ({c_pos}/{max_pos})	🧪 🛠️
    elseif code == "PLR0917" then
      local c_pos, max_pos = message:match("Too many positional arguments %((%d+)/(%d+)%)")
      if lang == "es" then
        return string.format("Demasiados argumentos posicionales (%s/%s)", c_pos, max_pos)
      elseif lang == "pt-br" then
        return string.format("Muitos argumentos posicionais (%s/%s)", c_pos, max_pos)
      elseif lang == "fr" then
        return string.format("Trop d'arguments positionnels (%s/%s)", c_pos, max_pos)
      elseif lang == "it" then
        return string.format("Troppi argomenti posizionali (%s/%s)", c_pos, max_pos)
      end
    -- 🔗🐍 [PLR1701]	repeated-isinstance-calls	Merge isinstance calls: {expression}	❌ 🛠️
    -- 🔗🐍 [PLR1702]	too-many-nested-blocks	Too many nested blocks ({nested_blocks} > {max_nested_blocks})	🧪 🛠️
    elseif code == "PLR1702" then
      local nested_blocks, max_nested_blocks = message:match("Too many nested blocks %((%d+) > (%d+)%)")
      if lang == "es" then
        return string.format("Demasiados bloques anidados (%s > %s)", nested_blocks, max_nested_blocks)
      elseif lang == "pt-br" then
        return string.format("Muitos blocos aninhados (%s > %s)", nested_blocks, max_nested_blocks)
      elseif lang == "fr" then
        return string.format("Trop de blocs imbriqués (%s > %s)", nested_blocks, max_nested_blocks)
      elseif lang == "it" then
        return string.format("Troppi blocchi nidificati (%s > %s)", nested_blocks, max_nested_blocks)
      end
    -- 🔗🐍 [PLR1704]	redefined-argument-from-local	Redefining argument with the local name {name}	✔️ 🛠️
    -- 🔗🐍 [PLR1706]	and-or-ternary	Consider using if-else expression	❌ 🛠️
    -- 🔗🐍 [PLR1711]	useless-return	Useless return statement at end of function	✔️ 🛠️
    elseif code == "PLR1711" then
      if lang == "es" then
        return "Declaración de retorno inútil al final de la función"
      elseif lang == "pt-br" then
        return "Declaração de retorno inútil no final da função"
      elseif lang == "fr" then
        return "Déclaration de retour inutile à la fin de la fonction"
      elseif lang == "it" then
        return "Dichiarazione di ritorno inutile alla fine della funzione"
      end
    -- 🔗🐍 [PLR1714]	repeated-equality-comparison	Consider merging multiple comparisons: {expression}. Use a set if the elements are hashable.	✔️ 🛠️
    -- 🔗🐍 [PLR1722]	sys-exit-alias	Use sys.exit() instead of {name}	✔️ 🛠️
    -- 🔗🐍 [PLR1730]	if-stmt-min-max	Replace if statement with {replacement}	✔️ 🛠️
    -- 🔗🐍 [PLR1733]	unnecessary-dict-index-lookup	Unnecessary lookup of dictionary value by key	🧪 🛠️
    -- 🔗🐍 [PLR1736]	unnecessary-list-index-lookup	List index lookup in enumerate() loop	✔️ 🛠️
    -- 🔗🐍 [PLR2004]	magic-value-comparison	Magic value used in comparison, consider replacing {value} with a constant variable	✔️ 🛠️
    elseif code == "PLR2004" then
      local value = message:match("consider replacing (.*) with")
      if lang == "es" then
        return string.format(
          "Valor mágico usado en la comparación, considere reemplazar %s con una variable constante",
          value
        )
      elseif lang == "pt-br" then
        return string.format(
          "Valor mágico usado na comparação, considere substituir %s por uma variável constante",
          value
        )
      elseif lang == "fr" then
        return string.format(
          "Valeur magique utilisée dans la comparaison, envisagez de remplacer %s par une variable constante",
          value
        )
      end
    -- 🔗🐍 [PLR2044]	empty-comment	Line with empty comment	✔️ 🛠️
    -- 🔗🐍 [PLR5501]	collapsible-else-if	Use elif instead of else then if, to reduce indentation	✔️ 🛠️
    -- 🔗🐍 [PLR6104]	non-augmented-assignment	Use {operator} to perform an augmented assignment directly	🧪 🛠️
    -- 🔗🐍 [PLR6201]	literal-membership	Use a set literal when testing for membership	🧪 🛠️
    -- 🔗🐍 [PLR6301]	no-self-use	Method {method_name} could be a function, class method, or static method	🧪 🛠️
    -- 🔗🐍 [PLW0108]	unnecessary-lambda	Lambda may be unnecessary; consider inlining inner function	🧪 🛠️
    -- 🔗🐍 [PLW0120]	useless-else-on-loop	else clause on loop without a break statement; remove the else and dedent its contents	✔️ 🛠️
    -- 🔗🐍 [PLW0127]	self-assigning-variable	Self-assignment of variable {name}	✔️ 🛠️
    -- 🔗🐍 [PLW0128]	redeclared-assigned-name	Redeclared variable {name} in assignment	✔️ 🛠️
    -- 🔗🐍 [PLW0129]	assert-on-string-literal	Asserting on an empty string literal will never pass	✔️ 🛠️
    -- 🔗🐍 [PLW0131]	named-expr-without-context	Named expression used without context	✔️ 🛠️
    -- 🔗🐍 [PLW0133]	useless-exception-statement	Missing raise statement on exception	✔️ 🛠️
    -- 🔗🐍 [PLW0177]	nan-comparison	Comparing against a NaN value; use math.isnan instead	🧪 🛠️
    -- 🔗🐍 [PLW0211]	bad-staticmethod-argument	First argument of a static method should not be named {argument_name}	✔️ 🛠️
    -- 🔗🐍 [PLW0245]	super-without-brackets	super call is missing parentheses	✔️ 🛠️
    -- 🔗🐍 [PLW0406]	import-self	Module {name} imports itself	✔️ 🛠️
    -- 🔗🐍 [PLW0602]	global-variable-not-assigned	Using global for {name} but no assignment is done	✔️ 🛠️
    -- 🔗🐍 [PLW0603]	global-statement	Using the global statement to update {name} is discouraged	✔️ 🛠️
    -- 🔗🐍 [PLW0604]	global-at-module-level	global at module level is redundant	✔️ 🛠️
    -- 🔗🐍 [PLW0642]	self-or-cls-assignment	Reassigned {} variable in {method_type} method	✔️ 🛠️
    -- 🔗🐍 [PLW0711]	binary-op-exception	Exception to catch is the result of a binary and operation	✔️ 🛠️
    -- 🔗🐍 [PLW1501]	bad-open-mode	{mode} is not a valid mode for open	✔️ 🛠️
    -- 🔗🐍 [PLW1508]	invalid-envvar-default	Invalid type for environment variable default; expected str or None	✔️ 🛠️
    -- 🔗🐍 [PLW1509]	subprocess-popen-preexec-fn	preexec_fn argument is unsafe when using threads	✔️ 🛠️
    -- 🔗🐍 [PLW1510]	subprocess-run-without-check	subprocess.run without explicit check argument	✔️ 🛠️
    elseif code == "PLW1510" then
      if lang == "es" then
        return "`subprocess.run` sin argumento `check` explícito"
      elseif lang == "pt-br" then
        return "`subprocess.run` sem argumento `check` explícito"
      elseif lang == "fr" then
        return "`subprocess.run` sans argument `check` explicite"
      elseif lang == "it" then
        return "`subprocess.run` senza argomento `check` esplicito"
      end
    -- 🔗🐍 [PLW1514]	unspecified-encoding	{function_name} in text mode without explicit encoding argument	🧪 🛠️
    -- 🔗🐍 [PLW1641]	eq-without-hash	Object does not implement __hash__ method	🧪 🛠️
    -- 🔗🐍 [PLW2101]	useless-with-lock	Threading lock directly created in with statement has no effect	✔️ 🛠️
    -- 🔗🐍 [PLW2901]	redefined-loop-name	Outer {outer_kind} variable {name} overwritten by inner {inner_kind} target	✔️ 🛠️
    elseif code == "PLW2901" then
      local outer_kind, name, inner_kind =
        message:match("Outer (.*) loop variable (.*) overwritten by inner (.*) loop target")
      if outer_kind == nil then
        outer_kind, name = message:match("(.*) loop variable (.*) overwritten by assignment target")
        if lang == "es" then
          return string.format("Variable de bucle %s %s sobrescrita por objetivo de asignación", outer_kind, name)
        elseif lang == "pt-br" then
          return string.format("Variável de loop %s %s sobrescrita por alvo de atribuição", outer_kind, name)
        elseif lang == "fr" then
          return string.format("Variable de boucle %s %s écrasée par la cible d'assignation", outer_kind, name)
        elseif lang == "it" then
          return string.format("Variabile di loop %s %s sovrascritta dall'obiettivo di assegnazione", outer_kind, name)
        end
      else
        -- Outer loop variable i overwritten by inner loop target j
        if lang == "es" then
          return string.format(
            "Variable de bucle %s %s sobrescrita por objetivo de bucle %s",
            outer_kind,
            name,
            inner_kind
          )
        elseif lang == "pt-br" then
          return string.format("Variável de loop %s %s sobrescrita por alvo de loop %s", outer_kind, name, inner_kind)
        elseif lang == "fr" then
          return string.format(
            "Variable de boucle %s %s écrasée par la cible de boucle %s",
            outer_kind,
            name,
            inner_kind
          )
        elseif lang == "it" then
          return string.format(
            "Variabile di loop %s %s sovrascritta dall'obiettivo di loop %s",
            outer_kind,
            name,
            inner_kind
          )
        end
      end
    -- 🔗🐍 [PLW3201]	bad-dunder-method-name	Dunder method {name} has no special meaning in Python 3	🧪 🛠️
    -- 🔗🐍 [PLW3301]	nested-min-max	Nested {func} calls can be flattened	✔️ 🛠️
    -- 🔗🐍 [TRY002]	raise-vanilla-class	Create your own exception	✔️ 🛠️
    elseif code == "TRY002" then
      if lang == "es" then
        return "Cree su propia excepción"
      elseif lang == "pt-br" then
        return "Crie sua própria exceção"
      elseif lang == "fr" then
        return "Créez votre propre exception"
      elseif lang == "it" then
        return "Crea la tua eccezione"
      end
    -- 🔗🐍 [TRY003]	raise-vanilla-args	Avoid specifying long messages outside the exception class	✔️ 🛠️
    elseif code == "TRY003" then
      if lang == "es" then
        return "Evite especificar mensajes largos fuera de la clase de excepción"
      elseif lang == "pt-br" then
        return "Evite especificar mensagens longas fora da classe de exceção"
      elseif lang == "fr" then
        return "Évitez de spécifier de longs messages en dehors de la classe d'exception"
      elseif lang == "it" then
        return "Evita di specificare messaggi lunghi al di fuori della classe di eccezione"
      end
    -- 🔗🐍 [TRY004]	type-check-without-type-error	Prefer TypeError exception for invalid type	✔️ 🛠️
    elseif code == "TRY004" then
      if lang == "es" then
        return "Prefiera la excepción `TypeError` para tipo inválido"
      elseif lang == "pt-br" then
        return "Prefira a exceção `TypeError` para tipo inválido"
      elseif lang == "fr" then
        return "Préférez l'exception `TypeError` pour un type invalide"
      elseif lang == "it" then
        return "Preferisci l'eccezione `TypeError` per il tipo non valido"
      end
    -- 🔗🐍 [TRY200]	reraise-no-cause	Use raise from to specify exception cause	❌ 🛠️
    elseif code == "TRY200" then
      if lang == "es" then
        return "Use `raise from` para especificar la causa de la excepción"
      elseif lang == "pt-br" then
        return "Use `raise from` para especificar a causa da exceção"
      elseif lang == "fr" then
        return "Utilisez `raise from` pour spécifier la cause de l'exception"
      elseif lang == "it" then
        return "Usa `raise from` per specificare la causa dell'eccezione"
      end
    -- 🔗🐍 [TRY201]	verbose-raise	Use `raise` without specifying exception name	✔️ 🛠️
    elseif code == "TRY201" then
      if lang == "es" then
        return "Use `raise` sin especificar el nombre de la excepción"
      elseif lang == "pt-br" then
        return "Use `raise` sem especificar o nome da exceção"
      elseif lang == "fr" then
        return "Utilisez `raise` sans spécifier le nom de l'exception"
      elseif lang == "it" then
        return "Usa `raise` senza specificare il nome dell'eccezione"
      end
    -- 🔗🐍 [TRY300]	try-consider-else	Consider moving this statement to an else block	✔️ 🛠️
    elseif code == "TRY300" then
      if lang == "es" then
        return "Considere mover esta declaración a un bloque `else`"
      elseif lang == "pt-br" then
        return "Considere mover esta declaração para um bloco `else`"
      elseif lang == "fr" then
        return "Envisagez de déplacer cette déclaration dans un bloc `else`"
      elseif lang == "it" then
        return "Considera di spostare questa dichiarazione in un blocco `else`"
      end
    -- 🔗🐍 [TRY301]	raise-within-try	Abstract `raise` to an inner function	✔️ 🛠️
    elseif code == "TRY301" then
      if lang == "es" then
        return "Abstraiga `raise` a una función interna"
      elseif lang == "pt-br" then
        return "Abstraia `raise` para uma função interna"
      elseif lang == "fr" then
        return "Abstraire `raise` dans une fonction interne"
      elseif lang == "it" then
        return "Astrai `raise` in una funzione interna"
      end
    -- 🔗🐍 [TRY302]	useless-try-except	Remove exception handler; error is immediately re-raised	✔️ 🛠️
    elseif code == "TRY302" then
      if lang == "es" then
        return "Elimine el manejador de excepciones; el error se vuelve a lanzar inmediatamente"
      elseif lang == "pt-br" then
        return "Remova o manipulador de exceções; o erro é imediatamente re-lançado"
      elseif lang == "fr" then
        return "Supprimez le gestionnaire d'exception; l'erreur est immédiatement re-lancée"
      elseif lang == "it" then
        return "Rimuovi il gestore delle eccezioni; l'errore viene immediatamente rilanciato"
      end
    -- 🔗🐍 [TRY400]	error-instead-of-exception	Use logging.exception instead of logging.error	✔️ 🛠️
    elseif code == "TRY400" then
      if lang == "es" then
        return "Use `logging.exception` en lugar de `logging.error`"
      elseif lang == "pt-br" then
        return "Use `logging.exception` em vez de `logging.error`"
      elseif lang == "fr" then
        return "Utilisez `logging.exception` au lieu de `logging.error`"
      elseif lang == "it" then
        return "Usa `logging.exception` invece di `logging.error`"
      end
    -- 🔗🐍 [TRY401]	verbose-log-message	Redundant exception object included in logging.exception call	✔️ 🛠️
    elseif code == "TRY401" then
      if lang == "es" then
        return "Objeto de excepción redundante incluido en la llamada a `logging.exception`"
      elseif lang == "pt-br" then
        return "Objeto de exceção redundante incluído na chamada `logging.exception`"
      elseif lang == "fr" then
        return "Objet d'exception redondant inclus dans l'appel à `logging.exception`"
      elseif lang == "it" then
        return "Oggetto di eccezione ridondante incluso nella chiamata a `logging.exception`"
      end
    -- 🔗🐍 [NPY001]	numpy-deprecated-type-alias	Type alias np.{type_name} is deprecated, replace with builtin type	✔️ 🛠️
    elseif code == "NPY001" then
      local type_name = message:match("Type alias `np%.(.*)` is deprecated, replace with builtin type")
      if lang == "es" then
        return string.format("El alias de tipo `np.%s` está obsoleto, reemplace con el tipo integrado", type_name)
      elseif lang == "pt-br" then
        return string.format("O alias de tipo `np.%s` está obsoleto, substitua pelo tipo integrado", type_name)
      elseif lang == "fr" then
        return string.format("L'alias de type `np.%s` est obsolète, remplacez par le type intégré", type_name)
      elseif lang == "it" then
        return string.format("L'alias di tipo `np.%s` è obsoleto, sostituiscilo con il tipo integrato", type_name)
      end
    -- 🔗🐍 [NPY002]	numpy-legacy-random	Replace legacy np.random.{method_name} call with np.random.Generator	✔️ 🛠️
    elseif code == "NPY002" then
      local method_name = message:match("Replace legacy `np%.random%.(.*)` call with `np%.random%.Generator`")
      if lang == "es" then
        return string.format("Reemplace la llamada heredada `np.random.%s` con `np.random.Generator`", method_name)
      elseif lang == "pt-br" then
        return string.format("Substitua a chamada legada `np.random.%s` por `np.random.Generator`", method_name)
      elseif lang == "fr" then
        return string.format("Remplacez l'appel hérité `np.random.%s` par `np.random.Generator`", method_name)
      elseif lang == "it" then
        return string.format("Sostituisci la chiamata legacy `np.random.%s` con `np.random.Generator`", method_name)
      end
    -- 🔗🐍 [NPY003]	numpy-deprecated-function	`np.{existing}` is deprecated; use `np.{replacement}` instead	✔️ 🛠️
    elseif code == "NPY003" then
      local existing, replacement = message:match("`np%.(.*)` is deprecated; use `np%.(.*)` instead")
      if lang == "es" then
        return string.format("`np.%s` está obsoleto; use `np.%s` en su lugar", existing, replacement)
      elseif lang == "pt-br" then
        return string.format("`np.%s` está obsoleto; use `np.%s` em seu lugar", existing, replacement)
      elseif lang == "fr" then
        return string.format("`np.%s` est obsolète; utilisez `np.%s` à la place", existing, replacement)
      elseif lang == "it" then
        return string.format("`np.%s` è obsoleto; usa `np.%s` invece", existing, replacement)
      end
    -- 🔗🐍 [NPY201]	numpy2-deprecation	`np.{existing}` will be removed in NumPy 2.0. {migration_guide}	✔️ 🛠️
    elseif code == "NPY201" then
      local existing, migration_guide = message:match("`np%.(.*)` will be removed in NumPy 2%.0%. (.*)")
      if lang == "es" then
        return string.format("`np.%s` se eliminará en NumPy 2.0. %s", existing, migration_guide)
      elseif lang == "pt-br" then
        return string.format("`np.%s` será removido no NumPy 2.0. %s", existing, migration_guide)
      elseif lang == "fr" then
        return string.format("`np.%s` sera supprimé dans NumPy 2.0. %s", existing, migration_guide)
      elseif lang == "it" then
        return string.format("`np.%s` verrà rimosso in NumPy 2.0. %s", existing, migration_guide)
      end
    -- 🔗🐍 [RUF001]	ambiguous-unicode-character-string	String contains ambiguous {}. Did you mean {}?	✔️ 🛠️
    -- 🔗🐍 [RUF002]	ambiguous-unicode-character-docstring	Docstring contains ambiguous {}. Did you mean {}?	✔️ 🛠️
    -- 🔗🐍 [RUF003]	ambiguous-unicode-character-comment	Comment contains ambiguous {}. Did you mean {}?	✔️ 🛠️
    -- 🔗🐍 [RUF005]	collection-literal-concatenation	Consider {expression} instead of concatenation	✔️ 🛠️
    -- 🔗🐍 [RUF006]	asyncio-dangling-task	Store a reference to the return value of {expr}.{method}	✔️ 🛠️
    -- 🔗🐍 [RUF007]	zip-instead-of-pairwise	Prefer itertools.pairwise() over zip() when iterating over successive pairs	✔️ 🛠️
    -- 🔗🐍 [RUF008]	mutable-dataclass-default	Do not use mutable default values for dataclass attributes	✔️ 🛠️
    -- 🔗🐍 [RUF009]	function-call-in-dataclass-default-argument	Do not perform function call {name} in dataclass defaults	✔️ 🛠️
    -- 🔗🐍 [RUF010]	explicit-f-string-type-conversion	Use explicit conversion flag	✔️ 🛠️
    -- 🔗🐍 [RUF011]	ruff-static-key-dict-comprehension	Dictionary comprehension uses static key	❌ 🛠️
    -- 🔗🐍 [RUF012]	mutable-class-default	Mutable class attributes should be annotated with typing.ClassVar	✔️ 🛠️
    -- 🔗🐍 [RUF013]	implicit-optional	PEP 484 prohibits implicit Optional	✔️ 🛠️
    elseif code == "RUF013" then
      if lang == "es" then
        return "PEP 484 prohíbe el uso implícito de `Optional`"
      elseif lang == "pt-br" then
        return "PEP 484 proíbe o uso implícito de `Optional`"
      elseif lang == "fr" then
        return "PEP 484 interdit l'utilisation implicite de `Optional`"
      elseif lang == "it" then
        return "PEP 484 vieta l'uso implicito di `Optional`"
      end
      -- 🔗🐍 [RUF015]	unnecessary-iterable-allocation-for-first-element	Prefer next({iterable}) over single element slice	✔️ 🛠️
      -- 🔗🐍 [RUF016]	invalid-index-type	Slice in indexed access to type {value_type} uses type {index_type} instead of an integer	✔️ 🛠️
      -- 🔗🐍 [RUF017]	quadratic-list-summation	Avoid quadratic list summation	✔️ 🛠️
      -- 🔗🐍 [RUF018]	assignment-in-assert	Avoid assignment expressions in assert statements	✔️ 🛠️
      -- 🔗🐍 [RUF019]	unnecessary-key-check	Unnecessary key check before dictionary access	✔️ 🛠️
      -- 🔗🐍 [RUF020]	never-union	{never_like} | T is equivalent to T	✔️ 🛠️
      -- 🔗🐍 [RUF021]	parenthesize-chained-operators	Parenthesize a and b expressions when chaining and and or together, to make the precedence clear	🧪 🛠️
      -- 🔗🐍 [RUF022]	unsorted-dunder-all	__all__ is not sorted	🧪 🛠️
      -- 🔗🐍 [RUF023]	unsorted-dunder-slots	{}.__slots__ is not sorted	🧪 🛠️
      -- 🔗🐍 [RUF024]	mutable-fromkeys-value	Do not pass mutable objects as values to dict.fromkeys	✔️ 🛠️
      -- 🔗🐍 [RUF025]	unnecessary-dict-comprehension-for-iterable	Unnecessary dict comprehension for iterable; use dict.fromkeys instead	🧪 🛠️
      -- 🔗🐍 [RUF026]	default-factory-kwarg	default_factory is a positional-only argument to defaultdict	✔️ 🛠️
      -- 🔗🐍 [RUF027]	missing-f-string-syntax	Possible f-string without an f prefix	🧪 🛠️
      -- 🔗🐍 [RUF028]	invalid-formatter-suppression-comment	This suppression comment is invalid because {}	🧪 🛠️
      -- 🔗🐍 [RUF029]	unused-async	Function {name} is declared async, but doesn't await or use async features.	🧪 🛠️
      -- 🔗🐍 [RUF030]	assert-with-print-message	print() expression in assert statement is likely unintentional	🧪 🛠️
      -- 🔗🐍 [RUF100]	unused-noqa	Unused noqa directive	✔️ 🛠️
      -- 🔗🐍 [RUF101]	redirected-noqa	{original} is a redirect to {target}	🧪 🛠️
      -- 🔗🐍 [RUF200]	invalid-pyproject-toml	Failed to parse pyproject.toml: {message}	✔️ 🛠️
    end
  end

  return message
end

return M
