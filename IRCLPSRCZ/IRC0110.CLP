/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas ABS - BOI Returns                                     */
/*                                                                   */
/*       IRC0110 - UIC Control Posting Extract Report                */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 13FEB97              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/

/***  Start Program.  ***/

             PGM      PARM(&RTYP &RRN &RSEQ &RLEV &RENT)

/***  Declare variable.  ***/

             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)

/***  Monitor for Error Messages from System.  ***/

             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ABNOR))

/***  Reset Error values - switches and LDA.  ***/

             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)

/***  Override to specific logicals files depending on which report    */
/***  is required - Daily, current month's or previous month's         */

             IF         COND(&RTYP *EQ 'M') THEN(DO)
             OVRDBF     FILE(IRDPSTL0) TOFILE(IRMPSTL0)
             OVRDBF     FILE(IRDPSTL1) TOFILE(IRMPSTL1)
             ENDDO

             IF         COND(&RTYP *EQ 'P') THEN(DO)
             OVRDBF     FILE(IRDPSTL0) TOFILE(IRPMPCL0)
             OVRDBF     FILE(IRDPSTL1) TOFILE(IRPMPCL1)
             ENDDO

             CALL       PGM(IR0110) PARM(&RTYP &RRN &RSEQ &RLEV &RENT)

             IF         COND(&RTYP *EQ 'M' *OR &RTYP *EQ 'P') THEN(DO)
             DLTOVR     FILE(IRDPSTL0 IRDPSTL1)
             ENDDO

/***  Monitor for Database Errors (U7 and U8 on).  ***/

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             ENDDO

             GOTO       CMDLBL(ENDPGM)

/***  Send Message to User alerting failure.  ***/

 ABNOR:      SNDPGMMSG  MSG('IRC0110 - UIC Control Posting Extract +
                          Report ended abnormally') TOMSGQ(MRUNQ +
                          MOPERQ)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM

 ENDPGM:     CHGVAR     VAR(&ACTCPY) VALUE('(C) Copyright +
                          Midas-Kapiti')
             ENDPGM
