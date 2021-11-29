#ifndef _DEFINITIONS_H
#define _DEFINITIONS_H

/* CONSTANTS FOR SIMULATION BOOL TYPE */
#define bool int
#define TRUE 1
#define FALSE 0
/* LENGTH OF SYMBOL TABLE */
#define SYMBOL_TABLE_LENGTH 64
/* MAX NUMBER OF PARAMETERS */
#define MAX_DIM 8
/* REGISTER FOR STORING RETURN VALUE OF FUNCTION */
#define FUN_REG 13
/* BUFFER LENGTH FOR STORING ERROR MESSAGES */
#define CHAR_BUFFER_LENGTH 129

/* SYMBOLS TABLE KINDS */
enum kinds { NO_KIND, LIT, FUN, VAR, PAR };

/* DATA TYPES */
enum types { NO_TYPE, INT, UINT, VOID };
/* ARTIHMETIC AND LOGICAL OPERATORS */
enum ops { PLUS, MINUS, STAR, DIV, MOD, SR, SL, AMP, BOR, BXOR, AND, OR };
/* RELATION OPERATORS */
enum relops { LT, LEQ, GT, GEQ, EQ, NEQ };
/* ITERATION OPERATORS */
enum itrops { INC, DEC };

#endif
