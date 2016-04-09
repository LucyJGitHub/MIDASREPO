/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Standing Data Audit Lists')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     Standing Data Module                             */
/*                                                                  */
/********SDC0602***UPDATE*THE EXCHANGE RATE                         *   LN0220*/
/*       SDC0602 - PRODUCE S.DATA AUDIT LISTS AND UPDATE LIMIT CCY  *   LN0220*/
/*                 EXCHANGE RATES                                   *   LN0220*/
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL018             Date 29Oct02              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      177440             Date 06Jan03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      195963             Date 13May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    131076            DATE 24FEB98                */
/*                    S01340            DATE 07FEB92                */
/*                    E29035            DATE 23OCT91                */
/*                    S01314            DATE 08APR91                */
/*                    LN0982            DATE 19NOV90                */
/*                    BHF890            DATE 16NOV90                */
/*                    LN0381            DATE 09JUL90                */
/*                    LN0220            DATE 21MAY90                */
/*                    S01189            DATE 06/04/89               */
/*                    S01179            DATE 12/09/88               */
/*                    S01146            DATE 17/11/87               */
/*                    E10746            DATE 23/04/87               */
/*                    S01092            DATE 30/07/86               */
/*                    E80695            DATE 12/06/86               */
/*                    RT      Drop SD0310 for RT test               */
/********************************************************************/
/*                                                                  */
/*     CCB020 - COB Restructure - Secondary COB Infrastructure      */
/*     CGL018 - Risk Weighted Assets                                */
/*     177440 - Add ABNOR processing.                               */
/*     195963 - Deleted broker codes not shown in SD0070P audit     */
/*     131076 - Message file QUSERMSG not found.                    */
/*     S01340 - PRODUCE GENERAL LEDGER AUDIT LISTS TOO              */
/*     E29035 - IF FILE CONTROLS OUT OF BALANCE THEN ONLY SET ON    */
/*              U8 AND SEND ERROR MESSAGE                           */
/*     S01314 - REVIEWED DURING PTF INCORPORATION AND               */
/*                 E22533, S01253 & S01168 ARE NOT APPLICABLE       */
/*     LN0982 - SEND MICROFICHE MESSAGE TO MRUNQ ONLY               */
/*     BHF890 - NOT ALL AUDIT REPORTS WERE BEING PRODUCED           */
/*     LN0381 - Microfich Archiving - New version -                 */
/*              add call to MA0500 (Reset EDDFLG dtaara)            */
/*     LN0220 - CALL THE NEW AUDIT REPORT CONTROL PROGRAM,          */
/*              DROP OLD M/FICHE CODING AND ADD CALL TO             */
/*              FCC06 TO RESET RCF FILES                            */
/*     S01189 - STANDARDISE DATABASE ERROR JOB SWITCH SETTINGS      */
/*     S01179 - AS400 CONVERSION                                    */
/*     S01146 - MICROFICHE ARCHIVING MODULE                         */
/*     E10746 - TO BYPASS THE PROCESSING IN SD0670 USING BCYL       *  *E10746*/
/*              IF DL IS NOT ON THE SYSTEM.                         *  *E10746*/
/*                                                                  */
/*     S01092 - CLEAR PRE-EX TIME ARRAY FILE PRIOR TO SD0670        */
/*                                                                  */
/********************************************************************/
             PGM
/*                                                                            */
             DCL        &SWS          TYPE(*CHAR)  LEN(8)
/*********** DCL ****** &N            TYPE(*CHAR)  LEN(8)  ****LN0381*/
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
/**********  DCL ****** VAR(&ABNML) TYPE(*CHAR) LEN(1) VALUE('0')     /*LN0381*/
/**********  DCL        &SUNDTA       TYPE(*CHAR)  LEN(111)  /*S01146*  LN0220*/
/**********  DCLDTAARA  DTAARA(MPHAS)                               *  *S01179*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*S01179 CCB020*/
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*LN0220*/
             DCL        VAR(&SEQNO) TYPE(*CHAR) LEN(5)                /*LN0220*/
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)                /*LN0220*/
             DCL        VAR(&ENTTY) TYPE(*CHAR) LEN(3)                /*LN0220*/
             DCL        VAR(&SDUSRMSG) TYPE(*CHAR) LEN(10)            /*131076*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*131076*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(25)                 /*131076*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*131076*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*131076*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*131076*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*131076*/
/*********** DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) *******/        /*CGL018*/
/*********** DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) *******/        /*CGL018*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CGL018*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CGL018*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*CGL018*/
             DCL        VAR(&PSEQ) TYPE(*CHAR) LEN(5)                 /*CGL018*/
             DCL        VAR(&PLVL) TYPE(*CHAR) LEN(1)                 /*CGL018*/
             DCL        VAR(&PENT) TYPE(*CHAR) LEN(3)                 /*CGL018*/
