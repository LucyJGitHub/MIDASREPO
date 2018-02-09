/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Restore master lib and jrn lib')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                       */
/*                                                                  */
/*       SDC1721 RESTORE MASTER LIBRARY                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6521            Date 03May05              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      087953            DATE  1APR96              */
/*                      RT0138            DATE 21JUN91              */
/*                      E13205            DATE 27/02/89             */
/*                      E10142            DATE 29/04/87             */
/*                      E10135            DATE 10/04/87             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6521 - Change Volume ID to be unique for each zone.      */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       CSC011 - 24x7 Midas Availability                           */
/*       087953 - Cancel request ignored if wrong tape loaded.      */
/*       RT0138  -  Abnormal termination should prompt re-try screen*/
/*                  so that media errors can be dealt with.         */
/*       E13205 - Change call of SDC1724 to SDC1774                 * /*E13205*/
/*       E10142 - CODE AFTER CALL TO SDC1724 DOES NOT BRANCH TO     *  *E10142*/
/*                THE 'END' OR 'ABNORMAL TERMINATION' CORRECTLY.    *  *E10142*/
/*       E10135 - INSUFFICIENT ERROR PROCESSING AFTER THE RSTLIB    *  *E10135*/
/*                COMMAND                                           *  *E10135*/
/*                                                                  */
/********************************************************************/
             PGM        PARM(&VOL1 &LIBID)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   INITIAL PROCESSING                                             */
/**/
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DEVIC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) VALUE(R)         /*RT0138*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC011*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CSC011*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CSC011*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC011*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC011*/
             DCL        VAR(&SUPPBACK) TYPE(*CHAR) LEN(1) VALUE('N')                      /*CSC011*/
             DCL        VAR(&SUPPLIB) TYPE(*CHAR) LEN(7)                                  /*CSC011*/
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)                                   /*CSC011*/
             DCL        VAR(&TAPOPT) TYPE(*CHAR) LEN(5)                                  /*BUG6521*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                   /*BUG6521*/
/*/COPY WNCPYSRC,SDC1721002                                          */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Restore Master Library') +
                        TOMSGQ(MRUNQ)
 
/** Initialise variables for AOSARDR0 */                                                  /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('      ')                                        /*CSC011*/
             CHGVAR     VAR(&SARD) VALUE('CSC011')                                        /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
                                                                                          /*CSC011*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*BUG6521*/
             RTVDTAARA  DTAARA(TAPOPT) RTNVAR(&TAPOPT)                                   /*BUG6521*/
/** Call AOSARDR0 to check if Switchable CSC011 is switched on */                         /*CSC011*/
                                                                                          /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)                       /*CSC011*/
                                                                                          /*CSC011*/
/** Database error */                                                                     /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CSC011*/
                    RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                          /*CSC011*/
                    SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                    TOMSGQ(MOPERQ)                                                        /*CSC011*/
                    GOTO       CMDLBL(ABNOR)                                              /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                        VAR(&CSC011) VALUE('Y'))                                          /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                    RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)                         /*CSC011*/
                    RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)                         /*CSC011*/
                    RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                         /*CSC011*/
                                                                                          /*CSC011*/
                     IF         COND(&CURR *EQ &MAIN) THEN(DO)                            /*CSC011*/
                            CHGVAR     VAR(&SUPPBACK) VALUE('Y')                          /*CSC011*/
                            CHGVAR     VAR(&SUPPLIB) VALUE(&SUPP *CAT 'DMLIB')            /*CSC011*/
                     ENDDO                                                                /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
RETRY:                                                                /*RT0138*/
/**/
/*  DETERMINE WHETHER RESTORE IS TO B.O.B. OR TO INPUT CYCLE       */
/**/
             IF         COND(&VOL1 *EQ *MOUN) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBMON) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBTUE) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBWED) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBTHU) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBFRI) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *EQ DBSAT) THEN(GOTO BOBDB1)
             IF         COND(&VOL1 *NE DBSUN) THEN(GOTO ICDB1)
