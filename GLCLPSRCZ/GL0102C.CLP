/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Reports (history)')                          */
/********************************************************************/
/*                                                                  */
/*       Midas     GENERAL LEDGER MODULE                            */
/*                                                                  */
/*       GL0102C - GL REPORTS (HISTORY)                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XXXXXX             Date 00Xxx00              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*    XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXX                           */
/*                                                                  */
/********************************************************************/
/*                                                                   */
             PGM  PARM(&PGM &SEQ &LEVEL &ENTITY &PARMS)
/*                                                                   */
             DCL  VAR(&PGM)    TYPE(*CHAR)  LEN(8)
             DCL  VAR(&SEQ)    TYPE(*CHAR)  LEN(5)
             DCL  VAR(&LEVEL)  TYPE(*CHAR)  LEN(1)
             DCL  VAR(&ENTITY) TYPE(*CHAR)  LEN(3)
             DCL  VAR(&PARMS)  TYPE(*CHAR)  LEN(100)
             DCL  VAR(&RTNCD)  TYPE(*CHAR)  LEN(7)
             DCL  VAR(&MSG)    TYPE(*CHAR)  LEN(75)
             DCL  VAR(&SWS)    TYPE(*CHAR)  LEN(8)
             DCL  VAR(&BEDT)   TYPE(*DEC)   LEN(5)
             DCL  VAR(&BTNB)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                  */
/* Create LDA if it doesn't already exist                           */
/*                                                                  */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/*                                                                  */
/* Set up parameters for report                                     */
/*                                                                  */
             CHGVAR     VAR(&BEDT) VALUE(%SST(&PARMS 1 5))
             CHGVAR     VAR(&BTNB) VALUE(%SST(&PARMS 6 3))
/*                                                                  */
/* Call report program                                              */
/*                                                                  */
             CALL PGM(&PGM) PARM(&RTNCD &BEDT &BTNB &SEQ &LEVEL +
                 &ENTITY)
             MONMSG  MSGID(CPF0001)  EXEC(DO)
                CHGVAR VAR(&MSG) VALUE('Error on call to program' +
                    *BCAT &PGM)
                SNDPGMMSG  TOMSGQ(MRUNQ MOPERQ)  MSG(&MSG)
             ENDDO
/*                                                                  */
/* Database error processing                                        */
/*                                                                  */
             RTVJOBA  SWS(&SWS)
             IF  (%SST(&SWS 7 2) *EQ '11') THEN(DO)
                CHGVAR &MSG VALUE(' JOB TERMINATED - DATABASE +
                    IN ERROR')
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)
             ENDDO
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*                                                                   */
             ENDPGM
