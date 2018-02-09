/*********************************************************************/
/*O*R****OVRDBF*FILE(SCJCHKPD)*TOFILE(QAFDMBR)************************/                   /*183337*/
/*OVR    OVRDBF FILE(SCJCHKPD) TOFILE(QAFDPHY)                       */                   /*183337*/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check and correct unjournalled files')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC2464 - Check and Correct Unjournalled Files              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG8207            Date 20Sep05              */
/*                      BUG6546            Date 21Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      183337             DATE 05Sep00              */
/*                      CCB009 *CREATE     DATE 21Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG8207 - SCC2463 on DLYW for too long due to locking with  */
/*                 CBMUTXPD.                                         */
/*       BUG6546 - Pass back error status to be trapped in calling   */
/*                 programs.                                         */
/*               - Do not call SCC2462 multiple times as it actions  */
/*                 all the SCNJRNL0 records in one call.             */
/*               - Call SCNJRNLKP to see if this file is not to be   */
/*                 journalled (on SCNJRNL0).                         */
/*       183337 - Change the created driving file to a list of       */
/*                files not members. This will speed up the          */
/*                processing.                                        */
/*       CCB009 - Journal files throughout close of business.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
/*/COPY WNCPYSRC,SCC2464INT                                          */
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBTYPE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                   /*BUG6546*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(27)                                    /*BUG6546*/
             DCL        VAR(&PHFILE) TYPE(*CHAR) LEN(10)                                 /*BUG6546*/
             DCL        VAR(&PHJRNL) TYPE(*CHAR) LEN(1)                                  /*BUG6546*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSGCLR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(QTEMP/SCJCHKPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC2464MPS                                          */
 
/* Create the message queue for SCC2465 reporting */
 
             DLTMSGQ    MSGQ(QTEMP/SCC2465)
             MONMSG     MSGID(CPF0000)
 
             CRTMSGQ    MSGQ(QTEMP/SCC2465)
 
             CHGVAR     VAR(&MESSAGE) VALUE('List of Files +
                          Journalled by this Component')
             SNDMSG     MSG(&MESSAGE) TOMSGQ(QTEMP/SCC2465)
 
/* Create the driving data */
 
/**********  DSPFD      FILE(&LIB/*ALL) TYPE(*MBR) OUTPUT(*OUTFILE) +  */                 /*183337*/
/**********               FILEATR(*PF) OUTFILE(QTEMP/SCJCHKPD) +       */                 /*183337*/
/**********               OUTMBR(*FIRST *REPLACE)                      */                 /*183337*/
 
             DSPFD      FILE(&LIB/*ALL) TYPE(*ATR) OUTPUT(*OUTFILE) +
                          FILEATR(*PF) OUTFILE(QTEMP/SCJCHKPD) +
                          OUTMBR(*FIRST *REPLACE)                                         /*183337*/
 
/**Read*through*the*file*and*end*journal*each*file.**/                                   /*BUG6546*/
/* Call SCC2462 once to ensure all files in SCNJRNL0 are not journalled. */              /*BUG6546*/
 
/*RCVF:****  RCVF                                                                        /*BUG6546*/
/**********  MONMSG     MSGID(CPF0864) EXEC(DO)                                          /*BUG6546*/
                CHGVAR     VAR(&LIBTYPE) VALUE(%SST(&LIB 3 6))
                IF         COND(&LIBTYPE *EQ 'DTALIB') THEN(CALL +
                             PGM(SCC2462))
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*BUG6546*/
                   CHGVAR     VAR(&RTCD) VALUE('SCC2462')                                /*BUG6546*/
                   GOTO       CMDLBL(ABNOR)                                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
/**********     GOTO       CMDLBL(END)                                                   /*BUG6546*/
/**********  ENDDO                                                                       /*BUG6546*/
 
/**********  IF         COND(&MBJRNL *EQ 'N') THEN(DO)       */                           /*183337*/
/**********     CALL       PGM(SCC2465) PARM(&MBFILE &MBLIB) */                           /*183337*/
                                                                                          /*183337*/
 RCVF:       RCVF                                                                        /*BUG6546*/
             MONMSG     MSGID(CPF0864 CPF4101) EXEC(GOTO +
                          CMDLBL(END))                                                   /*BUG6546*/
             IF         COND(&PHJRNL *EQ 'N') THEN(DO)                                    /*183337*/
/* Call SCNJRNLKP using SCNJRNL0 to see if this file is one not to be journalled. */     /*BUG6546*/
                CALL       PGM(SCNJRNLKP) PARM(&PHFILE &PHJRNL)                          /*BUG6546*/
                IF         COND(&PHJRNL *EQ 'N') THEN(DO)                                /*BUG6546*/
                CALL       PGM(SCC2465) PARM(&PHFILE &PHLIB)                              /*183337*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                           /*BUG6546*/
                      CHGVAR     VAR(&RTCD) VALUE('SCC2465')                             /*BUG6546*/
                      GOTO       CMDLBL(ABNOR)                                           /*BUG6546*/
                   ENDDO                                                                 /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
             ENDDO
 
/*/COPY WNCPYSRC,SCC2464MPE                                          */
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC2464ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC2464 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
/* Report exactly which call action failed */                                            /*BUG6546*/
               CHGVAR     VAR(&MSG) VALUE(&RTCD *CAT &PHFILE *CAT &LIB)                  /*BUG6546*/
               SNDPGMMSG MSGID(USR9829) MSGF(SDUSRMSG) MSGDTA(&MSG) +
                            TOMSGQ(MOPERQ)                                               /*BUG6546*/
               MONMSG     MSGID(CPF0000 MCH0000)                                         /*BUG6546*/
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             DSPMSG     MSGQ(QTEMP/SCC2465) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
 
/* Pass back completion status to SCC2463.                                               /*BUG6546*/
/**********  IF         COND(¬%SWITCH(XXXXXX11)) THEN(DO)            */          /*BUG6546 BUG8207*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                 /*BUG8207*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DMLIB   ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (86 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DPLIB   ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (87 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DTALIB  ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (88 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
                IF         COND(%SST(&LIB 3 8) *EQ 'DZLIB   ') THEN(DO)                  /*BUG6546*/
                CHGDTAARA  DTAARA(SDSTAT (89 1)) VALUE('Y')                              /*BUG6546*/
                ENDDO                                                                    /*BUG6546*/
             ENDDO                                                                       /*BUG6546*/
                                                                                         /*BUG6546*/
/*/COPY WNCPYSRC,SCC2464END                                          */
 
             ENDPGM