/**/
/*  OBTAIN MEDIA AND DEVICE FOR B.O.B. RESTORE FROM JNSTAT           */
/**/
BOBDB1:      RTVDTAARA  DTAARA(JNSTAT (39 10)) RTNVAR(&DEVIC)
             RTVDTAARA  DTAARA(JNSTAT (35 4)) RTNVAR(&SAVD)
             IF         COND(&VOL1 *EQ *MOUN) THEN(GOTO RSTLIB1)
             GOTO RESTORE1
/**/
/*  OBTAIN MEDIA AND DEVICE FOR I-C RESTORE FROM JNSTAT           */
/**/
ICDB1:       RTVDTAARA  DTAARA(JNSTAT (53 10)) RTNVAR(&DEVIC)
             RTVDTAARA  DTAARA(JNSTAT (49 4)) RTNVAR(&SAVD)
/**/
/*  CHECK THE REQUIRED TAPE/DISKETTE HAS BEEN LOADED CORRECTLY                */
/**/
 RESTORE1:   IF         COND(&SAVD *EQ 'DKTE') THEN(DO)
/**/
 CHECK1:     CHKDKT     DEV(DKT01) VOL(&VOL1)
 
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Diskette with volume ID ' *CAT  +
                                             &VOL1 *CAT ' not found. Mount the +
                                             correct diskette and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6164) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to read diskette due to +
                                             surface defect. Mount another +
                                             diskette and retry OR enter "C" +
                                             to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
/*  IF ERROR MSG SENT, WAIT FOR REPLY. IF 'C', END PROGRAM ELSE RETURN        */
/*  TO CHECK1                                                                 */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
                             RCVMSG     MSG(&RMSG) PGMQ(*EXT)
/**/
                             IF         COND(&RMSG *EQ 'C') THEN(DO)
                               SNDPGMMSG  MSG('Restore Master +
                                              Library - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK1
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
             IF         COND(&SAVD *EQ 'TAPE') THEN(DO)
/*/COPY WNCPYSRC,SDC1721003                                          */
/**/
/********** CHECK2:                 CHKTAP     DEV(&DEVIC) VOL(&VOL1)                    /*BUG6521*/
CHECK2:                                                                                  /*BUG6521*/
             IF         COND((&TAPOPT *EQ 'SYSID') *AND (%SST(&VOL1 +
                          1 2) *EQ 'DB')) THEN(CHGVAR VAR(&VOL1) +
                          VALUE(&SYSID *TCAT %SST(&VOL1 3 3)))                          /*BUG6521*/
             CHKTAP     DEV(&DEVIC) VOL(&VOL1)                                          /*BUG6521*/
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available and +
                                             mount volume ' *CAT &VOL1 *CAT ' +
                                             OR enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6720) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Tape with volume ID ' *CAT  +
                                             &VOL1 *CAT ' not found. Mount +
                                             the correct tape and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6760) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not ready. Mount volume +
                                             with ID ' *CAT &VOL1 *CAT ' on +
                                             device, press START and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6772) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Cannot process mounted vol.Clean +
                                             tape path & heads,& retry OR +
                                             enter"C"to cancel program.If +
                                             problem recurs,mount another vol +
                                             & retry.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF9814) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not found. Mount volume +
                                             with ID ' *CAT &VOL1 *CAT ' on +
                                             correct device and retry OR enter +
                                             "C" to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/*/COPY WNCPYSRC,SDC1721004                                          */
/**/
/*  IF ERROR MSG SENT, WAIT FOR REPLY. IF 'C', END PROGRAM ELSE RETURN        */
/*  TO CHECK2                                                                 */
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*************               RCVMSG  MSG(&RMSG) PGMQ(*EXT)            /*087953*/
                             RCVMSG  PGMQ(*EXT) MSGTYPE(*RPY) +
                                     MSG(&RMSG)                       /*087953*/
