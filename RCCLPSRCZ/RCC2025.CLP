/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RC II - Statement/Ledger download processing')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Automatic Reconciliations II Module                 */
/*                                                                   */
/*       RCC2025 - Statement/Ledger Download Processing              */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      235757  *CREATE    Date 26Aug05              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       235757 - Related to BUG2634                                 */
/*                Intellimatch downloads.  Copy RCLINTPD and         */
/*                RCSINTPD to xxDPLIB to allow extraction from the   */
/*                database. Also deletes them after download         */
/*                                                                   */
/*********************************************************************/
             PGM   (&MODE &PREFIX &PCID &FILE)
 
/*/COPY WNCPYSRC,RCC2025INT                                          */
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBLPFX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROCESS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
 
/*/COPY WNCPYSRC,RCC2025MPS                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBLPFX)
 
             IF         COND(&LIBLPFX *NE &PREFIX) THEN(DO)
                SNDMSG     MSG('AutoRecs II PC download - library list +
                             incorrect for system prefix ' *CAT +
                             &PREFIX) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
 
/* If not in I/C send error message and terminate */
 
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (MPHAS *NE 'G')) +
                          THEN(DO)                                                        /*CCB020*/
                SNDMSG     MSG('AutoRecs II PC download - Midas is not +
                             in input cycle. Download is not permitted +
                             at this time.') TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Start commitment control and create Local Data Area */
 
             STRCMTCTL  LCKLVL(*ALL) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS(XXXXXX00)
 
/* If the mode is set to Copy file to xxDPLIB */
 
             IF         COND(&MODE = C) THEN(DO)
                CHGVAR     VAR(&PROCESS) VALUE('COPY')
 
/* Access time, and send start message to MOPERQ, MRUNQ */
                RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
                SNDMSG     MSG('AutoRecs II PC download - ' *CAT +
                             &PROCESS *CAT ' file for ' *CAT &FILE +
                             *CAT ' download for PC id ' *CAT &PCID +
                             *CAT ' attempted at ' *CAT &TIME) +
                             TOMSGQ(MOPERQ MRUNQ)
                IF         COND(&FILE = 'RCLINTPD') THEN(DO)
                   CPYF       FROMFILE(RCLINTPD) TOFILE(&DPLIB/RCLINTPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                MBROPT(*REPLACE) CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   GRTOBJAUT  OBJ(&DPLIB/RCLINTPD) OBJTYPE(*FILE) +
                                USER(*PUBLIC) AUT(*USE)
                ENDDO
 
                IF         COND(&FILE = 'RCSINTPD') THEN(DO)
                   CPYF       FROMFILE(RCSINTPD) TOFILE(&DPLIB/RCSINTPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) +
                                MBROPT(*REPLACE) CRTFILE(*YES)
                   MONMSG     MSGID(CPF0000)
                   GRTOBJAUT  OBJ(&DPLIB/RCLINTPD) OBJTYPE(*FILE) +
                                USER(*PUBLIC) AUT(*USE)
                ENDDO
             ENDDO
 
/* If the mode is set to Delete file from xxDPLIB */
 
             IF         COND(&MODE = D) THEN(DO)
                CHGVAR     VAR(&PROCESS) VALUE('DELETE')
 
/* Access time, and send start message to MOPERQ, MRUNQ */
                RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
                SNDMSG     MSG('AutoRecs II PC download - ' *CAT +
                             &PROCESS *CAT ' file for ' *CAT &DPLIB +
                             *CAT '\' *CAT &FILE *CAT ' download for +
                          PC id ' *CAT &PCID *CAT ' attempted at ' +
                          *CAT &TIME) TOMSGQ(MOPERQ MRUNQ)
 
                IF         COND(&FILE = 'RCLINTPD') THEN(DO)
                   DLTF       FILE(&DPLIB/RCLINTPD)
                ENDDO
 
                IF         COND(&FILE = 'RCSINTPD') THEN(DO)
                   DLTF       FILE(&DPLIB/RCSINTPD)
                ENDDO
             ENDDO
 
/* If database in error, send appropriate message... */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ROLLBACK
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 /* else, if no error, send completion message */
 
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
                RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
                SNDMSG     MSG('AutoRecs II PC download - ' *CAT +
                             &PROCESS *CAT ' File ' *CAT &FILE *CAT ' +
                             for PC id ' *CAT &PCID *CAT ' completed +
                             normally at ' *CAT &TIME) TOMSGQ(MOPERQ)
             ENDDO
 
/* Skip error processing */
 
             GOTO END
 
 ABNOR:
             SNDPGMMSG  MSG('AutoRecs II PC download - ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:
             RCLRSC
             MONMSG MSGID(CPF0000 MCH0000)
 
/*End commitment control and delete Local Data Area */
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLTDTAARA  DTAARA(QTEMP/LDA)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
