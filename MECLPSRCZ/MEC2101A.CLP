/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages report')                      */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC2101A - Outgoing messages report - COB                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.  X00000           DATE 00XXX00              */
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBIN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing messages report') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Access data area rundat for the Multibranching indicator */
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)
 
/* Obtain RUNDAT in YYMMDD format */
             CALL       PGM(ZM0080) PARM(&RUNDAT &FORMAT)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/* Set parmeters used to call MEC0810 */
             CHGVAR     VAR(%SST(&PARM 15 3)) VALUE('***')
             CHGVAR     VAR(%SST(&PARM 18 4)) VALUE('1234')
             CHGVAR     VAR(%SST(&PARM 23 6)) VALUE(&RUNDAT)
             CHGVAR     VAR(%SST(&PARM 29 6)) VALUE(&RUNDAT)
 
/*/COPY WNCPYSRC,MEC2101A01                                          */
/* Call MEC0810 (Outgoing message details report - System level) */
             CALL       PGM(MEC0810) PARM('   ' 'S' '   ' &PARM)
/*/COPY WNCPYSRC,MEC2101A02                                          */
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/* If system is multibranched then produce branch 'ALL' report */
 
    IF     COND(&MBIN = 'Y') THEN(DO)
 
/* Call MEC0810 (Outgoing message details report - System level) */
             CALL       PGM(MEC0810) PARM('   ' 'B' 'ALL' &PARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
    ENDDO
 
             GOTO END
 ERR:        SNDPGMMSG  MSG('Outgoing messages report COB +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
