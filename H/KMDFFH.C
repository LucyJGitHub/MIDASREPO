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

#ifndef _KMDFFH_H_
#define _KMDFFH_H_

#include <recio.h>

typedef struct {
   char WHFILE[10];   /*  File                                               */
   char WHLIB[10];    /*  Library                                            */
   char WHCRTD[7];    /*  File creation date: century/date                   */
   char WHFTYP;       /*  Type of file: P=Physical, L=Logical, D=Device      */
   int  WHCNT;        /*  Number of record formats                           */
   char WHDTTM[13];   /*  Retrieval date: century/date/time                  */
   char WHNAME[10];   /*  Record format                                      */
   char WHSEQ[13];    /*  Format level identifier                            */
   char WHTEXT[50];   /*  Format text description                            */
   int  WHFLDN;       /*  Number of fields and indicators                    */
   int  WHRLEN;       /*  Record format length                               */
   char WHFLDI[10];   /*  Internal field name                                */
   char WHFLDE[10];   /*  External field name                                */
   int  WHFOBO;       /*  Output buffer position                             */
   int  WHIBO;        /*  Input buffer position                              */
   int  WHFLDB;       /*  Field length in bytes                              */
   int  WHFLDD;       /*  Number of digits                                   */
   int  WHFLDP;       /*  Decimal positions to right of decimal              */
   char WHFTXT[50];   /*  Field text description                             */
   int  WHRCDE;       /*  32=Data Type,64=Name, 128=None                     */
   char WHRFIL[10];   /*  Reference file                                     */
   char WHRLIB[10];   /*  Reference library                                  */
   char WHRFMT[10];   /*  Reference record format                            */
   char WHRFLD[10];   /*  Reference field                                    */
   char WHCHD1[20];   /*  Column heading 1                                   */
   char WHCHD2[20];   /*  Column heading 2                                   */
   char WHCHD3[20];   /*  Column heading 3                                   */
   char WHFLDT;       /*  Field type: B, A, S, P, F, O, J, E, H, L, T, Z, G  */
   char WHFIOB;       /*  I/O attribute: I=Input,O=Output,B=Both,N=Neither   */
   char WHECDE[2];    /*  Edit code                                          */
   char WHEWRD[32];   /*  Edit word: Truncated after 30 characters           */
   int  WHVCNE;       /*  Number of validity checks                          */
   int  WHNFLD;       /*  Number of fields                                   */
   int  WHNIND;       /*  Number of indicators                               */
   char WHSHFT;       /*  Keyboard shift                                     */
   char WHALTY;       /*  Character field may be DBSC activated: N=No, Y=Yes */
   char WHALIS[30];   /*  Alternative field name                             */
   int  WHJREF;       /*  Join reference to JFILE                            */
   int  WHDFTL;       /*  DFT value length: -1=Greater than 30 characters    */
   char WHDFT[30];    /*  DFT value: Truncated after 30 characters           */
   char WHCHRI;       /*  Character Id changes allowed: N=No, Y=Yes          */
   char WHCTNT;       /*  Translation table used:  N=No, Y=Yes               */
   char WHFONT[10];   /*  Font identifier                                    */
   int  WHCSWD;       /*  Character size width                               */
   int  WHCSHI;       /*  Character size height                              */
   char WHBCNM[10];   /*  Barcode name                                       */
   int  WHBCHI;       /*  Barcode height:  000=No height specified           */
   char WHMAP;        /*  Substring specified: N=No, Y=Yes                   */
   int  WHMAPS;       /*  Substring starting position                        */
   int  WHMAPL;       /*  Substring number of bytes (characters, if graphic) */
   char WHSYSN[8];    /*  System Name (Source System, if file is DDM)        */
   char WHRES1[2];    /*  Reserved                                           */
   char WHSQLT;       /*  SQL file type: 0=None, T=TABLE, I=INDEX, V=VIEW    */
   char WHHEX;        /*  Hexadecimal:  Y=Yes                                */
   int  WHPNTS;       /*  Point size: 0 = none                               */
   int  WHCSID;       /*  Coded Character set Identifier                     */
   char WHFMT[4];     /*  Date and time format parameters                    */
   char WHSEP;        /*  '/', '-', '.', ',', ':', or ' '                    */
   char WHVARL;       /*  Variable length field: N=No, Y=Yes                 */
   int  WHALLC;       /*  Allocated length                                   */
   char WHNULL;       /*  Allow Null Value: N=No,Y=Yes                       */
   char WHFCSN[10];   /*  Font character set, blank = none                   */
   char WHFCSL[10];   /*  Char set lib, blank = none                         */
   char WHFCPN[10];   /*  Font code page, blank = none                       */
   char WHFCPL[10];   /*  Code page lib, blank = none                        */
   char WHCDFN[10];   /*  Coded Font, blank = none                           */
   char WHCDFL[10];   /*  Coded font lib, blank = none                       */
   char WHDCDF[10];   /*  DBCS Coded Font, blank = none                      */
   char WHDCDL[10];   /*  DBCS font lib, blank = none                        */
   int  WHTXRT;       /*  Degree of text rotation, -1 = not specified        */
   int  WHFLDG;       /*  Field length in characters, 0 = not graphic        */
   int  WHFDSL;       /*  Displayed field length                             */
} ffd_t;

int open_ffd(char *);
ffd_t * get_ffd();
void close_ffd();

#ifndef SQLDASIZE
struct sqlda {
    unsigned char sqldaid[8]; /*  Identity of structure                      */
    long          sqldabc;    /*  size of this sqlda structure               */
    short         sqln;       /*  Number of sqlvar entries                   */
    short         sqld;       /*  Number of columns or host variables        */
    struct        sqlvar {
        short          sqltype; /*  SQL data type                            */
        short          sqllen;  /*  field length                             */
        unsigned char* sqldata; /*  pointer to data buffer                   */
        short*         sqlind;  /*  pointer to null indicator                */
        struct sqlname {
            short         length;
            unsigned char data[30];
        } sqlname; /*  Name of column                                        */
    } sqlvar[1];  /*  One structure per column                               */
};
#define SQLDASIZE(n) \
   ( sizeof(struct sqlda) + ((n)-1) * sizeof(struct sqlvar) )
#endif
typedef struct sqlda sqlda;

sqlda* get_sqlda(char *);
#endif

