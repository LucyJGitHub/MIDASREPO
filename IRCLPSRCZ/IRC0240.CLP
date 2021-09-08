/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting - Italy                          */
/*                                                                   */
/*       IRC0240 - IR Daily Posting Conversion                       */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 04jan97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

/***  Declaration of Variables used.  ***/

             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')

/***  Global monitor message.  ***/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/***  Check feature is present, else end component.  ***/

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

/***  Send Execution message.  ***/

             SNDPGMMSG  MSG('IRC0240 - Daily Posting Conversion +
                          started') TOMSGQ(MRUNQ)

/***  Determine System libraries.  ***/

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')

/***  Check component status. Is it a restart or first run?  ***/

             CHGVAR     VAR(&STAT) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

/***  If it is a restarted component, used security copy,  ***/

             IF         COND(&STAT *EQ 'Y') THEN(DO)

             CPYF       FROMFILE(XERITDTPD) TOFILE(ERITDTPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERITDTPD))

             ENDDO

/***  else take a security copy in case of trouble.  ***/

             ELSE       CMD(DO)

             CPYF       FROMFILE(ERITDTPD) TOFILE(&DPLIB/XERITDTPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERITDTPD))
             ENDDO

/***  Call CB0150 to indicated that RPG will run.  ***/

             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/***  Call RPG program IR0240.  ***/

             CALL       PGM(IR0240)

/***  Program error handling.  ***/

             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   SNDPGMMSG  MSG('IR0240 - Daily Posting Conversion +
                          abnormally terminated - Program Error.') +
                          TOMSGQ(MRUNQ MOPERQ)
                   GOTO       CMDLBL(END)
             ENDDO

/***  Database error handling.  ***/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOMSGQ(MRUNQ MOPERQ)
                  SNDPGMMSG  MSG('IR0240 - Daily Posting Conversion +
                          abnormally terminated - Data base +
                          Error.') TOMSGQ(MRUNQ MOPERQ)
                  GOTO       CMDLBL(END)
             ENDDO

/***  Call CB0150 to indicate normal end of program.  ***/

             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(XERITDTPD)

             GOTO       CMDLBL(END)

 ABNOR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('IRC0240 - Daily Posting Conversion +
                          abnormally terminated - Program Error - +
                          See joblog for details.') TOMSGQ(MRUNQ +
                          MOPERQ)
               MONMSG     MSGID(CPF0000)

 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')


             ENDPGM
