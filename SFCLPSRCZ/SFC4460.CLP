/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Session manager')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas      STANDING DATA MODULE                         */
/*                                                                   */
/*       SFC4460 -  SESSION MANAGER                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSF002             Date 11Aug03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01405             Date 03Dec92              */
/*                      AUS025             Date 13Feb91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSF002 - Global Processing                                  */
/*                Remove the command which sets up SFC0600 as the    */
/*                program to be called when Attention Key is pressed */
/*                since SFC0600 is made redundant already.           */
/*                Remove SF0420DF overrides since this is made       */
/*                redundant also.                                    */
/*       S01405 - CHANGES MADE TO STANDARDISE PROGRAM                */
/*       AUS025 - AUSTRALIAN PRODUCT - SESSION MANAGER           */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SFC4460001                                          */
             DCL        VAR(&MSGKEY)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&MSGSEND)   TYPE(*CHAR) LEN(80)
             DCL        VAR(&OFFSET)    TYPE(*DEC)  LEN(3 2)
             DCL        VAR(&DAY)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&TIME)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&JN)        TYPE(*CHAR) LEN(80)
             DCL        VAR(&NEWJOB)    TYPE(*CHAR) LEN(10) VALUE(+
             'S1405     ')
             DCL        VAR(&TXTPTR)    TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&L)         TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&CNT)       TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&JOBPTR)    TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&GRPJOBL)   TYPE(*CHAR) LEN(1056)
             DCL        VAR(&GRPJOBCNT) TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&INLGRPPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&TIMEO)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&TIMEOA)    TYPE(*CHAR) LEN(5)
 
/*   ERROR HANDLING FIELDS                                          */
 
             DCL        VAR(&MSGID)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)    TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRORSW)   TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCLF       FILE(SDC4460DF) */                            /*S01405*/
             DCLF       FILE(SFC4460DF)                               /*S01405*/
 
             CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES)
/*    GET GROUP JOB DATA                                            */
 
/*********** RTVDTAARA  DTAARA(*GDA (1 10)) RTNVAR(&INLGRPPGM)        /*S01405*/
/*********** RTVDTAARA  DTAARA(*GDA (11 50)) RTNVAR(&TEXT)            /*S01405*/
/*********** RTVDTAARA  DTAARA(*GDA (61 5))  RTNVAR(&TIMEOA)          /*S01405*/
             RTVDTAARA  DTAARA(*GDA (301 10)) RTNVAR(&INLGRPPGM)      /*S01405*/
             RTVDTAARA  DTAARA(*GDA (311 50)) RTNVAR(&TEXT)           /*S01405*/
             RTVDTAARA  DTAARA(*GDA (361 5))  RTNVAR(&TIMEOA)         /*S01405*/
             CHGVAR     VAR(&TIMEO) VALUE(&TIMEOA)
/*********** CHGDTAARA  DTAARA(*GDA (11 50)) VALUE(' ')               /*S01405*/
             CHGDTAARA  DTAARA(*GDA (311 50)) VALUE(' ')              /*S01405*/
             RTVGRPA    GRPJOBL(&GRPJOBL) GRPJOBCNT(&GRPJOBCNT)
             IF         COND(&GRPJOBCNT = 0) THEN(GOTO ENDPGM)
 
/*/COPY WNCPYSRC,SFC4460002                                          */
/*     DEFINE WINDOW BORDER CONTENTS                                */
 
             CHGVAR     VAR(%SST(&TOP 15 25)) VALUE('Midas +
                          SESSION MANAGER')
/*           CHGVAR     VAR(%SST(&BOTTOM  2 15)) VALUE('F3=Exit')  S01405*/
             CHGVAR     VAR(%SST(&BOTTOM  2 7)) VALUE('F3=Exit') /*S01405*/
/**********  CHGVAR     VAR(%SST(&BOTTOM 10 23)) VALUE('F13=+     */                      /*CSF002*/
/**********               Instruction Manual')                    */           /*S01405*/ /*CSF002*/
             CHGVAR     VAR(&INST) VALUE(' Place a "1" beside +
                          selection and press ENTER')
 
/*     CREATE A NAME FOR A NEW JOB                               */
 
 ENDLOOP:
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGVAR     VAR(%SST(&NEWJOB 6 5)) VALUE(&TIME)
             CHGVAR     VAR(&OFFSET) VALUE(0)
 
 
/*     SET SCREEN VARIABLES FROM GROUP JOB LIST                   */
 
/*     SET UP VARIABLES                                          */
 START:      CHGVAR     VAR(&L)      VALUE(1)
             CHGVAR     VAR(&CNT)    VALUE(1)
             CHGVAR     VAR(&TXTPTR) VALUE(17)
 
/*     SET SCREEN VARIABLES FROM GROUP JOB LIST                   */
 
 STRPGM: IF COND(&CNT *LE &GRPJOBCNT) THEN(+
         DO)
            IF     COND(%SST(&GRPJOBL &L 5) *EQ 'S1405') THEN(+
            DO)
               IF   COND(&F03E01 *EQ '          ') THEN(+
               DO)
                      IF  COND(%SST(&GRPJOBL &TXTPTR 50) *NE '    ') +
                          THEN(CHGVAR VAR(&F03E01) +
                                   VALUE(%SST(&GRPJOBL &TXTPTR 50)))
                      ELSE CMD(+
                           CHGVAR VAR(&F03E01) VALUE(&TEXT))
 
                 CHGVAR   VAR(%SST(&JN 1 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E02 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E02) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 11 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E03 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E03) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 21 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E04 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E04) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 31 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E05 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E05) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 41 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E06 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E06) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 51 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E07 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E07) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 61 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
               IF   COND(&F03E08 *EQ '          ') THEN(+
               DO)
                 CHGVAR   VAR(&F03E08) VALUE(%SST(&GRPJOBL &TXTPTR 50))
                 CHGVAR   VAR(%SST(&JN 71 10)) VALUE(%SST(+
                             &GRPJOBL &L 10))
                 GOTO NEXT
               ENDDO
 
            ENDDO
