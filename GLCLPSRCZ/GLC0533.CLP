/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Future Value Dated Journal Entry')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0533 - GL Future Value Dated Journal Entry               */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD045372 *CREATE   Date 23May17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD045372 - CGL010 process is not task split.                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAME &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2017')
/* Additional variables */
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GLC0533 - GL Future Value Dated Journal Entry') +
                        TOMSGQ(MRUNQ)
 
 
/* Read COB components file to check the restart status */
 
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)
 
/* Check if any problems with COB components file */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Set restart status to 'Y' */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
 
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
 
             CALL       PGM(GL0533)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO ABNOR
             ENDDO
 
             OVRDBF     FILE(GLBATHPA) TOFILE(MANPOZZ)
             CALL       PGM(GL0534)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO ABNOR
             ENDDO
 
             CALL       PGM(SCC000060) PARM('GLVALPPD' '*FIRST')
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
 
/* Commit changes */
             COMMIT
             GOTO END
 
 
 ABNOR:      SNDPGMMSG  MSG('Program GLC0533 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
 
 
  END:       IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
