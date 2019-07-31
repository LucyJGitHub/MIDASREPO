/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Change journal receivers')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                       */
/*                                                                  */
/*       SCC1716 - CHANGE JOURNAL RECEIVER(S)                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097467          Date 04Apr13              */
/*                      CLE134             Date 01Aug12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 23May08              */
/*                      247401             Date 31May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      CER001             Date 25Apr05              */
/*                      BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC020             Date 31Mar03              */
/*                      CRE008             Date 19Feb02              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180491             Date 20Jun00              */
/*                      CCB009             Date 01Jun00              */
/*                      CDE001             Date 12Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      131412             Date 03Mar98              */
/*                      CLE004             Date 02May97              */
/*                      095456             DATE 06NOV95              */
/*                      CCM002             DATE 04SEP95              */
/*                      076466             DATE 20SEP94              */
/*                      S01495             DATE 01OCT94              */
/*                       S01343           DATE  15AUG91             */
/*                       E81129           DATE  13/04/87            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097467 - Expected 15% COB run optimization not met       */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BG18886 - Amend non-standard codes.                        */
/*       247401 - Journal sequence number should not be reset.       */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*                PBROLL fix from LUX applied                        */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CRE008 - Cash Management                                    */
/*       CSC018 - Journaling options for High Availability           */
/*       CSC011 - 24x7 Midas Availability                           */
/*       180491 - Journal files throughout close of business         */
/*       CCB009 - Journal files throughout close of business         */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       131412 - LEDRIP is not deallocated in correct place        */
/*                stops LEC2016 from starting after COB             */
/*       CLE004 - Customer Lending Enhancements - Syndications      */
/*                Tranche II.                                       */
/*       095456 - Sending of termination entries to Citydealer       */
/*                transaction extract program does not need to be    */
/*                conditioned on Exposure Management being off as    */
/*                the files are different and mutually exclusive.    */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, the Citydealer transactions      */
/*                extract will either be paused or stopped.  If the  */
/*                background jobs are to be stopped, it will end the */
/*                Citydealer transmission handler process.           */
/*          076466 - WAIT UNTIL HAF HAS FINISHED                    */
/*          S01495 - COB enhancements.                              */
/*          S01343 - SC/RR/SD MODULE RENAME PROJECT.                */
/*                   - SCC1716 RENAMED FROM SDC1716.                */
/********************************************************************/
             PGM        PARM(&PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
/************DCL********VAR(&DRIN)*TYPE(*CHAR)*LEN(1)***************************************CSC020*/
/*********** DCL        VAR(&AREC) TYPE(*CHAR) LEN(3)                                       CSC020*/
/*********** DCL        VAR(&NAREC) TYPE(*DEC) LEN(3)                                       CSC020*/
             DCL        VAR(&AREC) TYPE(*CHAR) LEN(8)                                     /*CSC020*/
             DCL        VAR(&NAREC) TYPE(*DEC) LEN(8)                                     /*CSC020*/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                /*E81129*/
             DCL        VAR(&EMMOD) TYPE(*CHAR) LEN(1)                /*E81129*/
             DCL        VAR(&EMUPD) TYPE(*CHAR) LEN(1)                /*E81129*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2)                 /*076466*/
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CCM002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5) VALUE(32)      /*CCM002*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(32) +
                          VALUE('END     0000000000000000000000NY')   /*CCM002*/
             DCL        VAR(&LEDRIP) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE004*/
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE001*/
             DCL        VAR(&CRE008) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CRE008*/
/***********************************************************************CCB009**************CSC020*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature****************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************DCL********VAR(&CCB009)*TYPE(*CHAR)*LEN(7)*****************CCB009**************CSC020*/
/************DCL********VAR(&AOFMT)*TYPE(*CHAR)*LEN(200)****************CCB009**************CSC020*/
/*                                                                      CCB009*/
/* Declare current and next receivers and number fields                 CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&MX1RTNRCV) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&MX1NXTRCV) TYPE(*CHAR) LEN(10)           /*CCB009*/
/************DCL        VAR(&MX1ANUMB) TYPE(*CHAR) LEN(3)               CCB009**************CSC020*/
             DCL        VAR(&MX1ANUMB) TYPE(*CHAR) LEN(8)                                 /*CSC020*/
