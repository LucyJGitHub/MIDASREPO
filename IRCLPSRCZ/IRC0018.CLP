/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       IRC0018 - Voce/Sottovoce Codes Maintenance                  */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 11FEB97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/

             PGM        /* No parameters */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set Job switches and LDA :                                   */

             CHGJOB     SWS(XXXXXX00)

             CALL       PGM(IR0018) PARM(' ')


/* Check Job switches for DB/Pgm. error :                      */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                 SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.+
                            Press ENTER to Continue.') TOPGMQ(*EXT)
             ENDDO

 /* No errors - exit program normally :                         */

             GOTO       CMDLBL(PGMEND)

 /* Database or Program error - inform User and calling pgm.:   */

 ABNOR:      SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.    +
                        Press ENTER to Continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)


/* Program end (Normal or Abnormal) :                           */

 PGMEND:

/* Reclaim resources :                                          */

             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)

