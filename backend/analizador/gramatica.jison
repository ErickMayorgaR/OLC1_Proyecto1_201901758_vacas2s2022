/**
 * Ejemplo mi primer proyecto con Jison utilizando Nodejs en Ubuntu
 */

/* Definición Léxica */

%lex
%options case-insensitive
%%



[\n\t\s\r]+                             {} // Espacios en blanco
"//".*                                  {} // Comentario de una linea // 
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]     {} // Comentario multilinea

//Reservadas res == reservada
"int"					return 'int';
"double"                return 'double';
"char"                  return 'char';
"bool"                  return 'bool';
"string"                return 'resstring';
"void"                  return 'void';

"null"                  return 'null';
"integer"               return 'integer';

"true"                  return 'true';
"false"                 return 'false';

"if"                    return 'if';
"else"                  return 'else';
"switch"                return 'switch'
"for"                   return 'for';
"while"                 return 'while';
"do"                    return 'do';
"console.write"         return 'imprimir';
"return"                return 'return';
"continue"				return 'continue'

"+"                     return 'mas';
"-"                     return 'menos';
"*"                     return 'por';
"/"                     return 'dividido';

"&&"                    return 'and'
"||"					return 'or'
"!"						return 'not'
">"						return 'mayor'
"<"						return 'menor'
">="					return 'mayorigual'
"<="					return 'menorigual'
"=="					return 'igualigual'
"!="					return 'diferente'
"++"					return 'masmas'
"--"					return 'menosmenos'

//simbolos
"{"              return 'llaveaper';     
"}"              return 'llavecierre';
"("              return 'parentesisaper';     
")"              return 'parentesiscierre';
","              return 'coma';
"."              return 'punto';
"="              return 'igual';
";"			     return 'puntocoma'
":"				 return 'dospuntos'



/* Espacios en blanco */


([a-zA-Z_])[a-z0-9A-Z_ñÑ]*       return 'id';
[0-9]+("."[0-9]+)\b         return 'decimal'
[0-9]+\b                    return 'entero'

\'((\\\')|[^\n\'])\'	{ yytext = yytext.substr(1,yyleng-2); return 'caracter'; }

[\"]("\\n"|"\\r"|"\\t"|"\\'"|"\\\""|"\\\\"|[^\"])*[\"]   {yytext = yytext.substring(1,yytext.length-1) 
                                                         yytext = yytext.replace(/\\n/g, '\n')
                                                         yytext = yytext.replace(/\\r/g, '\r')
                                                         yytext = yytext.replace(/\\t/g, '\t')
                                                         yytext = yytext.replace(/\\\'/g, '\'')
                                                         //yytext = yytext.replace(/\\\"/g, '\"')
                                                         //yytext = yytext.replace(/\\\\/g, '\\')
                                                         return'cadena';}  


<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

%{
	const Reportes = require('./reportes.js');
	const Declaracion = require('./Declaracion.js');
	const SymbolTable = require('./tabla_simbolos.js');
	const Type = require('./tipo.js')
	var reportes = new Reportes();
	var tabla_simbolo = new SymbolTable(null);
	tabla_simbolo.reportes = reportes;

%}

/* Asociación de operadores y precedencia */

%left 'mas' 'menos'
%left 'por' 'dividido'
%left uMenos

%start INI

%% /* Definición de la gramática */

INI
	: INSTRUCCIONES EOF {
		
		  for(var i = 0; i< $1.length; i++){
            if($1[i])
                $1[i].operar(tabla_simbolo, reportes)
        }

		return reportes;
	}	
;

INSTRUCCIONES
	: INSTRUCCIONES INSTRUCCION  {$$ = $1; $$.push($2);}
	| INSTRUCCION  {$$ = []; $$.push($1)}
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); 
			  reportes.putError_sintactico({lexema:yytext, fila: this._$.first_line, columna:this._$.first_column })
			}	
;

INSTRUCCION
	: DECLARACION_VAR  puntocoma {  console.log("Paso a aqui 2", $1); if($1 != null){$$ = $1}}
	| DECLARACION_FUNCION puntocoma {if($1 != null){$$ = $1}}
	| DECLARACION_METODO puntocoma
	| ASIGNACIONVAR puntocoma
	| IF puntocoma
	| SWITCH puntocoma
	| FOR puntocoma
	| WHILE puntocoma
	| PRINT puntocoma
	| RETURN puntocoma
	| BREAK puntocoma
	| CONTINUE puntocoma
