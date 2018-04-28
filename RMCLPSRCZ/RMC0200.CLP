/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IRM Copy Tmark Extract to Folder')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Interest Risk Management                        */
/*                                                                   */
/*       RMC0200 - Copy Tmark Extract to Folder                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 094899             Date 20OCT95              */
/*       Prev Amend No. CRM001  *CREATE    Date 06FEB95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       094889 - RENAME TRADES.DAT TO CFTRADES.INT AND CHANGE       */
/*                FOLDER NAME TO REFLECT SYSTEM ID.                  */
/*       CRM001 - Midas/Tmark Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&RMRUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)              /*094889*/
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(12)                /*094889*/
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
/**/
/**  Call RM0009 to determine if a run is required                   */
/**/
             CALL       PGM(RM0009) PARM(&RMRUN)
/**/
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) = '11') THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**  Proceed if RM run required                                      */
/**/
             IF         COND(&RMRUN = 'Y') THEN(DO)
/**/
                CLRPFM     FILE(RMTREXPD)
/**/
                CPYF       FROMFILE(RMFXEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
                CPYF       FROMFILE(RMMMEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
                CPYF       FROMFILE(RMLEEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
                CPYF       FROMFILE(RMFIEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
                CPYF       FROMFILE(RMSEEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
                CPYF       FROMFILE(RMFOEXPD) TOFILE(RMTREXPD) +
                             MBROPT(*ADD)
                MONMSG     MSGID(CPC2957)
                MONMSG     MSGID(CPF2817) EXEC(DO)
                  SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
/**  Copy to PC document                                             */
/**/
                CHKDLO     DLO(IRM) FLR(MIDAS) OBJTYPE(*FLR)
                MONMSG     MSGID(CPF8A77) EXEC(DO)
                   CRTFLR     FLR(MIDAS)
                   MONMSG     MSGID(CPF0000)
                   CRTFLR     FLR(IRM) INFLR(MIDAS)
                   MONMSG     MSGID(CPF0000)
                ENDDO
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)         /*094889*/
             CHGVAR     VAR(&FLR) VALUE('MIDAS/IRM/' *TCAT +
                          &SYSTEM)                                   /*094889*/
/**/                                                                 /*094889*/
             CHKDLO     DLO(&SYSTEM) FLR('MIDAS/IRM') OBJTYPE(*FLR)  /*094889*/
             MONMSG     MSGID(CPF8A77) EXEC(DO)                      /*094889*/
             CRTFLR     FLR(&SYSTEM) INFLR('MIDAS/IRM')              /*094889*/
             ENDDO                                                   /*094889*/
/**/                                                                 /*094889*/
/*********** CPYTOPCD   FROMFILE(RMTREXPD) TOFLR('MIDAS/IRM') +      /*094889*/
/***********              FROMMBR(*FIRST) TODOC(CFTRADES.INT) +      /*094889*/
/***********              REPLACE(*YES)                              /*094889*/
             CPYTOPCD   FROMFILE(RMTREXPD) TOFLR(&FLR) +
                          FROMMBR(*FIRST) TODOC(CFTRADES.INT) +
                          REPLACE(*YES)                              /*094889*/
                MONMSG     MSGID(IWS1612) EXEC(DO)
                  SNDPGMMSG  MSGID(IWS1612) MSGF(QIWS/QIWSMSG) +
                             MSGDTA(RMTREXPD) TOMSGQ(MOPERQ) +
                             MSGTYPE(*NOTIFY) RPYMSGQ(*PGMQ)
                  GOTO       CMDLBL(ABNOR)
                ENDDO
 
             ENDDO
/**/
/**  Update next RM run date                                         */
/**/
             CALL       PGM(RM0006)
             RTVJOBA    SWS(&SWS)
             IF         COND(%SST(&SWS 7 2) = '11') THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(PGMEND)
 
/**/
/**  Error Processing:                                               */
/**   Dump the program if error occurred in this program             */
/**/
 ABNOR:      DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDMSG     MSG('Job terminated - Copy Tmark Extract +
                        to Folder processing ended in error') +
                        TOMSGQ(MOPERQ MRUNQ)
/**/
/**  End of Program:                                                 */
PGMEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
