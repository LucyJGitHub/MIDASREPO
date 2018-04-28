/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trades input (APIs version of screen)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas -  Futures and Options Module                         */
/*                                                                   */
/*       FFC0212 - Trades input                                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Note: This is an amended copy of FFC0210.  If this changes, */
/*             that may need to also.                                */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE020             Date 20Jan04              */
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP166             Date 15Oct01              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      147775             Date 16Nov98              */
/*                      CAP004  *CREATE    Date 24Aug98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CAP166 - API for Non-Currency OTC                           */
/*       CSC011 - 24x7 Midas Availability                            */
/*       147775 - General FF API fixes - (Pre-release unnanotated)   */
/*       CAP004 - Midas APIs phase 3.                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)
             DCL        VAR(&PFRST)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10) /* The +
                          function to be called */
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(9)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CRE020*/
                                                                                          /*CRE020*/
             DCLF       FILE(MKCTLD)
                                                                                          /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&SAR) VALUE('CRE020')                                         /*CRE020*/
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &FMT)                         /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
             DMPCLPGM                                                                     /*CRE020*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
 
/** Lock market data-areas     */
 
             IF         COND(&PROGRAM *EQ 'FFEXTRSIN' *OR &PROGRAM +
                          *EQ 'FFEXTRRPR') THEN(DO)
LOOP1: RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP1))
 
             IF         COND(&RECI *NE 'D') THEN(GOTO CMDLBL(LOOP1))
             IF         COND(&MKCI *NE 'I') THEN(GOTO CMDLBL(LOOP1))
 
             CHGVAR     VAR(%SST(&FFM &A 2)) VALUE(&MRKT)
             CHGVAR     VAR(&A) VALUE(&A + 2)
 
             ALCOBJ     OBJ((&MRKT *DTAARA *SHRRD))
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(LOOP1)
 
ENDLOOP1:    ENDDO
 
/**/
/*COPY WNCPYSRC,FFC0212MPS                                           */
/**/
 
             OVRDBF     FILE(FOPCC) SHARE(*NO)
             OVRDBF     FILE(FOPCK) SHARE(*NO)
 
/* +
   Call the program based on the value received +
*/
             CALL       PGM(&PROGRAM)
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP +
                          &PROGRAM)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
/*  DATABASE ERRORS, IF U7 + U8 ON  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
 
 
/* Submit job to update unrealised P&L                             */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/** Do OTC revaluation */
 
/*           IF         COND(&PROGRAM *EQ 'FFOTCCSIN' *OR &PROGRAM + */                   /*CAP166*/
/*                        *EQ 'FFOTCCRPR') THEN(DO)                  */                   /*CAP166*/
             IF         COND(&PROGRAM *EQ 'FFOTCCSIN' *OR &PROGRAM +
                          *EQ 'FFOTCCRPR' *OR &PROGRAM *EQ +
                          'FFOTCOSIN' *OR &PROGRAM *EQ 'FFOTCORPR') +
                          THEN(DO)                                                        /*CAP166*/
             CHGVAR     VAR(&MARKT) VALUE('OTC')
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)                      /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
             ENDDO
 
/** Do open market revaluation & release market data-areas */
 
             IF         COND(&PROGRAM *EQ 'FFEXTRSIN' *OR &PROGRAM +
                          *EQ 'FFEXTRRPR') THEN(DO)
             CHGVAR     VAR(&A) VALUE(1)
LOOP2:
             CHGVAR     VAR(&MRKT) VALUE(%SST(&FFM &A 2))
             CHGVAR     VAR(&A) VALUE(&A + 2)
             CHGVAR     VAR(&MARKT) VALUE(&MRKT)
             IF         COND(&MARKT *EQ '   ') THEN(GOTO +
                          CMDLBL(ENDLOOP2))
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)                      /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
 
             DLCOBJ     OBJ((&MRKT *DTAARA *SHRRD))
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(LOOP2)
 
ENDLOOP2:    ENDDO
 
/** Check if 24x7 Midas Availability Feature is on   */                                   /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CHGVAR     VAR(&SAR)  VALUE('CSC011')                                        /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSC011*/
                                                                                          /*CSC011*/
/** If CSC011 is present and the user is in support system, bypass  */                    /*CSC011*/
/** the creation of OTC confirmation. */                                                  /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC011*/
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)                             /*CSC011*/
                IF         COND(&CURR *EQ &SUPP) THEN(GOTO +
                           CMDLBL(SKIPCONF))                                              /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/* Produce OTC confirmations                             */
 
/*           IF         COND(&PROGRAM *EQ 'FFOTCCSIN' *OR &PROGRAM + */                   /*CAP166*/
/*                        *EQ 'FFOTCCRPR') THEN(DO)                  */                   /*CAP166*/
             IF         COND(&PROGRAM *EQ 'FFOTCCSIN' *OR &PROGRAM +
                          *EQ 'FFOTCCRPR' *OR &PROGRAM *EQ +
                          'FFOTCOSIN' *OR &PROGRAM *EQ 'FFOTCORPR') +
                          THEN(DO)                                                        /*CAP166*/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR)  VALUE('CFF001')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
 
             IF         COND(&RTCD *EQ '       ') THEN(DO)
             RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&FFSTAT)
             IF         COND(%SUBSTRING(&FFSTAT 37 1) *NE 'Y') +
                        THEN(DO)
                CHGDTAARA  DTAARA(FFSTAT (37 1)) VALUE('Y')
                CALL       PGM(FF0582)
                CHGDTAARA  DTAARA(FFSTAT (37 1)) VALUE('N')
             ENDDO
             ENDDO
             ENDDO
 
 
             ENDDO
                                                                                          /*CSC011*/
SKIPCONF:                                                                                 /*CSC011*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*   RELEASE ANY LOCKS                                            */
 
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXXX00)) +
                     *AND (&CRE020 = 'Y')) THEN(DO)                                       /*CRE020*/
                                                                                          /*CRE020*/
          IF         COND(&PROGRAM *EQ 'FFOTCCSIN' +
                     *OR &PROGRAM *EQ 'FFOTCCRPR') THEN(DO)                               /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FFOTCCSIN FF)') INLLIBL(*JOBD) MSGQ(MOPERQ)                    /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
          IF         COND(&PROGRAM *EQ 'FFOTCOSIN' +
                     *OR &PROGRAM *EQ 'FFOTCORPR') THEN(DO)                               /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FFOTCOSIN FF)') INLLIBL(*JOBD) MSGQ(MOPERQ)                    /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
ENDPGM:
 
             ENDPGM