;

DECLARACION_VAR
     : TYPE id igual EXPRESION  { console.log("Paso a aqui", $1); $$ = new Declaracion($2,$1,Type.VARIABLE,Type.VARIABLE, $4 ,this._$.first_line,this._$.first_column);}
	 | TYPE id coma DECLARACION_VAR 
	 | TYPE id 
;

ASIGNACIONVAR 
: id igual EXPRESION
;

DECLARACION_FUNCION
	: TYPE id parentesisaper parentesiscierre llaveaper INSTRUCCIONES llavecierre
	| TYPE id parentesisaper PARAMETROS parentesiscierre llaveaper INSTRUCCIONES llavecierre
;

DECLARACION_METODO 
	: void id parentesisaper parentesiscierre llaveaper INSTRUCCIONES llavecierre
	| void id parentesisaper PARAMETROS parentesiscierre llaveaper INSTRUCCIONES llavecierre
	;
// if
IF 
 : INS_IF
 | INS_IF ELSE 
 | INS_IF MULTI_ELSE ELSE 
 ;

 INS_IF 
 : if parentesisaper EXPRESION parentesiscierre llaveaper INSTRUCCIONES llavecierre
 | if parentesisaper EXPRESION parentesiscierre llaveaper llavecierre
 ;

 ELSE
 : else llaveaper INSTRUCCIONES llavecierre
 | else llaveaper llavecierre
 ;

MULTI_ELSE 
 : MULTI_ELSE ELSE
 | ELSE
 ;

// switch 
SWITCH 
: switch parentesisaper EXPRESION parentesiscierre llaveaper SWITCHCASES llavecierre
;

SWITCHCASES 
: CASES DEFAULT
| CASES 
| DEFAULT
;

CASES 
: CASES CASE 
| CASE
;

CASE 
: case EXPRESION dospuntos INSTRUCCIONES
;

DEFAULT
: default dospuntos INSTRUCCIONES
;
//FOR
FOR 
:parentesisaper INICIOFOR puntocoma EXPRESION puntocoma ACTUALIZACIONFOR parentesiscierre llaveaper INSTRUCCIONES llavecierre 
;

INICIOFOR 
: DECLARACION_VAR
| ASIGNACIONVAR
;

ACTUALIZACIONFOR 
: ACTUALIZACION
| ASIGNACIONVAR
;
//WHILE 

WHILE
: WHILESIMPLE llaveaper INSTRUCCIONES llavecierre
| do llaveaper INSTRUCCIONES llavecierre WHILESIMPLE
;

WHILESIMPLE
: while parentesisaper EXPRESION parentesiscierre llaveaper 

ACTUALIZACION 
: id masmas
| id menosmenos
;


//print 

PRINT
: imprimir parentesisaper cadena parentesiscierre
;

//return 

RETURN 
: return EXPRESION
| return
;

//break

BREAK 
: break
;

//continue

CONTINUE
: continue
;


PARAMETROS
: PARAMETROS coma PARAMETROS
|PARAMETROS
;

PARAMETRO 
: TYPE id 
;


EXPRESION
	: menos EXPRESION %prec uMenos  { $$ = $2 *-1; }
	| EXPRESION mas EXPRESION       { $$ = $1 + "+" +  $3; }
	| EXPRESION menos EXPRESION     { $$ = $1 + "-" + $3; }
	| EXPRESION por EXPRESION       { $$ = $1 + "*" + $3; }
	| EXPRESION dividido EXPRESION  { $$ = + $1 + "/" + $3; }
	| cadena						{ console.log("asdfasdf", $1); $$ = $1; }
	| entero                        { $$ = Number($1); }
	| decimal                       { $$ = Number($1); }
	| true							{ console.log("asdfasdf", $1); $$ = $1 }
	| false							{ $$ = $1; }
	| caracter 						{ $$ = $1; }
	| parentesisaper EXPRESION parentesiscierre       { $$ = $2; }
;


TYPE
     :int     {$$ = Type.ENTERO}
     | double {$$ = Type.DOUBLE}
     | bool   {$$ = Type.BOOLEANO}
     | resstring {console.log("reconociendo string", $1); $$ = Type.CADENA}
	 | char   {$$ = Type.CARACTER}
;
