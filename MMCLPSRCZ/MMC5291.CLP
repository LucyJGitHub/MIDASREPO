/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Penalty Termination Reporting I/C')          */
/*********************************************************************/
/*                                                                   */
/*       MIDAS¦DBA - Dealing Money Market Module                     */
/*                                                                   */
/*       MMC5291 - Penalty Termination I/C Reporting                 */
/*                                                                   */
/*       (C) Copyright Misys International Banking Systems Ltd 2008  */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 256795  *Create    Date 25Sep08              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       256795 - Penalty Termination of Time Deposits (CDL052)      */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                        Copyright MISYS INTERNATIONAL BANKING SYSTEMS 2008')
 
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&ABNOR)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('CDL052')
             DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)
 
/** Global monitor message **/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 3 1))
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)
             IF         COND(&RTCD *NE '       ') +
                           THEN(GOTO CMDLBL(END))
 
             CALL       PGM(MM5291) PARM(&RSEQ &RLEV &RENT &TYPE)
 
/** Database error processing **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
             IF         COND(&ABNOR *EQ 'Y') THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&ABNOR) VALUE('Y')
 
             SNDPGMMSG  MSG('Penalty Termination Reporting ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (261 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0088) MSGF(GBMIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (361 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('MMC5291' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:        RCLRSC
     CHGVAR &MKICPY '(C) Copyright MISYS INTERNATIONAL BANKING SYSTEMS LTD 2008'
 
 ENDPGM
 