/*/COPY WNCPYSRC,SDH00594                                            */
 
 dcl        &rtcd       *char    7  (' ')                   /*LN0381*/
 dcl        &optn       *char    7  ('*FIRST ')             /*LN0381*/
 dcl        &fmt        *char  200                          /*LN0381*/
 dcl        &fiche      *char    1                          /*LN0381*/
 dcl        &optdk      *char    1                          /*LN0381*/
 
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*177440*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*                                                          *LN0381*/
/* Microfich Module active = (&FMT 54) is 'Y'               *LN0381*/
/* Optical Disk Module active = (&FMT 85) is 'Y'            *LN0381*/
                                                           /*LN0381*/
 call   AOMMODR0 parm(&RTCD &OPTN &FMT)                    /*LN0381*/
/* Database error handling                                  *LN0381*/
 IF     cond(&RTCD *ne '       ') then(DO)                 /*LN0381*/
        sndpgmmsg  msg('Error on access to ICD file +
                  AOMMODPD') TOMSGQ(MRUNQ MOPERQ)          /*LN0381*/
        chgjob sws(XXXXXX11)                               /*LN0381*/
     GOTO CMDLBL(ABNOR)                                               /*177440*/
/*******goto ENDCLPGM                                          /*LN0381 177440*/
 ENDDO                                                     /*LN0381*/
                                                           /*LN0381*/
 chgvar &FICHE  (%SST(&FMT 54 1))                          /*LN0381*/
 chgvar &OPTDK  (%SST(&FMT 85 1))                          /*LN0381*/
 
/*/COPY WNCPYSRC,SDH00595                                            */
/**/                                                                  /*LN0220*/
/* CALL FCC06 TO RESET RCF FILE/DATA AREA FOR PERIODIC REPORTS          LN0220*/
             CALL       PGM(FCC06)                                    /*LN0220*/
/**/                                                                  /*LN0220*/
/* IF A DATABASE ERROR OCCURS IN FCC06 END THE PROGRAM                  LN0220*/
             IF         (%SWITCH(XXXXXX11)) THEN(DO)                  /*LN0220*/
             GOTO       CMDLBL(ABNOR)                                 /*177440*/
/********************GOTO       ENDCLPGM                       /*LN0220 177440*/
             ENDDO                                                    /*LN0220*/
/**/                                                                  /*LN0220*/
/*                                                                  */
/**********  RCVDTAARA  DTAARA(MPHAS)                               *  *S01179*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*S01179 CCB020*/
/**********  RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
             CHGVAR     &MSG VALUE(' UPDATE OF EXCHANGE RATES TO LIMIT +
                          CURRENCY EXECUTING')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
/*                                                                  */
/*                                                                            */
             CLRPFM     FILE(TABTG30)                                 /*S01092*/
             OVRDBF     FILE(TABLE) TOFILE(TABSDU)
             OVRDBF     FILE(PHASD) TOFILE(PHASA)
             CHGJOB     SWS(00000000)
/*                                                                  *  *E10746*/
             IF         COND(%SST(&MMOD 2 1) *EQ 'Y') THEN(DO)        /*E10746*/
             CHGJOB     SWS(1XXXXXXX)                                 /*E10746*/
             ENDDO                                                    /*E10746*/
/*                                                                  *  *E10746*/
             CALL       SD0670
/*                                                                  *  *E10746*/
             CHGJOB     SWS(0XXXXXXX)                                 /*E10746*/
/*                                                                  *  *E10746*/
             IF         (%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE +
                        IN ERROR')
             SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)                /*E80695*/
/*           SNDMSG     TOMSGQ(&JOB) MSG(&MSG)                      *  *E80695*/
/************GOTO       ENDCLPGM                                      /*177440*/
             ENDDO
             DLTOVR     (*ALL)
/* MICROFICHE PROCESSING - REQUIREDIFSUNDTAPRESENT&NON-BLANK S01146    *LN0220*/
/************RTVDTAARA  DTAARA(SUNDTA *ALL) RTNVAR(&SUNDTA) *S01146*/ /*LN0220*/
/************MONMSG     MSGID(CPF1015)                      *S01146*/ /*LN0220*/
/************IF         COND(&SUNDTA *NE ' ') THEN(DO)      *S01146*/ /*LN0220*/
/************   CHGVAR     &MSG VALUE(' MICROFICHE COB SETUP*S01146*/ /*LN0220*/
/************   SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)          *S01146*/ /*LN0220*/
/************                                               *S01146*/ /*LN0220*/
/************   CHGJOB     SWS(00000000)                    *S01146*/ /*LN0220*/
/************                                            *  *S01146*/ /*LN0220*/
/************                                            *  *S01146*/ /*LN0220*/
/************   CALL       PGM(MAS00R)                      *S01146*/ /*LN0220*/
/************                                            *  *S01146*/ /*LN0220*/
/************                                            *  *S01146*/ /*LN0220*/
/************   IF         (%SWITCH(XXXXXX11)) THEN         *S01146*/ /*LN0220*/
/************      CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE +  LN0220*/
/************                   IN ERROR')                  *S01146*/ /*LN0220*/
/************      SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG *S01146*/ /*LN0220*/
/************      GOTO       ENDCLPGM                      *S01146*/ /*LN0220*/
/************   ENDDO                                       *S01146*/ /*LN0220*/
/************ENDDO                                          *S01146*/ /*LN0220*/
 
/* Optical Disk and/or                                        *LN0381*/
/* Microfiche Processing -                                    *LN0381*/
/*                        Set up Collation Frequency Dataara  *LN0381*/
 
   IF    ((&fiche *EQ 'Y') *or +
          (&optdk *EQ 'Y'))     +
       then(DO)                                              /*LN0381*/
 
          chgvar   &MSG  ('MICROFICHE COB PROCESSING, +
                           setup Collation Frequencies')     /*LN0381*/
/******** sndmsg   tomsgq(MRUNQ MOPERQ) msg(&MSG)      LN0381/*LN0982*/
          SNDMSG     MSG(&MSG) TOMSGQ(MRUNQ)                 /*LN0982*/
 
/* reset EDDFLG                                               *LN0381*/
          chgjob   sws(XXXXXX00)                             /*LN0381*/
          call     MA0500                                    /*LN0381*/
          IF       (%SWITCH(XXXXXX11)) +
                then(DO)                                     /*LN0381*/
                   chgvar   &msg (' JOB TERMINATED - +
                                  DATABASE IN ERROR')        /*LN0381*/
                   sndmsg   tomsgq(MRUNQ MOPERQ) msg(&MSG)   /*LN0381*/
                   goto       ABNOR                          /*177440*/
/******************goto       ENDCLPGM                /*LN0381 177440*/
                ENDDO                                        /*LN0381*/
       ENDDO                                                 /*LN0381*/
 
/*                                                                  */
             CHGVAR     &MSG VALUE(' UPDATED TABLES REPORTS EXECUTING')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
             CHGJOB     SWS(10000000)
             CHGVAR     &MSG VALUE(' SELECT TABLES FOR PRINTING')
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)
/*                                                                  */
/*           OVRDBF     FILE(TABLEP) TOFILE(TABSDU)              */   /*RT*/
/*           IF         COND(%SST(&MMOD 16 1) *EQ 'Y') THEN(CALL */   /*RT*/   +
/*                        PGM(SD0310) PARM('Y'))                 */   /*RT*/
/*           ELSE       CMD(CALL PGM(SD0310) PARM(' '))          */   /*rt*/
/*           DLTOVR     (*ALL)                                   */   /*rt*/
/*                                                               */
/* BECAUSE SDFCTLL1 IS USED AT SEVERAL DIFFERENT PROGRAM LEVELS  */   /*BHF890*/
/* SHARE OPEN DATA PATH MUST BE CHANGED TO *NO SO THAT THE FILE'S*/   /*BHF890*/
/* POINTER IN THE FIRST PROGRAM IS NOT CHANGED BY LOWER PROGRAMS */   /*BHF890*/
             OVRDBF     FILE(SDFCTLL1) SHARE(*NO)                     /*BHF890*/
             CLRPFM     FILE(SDBRKDPD)                                /*195963*/
/* CALL THE NEW AUDIT REPORT CONTROL PROGRAM                            LN0220*/
             CALL       PGM(SF0410) PARM(&GROUP &USR &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*131076*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*131076*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*131076*/
             ENDDO                                                    /*131076*/
             CHGVAR     VAR(&SDUSRMSG) VALUE(&MULT *CAT 'SDUSRMSG')   /*131076*/
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&SDUSRMSG)              /*131076*/
             CALL       PGM(SD0541X) PARM(&RTNCDE &SEQNO &LEVEL +
                          &ENTTY)                                     /*LN0220*/
             DLTOVR     FILE(QUSERMSG)                                /*131076*/
             DLTOVR     FILE(SDFCTLL1)                                /*BHF890*/
             RTVJOBA    SWS(&SWS)
/************IF         (%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)       /*E29035*/
             IF         (%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)      /*E29035*/
/************CHGJOB     SWS(XXXXXX1X) */                   /*S01189*/ /*E29035*/
             CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE IN ERROR')
             SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)                /*E80695*/
/*           SNDMSG     TOMSGQ(&JOB) MSG(&MSG)                      *  *E80695*/
/************GOTO       ENDCLPGM                                      /*177440*/
             GOTO       ABNOR                                         /*177440*/
 ENDD001:    ENDDO
 
             IF         (%SUBSTRING(&SWS 7 2) *EQ '01') THEN(DO)      /*E29035*/
                CHGVAR     VAR(&MSG) VALUE(' FILE CONTROLS OUT OF +
                             BALANCE')                                /*E29035*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*E29035*/
             GOTO CMDLBL(ABNOR)                                       /*177440*/
/************GOTO       ENDCLPGM                                      /*177440*/
             ENDDO                                                    /*E29035*/
/*/COPY WNCPYSRC,SDH00596                                            */
/**/                                                                  /*S01340*/
/* OVERRIDE SDFCTL LOGICALS TO GLFCTL AS THE SAME PROGRAMS       */   /*S01340*/
/* PROCESS THE REPORTS FOR BOTH MODULES.                         */   /*S01340*/
             OVRDBF     FILE(SDFCTLL1) TOFILE(GLFCTLL1) SHARE(*NO)    /*S01340*/
             OVRDBF     FILE(SDFCTLL0) TOFILE(GLFCTLL0)               /*S01340*/
/* CALL THE NEW GL AUDIT REPORT CONTROL PROGRAM                         S01340*/
             CALL       PGM(GL0930) PARM(&RTNCDE &SEQNO &LEVEL +
                          &ENTTY)                                     /*S01340*/
             DLTOVR     FILE(SDFCTLL1 SDFCTLL0)                       /*S01340*/
/* CGL018 start */
 
/*  Check if feature on                                              */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CGL018')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
             GOTO       CMDLBL(POSTRWA)
             ENDDO
 
             CHGVAR     VAR(&MODE) VALUE('A')
 
/*  RWA Sets Audit Report                                            */
             CHGVAR     VAR(&PSEQ) VALUE('     ')
             CALL       PGM(SD001244) PARM(&RTCD &MODE &PSEQ &PLVL &PENT)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             GOTO       CMDLBL(POSTRWA)
             ENDDO
 
/*  RWA Codes Audit Report                                           */
             CHGVAR     VAR(&PSEQ) VALUE('     ')
             CALL       PGM(SD001246) PARM(&RTCD &MODE &PSEQ &PLVL &PENT)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             GOTO       CMDLBL(POSTRWA)
             ENDDO
 
/*  RWA Netting Groups Audit Report                                  */
             CHGVAR     VAR(&PSEQ) VALUE('     ')
             CALL       PGM(GL001247) PARM(&RTCD &MODE &PSEQ &PLVL &PENT)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             GOTO       CMDLBL(POSTRWA)
             ENDDO
 
POSTRWA:
 
/* CGL018 end */
             RTVJOBA    SWS(&SWS)
             IF         (%SUBSTRING(&SWS 7 2) *EQ '11') THEN(DO)      /*S01340*/
             CHGVAR     &MSG VALUE(' JOB TERMINATED - DATABASE IN ERROR')
             SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)                /*S01340*/
             GOTO       ENDCLPGM                                      /*S01340*/
 ENDD002:    ENDDO                                                    /*S01340*/
/**/                                                                  /*S01340*/
             IF         (%SUBSTRING(&SWS 7 2) *EQ '01') THEN(DO)      /*S01340*/
                CHGVAR     VAR(&MSG) VALUE(' FILE CONTROLS OUT OF +
                             BALANCE')                                /*S01340*/
                SNDMSG     TOMSGQ(MRUNQ MOPERQ) MSG(&MSG)             /*S01340*/
                GOTO       CMDLBL(ABNOR)                              /*177440*/
             ENDDO                                                    /*S01340*/
/*                                                                */  /*S01340*/
             GOTO       CMDLBL(ENDCLPGM)                              /*177440*/
                                                                      /*177440*/
 ABNOR:                                                               /*177440*/
                                                                      /*177440*/
             SNDPGMMSG  MSG('SDC0602 Standing Data Audit/Update of +
                          Limit Ccy Exchange Rates ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             DMPCLPGM                                                 /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
             CHGJOB     SWS(XXXXXX11)                                 /*177440*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*177440*/
 ENDCLPGM:
             RETURN
             ENDPGM     /* END CL PGM */
