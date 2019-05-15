/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Nostro Account Activity Report Request')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standing Data Module                              */
/*                                                                   */
/*       SDC000152 - NOSTRO ACCOUNT ACTIVITY REPORT REQUEST          */
/*                                                                   */
/*       (c) Finastra International Limited (2017)                   */
/*                                                                   */
/*       Last Amend No. MD048898           Date 11Dec17              */
/*       Prev Amend No. MD038440  *Create  Date 27Oct17              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD048898 - Nostro can be deleted when attached only to CCY  */                             
/*                  Fix postions for the parameter.                  */
/*       MD038440  - Nostro code deletion issue. Generate report     */
/*                   to display transactions of a Nostro accnt.      */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&A7BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&A7CUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&A7CYCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&A7ACCD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&##ACSN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&A7NONB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited (2017)')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXX000)

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
/**/
             CHGVAR     VAR(&PMODE) VALUE(%SST(&RPARM 1 1))
             CHGVAR     VAR(&A7BRCD) VALUE(%SST(&RPARM 2 3))
             CHGVAR     VAR(&A7CUST) VALUE(%SST(&RPARM 5 6))
             CHGVAR     VAR(&A7CYCD) VALUE(%SST(&RPARM 11 3))
             CHGVAR     VAR(&A7ACCD) VALUE(%SST(&RPARM 14 10))
             CHGVAR     VAR(&##ACSN) VALUE(%SST(&RPARM 24 2))
/**********  CHGVAR     VAR(&A7NONB) VALUE(%SST(&RPARM 27 2))        */                 /*MD048898*/
/**********  CHGVAR     VAR(&RETURN) VALUE(%SST(&RPARM 29 1))        */                 /*MD048898*/
             CHGVAR     VAR(&A7NONB) VALUE(%SST(&RPARM 26 2))                           /*MD048898*/
             CHGVAR     VAR(&RETURN) VALUE(%SST(&RPARM 28 1))                           /*MD048898*/
/**/

             CALL       PGM(SD000152DL) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             CALL       PGM(SD000152FT) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             CALL       PGM(SD000152GL) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             CALL       PGM(SD000152LE) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             CALL       PGM(SD000152SE) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             CALL       PGM(SD000152OM) PARM(&PMODE &A7BRCD &A7CUST +
                          &A7CYCD &A7ACCD &##ACSN &A7NONB &RETURN &RSEQ)
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
 ABNOR:      SNDPGMMSG  MSG('Nostro Account Activity Report Request +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        DLTOVR     FILE(*ALL) LVL(*JOB)
             ENDPGM

