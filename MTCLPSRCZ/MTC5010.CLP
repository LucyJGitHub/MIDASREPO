/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Telex inQ/outQ purge')                       */
/********************************************************************/
/*                                                                   */
/*     Midas - Midas Telex.                                      */
/*                                                                   */
/*     MTC5010 - Telex InQ/OutQ Purge.                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO 081507  *CREATE   DATE 20JAN95                  */
/*     PREV AMEND NO XXXXXX            DATE XXAAAXX                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
                          Misys International Banking Systems Ltd. +
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
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
