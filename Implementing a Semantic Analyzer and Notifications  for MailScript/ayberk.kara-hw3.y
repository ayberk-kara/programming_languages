%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ayberk.kara-hw3.h"

int inMailBlock = 0;
int inScheduleBlock = 0;
char * adress = "";
int error = 0; // if 0 no error. if 1 undeclared var. if 2 invalid date. if 3 invalid time. // if 4

char ** errors;
int errorSize = 100;
int errorIndex = 0;

char ** Notifications;
int NotificationsSize = 100;
int NotificationsIdx = 0;



char ** LocalVariableList;
int LocalVariableListSize = 100;
int LocalVariableListIdx = 0;

char ** GlobalVariableList;
int GlobalVariableListSize = 100;
int GlobalVariableListIdx = 0;

char ** GlobalValueList;
int GlobalValueListSize = 100;
int GlobalValueListIdx = 0;

char ** LocalValueList;
int LocalValueListSize = 100;
int LocalValueListIdx = 0;


RecipientNode ** RecipientList;
int RecipientListSize = 300;
int RecipientListIdx = 0;






char ** SendSenderNameList;
int SendSenderNameSize = 300;
int SendSenderNameIdx = 0;

char ** SendRecieverList;
int SendRecieverSize = 300;
int SendRecieverIdx = 0;

char ** SendMessageList;
int SendMessageListSize = 300;
int SendMessageListIdx = 0;

#ifdef YYDEBUG
  yydebug = 1;
#endif
void printErrors() {
    int i = 0;
    for (; i < errorIndex; i++) {
        printf("%s\n", errors[i]);
    }
}
void printNotifications(){
    int i = 0;
    for (; i < NotificationsIdx; i++) {
        printf("%s\n", Notifications[i]);
    }
}

void addVariable(IdentNode identNode){
    if(inMailBlock == 1){
        if (LocalVariableListIdx < LocalVariableListSize) {
        LocalVariableList[LocalVariableListIdx] = identNode.value;
        LocalVariableListIdx += 1;
        }   
        else{

        LocalVariableListSize = LocalVariableListSize + LocalVariableListSize;
        LocalVariableList = realloc(LocalVariableList, LocalVariableListSize * sizeof(char *));
        LocalVariableList[LocalVariableListIdx] = identNode.value;
        LocalVariableListIdx += 1;
        }
    }
    else if(inMailBlock == 0){
        if (GlobalVariableListIdx < GlobalVariableListSize) {
        GlobalVariableList[GlobalVariableListIdx] = identNode.value;
        LocalVariableListIdx += 1;
        }   
        else{

        GlobalVariableListSize = GlobalVariableListSize + GlobalVariableListSize;
        GlobalVariableList = realloc(GlobalVariableList, GlobalVariableListSize * sizeof(char *));
        GlobalVariableList[GlobalVariableListIdx] = identNode.value;
        GlobalVariableListIdx += 1;
        }
    }

}


void addValue(StringNode stringNode){
    if(inMailBlock == 1){
        if (LocalValueListIdx < LocalValueListSize) {
        LocalValueList[LocalValueListIdx] = stringNode.value;
        LocalValueListIdx += 1;
        }   
        else{

        LocalValueListSize = LocalValueListSize + LocalValueListSize;
        LocalValueList = realloc(LocalValueList, LocalValueListSize * sizeof(char *));
        LocalValueList[LocalValueListIdx] = stringNode.value;
        LocalValueListIdx += 1;
        }
    }
    else if(inMailBlock == 0){
        if (GlobalValueListIdx < GlobalValueListSize) {
        GlobalValueList[GlobalValueListIdx] = stringNode.value;
        LocalVariableListIdx += 1;
        }   
        else{

        GlobalValueListSize = GlobalValueListSize + GlobalValueListSize;
        GlobalValueList = realloc(GlobalValueList, GlobalValueListSize * sizeof(char *));
        GlobalValueList[GlobalValueListIdx] = stringNode.value;
        GlobalValueListIdx += 1;
        }
    }

}

