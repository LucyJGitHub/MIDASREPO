/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting - Italy                          */
/*                                                                   */
/*       IRC0400 - IRSTAT Data area Setup                            */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 03fev97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/
             PGM

/***  Declare varaible used.  ***/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1996')

             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))

/***  Check feature presence to run.  ***/

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE '       ') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

/***  Send execution message.  ***/

             SNDMSG     MSG('IRC0400 - Italian Returns data area +
                          setup') TOMSGQ(MRUNQ)

/***  Call RPG program.  ***/

             CALL       PGM(IR0400)

/***  U7 on and U8 off : program or file error.  ***/

             IF         COND(%SWITCH(XXXXXX10)) THEN(SNDPGMMSG +
                          MSG('IR0400 - Job terminated abnormally +
                          (pgm error)') TOMSGQ(MRUNQ MOPERQ))

/***  U7 and U8 on : database error.  ***/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOMSGQ(MRUNQ MOPERQ)
             SNDPGMMSG  MSG('IR0400 - Job terminated abnormally +
                          (data base error)') TOMSGQ(MRUNQ MOPERQ)
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('IRC0400 - Job abnormally terminated - +
                          Execution error') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

 END:        CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')
             MONMSG     MSGID(CPF0000)

             ENDPGM
