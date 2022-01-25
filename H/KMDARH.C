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

#ifndef _KMDARH_H_
#define _KMDARH_H_
/*

    Support for manipulating arrays of structures.

*/

#ifndef _WINDOWS_
#ifndef _BOOL_
#define _BOOL_
typedef enum {FALSE,TRUE} BOOL;
#endif
#else
#include <windows.h>
#endif

/*                                                                           */
/*  This set of macros and function allow an array of structures to be       */
/*  set up together with an accessor function and various manager macros     */
/*                                                                           */
/*  Using these macros for an array named xx gives an accessor function      */
/*  pxx(index) which returns a pointer to the array element.                 */
/*  xx is defined as an extended array, and requires an element ixx to be    */
/*  defined to act as the initialiser for an individual element.             */


#define ahPROTO(y) struct { \
   union {\
      y * pArray; \
      y ** ppObj;\
   } u;\
   int allocated; \
   int used; \
   BOOL indirect;\
}

/* Generic header */

typedef ahPROTO(char) gen_header;

/* Header initialiser string */

#define ahINIT {NULL,0,0,FALSE}
extern gen_header gen_header_init_struct;

/* Elements to extend array by */

#ifndef aEXTEND_AMOUNT
#define aEXTEND_AMOUNT 10
#endif

/* Define array header and access function */

extern void * _array_element(gen_header *,int,int,int,void *);

extern int _index_of(gen_header *,int,int,int);

#define ahSTRUCT(x,y) static ahPROTO(y) x = ahINIT;\
 static y * p##x(int i) {return \
_array_element((gen_header *) &x,sizeof(*(((x.indirect == FALSE)\
 ? x.u.pArray : *(x.u.ppObj)))),\
aEXTEND_AMOUNT,i,&y##_init_struct);}

extern void trim(gen_header * pgh,int i);

#define INIT(x) memcpy(&x,&gen_header_init_struct,sizeof(gen_header))
#define ADD_TO(x) p##x(x.used)
#define LAST(x) ((((x.indirect == FALSE) ?\
 x.u.pArray  + x.used - 1: *(x.u.ppObj + x.used - 1))))
#define TRIM(x) trim((gen_header *) &x,sizeof(*(x.u.pArray)));
#define INDEX_OF(x,y) (x.u.pArray == NULL) ? -1 : \
 _index_of(\
           (gen_header*)&x,\
           sizeof(i##x),\
           ((char *) &i##x.name) - ((char *) &i##x),\
           y)
#endif