char * checkIdentifier(IdentNode identNode) {
    int latestIndex = -1;
    int i = 0;
    for (; i < LocalVariableListIdx; i++) {
        if (strcmp(identNode.value, LocalVariableList[i]) == 0) {
            latestIndex = i;
        }
    }
    if(latestIndex != -1){
        return LocalValueList[latestIndex];
    }


    if(latestIndex == -1){
        i = 0;
        for (; i < GlobalVariableListIdx; i++) {
        if (strcmp(identNode.value, GlobalVariableList[i]) == 0) {
            latestIndex = i;
        }
        }


    }
    if(latestIndex != -1){
        return GlobalValueList[latestIndex];
    }

    if(latestIndex == -1){
        char * src =  "ERROR at line %d: %s is undefined\n";
        char * dest = (char *)malloc(strlen(src) + strlen(identNode.value) + identNode.lineNum + 10);
        sprintf(dest, src, identNode.lineNum, identNode.value);

        if(errorIndex < errorSize){
                errors[errorIndex] = dest;
                errorIndex += 1;
            }
            else{
                errorSize = errorSize + errorSize;
                errors = realloc(errors, errorSize);
                errors[errorIndex] = dest;
                errorIndex += 1;
            }

    }
    char * empty = "";
    if(latestIndex == -1){
        return empty;
    } 
    
}

optionNode * makeOptionFromIdent(IdentNode ident){

    optionNode * newNode = (optionNode *)malloc(sizeof(optionNode));
    newNode->value = checkIdentifier(ident);
    newNode->lineNum = ident.lineNum;
    return newNode;
}


optionNode * makeOptionFromString(StringNode ident){

    optionNode * newNode = (optionNode *)malloc(sizeof(optionNode));
    newNode->value = ident.value;
    newNode->lineNum = ident.lineNum;
    return newNode;
}


RecipientNode * makeRecipientNodeFromAdress(char* SenderAdress, char * RecieverAdress){

    RecipientNode * newNode = (RecipientNode *)malloc(sizeof(RecipientNode));
    newNode->sender = SenderAdress;
    newNode->lineNum = RecieverAdress;
    newNode->name = "";
    return newNode;
}


RecipientNode * makeRecipientNodeFromString(StringNode stringNode, char* SenderAdress , char * RecieverAdress){

    RecipientNode * newNode = (RecipientNode *)malloc(sizeof(RecipientNode));
    newNode->sender = SenderAdress;
    newNode->lineNum = RecieverAdress;
    newNode->name = stringNode.value;
    return newNode;
}

RecipientNode * makeRecipientNodeFromIdent(IdentNode identNode, char* SenderAdress, char * RecieverAdress){

    RecipientNode * newNode = (RecipientNode *)malloc(sizeof(RecipientNode));
    newNode->sender = SenderAdress;
    newNode->lineNum = RecieverAdress;
    
    newNode->name = checkIdentifier(identNode);

    
    

    
    return newNode;
}

void addNotification(char * mystr){
    if(NotificationsIdx < NotificationsSize){
        Notifications[NotificationsIdx] = mystr;
        NotificationsIdx += 1;
    }
    else{
        NotificationsSize = NotificationsSize + NotificationsSize;
        Notifications = realloc(Notifications, NotificationsSize);
        Notifications[NotificationsIdx] = mystr;
        NotificationsIdx += 1;
    }

}

void checkDate(DateNode dateNode){

if(dateNode.month > 12 || dateNode.month < 1 || dateNode.day >31 || dateNode.day < 1 || dateNode.year < 1){
    char * src =  "ERROR at line %d: date object is not correct %s\n";
        char * dest = (char *)malloc(strlen(src) + strlen(dateNode.value) + dateNode.lineNum + 10);
        sprintf(dest, src, dateNode.lineNum, dateNode.value);

        if(errorIndex < errorSize){
                errors[errorIndex] = dest;
                errorIndex += 1;
            }
            else{
                errorSize = errorSize + errorSize;
                errors = realloc(errors, errorSize);
                errors[errorIndex] = dest;
                errorIndex += 1;
            }

    }
}

void checkTime(TimeNode timeNode){

if(timeNode.hour > 23 || timeNode.hour < 1 || timeNode.minute >59 || timeNode.minute < 1){
    char * src =  "ERROR at line %d: time object is not correct %s\n";
        char * dest = (char *)malloc(strlen(src) + strlen(timeNode.value) + timeNode.lineNum + 10);
        sprintf(dest, src, timeNode.lineNum, timeNode.value);

        if(errorIndex < errorSize){
                errors[errorIndex] = dest;
                errorIndex += 1;
            }
            else{
                errorSize = errorSize + errorSize;
                errors = realloc(errors, errorSize);
                errors[errorIndex] = dest;
                errorIndex += 1;
            }

    }
}

