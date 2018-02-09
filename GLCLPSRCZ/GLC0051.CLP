/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Keys Reports')                       */
/*********************************************************************/
/*                                                                   */
/*      Midas GENERAL LEDGER MODULE                          */
/*                                                                   */
/*      GLC0051 - Call to Account Keys Reports                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. XXXXXX        DATE  XXXXXXX                  */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
                          Finastra International Limited')
/**/
             CHGVAR     VAR(&PARAM) VALUE(&RPARM)
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Call Report Programs */
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ 'Y') THEN(DO)
             CALL       PGM(GL0051) PARM(&RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
             ENDDO
/**/
             IF         COND(%SST(&PARAM 2 1) *EQ 'Y') THEN(DO)
             CALL       PGM(GL0052) PARM(&RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
             ENDDO
/**/
             IF         COND(%SST(&PARAM 3 1) *EQ 'Y') THEN(DO)
             CALL       PGM(GL0053) PARM(&RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
             ENDDO
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
 ABNOR:      SNDPGMMSG  MSG('Account Keys Report Request ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
