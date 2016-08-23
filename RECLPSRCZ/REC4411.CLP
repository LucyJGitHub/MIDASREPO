/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Comms Program Error Report Control')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail  Module                                      */
/*                                                                   */
/*       REC4411 - CI Comms Program Error Report Control             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 118134             Date 02Jun97              */
/*       Prev Amend No. CRT003  *CREATE    Date 22JUL96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       118134 - Correct ABNOR processing to ensure termination.    */
/*       CRT003 - Branch Automation Interface.                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &JOBNUM &MMCODE &BRCA &MSGID &MSGDTA)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PROG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MMCODE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSG)    TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&ZZCIF) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ZZMIDAS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*USE)
             MONMSG     MSGID(CPF1023)
 
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL +
                          &TIMEO &ERRORC &MULT)
             IF         COND(&MULT *EQ '  ') THEN(DO)
                  CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
             CHGVAR     VAR(&ZZCIF) VALUE(&MULT *CAT 'CIMSGF')
             OVRMSGF    MSGF(CIMSGF)  TOMSGF(&ZZCIF)
             CHGVAR     VAR(&ZZMIDAS) VALUE(&MULT *CAT 'MIDAS')
             OVRMSGF    MSGF(MIDAS) TOMSGF(&ZZMIDAS)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(RE4411) PARM(&PROG &JOBNUM &MMCODE &BRCA +
                          &MSGID &MSGDTA)
                          GOTO CMDLBL(END)
             ENDDO
 
 ABNOR:
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000)                                /*118134*/
 
             CHGVAR     VAR(&MSG) VALUE(%SST(&LDA 134 51))
             MONMSG     MSGID(CPF0000)                                /*118134*/
 
             SNDPGMMSG  MSG('CI Comms Program Errors Report Ended +
                          Abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF2469)  EXEC(DO)                      /*118134*/
                SNDPGMMSG  MSG('CI Comms Program Errors Report Ended +
                             Abnormally') TOMSGQ(QSYSOPR)             /*118134*/
             ENDDO                                                    /*118134*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
