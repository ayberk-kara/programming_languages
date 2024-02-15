%{
#include <stdio.h> 
#include <string.h>
void yyerror (const char *msg){
    return;
} 
    
    
    

%}

%token  tMAIL tENDMAIL tSCHEDULE tENDSCHEDULE tSEND tSET tTO tFROM tAT tCOMMA tCOLON tLPR tRPR tLBR tRBR tIDENT tSTRING tADDRESS tDATE tTIME
%start program





%%

program:
    | program component
    | component
    ;

component:
    mail_block
    | set_statement
    ;

mail_block:
    tMAIL tFROM tADDRESS tCOLON tENDMAIL
    | tMAIL tFROM tADDRESS tCOLON statement_list tENDMAIL
    ;

set_statement:
    tSET tIDENT tLPR tSTRING tRPR
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    send_statement
    | schedule_statement
    | set_statement
    ;



schedule_statement:
    tSCHEDULE tAT tLBR tDATE tCOMMA tTIME tRBR tCOLON send_statement_list tENDSCHEDULE
    ;

send_statement_list:
    send_statement
    | send_statement_list send_statement
    ;

send_statement:
    tSEND tLBR tSTRING tRBR tTO recipient_list
    | tSEND tLBR tIDENT tRBR tTO recipient_list
    | tSEND tLBR tSTRING tRBR tTO tLBR recipient tRBR
    | tSEND tLBR tIDENT tRBR tTO tLBR recipient tRBR
    ;
recipient_list:
    tLBR recipientsinlist tRBR
    ;

recipientsinlist:
    recipient
    | recipientsinlist tCOMMA recipient
    ;

recipient:
    tLPR tSTRING tCOMMA tADDRESS tRPR
    | tLPR tIDENT tCOMMA tADDRESS tRPR
    |tLPR tADDRESS tRPR
    ; 
    |







%%

int main ()
{
if (yyparse())
{
// parse error
printf("ERROR\n");
return 1;
}
else
{
// successful parsing
printf("OK\n");
return 0;
}
}
