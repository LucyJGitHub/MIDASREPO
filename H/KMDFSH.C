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

#ifndef _kcmfsh_h_
#define _kcmfsh_h_
#include <recio.h>
#include <xxfdbk.h>

/*                                                                           */
/*  Extended file I/O using _RFILE's rather than FILEs                       */
/*                                                                           */
/*  All macros defined simply use their similarly named functions with a     */
/*  'current file' as the context                                            */
/*                                                                           */

typedef struct fcb {
    _RFILE*    file;
    char*      buffer;
    _XXOPFB_T* opfb;
    short      crec;
} fcb;

extern fcb * FDEFAULT;  /*  Current file                                     */

/*  Open a file                                                              */
fcb* Ffopen(char *);
fcb* Fopen(char *);

/*  Close a file                                                             */
void Ffclose(fcb *);
#define Fclose() Ffclose(FDEFAULT)

/*  Read a character                                                         */
unsigned char Ffgetc(fcb *, int);
#define Fgetc(x) Ffgetc(FDEFAULT, x)

/*  Find first occurrence of a character                                     */
int Ffchr(fcb *, int, char);
#define Fchr(x, y) Ffchr(FDEFAULT, x, y)

/*  Find first occurrence of a string                                        */
int Ffstr(fcb *, int, char *);
#define Fstr(x, y) Ffstr(FDEFAULT, x, y)

/*  Compare strings                                                          */
int Ffncmp(fcb *,int,char *,int);
#define Fncmp(x,y,z) Ffncmp(FDEFAULT,x,y,z)

/*  Copy string                                                              */
char * Ffncpy(fcb *,char *,int,int);
#define Fncpy(x,y,z) Ffncpy(FDEFAULT,x,y,z)

/*  Return size of file                                                      */
int Fflen(fcb *);
#define Flen() Fflen(FDEFAULT)

/* Return row                                                                */
int Ffrow(fcb *, int);
#define Frow(x) Ffrow(FDEFAULT, x)

/* Return column                                                             */
int Ffcol(fcb *, int);
#define Fcol(x) Ffcol(FDEFAULT,x)

#endif