char * returnMonth(DateNode dateNode){
    if(dateNode.month == 1){
        return "January";
    }
    if(dateNode.month == 2){
        return "February";
    }
    if(dateNode.month == 3){
        return "March";
    }
    if(dateNode.month == 4){
        return "April";
    }
    if(dateNode.month == 5){
        return "May";
    }
    if(dateNode.month == 6){
        return "June";
    }
    if(dateNode.month == 7){
        return "July";
    }
    if(dateNode.month == 8){
        return "August";
    }
    if(dateNode.month == 9){
        return "September";
    }
    if(dateNode.month == 10){
        return "October";
    }
    if(dateNode.month == 11){
        return "November";
    }
    if(dateNode.month == 12){
        return "December";
    }
    return "invalid month";

}

void yyerror (const char *msg) /* Called by yyparse on error */ {return; }
%}

%union{
    IdentNode identNode;
    StringNode stringNode;
    DateNode dateNode;
    TimeNode timeNode;
    RecipientNode * recipientNodePtr;
    optionNode * optionNodePtr;
    char * adressString;

    int lineNum;
}

%token<lineNum> tMAIL tENDMAIL tSCHEDULE tENDSCHEDULE tSEND tTO tFROM tSET tCOMMA tCOLON tLPR tRPR tLBR tRBR tAT  

//token <lineNum> tASSIGN
%token <identNode> tIDENT
%token <stringNode> tSTRING
%token <dateNode> tDATE
%token <timeNode> tTIME
%token <adressString> tADDRESS

%type <recipientNodePtr> recipient
%type <optionNodePtr> option

%start program
%%

program : statements
;

statements : 
            | setStatement statements
            | mailBlock statements
;

mailBlock : tMAIL tFROM tADDRESS tCOLON statementList {
    inMailBlock = 1;
    adress = $3;
    LocalVariableList = NULL;
    LocalVariableListIdx = 0;
    LocalVariableListSize = 100;

    LocalValueList = NULL;
    LocalValueListIdx = 0;
    LocalValueListSize = 100;
}
tENDMAIL{
    inMailBlock = 0;
    adress = "";
    int i = 0;
    for (; i < LocalVariableListIdx; i++) {
    free(LocalVariableList[i]);
    }
    free(LocalVariableList);

    
    int j = 0;
    for (; j < LocalValueListIdx; j++) {
    free(LocalValueList[j]);
    }
    free(LocalValueList);
    

}
;

statementList : 
                | setStatement statementList
                | sendStatement statementList
                | scheduleStatement statementList
;

sendStatements : sendStatement
                | sendStatement sendStatements 
;
//sendstatmen list
sendStatement : tSEND tLBR option tRBR tTO tLBR recipientList tRBR{
    RecipientNode ** RecipientList;
    int RecipientListSize = 300;
    int RecipientListIdx = 0;
    
    if(inScheduleBlock == 0){
        
        
        char **uniqueEmails = NULL;
        int uniqueEmailsSize = 0;

        int i;
        for (i = 0; i < RecipientListIdx; i++) {
            RecipientNode *recipient = RecipientList[i];

            // Check if the email is already in the set
            int isUnique = 1;
            int j;
            for (j = 0; j < uniqueEmailsSize; ++j) {
                if (strcmp(uniqueEmails[j], recipient->email) == 0) {
                    isUnique = 0;
                    break;
                }
            }

            // If the email is unique, print the notification
            if (isUnique) {
                char *senderInfo = recipient->sender;
                char *recipientInfo;
                char *notification = (char *)malloc(256);
                if(recipient->name != NULL && strlen(recipient->name) > 0){
                    recipientInfo = recipient->name;
                }
                else{
                    recipientInfo = recipient->email;
                }
                sprintf(notification, "E-mail sent from %s to %s: \"%s\"\n", senderInfo, recipientInfo, $3->value);
                addNotification(notification);
                //printf("E-mail sent from %s to %s: \"%s\"\n", senderInfo, recipientInfo,$3->value);

                // Add the email to the set
                uniqueEmailsSize += 1;
                uniqueEmails = realloc(uniqueEmails, uniqueEmailsSize * sizeof(char *));
                uniqueEmails[uniqueEmailsSize - 1] = recipient->email;
            }
        }

        // Reset the recipient list and the set for the next send statement
        RecipientListIdx = 0;
        free(uniqueEmails);











    }
    else if(inScheduleBlock == 1){
        char ** SendSenderNameList;
        int SendSenderNameSize = 300;
        int SendSenderNameIdx = 0;

        char ** SendRecieverList;
        int SendRecieverSize = 300;
        int SendRecieverIdx = 0;

        char ** SendMessageList;
        int SendMessageListSize = 300;
        int SendMessageListIdx = 0;


        char **uniqueEmails = NULL;
        int uniqueEmailsSize = 0;

        int i;
        for (i = 0; i < RecipientListIdx; i++) {
            RecipientNode *recipient = RecipientList[i];

            // Check if the email is already in the set
            int isUnique = 1;
            int j;
            for (j = 0; j < uniqueEmailsSize; ++j) {
                if (strcmp(uniqueEmails[j], recipient->email) == 0) {
                    isUnique = 0;
                    break;
                }
            }

            // If the email is unique, print the notification
            if (isUnique) {
                char *senderInfo = recipient->sender;
                char *recipientInfo;
                char *notification = (char *)malloc(256);
                if(recipient->name != NULL && strlen(recipient->name) > 0){
                    recipientInfo = recipient->name;
                }
                else{
                    recipientInfo = recipient->email;
                }
                
                SendSenderNameList[SendSenderNameIdx] = senderInfo;
                SendSenderNameIdx++;

                SendRecieverList[SendRecieverIdx] = recipientInfo;
                SendRecieverIdx++;

                SendMessageList[SendMessageListIdx] = $3->value;
                SendMessageListIdx++;



                // Add the email to the set
                uniqueEmailsSize += 1;
                uniqueEmails = realloc(uniqueEmails, uniqueEmailsSize * sizeof(char *));
                uniqueEmails[uniqueEmailsSize - 1] = recipient->email;
            }
        }

        // Reset the recipient list and the set for the next send statement
        RecipientListIdx = 0;
        free(uniqueEmails);




        
    }
    int i = 0;
    for (; i < RecipientListIdx; i++) {
    free(RecipientList[i]);
    }
    free(RecipientList);
    RecipientListIdx = 0;

    i = 0;
    for (; i < SendSenderNameIdx; i++) {
    free(SendSenderNameList[i]);
    }
    free(SendSenderNameList);
    SendSenderNameIdx = 0;

    i = 0;
    for (; i < SendRecieverIdx; i++) {
    free(SendRecieverList[i]);
    }
    free(SendRecieverList);
    SendRecieverIdx = 0;

    i = 0;
    for (; i < SendMessageListIdx; i++) {
    free(SendMessageList[i]);
    }
    free(SendMessageList);
    SendMessageListIdx = 0;
}
;

