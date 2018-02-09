/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Movements Status - Menu option control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC025 - Movements Status - Menu Option Control         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG11813           Date 04Aug06              */
/*                      CSC022             Date 24Feb04              */
/*                      CSE039   *CREATE   Date 27Feb03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11813 - Screen has no validation when status movement    */
/*                  enquiry is selected                              */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CSE039 - Automatic Settlement of Trades                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&Prog &TrnRef &TrnTyp &ProcMode &EndByF3 +
                             &EndByF12)
 
             DCL        VAR(&Prog)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&TrnRef)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&TrnTyp)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&ProcMode)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&EndByF3)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&EndByF12)   TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RtCd)       TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&ReturnCode) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ActGrp)     TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Msg)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&Message)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&NoReply)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CpyFld)     TYPE(*CHAR) LEN(64) VALUE('(c) +
                               Finastra International Limited +
                               2003')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MLINK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LNKOBJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
             DCL        VAR(&CMTNUM) TYPE(*DEC) LEN(3 0)                                  /*CSC022*/
             DCL        VAR(&CMTJOB1) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB2) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB3) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB4) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB5) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB6) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB7) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB8) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB9) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTJOB10) TYPE(*CHAR) LEN(10)                                /*CSC022*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)                                 /*CSC022*/
             DCL        VAR(&CMTSKP) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC022*/
 
/** Monitor for error messages not trapped in the rest of the **/
/** program.  If they occur, reclaim resources and exit.      **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(Error))
                                                                                          /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE(' ')                                           /*CSC022*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SAR) VALUE('CSC022')                                         /*CSC022*/
 
/** Reset job switches. **/
 
             CHGJOB     SWS(XXXXXX00)
 
/** End program if CSE039 isn't on **/
 
             CALL       PGM(AOSARDR0) PARM(&RtCd '*VERIFY' 'CSE039')
 
             IF         (&RtCd *NE ' ') +
                 GOTO       CMDLBL(EndPgm)
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC022*/
                 CHGVAR     VAR(&CSC022) VALUE('Y')                                       /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNUM) VALUE(%SST(&SCCMTJOB 1 3))                           /*CSC022*/
             CHGVAR     VAR(&CMTJOB1) VALUE(%SST(&SCCMTJOB 4 10))                         /*CSC022*/
             CHGVAR     VAR(&CMTJOB2) VALUE(%SST(&SCCMTJOB 14 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB3) VALUE(%SST(&SCCMTJOB 24 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB4) VALUE(%SST(&SCCMTJOB 34 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB5) VALUE(%SST(&SCCMTJOB 44 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB6) VALUE(%SST(&SCCMTJOB 54 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB7) VALUE(%SST(&SCCMTJOB 64 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB8) VALUE(%SST(&SCCMTJOB 74 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB9) VALUE(%SST(&SCCMTJOB 84 10))                        /*CSC022*/
             CHGVAR     VAR(&CMTJOB10) VALUE(%SST(&SCCMTJOB 94 10))                       /*CSC022*/
                                                                                          /*CSC022*/
             RTVJOBA    JOB(&JOBNAME)                                                     /*CSC022*/
             IF         COND((&CMTNUM *GT 0) *AND (&CMTJOB1 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 1) *AND (&CMTJOB2 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 2) *AND (&CMTJOB3 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 3) *AND (&CMTJOB4 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 4) *AND (&CMTJOB5 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 5) *AND (&CMTJOB6 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 6) *AND (&CMTJOB7 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 7) *AND (&CMTJOB8 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 8) *AND (&CMTJOB9 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNUM *GT 9) *AND (&CMTJOB10 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&CMTSKP) VALUE('Y')                                           /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
              RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
              CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
              CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'MLINK')
              ADDLIBLE   LIB(&TOLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF2103) EXEC(CHGVAR VAR(&MLINK) +
                          VALUE('Y'))
                MONMSG     MSGID(CPF2110)                                               /*BUG11813*/
              ADDLIBLE   LIB(MRDLNKOBJ) POSITION(*LAST)
             MONMSG     MSGID(CPF2103) EXEC(CHGVAR VAR(&LNKOBJ) +
                          VALUE('Y'))
                MONMSG     MSGID(CPF2110)                                               /*BUG11813*/
 
/** Override files - for an eventual call to SE4410 (SWIFT Msg Enquiry) **/
 
             OVRDBF     FILE(SEMESSPDX) TOFILE(SEMESSPD) OVRSCOPE(*JOB)
 
/** Call program. **/
 
             IF         (&Prog = 'SEMVTSSIN') +
                 CALL       PGM(&Prog) PARM(&TrnRef &TrnTyp &ProcMode +
                                            &EndByF3 &EndByF12)
             ELSE +
                 CALL       PGM(&Prog)
 
/** Ensure that no files were left open in called OPM programs **/
 
             RCLRSC
 
/** Destroy the activation group used by the program             **/
/** First, retrieve the name of the activation group that the    **/
/** program runs in.                                             **/
 
             CALL       PGM(ZAGETACTGP) PARM(&ReturnCode &ActGrp &Prog)
 
             IF         COND(&ReturnCode = ' ') THEN(DO)
                 RCLACTGRP  ACTGRP(&ActGrp)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
/** Delete override **/
 
             DLTOVR     FILE(SEMESSPDX) LVL(*JOB)
 
/** For Database Errors, recover Data from LDA. **/
 
             IF         COND(%Switch(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&Msg)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&Msg) +
                              TOMSGQ(MOPERQ)
 
/** Call SCC0010 to send abnormal termination screen. **/
 
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&Message)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&Message)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&Message)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&Message)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('SEC025' 'ENTER' &NoReply)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&CSC022 *NE 'Y') THEN(DO)                                    /*CSC022*/
                ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&CMTSKP *NE 'Y') THEN(DO)                                    /*CSC022*/
                ROLLBACK                                                                  /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
                CHGJOB    SWS(XXXXXX11)                                                   /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO
 
             GOTO       CMDLBL(EndPgm)
 
 Error:      RCLRSC
             RCLACTGRP  ACTGRP(*ELIGIBLE)
 
 EndPgm:
             CHGVAR     VAR(&CpyFld) VALUE('(c) +
                          Finastra International Limited')
             IF         COND(&MLINK *NE 'Y') THEN(DO)
                RMVLIBLE   LIB(MRDLNKOBJ)
                MONMSG     MSGID(CPF0000)
             ENDDO
             IF         COND(&LNKOBJ *NE 'Y') THEN(DO)
                RMVLIBLE   LIB(&TOLIB)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             ENDPGM