/************DCL        VAR(&MX1NUMB) TYPE(*DEC) LEN(3 0)               CCB009**************CSC020*/
             DCL        VAR(&MX1NUMB) TYPE(*DEC) LEN(8 0)                                 /*CSC020*/
/*                                                                      CCB009*/
/**Declare*value*of*MPHAS**********************************************         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&E40MPHAS) TYPE(*CHAR) LEN(1)                       */ /*CCB009 CCB020*/
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling options for High Availability                /*CSC018*/
/*                                                                                        /*CSC018*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
/**********  DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                         */ /*CSC018 CCB020*/
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)                                 /*CSC018*/
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*SHA003*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CSTAT) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/*/COPY WNCPYSRC,SCC1716001                                          */
/**/
/* GLOBAL MONITOR MESSAGES */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/***********************************************************************CCB009**************CSC020*/
/***Check*for*Switchable*feature*CCB009.********************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************CALL*******PGM(AOSARDR0)*PARM(&CCB009*'*VERIFY'*+******************************CSC020*/
/*************************'CCB009'*&AOFMT)******************************CCB009**************CSC020*/
/*                                                                                        /*CSC018*/
/***Check*for*Switchable*feature*CSC018.*******************************         */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**********  CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                      */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' (Journal options for high availability),                     /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND(&CSC018 *EQ '       ') THEN(DO)                    */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CCB020*/
/* Check if the system is in COB Phase */                                                 /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                                          /*CCB020*/
/**********  CALL       PGM(AOCOMSR0) PARM('SCC1711' '00001' &CSTAT)            /*CCB020 AR1097467*/
             CALL       PGM(AOCOMSR0) PARM('SCC1711001' '00001' &CSTAT)                /*AR1097467*/
                                                                                          /*CCB020*/
                                                                                          /*CSC018*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'HighAvlRmtJrnActive' &SVAL1 +
                          'HighAvlIgnTgtOnDel' &SVAL2 +
                          'HighAvlMangBackUpJrn' &SVAL3 +
                          'HighAvlDdmFileName' &SVAL4 +
                          'HighAvlDdmFileLib' &SVAL5 &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 &SVALK9 +
                          &SVAL9 &SVALK10 &SVAL10)                                        /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file name.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL4 1 10))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file library name.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL5 1 10))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether remote journaling is being used                                     /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL1 1 1))                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If remote journaling is being used,                                                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether to ignore target receivers when deleting.                            /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL2 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote journaling journal library.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*CSC018*/
              CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'JLIBRMT ')                      /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO
/*                                                                                        /*CSC018*/
/*  Determine whether backup journal management is being used                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup receiver management is being used,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the backup journal library.                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CSC018*/
             CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')                       /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
CSC018END:                                                                                /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**/
/************SNDPGMMSG  MSG('Change Journal Receivers') +          */ /*S01495*/
/************           TOMSGQ(MRUNQ)                              */ /*S01495*/
/**/
/*/COPY WNCPYSRC,SCC1716002                                          */
/************RTVDTAARA**DTAARA(JNSTAT*(68*1))*RTNVAR(&DRIN)*********************************CSC020*/
/**********  RTVDTAARA  DTAARA(JNSTAT (6 3)) RTNVAR(&AREC)                                  CSC020*/
             RTVDTAARA  DTAARA(JNSTAT (3 8)) RTNVAR(&AREC)                                /*CSC020*/
/**/
             CHGVAR     VAR(&NAREC) VALUE(&AREC)
/**/                                                                  /*E81129*/
/*  IF EXPOSURE MANAGEMENT MODULE IS PRESENT AND UPDATING IS       */ /*E81129*/
/*  ACTIVE THEN STOP UPDATING IF PHASE IS 'B'/'X' OR PAUSE         */ /*E81129*/
/*  IF PHASE IS 'A'.                                               */ /*E81129*/
             RTVDTAARA  DTAARA(MMOD (7 1)) RTNVAR(&EMMOD)             /*E81129*/
