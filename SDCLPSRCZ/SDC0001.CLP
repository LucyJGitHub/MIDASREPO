/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Menu option control - security details')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0001 - SD Menu Option Control                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC022             Date 24Feb04              */
/*       Prev Amend No. CSD012             Date 15Oct02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE022             Date 29Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CAP039  *CREATE    Date 04Oct99              */
/*                      xxxxxx             Date xxxxxxx              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       CSD012 - Standing Data Authorisation                        */
/*       CSE022  - Depository Definition Enhancement                 */
/*       CAP039 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &SCST &ACT)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SCST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
 
/* Declare the variables to check the enhancements file */                                /*CSE022*/
                                                                                          /*CSE022*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CSE022*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CSE022*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CSE022')                                                 /*CSE022*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CSE022*/
                                                                                          /*CSE022*/
             DCL        VAR(&SCCMTJOB) TYPE(*CHAR) LEN(256)                               /*CSC022*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC022*/
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1)                                   /*CSC022*/
             DCL        VAR(&CMTNO) TYPE(*DEC) LEN(3 0)                                   /*CSC022*/
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
             DCL        VAR(&WSKIP) TYPE(*CHAR) LEN(1) VALUE(' ')                         /*CSC022*/
                                                                                          /*CSC022*/
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
             RETURN
 
RUN:
 
/* RESET THE JOB SWITHCHES */
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(SDSECSLR) TOFILE(SDSECSL0) SHARE(*NO)
             OVRDBF     FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO) +
                          /* CSD012 */
 
/* Access switchable features file to see if feature CSE022     */                        /*CSE022*/
/* is installed  */                                                                       /*CSE022*/
                                                                                          /*CSE022*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CSE022*/
             IF         COND((&RTCD *EQ '       ') *AND ((&PROG *EQ +
                          'SDSECDSIN') *OR (&PROG *EQ +
                          'SDSECDRPR'))) THEN(OVRDBF FILE(SDSECSL1) +
                          SHARE(*NO)) /*CSE022*/
                                                                                          /*CSE022*/
/* Access switchable features file to see if feature CSC022     */                        /*CSC022*/
/* is installed  */                                                                       /*CSC022*/
             CHGVAR     VAR(&CSC022) VALUE(' ')                                           /*CSC022*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC022*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC022*/
             CHGVAR     VAR(&SARD) VALUE('CSC022')                                        /*CSC022*/
                                                                                          /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                     /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC022*/
                 CHGVAR     VAR(&CSC022) VALUE('Y')                                       /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB (1 256)) RTNVAR(&SCCMTJOB)                        /*CSC022*/
             CHGVAR     VAR(&CMTNO) VALUE(%SST(&SCCMTJOB 1 3))                            /*CSC022*/
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
             IF         COND((&CMTNO *GT 0) *AND (&CMTJOB1 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 1) *AND (&CMTJOB2 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 2) *AND (&CMTJOB3 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 3) *AND (&CMTJOB4 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 4) *AND (&CMTJOB5 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 5) *AND (&CMTJOB6 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 6) *AND (&CMTJOB7 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 7) *AND (&CMTJOB8 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 8) *AND (&CMTJOB9 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             IF         COND((&CMTNO *GT 9) *AND (&CMTJOB10 *EQ +
                          &JOBNAME)) THEN(DO)                                             /*CSC022*/
             CHGVAR     VAR(&WSKIP) VALUE('Y')                                            /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
/* CALL PROGRAM  */
 
             CALL       PGM(&PROG) PARM(&SCST &ACT)
 
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
 /* IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN */
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('SDC0001' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&CSC022 *NE 'Y') THEN(DO)                                    /*CSC022*/
                ROLLBACK
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&WSKIP *NE 'Y') THEN(DO)                                     /*CSC022*/
                ROLLBACK                                                                  /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO
 
             RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
