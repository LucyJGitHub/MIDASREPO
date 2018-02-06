/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG SD Interface for Branch codes')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0022  - SD interface for branch codes.                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 21Nov94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &ACTN &BRANCH)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3) /* Branch */
             DCL        VAR(&CPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&YORN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INTBATCH) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(57)                                  /*CGL029*/
             DCL        VAR(&P2PARM) TYPE(*CHAR) LEN(69)                                  /*CGL029*/
             DCL        VAR(&RETURN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARFMT) TYPE(*CHAR) LEN(200)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTCD) VALUE(' ')
 
/* If action code is NOT a deletion check for S01531 being switched on  */
 
             IF         COND(&ACTN *NE 'D') THEN(DO)
             CHGVAR     VAR(&RETURN) VALUE('       ')
             CHGVAR     VAR(&OPTION) VALUE('*VERIFY')
             CHGVAR     VAR(&SARNBR) VALUE('S01531')
 
             CALL       PGM(AOSARDR0) PARM(&RETURN &OPTION &SARNBR &SARFMT)
             IF         COND(&RETURN *NE '       ') THEN(DO)
                GOTO ENDCLPGM
             ENDDO
             ENDDO
 
/* */
/* Retrieve TYPE to determin if the job is being run interactively(1)*/
/* or in batch.                                                      */
/* */
             RTVJOBA    TYPE(&INTBATCH)
             IF         COND(&INTBATCH *EQ '1') THEN(DO)
             CHGVAR     VAR(&CPGM) VALUE('SD0061R')
             ENDDO
             ELSE       (DO)
             CHGVAR     VAR(&CPGM) VALUE('CGC0022')
             ENDDO
 
             IF         COND(&ACTN *EQ 'D') THEN(DO)
             CALL       PGM(CG0100) PARM(&RTCD &BRANCH &CPGM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
 
             IF         COND(&ACTN *NE 'D') THEN(DO)
             CALL       PGM(CG0025) PARM(&RTCD &YORN)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
             IF         COND(&RTCD *EQ 'Y2U9999' *OR &RTCD *EQ +
                          USR0790) THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
             IF         COND(&RTCD *NE ' ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
 
             IF         COND(&YORN *EQ 'Y') THEN(DO)
             IF         COND(&ACTN *EQ 'I' *OR &ACTN *EQ 'A') THEN(DO)
             CHGVAR     VAR(&ACTN) VALUE('a')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&ACTN) VALUE('e')
             ENDDO
 
/* */
/* Substring the branch  into the correct position of the  */
/* &P2PARM parameter.                                      */
/* */
             CHGVAR     VAR(%SST(&P2PARM 17 3))  VALUE(&BRANCH)
/**********  CHGVAR     VAR(%SST(&P2PARM 50 6))  VALUE('BRANCH')                          /*CGL029*/
             CHGVAR     VAR(%SST(&P2PARM 62 6))  VALUE('BRANCH')                          /*CGL029*/
 
             CALL       PGM(CG0020) PARM(&RTCD &ACTN &P2PARM)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
             ENDDO
 
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0022 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0022 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
 
             ENDPGM
