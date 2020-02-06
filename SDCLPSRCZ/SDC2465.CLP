/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas BRT Control Data List')                         */
/********************************************************************/
/*                                                                  */
/*    Midas Standing Data Module                            */
/*                                                                  */
/*     SDC2465 - BRT DATA CONTROL LIST                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     PREV AMEND NO.  S01383           DATE 27APR92                */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*    MD046248 - Finastra Rebranding                                */
/*    S01383  -  BASIC RATE TAX INCORPORATION                       */
/*               NEW PROGRAM                                        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RUNTYP &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +
                        VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +
                        VALUE('S01383')
 
/* Set switches                                                     */
 
      CHGJOB  SWS(00000000)
 
/**/
/* DETERMINE IF BRT SAR INSTALLED */
/**/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/**/
/* BRT SAR NOT INSTALLED */
/**/
             IF         COND(&SRTCD *NE '       ') THEN(DO)
                GOTO ENDPGM
             ENDDO
 
             IF COND(&RUNTYP *EQ 'R') THEN(DO)    /*REPORT*/
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
             CALL       PGM(SD2465) PARM('R' &RSEQ)
 
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SDC2465 - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MOPERQ)
                GOTO ENDPGM
             ENDDO
             ENDDO
 
             IF COND(&RUNTYP *NE 'R') THEN(DO)    /*COB AUDIT*/
/**/
/* SEND PGM MESSAGE */
/**/
             CHGVAR     VAR(&MEM) VALUE('SDC2465 - BRT Control Data +
                          Audit List')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
/**/
/* CLEAR SWITCHES */
/**/
             CHGJOB     SWS(00000000)
/**/
             CALL       PGM(SD2465) PARM(' ' &RSEQ)
 
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SDC2465 - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