NEXT:       CHGVAR   VAR(&L)      VALUE(&L + 66)
            CHGVAR   VAR(&TXTPTR) VALUE(&TXTPTR + 66)
            CHGVAR   VAR(&CNT)    VALUE(&CNT + 1)
            GOTO STRPGM
         ENDDO
 
/*     CHANGE CURRENT JOBS TEXT                                  */
 
             CHGVAR     VAR(&JOBPTR) VALUE(&OFFSET + (0 * 66) + 1)
             CHGVAR     VAR(&TXTPTR) VALUE(&JOBPTR + 16)
 
             IF         COND(&TEXT *NE ' ')     +
                THEN(DO)
                CHGGRPA      GRPJOB(%SST(&GRPJOBL &JOBPTR 10)) +
                             TEXT(&TEXT)
                CHGVAR       VAR(&F03E01) VALUE(&TEXT)
                ENDDO
 
/*    DISPLAY SCREEN                                           */
SCREEN:
             SNDF       RCDFMT(DUMMY)
             SNDRCVF    RCDFMT(MENU)
 
             IF         COND(&IN03) THEN(GOTO CMDLBL(ENDPGM))
/**********  IF         COND(&IN13) THEN(DO) */                                /*S01405*/ /*CSF002*/
/**********  CALL       PGM(SFC0600)         */                                /*S01405*/ /*CSF002*/
/**********  GOTO       CMDLBL(ENDPGM)       */                                /*S01405*/ /*CSF002*/
/**********  ENDDO                           */                                /*S01405*/ /*CSF002*/
 
 
             IF COND(&F01E01 *NE ' ') THEN(GOTO CMDLBL(ENDPGM))
 
/*   TRANSFER TO SECONDARY JOB                               */
 
             IF COND(&F01E01 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 1 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 1 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 1 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) SECURE(*YES)  *S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO) SECURE(*YES)          /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
 
             IF COND(&F01E02 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 11 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 11 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 11 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(&F01E03 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 21 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 21 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 21 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(&F01E04 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 31 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 31 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 31 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(&F01E05 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 41 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 41 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               OVRDSPF    FILE(SD2316DF) WAITRCD(*NOMAX) SECURE(*YES)
               TFRGRPJOB GRPJOB(%SST(&JN 41 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(&F01E06 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 51 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 51 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 51 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             IF COND(&F01E07 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 61 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 61 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF) */                           /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 61 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO) */           /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
             CHGVAR VAR(&JOBPTR) VALUE(&OFFSET + (7 * 66) + 1)
             IF COND(&F01E08 *NE ' ') THEN(DO)
               IF COND(%SST(&JN 71 1) *EQ ' ') THEN( +
                 CHGVAR VAR( %SST(&JN 71 10)) VALUE(&NEWJOB))
/**************DLTOVR     FILE(SD2316DF)                              /*S01405*/
/**********    DLTOVR     FILE(SF0420DF)                                       /*S01405*/ /*CSF002*/
/**********    MONMSG     MSGID(CPF0000)                                                  /*CSF002*/
               TFRGRPJOB GRPJOB(%SST(&JN 71 10)) +
                 INLGRPPGM(&INLGRPPGM) TEXT(&TEXT)
/**************OVRDSPF    FILE(SD2316DF) WAITRCD(&TIMEO)              /*S01405*/
/**********    OVRDSPF    FILE(SF0420DF) WAITRCD(&TIMEO)                       /*S01405*/ /*CSF002*/
               GOTO CMDLBL(ENDPGM)
             ENDDO
 
   /*        GOTO STRPGM   */
             GOTO SCREEN
ERROR:       IF  COND(&ERRORSW) THEN(SNDPGMMSG MSGID(CPF9999) +
             MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
             CHGVAR VAR(&ERRORSW) VALUE('1')
ERROR2:      RCVMSG MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
             MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF COND(&MSGID = '       ') THEN(GOTO CMDLBL(ERROR3))
             SNDPGMMSG MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
             MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO CMDLBL(ERROR2)
ERROR3:      RCVMSG MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
             MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             SNDPGMMSG MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
             MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
/* */                                                                 /*S01405*/
/** Change value of &BISCPY to avoid error of its declaration.     */ /*S01405*/
/* */                                                                 /*S01405*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */                                                                 /*S01405*/
ENDPGM:      ENDPGM
