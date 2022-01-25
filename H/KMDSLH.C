/********************************************************************
 *
 *       Meridian Replication
 *
 *       (c) Finastra International Limited 2021
 *
 *       Last Amend No. MD058809  *CREATE  Date 16Dec21
 *
 ********************************************************************
 *
 *       MD058809 - After installation of MQ9 compatibility patch and
 *                  restart of the Meridian Replication subsystem
 *                  REPMIDASPT, the job MPT1PBSIN ended in MSGW.
 *
 ********************************************************************
 */

#ifndef _kcmslh_h_
#define _kcmslh_h_
#include "kmdtrh.h"
#include "kmdmph.h"

/* Operators & functions */

typedef enum {
 /* This item is a parameter */
   FIELD,
 /* Variable parameter list marker */
   MARKER,
 /* Comma - will not appear in final stack */
   COMMA,
 /* Arithmetic operators */
   ADD,
   SUB,
   MUL,
   DIV,
   EXP,
   IMINUS,
   IPLUS,
 /* Logical operators */
   _NOT, /* Temporary unbound NOT */
   NOT,
   OR,
   AND,
 /* Comparison operators */
   LT,
   GT,
   LE,
   GE,
   EQ,
   NE,
   CONCAT,
   LIKE,
   NOT_LIKE,
 /* Functions */
   SUBSTR,
   TRANSLATE,
   UNKNOWN,  /* to allow parsing to continue */
 /* All done marker */
   DONE
} operation_t;


typedef enum {
   ROW,
   WORK,
   EXT
} buffer_t;


typedef enum {
   CHAR,
   VARCHAR,
   SHORT,
   LONG,
   PACKED,
   ZONED,
   FLOAT,
   DOUBLE,
   LOGICAL,

   /* data classes */

   NUMERIC,
   DATA,
   ANY
} datatype_t;


typedef enum {
   _FIELD,
   PUNCTUATION,
   OPERATOR,
   FUNCTION
} item_t;

#define FIRST_OPERATOR ADD
#define FIRST_FUNCTION SUBSTR

typedef enum {
   LtoR,
   RtoL
} assoc_t;

typedef _Packed struct {
   operation_t operation;
   unsigned int buffer : 2;
   unsigned int reserved : 7;
   unsigned int type : 7;
   short length;
   short offset;
   short extra_1;
   short extra_2;
} s_item;

typedef struct {
   Struct * pStruct;
   unsigned short sid[16];
} Sids;

#define S_ADD 0
#define S_BUFFERED_ADD 1
#define S_DELETE 2
#define S_CLEAR 3
#define S_BEFORE 4
#define S_UPDATE 5

#define FALSE 0
#define TRUE 1

extern Sids * find_family(char *);
extern char * fname(short);
extern s_item * get_item(char *);
extern s_item * get_ext_item(char *);
extern char * get_ext_item_data(s_item *, char *);
extern int uncompile (char *,char *,s_item *);
extern int evaluate (char *,char *,s_item *);
extern int current_file;

typedef struct error_msg {
   struct error_msg * next;
   int offset;
   char text[120];
} error_msg;
extern error_msg * compile(char *,s_item **,int *,char **,int *);

typedef _Packed struct {
   char * pWORK;
   s_item * pSTACK;
   int icount;
   Struct * pSTRUCT;
} s_control_t;

#ifndef __ILEC400__
#define LOG_DEBUG 4
#define LOG_ERROR 0
void dprintf(int,char *);
#endif

/* Department level control blocks */

typedef struct {
   s_control_t * plist; /* Selection control array for dept */
   qhandle queue;       /* Output queue handle */
   char * before;       /* Before image for comparison */
   char * beforex;      /* Before image for transmission */
   int bxlen;           /* Length of " */
   char dept[3];        /* Department mnemonic */
   BOOL send;           /* Send current record */
} dscb;

/* Selection control block */

typedef struct {
   Master * master;         /* Mapping control block */
   s_control_t * plist;     /* Overall selection control */
   dscb * pdscb;            /* Department level selection control */
   Sids * pSids;            /* Fast access array for structs */
   int nstream;             /* Number of streams */
}  selcb;

int init_selection(char * product, /* Mapping script file */
               char * env,            /* Target unit */
               char * process,
               tinit_t ptinit,     /* Target initialisation function */
               void * puser,          /* Source to target information */
               selcb * psel           /* Selection control block */
               );
extern void FillInHeader(Master *mast, char *struct_id, char *prod_id, char *data);
#endif
