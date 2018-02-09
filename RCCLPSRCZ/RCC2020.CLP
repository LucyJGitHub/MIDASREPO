/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RC II - Ledger detail download')                */
/********************************************************************/
/*                                                                  */
/*       Midas     - Automatic Reconciliations II               */
/*                                                                  */
/*       RCC2020 - Ledger details download                          */
/*                                                                  */
/*       Function: Download Midas generated ledger details to PC    */
/*                 component. This program is evoked by the remote  */
/*                 PC using the PC/support command RMTCMD. The PC   */
/*                 should pass its subsystem id as a parameter.     */
/*                 This program will process all details for        */
/*                 branches linked to the subsystem id.             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                       137559           DATE 22JUN98              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       137559 - When RMTCMD is issued from an NT server it is     */
/*                Handled by a QUSER job called QZRCSRVR. This job  */
/*                remains active and when RMTCMD is issued a        */
/*                second time the transfer of data from MIDAS to    */
/*                the Autos Recs server fails because an attempt    */
/*                is made to STRCMTCTL When it is already active    */
/*                When exiting RCC2020 ENDCMTCTL and delete LDA.    */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PREFIX &PCID)
 
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBLPFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Check library list */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBLPFX)
             IF         COND(&LIBLPFX *NE &PREFIX) THEN(DO)
             SNDMSG     MSG('AutoRecs II PC download - library list +
                          incorrect for system prefix ' *CAT +
                          &PREFIX) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Access time, and send start message to MOPERQ, MRUNQ */
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             SNDMSG     MSG('AutoRecs II PC download - ledger +
                          download for PC id ' *CAT &PCID *CAT ' +
                          attempted at ' *CAT &TIME) TOMSGQ(MOPERQ +
                          MRUNQ)
 
/* Clear interface file */
             CLRPFM     FILE(RCLINTPD)
 
/* If not in I/C send error message and terminate */
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)              */                     /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (&MPHAS *NE 'G')) +
                          THEN(DO)                                                        /*CCB020*/
             SNDMSG     MSG('AutoRecs II PC download - Midas is not +
                          in input cycle. Download is not permitted +
                          at this time.') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* Start commitment control and create Local Data Area */
/**********  STRCMTCTL  LCKLVL(*ALL)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)                   /*CPK009*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*137559*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000 MCH0000)                        /*137559*/
 
/* Set off switches */
             CHGJOB SWS(XXXXXX00)
 
/* Call extraction program */
             CALL       PGM(RC2020) PARM(&PCID &RTCD)
 
/* If database in error, send appropriate message... */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ROLLBACK
             GOTO       CMDLBL(ERR)
             ENDDO
 
 /* else, if no error, send completion message */
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             SNDMSG     MSG('AutoRecs II PC download - ledger +
                          download for PC id ' *CAT &PCID *CAT ' +
                          completed normally at ' *CAT &TIME) +
                          TOMSGQ(MOPERQ)
             ENDDO
 
/* Skip error processing */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('AutoRecs II PC download - ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
             /*End commitment control and delete Local Data Area */   /*137559*/
             ENDCMTCTL                                                /*137559*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*137559*/
             DLTDTAARA  DTAARA(QTEMP/LDA)                             /*137559*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*137559*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
