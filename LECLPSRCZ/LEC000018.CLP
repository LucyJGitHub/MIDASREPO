/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Initialisation program for CAS009(AYACAI)')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC000018 - Lending Initialisation program for CAS009       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS011             Date 04May04              */
/*                      231566  *CREATE    Date 12Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CAS011 - EIR/AC Accounting Upgrade to MP1. Apply 231566.    */
/*       231566 - Initialise Amortised Cost Accounting Indicator for */
/*                Loan Types/Sub-types file (SDLOANPD)               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &PMODE)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
             IF         COND((&PMODE *EQ '1') *OR (&PMODE *EQ '2')) +
                          THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF8351)
 
/** Call LE000018 */
 
                CALL       PGM(LE000018)
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/** Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC000018 ended abnormally - see joblog +
                          ') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End program */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