option: tSTRING {
    makeOptionFromString($1);
}
| tIDENT{
    //checkIdentifier($1);
    makeOptionFromIdent($1);
}
;


recipientList : recipient{
    
}
            | recipient tCOMMA recipientList
;

recipient : tLPR tADDRESS tRPR{
            
            RecipientList[RecipientListIdx] = makeRecipientNodeFromAdress($2, adress);
            RecipientListIdx += 1;
}
            | tLPR tSTRING tCOMMA tADDRESS tRPR{
                
                RecipientList[RecipientListIdx] = makeRecipientNodeFromString($2, $4, adress);
            RecipientListIdx += 1;
            }
            | tLPR tIDENT tCOMMA tADDRESS tRPR{
                
                RecipientList[RecipientListIdx] = makeRecipientNodeFromIdent($2, $4, adress);
                //checkIdentifier($2);
            }
;

scheduleStatement : tSCHEDULE tAT tLBR tDATE tCOMMA tTIME tRBR tCOLON sendStatements{
    inScheduleBlock = 1;
    checkDate($4);
    checkTime($6);
    char * myMonth = returnMonth($4);
    char *notification = (char *)malloc(512);
    int i = 0;
    for (; i < SendSenderNameIdx; i++) {

        sprintf(notification, "E-mail scheduled to be sent from %s on %s %d, %d, %s to %s: \"%s\"\n", SendSenderNameList[i], myMonth, $4.day, $4.year, $6.value, SendRecieverList[i], SendMessageList[i]);
        addNotification(notification);

    }


} 
tENDSCHEDULE{
    inScheduleBlock=0;
}
;

setStatement : tSET tIDENT tLPR tSTRING tRPR{

    addVariable($2);
    addValue($4);
}
;







%%
int main () 
{
    errors = (char**)malloc(errorSize * sizeof(char*));
    GlobalValueList = (char**)malloc(GlobalValueListSize * sizeof(char*));
    LocalValueList = (char**)malloc(LocalValueListSize * sizeof(char*));
    LocalVariableList = (char**)malloc(LocalVariableListSize * sizeof(char*));
    GlobalVariableList = (char**)malloc(GlobalVariableListSize * sizeof(char*));
   if (yyparse())
   {
      printf("ERROR\n");
      return 1;
    } 
    else 
    {
        //printf("OK\n");
        if(errorIndex > 0){
            printErrors();
        }
        else{

        }
        return 0;
    } 
}