/**/
/*************               IF         COND(&RMSG *EQ 'C') THEN(DO)  /*087953*/
                             IF         COND((&RMSG *EQ 'C') *OR +
                                         (&RMSG *EQ 'c')) THEN(DO)    /*087953*/
                               SNDPGMMSG  MSG('Restore Master +
                                               Library - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO END
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
/*/COPY WNCPYSRC,SDC1721005                                          */
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*   RESTORE MASTER LIBRARY                                         */
/**/
             SNDMSG     MSG('Restore of library ' *CAT &LIBID *TCAT 'DMLIB'  +
                          *CAT ' in progress.') TOMSGQ(MOPERQ)
/**/
RSTLIB1:                                                                                  /*207764*/
/*RSTLIB1:***RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVIC) + */                     /*207764*/
/**********               VOL(*MOUNTED) MBROPT(*ALL)               */                     /*207764*/
             RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVIC) +
                          VOL(*MOUNTED) MBROPT(*ALL) OUTPUT(*PRINT)                       /*207764*/
             MONMSG     MSGID(CPF3731 CPF3812) EXEC(DO)               /*E10135*/
                        SNDPGMMSG MSG('Library in use.Retry or +
                                       enter "C" to cancel.') +
                                  MSGTYPE(*INQ) TOPGMQ(*EXT)          /*E10135*/
                        CHGVAR VAR(&MONIND) VALUE('1')                /*E10135*/
                        ENDDO                                         /*E10135*/
             MONMSG     MSGID(CPF3785) EXEC(DO)                       /*E10135*/
                        SNDPGMMSG MSG('Not all subsystems have +
                                       been terminated.Retry or +
                                       enter "C" to cancel.') +
                                  MSGTYPE(*INQ) TOPGMQ(*EXT)          /*E10135*/
                        CHGVAR VAR(&MONIND) VALUE('1')                /*E10135*/
                        ENDDO                                         /*E10135*/
/*/COPY WNCPYSRC,SDC1721001                                          */
             IF COND(&MONIND *EQ '1') THEN(DO)                        /*E10135*/
                RCVMSG MSG(&RMSG) PGMQ(*EXT)                          /*E10135*/
                IF ((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) THEN(DO)     /*E10135*/
                   GOTO ABNOR                                         /*E10135*/
                ENDDO                                                 /*E10135*/
/*/COPY WNCPYSRC,SDC1721006                                          */
                ELSE DO                                               /*E10135*/
                   CHGVAR VAR(&MONIND) VALUE('0')                     /*E10135*/
                   GOTO RSTLIB1                                       /*E10135*/
                ENDDO                                                 /*E10135*/
             ENDDO                                                    /*E10135*/
                                                                                          /*CSC011*/
/** Restore Main system DMLIB to Support system DMLIB */                                  /*CSC011*/
                                                                                          /*CSC011*/
             IF    COND(&SUPPBACK *EQ 'Y') THEN(DO)                                       /*CSC011*/
              SNDMSG   MSG('Restore of library ' *CAT &SUPPLIB +
                           *CAT ' in progress.') TOMSGQ(MOPERQ)                           /*CSC011*/
                                                                                          /*CSC011*/
 RSTLIB2:                                                                                 /*207764*/
/*RSTLIB2:***RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVIC) + */          /*CSC011*/ /*207764*/
/**********               VOL(*MOUNTED) ALWOBJDIF(*FILELVL) +      */          /*CSC011*/ /*207764*/
/**********               RSTLIB(&SUPPLIB)                         */          /*CSC011*/ /*207764*/
             RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVIC) +
                          VOL(*MOUNTED) ALWOBJDIF(*FILELVL) +
                          RSTLIB(&SUPPLIB) OUTPUT(*PRINT)                                 /*207764*/
              MONMSG   MSGID(CPF3731 CPF3812) EXEC(DO)                                    /*CSC011*/
                           SNDPGMMSG MSG('Library in use. Retry or +
                           enter "C" to cancel.') MSGTYPE(*INQ) +
                           TOPGMQ(*EXT) KEYVAR(&KEYVAR)                                   /*CSC011*/
                           CHGVAR VAR(&MONIND) VALUE('1')                                 /*CSC011*/
                           ENDDO                                                          /*CSC011*/
                                                                                          /*CSC011*/
              IF       COND(&MONIND *EQ '1') THEN(DO)                                     /*CSC011*/
                           RCVMSG     MSGKEY(&KEYVAR) WAIT(*MAX) KEYVAR(&KEYVAR) +
                           MSG(&RMSG)                                                     /*CSC011*/
                           IF ((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) +
                           THEN(DO)                                                       /*CSC011*/
                             GOTO ABNOR                                                   /*CSC011*/
                           ENDDO                                                          /*CSC011*/
              ELSE     DO                                                                 /*CSC011*/
                           CHGVAR VAR(&MONIND) VALUE('0')                                 /*CSC011*/
                           GOTO RSTLIB2                                                   /*CSC011*/
                       ENDDO                                                              /*CSC011*/
              ENDDO                                                                       /*CSC011*/
                                                                                          /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/SDSTAT (6 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/TIDTA (11 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/CGDTA  (7 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/RPTRG  (1 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/RPTRG (21 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/RPTRG (39 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/RPTRG (49 2)) VALUE(&SUPP)                       /*CSC011*/
              CHGDTAARA  DTAARA(&SUPPLIB/MPHAS (1 1)) VALUE('A')                          /*CSC011*/
                                                                                          /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/*/COPY WNCPYSRC,SDC1721007                                          */
/**/
/*   CALL SDC1724 TO OPEN AND CLOSE ALL LOGICAL FILES               */
/**/
/*           CALL       PGM(SDC1724)                               */ /*E13205*/
             CALL       PGM(SDC1774)                                  /*E13205*/
/************IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)*******  *E10142*/
             IF         COND(%SWITCH(XXXXXX0X)) THEN(GOTO END)
/**/
/************GOTO END************************************************  *E10142*/
/**/
/*   ERROR PROCESSING                                               */
/**/
/***ABNOR:*******SNDPGMMSG  MSG('PROGRAM - Restore Master +           /*RT0138*/
/***********            Library - ENDED ABNORMALLY') +                /*RT0138*/
/***********            TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)             /*RT0138*/
ABNOR:                                                                /*RT0138*/
             SNDPGMMSG  MSG('PROGRAM - Restore Master +
                        Library - ENDED ABNORMALLY') +
                        TOMSGQ(MOPERQ MRUNQ)                          /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*RT0138*/
/* Call program to show restore fail and prompt for joblog */         /*RT0138*/
/**/                                                                  /*RT0138*/
             CALL       PGM(SCC0020) PARM('SDC1721' 'RESTFAILJ')      /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Call program to show abnormal end and prompt for retry */          /*RT0138*/
/**/                                                                  /*RT0138*/
             CHGVAR     VAR(&RPY) VALUE('R')                          /*RT0138*/
             CALL       PGM(RRC0010) PARM('SDC1721' 'MSTRESTABN' +
                          &RPY)                                       /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Retry save if requested else end program                           /*RT0138*/
/**/                                                                  /*RT0138*/
             IF         COND(&RPY = 'R') THEN(DO)                     /*RT0138*/
                SNDPGMMSG  MSG('Restore master library RETRY +
                                ATTEMPT') TOMSGQ(MOPERQ MRUNQ)        /*RT0138*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*RT0138*/
                GOTO       CMDLBL(RETRY)                              /*RT0138*/
             ENDDO                                                    /*RT0138*/
                                                                      /*RT0138*/
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(%SUBSTRING(&VOL1 1 2)) VALUE('DB')
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
