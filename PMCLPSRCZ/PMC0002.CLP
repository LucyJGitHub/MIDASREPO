/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Pool Portfolio File Setup')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0002 - Pool Portfolio Files Setup                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486  *CREATE    DATE 24NOV94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01486 - Portfolio Management Enhancements (New program)    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/**/
/*********** PGM                                                        S01486*/
             PGM        PARM(&RTNCDE &IPMODE)                         /*S01496*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*S01486*/
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)               /*S01486*/
/**/
/** Global monitor message error trap */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
/**/
/**  Create LDA if not present */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                            AUT(*EXCLUDE)
             ENDDO
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Call program */
/**/
             CALL       PGM(PM0002) PARM(&RTCD)
/**/
/**  If database error, output message to user */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSG('PMC0002 - JOB TERMINATED, DATABASE IN +
                              ERROR') TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  Check value of return code and send appropriate message */
/**/
             IF         COND(&RTCD *EQ ' ') THEN(DO)
                SNDPGMMSG  MSG('Pool Portfolio files set up +
                              successfully.') TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             IF         COND(&RTCD *EQ '1') THEN(DO)
                SNDPGMMSG  MSG('Portfolio Management is not present, +
                              Pool Portfolio files are not set up.') +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             IF         COND(&RTCD *EQ '2') THEN(DO)
                SNDPGMMSG  MSG('Pool Portfolio is not installed, +
                              files are not set up.') +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             IF         COND(&RTCD *EQ '3') THEN(DO)
                SNDPGMMSG  MSG('Pool Portfolio files already exist.') +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
ABNOR:       SNDPGMMSG  MSG('Program PMC0002 ended ABNORMALLY.') +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
