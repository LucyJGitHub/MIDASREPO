/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Performance Analysis Member Merge')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1590 - Performance Analysis Member Merge                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 06DEC94              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01496 - Portfolio Management Module                        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - WRITTEN FOR PORTFOLIO PERFORMANCE                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*    FOR ACCESSING DATA AREAS                               */
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
 
/*  RESET JOB SWITCHES  */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1590 - Performance Analysis Member +
                          Merge') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             IF         COND(%SST(&MMOD 2 1) *EQ 'Y') THEN(DO)
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(DL1) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(DL1) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(DL5) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(DL5) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(DL1)                    */ /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(DL5)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(DL1)                       /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(DL5)                       /*S01486*/
             ENDDO
 
             IF         COND(%SST(&MMOD 10 1) *EQ 'Y') THEN(DO)
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(LE1) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(LE1) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(LE5) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(LE5) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(LE1)                    */ /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(LE5)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(LE1)                       /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(LE5)                       /*S01486*/
             ENDDO
 
             IF         COND(%SST(&MMOD 21 1) *EQ 'Y') THEN(DO)
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(SE1) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(SE1) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(SE5) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(SE5) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(SE1)                    */ /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(SE5)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(SE1)                       /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(SE5)                       /*S01486*/
             ENDDO
 
             IF         COND(%SST(&MMOD 50 1) *EQ 'Y') THEN(DO)
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(FF1) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
             CPYF       FROMFILE(PMPTRAPD) TOFILE(PMPTRAPD) +
                          FROMMBR(FF1) TOMBR(PMPTRAPD) MBROPT(*ADD)   /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(FF1)                    */ /*S01486*/
             CLRPFM     FILE(PMPTRAPD) MBR(FF1)                       /*S01486*/
             ENDDO
 
/*********** IF         COND(%SST(&MMOD 81 1) *EQ 'Y') THEN(DO)       /*S01486*/
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(FI1) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
/*********** MONMSG     MSGID(CPF2817)                                /*S01486*/
/**/
/*********** CPYF       FROMFILE(PMPTRAPP) TOFILE(PMPTRAPP) +
                          FROMMBR(FI5) TOMBR(PMPTRAPP) MBROPT(*ADD)*/ /*S01486*/
/*********** MONMSG     MSGID(CPF2817)                                /*S01486*/
/**/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(FI1)                    */ /*S01486*/
/*********** CLRPFM     FILE(PMPTRAPP) MBR(FI5)                    */ /*S01486*/
/*********** ENDDO                                                    /*S01486*/
 
/*********** CPYF       FROMFILE(PMPCAAPP) TOFILE(PMPCAAPP) +
                          FROMMBR(NEW1) TOMBR(PMPCAAPP) MBROPT(*AD */ /*S01486*/
             CPYF       FROMFILE(PMPCAAPD) TOFILE(PMPCAAPD) +
                          FROMMBR(NEW1) TOMBR(PMPCAAPD) MBROPT(*ADD)  /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CPYF       FROMFILE(PMPCAAPP) TOFILE(PMPCAAPP) +
                          FROMMBR(NEW5) TOMBR(PMPCAAPP) MBROPT(*AD */ /*S01486*/
             CPYF       FROMFILE(PMPCAAPD) TOFILE(PMPCAAPD) +
                          FROMMBR(NEW5) TOMBR(PMPCAAPD) MBROPT(*ADD)  /*S01486*/
             MONMSG     MSGID(CPF2817)
/**/
/*********** CLRPFM     FILE(PMPCAAPP) MBR(NEW1)                   */ /*S01486*/
/*********** CLRPFM     FILE(PMPCAAPP) MBR(NEW5)                   */ /*S01486*/
             CLRPFM     FILE(PMPCAAPD) MBR(NEW1)                      /*S01486*/
             CLRPFM     FILE(PMPCAAPD) MBR(NEW5)                      /*S01486*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
