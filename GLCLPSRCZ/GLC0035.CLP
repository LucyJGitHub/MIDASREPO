/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Chart of Accounts Report')                   */
/*********************************************************************/
/*                                                                   */
/*      Midas GENERAL LEDGER MODULE                          */
/*                                                                   */
/*      GLC0035 - Call to Chart of Accounts Report                   */
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
/*       LAST AMEND NO. S01340        DATE  03OCT91                  */
/*                                                                   */
/*********************************************************************/
/*       S01340 - Changes for MIS 10.1 - different versions of       */
/*                Chart of Accounts                                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
/************PGM********PARM(&RSEQ &RLEV &RENT)                    */ /*S01340*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01340*/
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01340*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Call Report Programs */
/**/
             IF         COND(%SST(&RPARM 1 1) *EQ 'Y') THEN(DO)       /*S01340*/
             CALL       PGM(GL0035) PARM(&RSEQ)
                  ENDDO                                               /*S01340*/
                                                                      /*S01340*/
             IF         COND(%SST(&RPARM 2 1) *EQ 'Y') THEN(DO)       /*S01340*/
                  CALL       PGM(GL0036) PARM(&RSEQ)                  /*S01340*/
                  ENDDO                                               /*S01340*/
                                                                      /*S01340*/
             IF         COND(%SST(&RPARM 3 1) *EQ 'Y') THEN(DO)       /*S01340*/
                  CALL       PGM(GL0037) PARM(&RSEQ)                  /*S01340*/
                  ENDDO                                               /*S01340*/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             GOTO       CMDLBL(END)
/**/
/* Database Error Messages will be sent by RCF */
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('Chart of Accounts Report Request ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
