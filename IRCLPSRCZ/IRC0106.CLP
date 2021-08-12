/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas ABS - European Reporting - Italy                      */
/*                                                                   */
/*       IRC0106 - Next Month Postings Extract                       */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti Internalitonal 1997.             */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 10FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - Bank of Italy Monthly Reporting                    */
/*                                                                   */
/*********************************************************************/

/***  Start Program.  ***/
             PGM        PARM(&CNAM &CSEQ)

/***  Declare variable.  ***/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&REMI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT ACT INTERNATIONAL LTD. 1995')
             DCLF       FILE(SDMMODPD)
             RCVF

/***  Global monitor message.  ***/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ERROR))

/***  Execute this processing only if BOI Monthly Reporting is switch on  ***/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ENDPGM))

/***  Reset U7 and U8 and send execution message.  ***/
             CHGJOB     SWS(XXXXXX00)

             SNDPGMMSG  MSG('IRC0106 - Next Month Postings Extract') +
                          TOMSGQ(MRUNQ)

/***  Call CB0150 to indicated that RPG will run.  ***/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/***  Retrieve data area IRSTAT  ***/
             RTVDTAARA  DTAARA(IRSTAT (2 1)) RTNVAR(&REMI)

/***  If the End of Month Indicator from IRSTAT is 'X' or 'M'  ***/
             IF         COND((&REMI = 'X') *OR (&REMI = 'M')) THEN(DO)

/***  Clear the next month's postings file  ***/
             CLRPFM     FILE(IRNMPSPD)

/***  Call RPG program.  ***/
             CALL       PGM(IR0106)
             ENDDO

/***  U7 on and U8 off : program or file error.  ***/
             IF         COND(%SWITCH(XXXXXX10)) THEN(SNDPGMMSG +
                          MSG('IR0106 - JOB TERMINATED - PROGRAM +
                          ERROR') TOMSGQ(MRUNQ MOPERQ))

/***  U7 and U8 on : database error.  ***/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&LDA) +
                             TOMSGQ(MRUNQ MOPERQ)
                SNDPGMMSG  MSG('IR0106 - JOB TERMINATED - DATABASE +
                             ERROR') TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO

/***  Call CB0150 to indicate normal end of program.  ***/
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

             GOTO       CMDLBL(ENDPGM)

 ERROR:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('IRC0106 - JOB TERMINATED - PROGRAM +
                          ERROR') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

 ENDPGM:     CHGVAR     VAR(&ACTCPY) VALUE('Copyright Midas-Kapiti')
             RCLRSC
             ENDPGM
