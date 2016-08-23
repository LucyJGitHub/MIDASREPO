/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check & correct unjournalled data queues')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2471 - Check and Correct Unjournalled Data Areas         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6546            Date 21Apr05              */
/*                      CSC018 *CREATE     Date 31May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG6546 - Pass back error status to be trapped in calling   */
/*                 programs.                                         */
/*               - Call SCNJRNLKP to see if this dtaq is not to be   */
/*                 journalled (on SCNJRNL2).                         */
/*       CSC018 - Journaling options for high availability           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
/*/COPY WNCPYSRC,SCC2471INT                                                                       */
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBTYPE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                   /*BUG6546*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(27)                                    /*BUG6546*/
             DCL        VAR(&ODOBNM) TYPE(*CHAR) LEN(10)                                 /*BUG6546*/
             DCL        VAR(&ODJRNL) TYPE(*CHAR) LEN(1)                                  /*BUG6546*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
             DCLF       FILE(QADSPOBJ)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2471MPS                                                                       */
 
/* Create the message queue for SCC2471 reporting                                                 */
 
             DLTMSGQ    MSGQ(QTEMP/SCC2472)
             MONMSG     MSGID(CPF0000)
 
             CRTMSGQ    MSGQ(QTEMP/SCC2472)
 
             CHGVAR     VAR(&MESSAGE) VALUE('List of Data Queues +
                          Journalled by this Component')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2472)
 
/* Create the driving data */
 
             DSPOBJD    OBJ(&LIB/*ALL) OBJTYPE(*DTAQ) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/DATAQ)
             MONMSG     MSGID(CPF2123)
 
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DATAQ)
 
/* Read through the file and journal each data area. */
 
 RCVF:
             RCVF
/**********  MONMSG     MSGID(CPF0864) EXEC(DO)                                          /*BUG6546*/
             MONMSG     MSGID(CPF0864 CPF4101) EXEC(DO)                                  /*BUG6546*/
                GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(&ODJRST *EQ '0') THEN(DO)
/* Call SCNJRNLKP using SCNJRNL2 to see if data queue is one not to be journalled. */    /*BUG6546*/
                OVRDBF     FILE(SCNJRNL0) TOFILE(SCNJRNL2)                               /*BUG6546*/
                CALL       PGM(SCNJRNLKP) PARM(&ODOBNM &ODJRNL)                          /*BUG6546*/
                DLTOVR     FILE(SCNJRNL0)                                                /*BUG6546*/
                IF         COND(&ODJRNL *EQ 'N') THEN(DO)                                /*BUG6546*/
                CALL       PGM(SCC2472) PARM(&ODOBNM &ODLBNM)
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                           /*BUG6546*/
                      CHGVAR     VAR(&RTCD) VALUE('SCC2472')                             /*BUG6546*/
                      GOTO       CMDLBL(ABNOR)                                           /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
             ENDDO
 
/*/COPY WNCPYSRC,SCC2471MPE                                                                       */
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2471ERR                                                                       */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC2471 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
/* Report exactly which call action failed */                                            /*BUG6546*/
               CHGVAR     VAR(&MSG) VALUE(&RTCD *CAT &ODOBNM *CAT &LIB)                  /*BUG6546*/
               SNDPGMMSG MSGID(USR9829) MSGF(SDUSRMSG) MSGDTA(&MSG) +
                            TOMSGQ(MOPERQ)                                               /*BUG6546*/
               MONMSG     MSGID(CPF0000 MCH0000)                                         /*BUG6546*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DSPMSG     MSGQ(QTEMP/SCC2472) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
 
/* Pass back completion status to SCC2463.                                               /*BUG6546*/
/**********  IF         COND(*%SWITCH(XXXXXX11)) THEN(DO)              */        /*BUG6546 BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX11)) THEN(DO)                    /*BUG6546 BG18886*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DMLIB   ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (95 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DPLIB   ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (96 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DTALIB  ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (97 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'XLIB    ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (98 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'JLIB    ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (99 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
             ENDDO                                                                       /*BUG6546*/
                                                                                         /*BUG6546*/
/*/COPY WNCPYSRC,SCC2471END                                                                       */
 
             ENDPGM