/**/                                                                  /*CCM002*/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active, retrieve the values in       /*CCM002*/
/*    data area MPHAS and DLCDSTAT.                                   /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If &CDSTAT is set to 'Y' and &PHASE is set to 'X' or 'B',       /*CCM002*/
/*    send the message to the data queue.                             /*CCM002*/
/**/                                                                  /*CCM002*/
/**********    IF         COND(%SST(&CDSTAT 1 1) *EQ 'Y') THEN(IF +
                            COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                            THEN(CALL PGM(QSNDDTAQ) PARM('DLCDDTAQ' +
                            '*LIBL' &LENGTH &MESSAGE)))                         */ /*CCM002 CCB020*/
             IF         COND(%SST(&CDSTAT 1 1) *EQ 'Y') THEN(IF +
                          COND(&PHASE *EQ 'X' *OR &CSTAT *EQ 'P   ') +
                          THEN(CALL PGM(QSNDDTAQ) PARM('DLCDDTAQ' +
                          '*LIBL' &LENGTH &MESSAGE)))                                     /*CCB020*/
             ENDDO                                                    /*CCM002*/
/**/                                                                  /*CCM002*/
/*If*Citydealer*Interface*is*active*and*Exposure*Management**CCM002*/ /*095456*/
/*is*not*used*and*&CDSTAT*is*set*to*'Y',*check*the*PHASE*and*CCM002*/ /*095456*/
/*send*appropriate*Journal*entry.****************************CCM002*/ /*095456*/
/*    If Citydealer Interface is active and &CDSTAT is set to 'Y',    /*095456*/
/*    check the PHASE and send appropriate Journal entry.             /*095456*/
/**/                                                                  /*CCM002*/
/****IF*****    COND(&CITYDLR *EQ 'Y' *AND &EMMOD *NE 'Y' +**CCM002*/ /*095456*/
/***********    *AND %SST(&CDSTAT 1 1) *EQ 'Y') THEN(DO)  ***CCM002*/ /*095456*/
/**********  IF         COND(&CITYDLR *EQ 'Y' +  */                                       /*CSC011*/
/**********               *AND %SST(&CDSTAT 1 1) *EQ 'Y') THEN(DO) */ /*095456*/          /*CSC011*/
/*/COPY WNCPYSRC,SCC1716003                                          */
/**********    IF         COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                            THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                            ENTDTA('STOP CD UPDATE') FILE(SDBANKPD)) */       /*CCM002*/ /*BUG9619*/
/**********    IF         COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                          THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                          ENTDTA('STOP CD UPDATE') FILE(SDBANKPD) +
                          FORCE(*YES))                                         */ /*BUG9619 CCB020*/
             IF         COND(&PHASE *EQ 'X' *OR &CSTAT *EQ 'P   ') +
                          THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                          ENTDTA('STOP CD UPDATE') FILE(SDBANKPD) +
                          FORCE(*YES))                                                    /*CCB020*/
/**********    IF         COND(&PHASE *EQ 'A') THEN(SNDJRNE +
                            JRN(ICJRN) TYPE('XJ') ENTDTA('PAUSE CD +
                            UPDATE') FILE(SDBANKPD)) */                       /*CCM002*/ /*BUG9619*/
/**********    IF         COND(&PHASE *EQ 'A') THEN(SNDJRNE JRN(ICJRN) +
                            TYPE('XJ') ENTDTA('PAUSE CD UPDATE') +
                            FILE(SDBANKPD) FORCE(*YES))                        */ /*BUG9619 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(SNDJRNE +
                          JRN(ICJRN) TYPE('XJ') ENTDTA('PAUSE CD +
                          UPDATE') FILE(SDBANKPD) FORCE(*YES))                            /*CCB020*/
/*/COPY WNCPYSRC,SCC1716004                                          */
/**********  ENDDO  */                                                             /*CCM002 CSC011*/
/**/                                                                  /*CCM002*/
             IF         COND(&EMMOD *EQ 'Y') THEN(DO)                 /*E81129*/
                RTVDTAARA  DTAARA(EMSTAT (2 1)) RTNVAR(&EMUPD)        /*E81129*/
                IF         COND(&EMUPD *EQ 'Y') THEN(DO)              /*E81129*/
                   RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)            /*E81129*/
