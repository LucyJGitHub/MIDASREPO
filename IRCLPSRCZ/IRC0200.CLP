/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting - Italy                          */
/*                                                                   */
/*       IRC0200 - Customer Details Extract                          */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 24feb97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI monthly Reporting                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

/***  Declare variable.  ***/

             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')

/***  Global monitor message  ***/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/***  Execute this processing only if BOI Monthly Reporting is switch on  ***/

             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ENDPGM))

             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)

/***  Send execution message.  ***/

             SNDPGMMSG  MSG('IRC0200 - Customer Details Extract') +
                          TOMSGQ(MRUNQ)

/***  Call CB00150 to indicate that rpg will run.  ***/

             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

/***  Clear file. The file is to be filled for each end-of-month situation */

             CLRPFM     FILE(IREXCLPD)

/***  Call RPG program IR0200.  ***/

             CALL       PGM(IR0200)

/*** Programm error Handling.  ***/

             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   SNDPGMMSG  MSG('IR0200 - IR customers extract +
                              abnormally terminated - Program error') +
                        TOMSGQ(MRUNQ MOPERQ)
                   GOTO       CMDLBL(ENDPGM)
             ENDDO

/***  Database error handling.  ***/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   SNDPGMMSG  MSG('IR0200 - IR Customers extract +
                              abnormally terminated - Data base error') +
                              TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ENDPGM)
             ENDDO

/***  Call CB0150 to indicate normall end of program.  ***/

             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

             GOTO       CMDLBL(ENDPGM)

 ABNOR:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('IRC0200 - IR Customer extract  +
                          abnormally terminated - Program error - +
                          See joblog for details.')              +
                          TOMSGQ(MRUNQ  MOPERQ)
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(XXXXXX11)

 ENDPGM:     CHGVAR     VAR(&CPYFLD) +
                     VALUE('Copyright Midas-Kapiti International Ltd.')

             ENDPGM
