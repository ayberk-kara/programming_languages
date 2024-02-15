#ifndef AYBERK_KARA_HW3_H
#define AYBERK_KARA_HW3_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct StringNode
{
   char *value;
   int lineNum;
} StringNode;

typedef struct IdentNode
{
    char *value;
    int lineNum;
} IdentNode;

typedef struct DateNode
{
    char *value;
    int year;
    int month;
    int day;
    int lineNum;
} DateNode;

typedef struct TimeNode
{
    char *value;
    int hour;
    int minute;
    int lineNum;
} TimeNode;

typedef struct RecipientNode
{
    char *sender;
    char *email;
    char *name;
    int lineNum;

} RecipientNode;

typedef struct optionNode
{
    char *value;
    int lineNum;

} optionNode;

#endif