/*/COPY WNCPYSRC,SCC1716005                                          */
/**********        IF         COND((&PHASE *EQ 'X') +
                                *OR (&PHASE *EQ 'B')) THEN(DO)                  */ /*E81129 CCB020*/
             IF         COND((&PHASE *EQ 'X') *OR (&CSTAT *EQ 'P   +
                          ')) THEN(DO)                                                    /*CCB020*/
/**********           SNDJRNE JRN(ICJRN) TYPE('XE') FILE(TABTB10) +
                                   ENTDTA('STOP EM UPDATE') */                /*E81129*/ /*BUG9619*/
                      SNDJRNE    JRN(ICJRN) TYPE('XE') ENTDTA('STOP EM +
                          UPDATE') FILE(TABTB10) FORCE(*YES)                             /*BUG9619*/
                   ENDDO                                              /*E81129*/
/**********        IF         COND(&PHASE *EQ 'A') THEN(DO)                     */ /*E81129 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
/**********           SNDJRNE JRN(ICJRN) TYPE('XJ') FILE(TABTB10) +
                                   ENTDTA('PAUSE EM UPDATE') */               /*E81129*/ /*BUG9619*/
                      SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('PAUSE EM +
                          UPDATE') FILE(TABTB10) FORCE(*YES)                             /*BUG9619*/
                   ENDDO                                              /*E81129*/
/*/COPY WNCPYSRC,SCC1716006                                          */
                ENDDO                                                 /*E81129*/
             ENDDO                                                    /*E81129*/
                                                                      /*CLE004*/
/**/                                                                  /*CLE004*/
/*    Check if Switchable feature CLE004 is active.                   /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*CLE004*/
             CHGVAR     VAR(&SARREC) VALUE(' ')                       /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&LEDRIP) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CDE001*/
/*    Check if CCRM - Limits is active (CDE001)                       /*CDE001*/
/**/                                                                  /*CDE001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDE001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE001*/
             CHGVAR     VAR(&SAR) VALUE('CDE001')                     /*CDE001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CDE001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))                    /*CDE001*/
/**/                                                                  /*CRE008*/
/*    Check if Cash Management is active (CRE008)                     /*CRE008*/
/**/                                                                  /*CRE008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CRE008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CRE008*/
             CHGVAR     VAR(&SAR) VALUE('CRE008')                     /*CRE008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CRE008*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE008) VALUE('Y'))                    /*CRE008*/
/*                                                                    /*CLE004*/
/* Try and allocate LEDRIP - if it fails Lending Drip Feed Transfer   /*CLE004*/
/* job is in action, check the phase and send appropriate Journal     /*CLE004*/
/* entry                                                              /*CLE004*/
/*                                                                    /*CLE004*/
        IF         COND(&LEDRIP *EQ 'Y') THEN(DO)                     /*CLE004*/
                                                                      /*CLE004*/
            ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))                  /*CLE004*/
            MONMSG     MSGID(CPF0000) EXEC(DO)                        /*CLE004*/
/**********     RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                         */ /*CLE004 CCB020*/
/**********     IF         COND(&PHASE *EQ 'A') THEN(DO)                        */ /*CLE004 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
 /**********       SNDJRNE    JRN(ICJRN) TYPE('YJ') ENTDTA('PAUSE LE +
                          UPDATE') FILE(SDCLNDPD) */                          /*CLE004*/ /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('YJ') ENTDTA('PAUSE LE +
                          UPDATE') FILE(SDCLNDPD) FORCE(*YES)                            /*BUG9619*/
                ENDDO                                                 /*CLE004*/
/**********     IF         COND(&PHASE *EQ 'B') THEN(DO)                        */ /*CLE004 CCB020*/
             IF         COND(&CSTAT *EQ 'P   ') THEN(DO)                                  /*CCB020*/
 /**********       SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE +
                          UPDATE') FILE(SDCLNDPD) */                          /*CLE004*/ /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE +
                          UPDATE') FILE(SDCLNDPD) FORCE(*YES)                            /*BUG9619*/
                ENDDO                                                 /*CLE004*/
                                                                      /*CLE004*/
             ENDDO                                                    /*131412*/
                DLCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))              /*CLE004*/
                MONMSG     MSGID(CPF0000)                             /*CLE004*/
/************ENDDO                                                    /*CLE004*/ /*131412*/
        ENDDO                                                         /*CLE004*/
                                                                      /*CLE004*/
