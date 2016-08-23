/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Initialisation Program for CAS009(FEE)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC000016 - Initialization Program for CAS009               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CAS009  *CREATE    Date 04May04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &PMODE)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
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
 
/** Call LE000016 */
 
                CALL       PGM(LE000016)
 
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
                          LEC000016 ended abnormally - see joblog +
                          ') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End program */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
