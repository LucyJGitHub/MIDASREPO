/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Telex inQ/outQ purge')                       */
/********************************************************************/
/*                                                                   */
/*     Midas - Midas Telex.                                      */
/*                                                                   */
/*     MTC5010 - Telex InQ/OutQ Purge.                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 081507  *CREATE    Date 20Jan95              */
/*                      XXXXXX             Date XXAaaXX              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     081507 - ORION UPGRADE.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USERID &NETADR &DTEFMT &INOUT)
 
             DCL        VAR(&INOUT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DTEFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NETADR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PURGO) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PURGI) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(*LIBL/MTC5010DF)
 
/* OUTQUEUE PURGE */
             IF         COND(&INOUT *EQ 'OUT') THEN(DO)
               SNDRCVF    RCDFMT(TR9001)
               CHGVAR     VAR(&PURGO) VALUE(&LONCMP *CAT &LONSNT *CAT +
                            &LONARC *CAT  &LONPRT)
               CALL       PGM(TR9001) PARM(&USERID &NETADR &DTEFMT +
                            &PURGO)
             ENDDO
 
/* INQUEUE PURGE */
             IF         COND(&INOUT *EQ 'IN ') THEN(DO)
               SNDRCVF    RCDFMT(TR9002)
               CHGVAR     VAR(&PURGI) VALUE(&LIRPY *CAT &LIACKN *CAT +
                            &LINPRT *CAT  &LINARC *CAT &LINRVW)
               CALL       PGM(TR9002) PARM(&USERID &NETADR &DTEFMT +
                            &PURGI)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