/**/                                                                  /*CLE004*/
/* If the CCRM - Limits Drip Feed job is active, shut it down         /*CDE001*/
/**/                                                                  /*CDE001*/
/**********  IF         COND(&CDE001 *EQ 'Y') +
/**********               THEN(CALL PGM(DEC0040))                              /*CDE001*/ /*180491*/
             IF         COND(&CDE001 *EQ 'Y') THEN(CALL PGM(DEC0040) +
                          PARM('I'))                                                      /*180491*/
                                                                                          /*CRE020*/
/** Check if MidasPlus Online Printing of Advices is on */                                /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&SAR) VALUE('CRE020')                                         /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)                      /*CRE020*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                                          /*CRE020*/
/** If the APIs Retail Advices job is active, shut it down */                             /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0470)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/                                                                  /*CRE008*/
/* If the Cash Management batch jobs are active, shut them down       /*CRE008*/
/**/                                                                  /*CRE008*/
             IF         COND(&CRE008 *EQ 'Y') THEN(DO)                /*CRE008*/
             CALL       PGM(REC101203)                                /*CRE008*/
             CALL       PGM(REC101503)                                /*CRE008*/
             ENDDO                                                    /*CRE008*/
/**/                                                                                     /*BUG2381*/
/* If the APIs Confirmations job is active, shut it down                                 /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0440)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&CCB009**EQ*'*******')*THEN(DO)************CCB009**************CSC020*/
/*                                                                      CCB009*/
/* Determine value of data area MPHAS.                                  CCB009*/
/*                                                                      CCB009*/
/**********  RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&E40MPHAS)                    */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/* Delete the next journal receiver in sequence.                        CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RTNRCV(&MX1RTNRCV)                 /*CCB009*/
/**********  CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 6 3))     *CCB009**************CSC020*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 3 8))                        /*CSC020*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1ANUMB)                /*CCB009*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1NUMB + 1)             /*CCB009*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(&MX1NUMB)                /*CCB009*/
/**********  CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 5) +
                          *CAT &MX1ANUMB *CAT '  ')                    *CCB009**************CSC020*/
             CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 2) +
                          *CAT &MX1ANUMB)                                                 /*CSC020*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on', (journal features for high availability),                   /*CSC018*/
/* and if remote journaling is being used and if 'Ignore                                  /*CSC018*/
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                   /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND((&CSC018 *EQ '       ') *AND (&RMTJR6 +
                          *EQ 'Y') *AND (&IGNTG6 *EQ 'Y')) THEN(DO)             */ /*CSC018 CCB020*/
             IF         COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO)                                                  /*CCB020*/
             DLTJRNRCV  JRNRCV(&MX1NXTRCV) DLTOPT(*IGNTGTRCV)                             /*CSC018*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
             DLTJRNRCV  JRNRCV(&MX1NXTRCV)                            /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             ENDDO                                                                        /*CSC018*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' (journal options for high availability),                     /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND(&CSC018 *EQ '       ') THEN(DO)                    */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &MX1NXTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the remote                   /*CSC018*/
/* journaling library on the other machine.                                               /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                &JLIBBKP *TCAT '/' *CAT &MX1NXTRCV *TCAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete receiver in the                                   /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/***********************************************************************CCB009**************CSC020*/
/**If*dual*receivers*are*being*used,*delete*the*next*receiver*as*well.**CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND(&DRIN**EQ*'Y')*THEN(DO)********************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1NUMB)*VALUE(&MX1NUMB*+*1)***************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1ANUMB)*VALUE(&MX1NUMB)******************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1NXTRCV)*VALUE(%SST(&MX1RTNRCV*1*5)*+************************CSC020*/
/**************************CAT*&MX1ANUMB**CAT*'**')*********************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*DFT)*********************************CCB009**************CSC020*/
/************DLTJRNRCV**JRNRCV(&MX1NXTRCV)******************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000)**********************************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*RQD)*********************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/***********************************************************************CDE001**************CSC020*/
/**'DUAL*RECEIVERS*AT*B.O.B'*INDICATOR*IS*'N'***********************************************CSC020*/
/***THEN*ADD*1*TO*CURRENTLY*ATTACHED*RECEIVER***********************************************CSC020*/
/*******************************************************************************************CSC020*/
/************IF*********COND(&DRIN**EQ*'N')*THEN(DO)****************************************CSC020*/
/**/
/* CHANGE JOURNAL RECEIVER */
/**/
RETRY:                                                                /*076466*/
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/**and*if*the*Midas*phase*is*'B',*then*change*the***********************CCB009**************CSC020*/
/**receiver*management*to*'*SYSTEM'*when*changing*receivers.************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND((&CCB009**EQ*'*******')**AND*(&E40MPHAS*+**********************CSC020*/
/**************************EQ*'B'))*THEN(DO)****************************CCB009**************CSC020*/
/* If the Midas phase is 'B', then change the                                               CSC020*/
/* receiver management to '*SYSTEM' when changing receivers.                                CSC020*/
/*                                                                                          CSC020*/
/**********  IF         COND(&E40MPHAS *EQ 'B') THEN(DO)                        */ /*CSC020 CCB020*/
             IF         COND(&CSTAT *EQ 'P   ') THEN(DO)                                  /*CCB020*/
             CHGJRN     JRN(ICJRN) JRNRCV(*GEN) MNGRCV(*SYSTEM) +
                                                                      /*CCB009*/
             MONMSG     MSGID(CPF9803) EXEC(DO)                       /*CCB009*/
                CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)              /*CCB009*/
             IF         COND(&COUNT *EQ 10) THEN(DO)                  /*CCB009*/
