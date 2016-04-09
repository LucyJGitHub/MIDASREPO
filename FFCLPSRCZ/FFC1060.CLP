/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Monthly P/L Report (EOC)')                   */
/*********************************************************************/
/*                                                                   */
/*     Midas - Futures and Options Module.                   */
/*                                                                   */
/*     FFC1060 - MONTHLY P/L REPORT (EOC)                            */
/*                                                                   */
/*     Function:  This program will report the monthly P/L           */
/*                  for those market centres whose EOC is not        */
/*                  run during COB.                                  */
/*                                                                   */
/*     ***** CREATED FOR S01456.*****                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 089302             DATE 19OCT95              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   089302 - FF1250 should run even if EOMCHK is not 'Y'.           */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/******      DCL        VAR(&RSEQ) TYPE(*CHAR)  LEN(5)                  *******/
/******      DCL        VAR(&RENT) TYPE(*CHAR)  LEN(3)                  *******/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(MKCTLD)
 
/**/
             MONMSG (CPF0000 RPG0000 MCH0000)
/**/
             CHGJOB     SWS(00000000)
/**                                                                           */
/**  Read the market control file to see if the EOC is valid,if there         */
/**  is a match and the end of month indicator is 'Y', then the               */
/**  program continues to produce the report.                                 */
/*                                                                            */
 TAG1:      RCVF
            MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/***********IF COND((&MKT *EQ &MRKT) *AND (&EOMCHK *EQ 'Y')) THEN(DO)  *089302*/
            IF COND((&MKT *EQ &MRKT)) THEN(DO)                        /*089302*/
/*                                                                            */
/**/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(POSTNK) MBR(&MKT)
/**/
/*   CLEAR P/L EXTRACT FILE AND CALL FF1241 TO EXTRACT P/L DETAILS */
/**/
             CLRPFM     BOKPL
/**/
/*   CALL FF1241 TO PRODUCE MONTHLY P/L REPORT EXTRACT            */
/**/
             CALL       PGM(FF1241)
/**/
/*   CALL FF1250 TO PRODUCE MONTHLY P/L REPORT                     */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(FF1250) PARM('     ' 'ALL')
             ENDDO
             DLTOVR     FILE(POSTNK)
/**/
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1060')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             ENDDO
/*                                                                          */
             ENDDO
             GOTO    CMDLBL(TAG1)
/*                                                                          */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