/**********  SNDPGMMSG  MSG('HAF has not finished**** Please +     */ /*CCB009*/ /*BG18886*/
/**********               check***') TOMSGQ(QSYSOPR MOPERQ MRUNQ)  */ /*CCB009*/ /*BG18886*/
             SNDPGMMSG  MSG('HAF has not finished.    Please +
                          check.  ') TOMSGQ(QSYSOPR MOPERQ MRUNQ)     /*CCB009*/ /*BG18886*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*CCB009*/
                CHGVAR     VAR(&COUNT) VALUE(0)                       /*CCB009*/
             ENDDO                                                    /*CCB009*/
             DLYJOB     DLY(60)                                       /*CCB009*/
             GOTO RETRY                                               /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             SCWRTJREG  EVENT(ICTJR) COMP(SCC1711) CMPSEQ(00001) +
                          TEXT('Journal receiver changed input +
                          cycle termination')                                             /*CSC020*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' and backup journal management is being used,                 /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND((&CSC018 *EQ '       ') *AND (&MNGBJ6 +
                          *EQ 'Y')) THEN(DO)                                    */ /*CSC018 CCB020*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CCB020*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN) +
                          MNGRCV(*SYSTEM)')                                               /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/*                                                                      CCB009*/
/* Determine the name of the currently attached receiver.               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNRCV(&MX1RTNRCV)  /*CCB009*/
/************CHGVAR*****VAR(&MX1ANUMB)*VALUE(%SST(&MX1RTNRCV*6*3))******CCB009**************CSC020*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 3 8))                        /*CSC020*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1ANUMB)                /*CCB009*/
/*                                                                      CCB009*/
/* Delete any receivers with higher sequence numbers                    CCB009*/
/* that may be present from the previous close of business.             CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1NUMB + 1)             /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
 DLTRCV:                                                              /*CCB009*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(&MX1NUMB)                /*CCB009*/
/************CHGVAR*****VAR(&MX1RTNRCV)*VALUE('ICRCV'**CAT*+********************************CSC020*/
/*************************&MX1ANUMB)************************************CCB009**************CSC020*/
             CHGVAR     VAR(&MX1RTNRCV) VALUE('IR' *CAT +
                          &MX1ANUMB)                                                      /*CSC020*/
/*                                                                      CCB009*/
/* Continue deleting receivers until all are deleted.                   CCB009*/
/*                                                                      CCB009*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on', (journal features for high availability),                   /*CSC018*/
/* and if remote journaling is being used and if 'Ignore                                  /*CSC018*/
/* Target Receiver' is 'Y', then delete receiver with option *IGNTGTRCV                   /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND((&CSC018 *EQ '       ') *AND (&RMTJR6 +
                          *EQ 'Y') *AND (&IGNTG6 *EQ 'Y')) THEN(DO)             */ /*CSC018 CCB020*/
             IF         COND((&RMTJR6 *EQ 'Y') *AND (&IGNTG6 *EQ +
                          'Y')) THEN(DO)                                                  /*CCB020*/
/*                                                                                        /*CSC018*/
             DLTJRNRCV  JRNRCV(&MX1RTNRCV) DLTOPT(*IGNTGTRCV)                             /*CSC018*/
             MONMSG     MSGID(CPF2105) EXEC(DO)                                           /*CSC018*/
             GOTO       CMDLBL(ENDDLTRCV)                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
             DLTJRNRCV  JRNRCV(&MX1RTNRCV)                            /*CCB009*/
             MONMSG     MSGID(CPF2105) EXEC(DO)                       /*CCB009*/
             GOTO       CMDLBL(ENDDLTRCV)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 (journal options for high availability) is 'on',                     /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND( &CSC018 *EQ '       ') THEN(DO)                   */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &MX1RTNRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the remote                   /*CSC018*/
/* journaling library on the other machine.                                               /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                &JLIBBKP *TCAT '/' *CAT &MX1RTNRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete receiver in the                                   /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1NUMB + 1)             /*CCB009*/
             GOTO       CMDLBL(DLTRCV)                                /*CCB009*/
 ENDDLTRCV:                                                           /*CCB009*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*/COPY WNCPYSRC,SCC1716007                                          */
/**********     CHGJRN     JRN(ICJRN) JRNRCV(*GEN)          */                            /*CER001*/
/**********  CHGJRN     JRN(ICJRN) JRNRCV(*GEN) SEQOPT(*RESET)                     /*CER001 247401*/
             CHGJRN     JRN(ICJRN) JRNRCV(*GEN) SEQOPT(*CONT)                             /*247401*/
             MONMSG     MSGID(CPF9803) EXEC(DO)                       /*076466*/
/*/COPY WNCPYSRC,SCC1716008                                          */
                CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)              /*076466*/
             IF         COND(&COUNT *EQ 10) THEN(DO)                  /*076466*/
/**********  SNDPGMMSG  MSG('HAF has not finished**** Please +       */                  /*BG18886*/
/**********               check***') TOMSGQ(QSYSOPR MOPERQ MRUNQ)    */                  /*BG18886*/
             SNDPGMMSG  MSG('HAF has not finished.     Please +
                          check.  ') TOMSGQ(QSYSOPR MOPERQ MRUNQ)                        /*BG18886*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*076466*/
                CHGVAR     VAR(&COUNT) VALUE(0)                       /*076466*/
             ENDDO                                                    /*076466*/
             DLYJOB     DLY(60)                                       /*076466*/
             GOTO RETRY                                               /*076466*/
             ENDDO                                                    /*076466*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' and backup journal management is being used,                 /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND((&CSC018 *EQ '       ') *AND (&MNGBJ6 +
                          *EQ 'Y')) THEN(DO)                                    */ /*CSC018 CCB020*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CCB020*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN)')                          /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                    /*CCB009*/
                CHGVAR     VAR(&NAREC) VALUE(&NAREC + 1)
/************ENDDO**************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/**'DUAL*RECEIVERS*AT*B.O.B'*INDICATOR*IS*'Y'***********************************************CSC020*/
/***THEN*ADD*2*TO*CURRENTLY*ATTACHED*RECEIVER***********************************************CSC020*/
/*******************************************************************************************CSC020*/
/************IF*********COND(&DRIN**EQ*'Y')*THEN(DO)****************************************CSC020*/
/*******************************************************************************************CSC020*/
/**CHANGE*JOURNAL*RECEIVERS*****************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/*/COPY WNCPYSRC,SCC1716009                                          */
/***********************************************************************CCB009**************CSC020*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),************CCB009**************CSC020*/
/**and*if*the*Midas*phase*is*'B',*then*change*the***********************CCB009**************CSC020*/
/**receiver*management*to*'*SYSTEM'*when*changing*receivers.************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************IF*********COND((&CCB009**EQ*'*******')**AND*(&E40MPHAS*+**********************CSC020*/
/**************************EQ*'B'))*THEN(DO)****************************CCB009**************CSC020*/
/************CHGJRN*****JRN(ICJRN)*JRNRCV(*GEN**GEN)*MNGRCV(*SYSTEM)*+**********************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**Determine*the*name*of*the*currently*attached*receiver.***************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*FROMENT(*LAST)*RTNRCV(&MX1RTNRCV)****CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1ANUMB)*VALUE(%SST(&MX1RTNRCV*6*3))******CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1NUMB)*VALUE(&MX1ANUMB)******************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**Delete*any*receivers*with*higher*sequence*numbers********************CCB009**************CSC020*/
/**that*may*be*present*from*the*previous*close*of*business.*************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1NUMB)*VALUE(&MX1NUMB*+*1)***************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*DFT)*********************************CCB009**************CSC020*/
/*DLTRCV2:**************************************************************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1ANUMB)*VALUE(&MX1NUMB)******************CCB009**************CSC020*/
/************CHGVAR*****VAR(&MX1RTNRCV)*VALUE('ICRCV'**CAT*+********************************CSC020*/
/*************************&MX1ANUMB)************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**Continue*deleting*receivers*until*all*are*deleted.*******************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/**********************************************************************************CSC018***CSC020*/
/**If*Feature*CSC018*is*'on',*(journal*features*for*high*availability),************CSC018***CSC020*/
/**and*if*remote*journaling*is*being*used*and*if*'Ignore***************************CSC018***CSC020*/
/**Target*Receiver'*is*'Y',*then*delete*receiver*with*option**IGNTGTRCV************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************IF*********COND((&CSC018**EQ*'*******')**AND*(&RMTJR6*+************************CSC020*/
/**************************EQ*'Y')**AND*(&IGNTG6**EQ*'Y'))*THEN(DO)****************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************DLTJRNRCV**JRNRCV(&MX1RTNRCV)*DLTOPT(*IGNTGTRCV)**********************CSC018***CSC020*/
/************MONMSG*****MSGID(CPF2105)*EXEC(DO)************************************CSC018***CSC020*/
/************GOTO*******CMDLBL(ENDDLTRCV2)*****************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************ENDDO*****************************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************MONMSG*****MSGID(CPF0000)*********************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************ENDDO*****************************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************ELSE*******CMD(DO)****************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************DLTJRNRCV**JRNRCV(&MX1RTNRCV)******************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF2105)*EXEC(DO)*************************CCB009**************CSC020*/
/************GOTO*******CMDLBL(ENDDLTRCV2)******************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000)**********************************CCB009**************CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************ENDDO*****************************************************************CSC018***CSC020*/
/**********************************************************************************CSC018***CSC020*/
/************CHGVAR*****VAR(&MX1NUMB)*VALUE(&MX1NUMB*+*1)***************CCB009**************CSC020*/
/************GOTO*******CMDLBL(DLTRCV2)*********************************CCB009**************CSC020*/
/*ENDDLTRCV2:***********************************************************CCB009**************CSC020*/
/************CHGJOB*****INQMSGRPY(*RQD)*********************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/************ELSE*******CMD(DO)*****************************************CCB009**************CSC020*/
/***************CHGJRN*****JRN(ICJRN)*JRNRCV(*GEN**GEN)*************************************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*/COPY*WNCPYSRC,SCC1716010*****************************************************************CSC020*/
/***************CHGVAR*****VAR(&NAREC)*VALUE(&NAREC*+*2)************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/**/
/* AMEND JNSTAT */
/**/
             CHGVAR     VAR(&AREC) VALUE(&NAREC)
/*********** CHGDTAARA  DTAARA(JNSTAT (6 3)) VALUE(&AREC)                                   CSC020*/
             CHGDTAARA  DTAARA(JNSTAT (3 8)) VALUE(&AREC)                                 /*CSC020*/
/*/COPY WNCPYSRC,SCC1716011                                          */
             GOTO       CMDLBL(END)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
ABNOR:       IF         COND(&PARM *EQ '1') THEN(DO)
                SNDPGMMSG  MSG('Change Journal Receivers ENDED +
                           ABNORMALLY') TOMSGQ(MOPERQ)                /*S01495*/
/*                         ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)    */    /*S01495*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             IF         COND(&PARM *EQ '0') THEN(DO)
                SNDPGMMSG  MSG('Change Journal Receivers ENDED +
                           ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)   /*S01495*/
 /*                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MRUNQ)    /*S01495*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/*/COPY WNCPYSRC,SCC1716012                                          */
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SCC1716013                                          */
END:         ENDPGM
/*/COPY WNCPYSRC,SCC1716014                                          */
