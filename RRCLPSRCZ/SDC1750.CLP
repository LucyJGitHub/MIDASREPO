/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RR Transfer database to secondary machine')     */
/*********************************************************************/
/*                                                                   */
/*        Midas - Restart Recovery Module                            */
/*                                                                   */
/*       SDC1750 - INITIAL SETUP OF BACKUP MACHINE                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/*                      CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180491             Date 20Jun00              */
/*                      CDE001             Date 12Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE004             Date 11May97              */
/*                      096935             Date 29Mar96              */
/*                      095590             DATE 29MAR96              */
/*                      CCM002             DATE 04SEP95              */
/*                      S01408             DATE 10MAY95              */
/*                      S01345             DATE 06NOV91              */
/*                      S01343               DATE  15AUG91          */
/*                      RT0138               DATE  24JUN91          */
/*                      S01194               DATE  21FEB90          */
/*                      E13205               DATE  13/03/89         */
/*                      E14638               DATE  26/08/88         */
/*                      S01179               DATE  13/09/88         */
/*                      S01173               DATE  30/06/88         */
/*                      S01133               DATE  14/05/87         */
/*                      E80904               DATE  20/03/87         */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastracture     */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       180491 - Add mode parameter to DEC0040 call.                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       096935 - Ensure that commonly used Access Objects close.   */
/*       095590 - Monitor for both 'C' and 'c' reply to cancel.     */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, the Citydealer transactions      */
/*                extract will either be paused or stopped.  If the  */
/*                background jobs are to be stopped, it will end the */
/*                Citydealer transmission handler process.           */
/*       S01408 - Addition of core hook SDC1750INT                  */
/*              - Addition of core hook SDC1750MP1                  */
/*              - Addition of core hook SDC1750MP2                  */
/*              - Addition of core hook SDC1750MP3                  */
/*              - Addition of core hook SDC1750MP4                  */
/*              - Addition of core hook SDC1750MP5                  */
/*              - Addition of core hook SDC1750MP6                  */
/*              - Addition of core hook SDC1750MP7                  */
/*       S01345 - JOURNALLING SYSTEM RE-WRITE.                      */
/*                                                                  */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SDC01 RENAMED TO SCC01                          */
/*                                                                  */
/*       RT0138 - Abnormal termination should prompt re-try screen  */
/*                so that media errors can be dealt with.           */
/*                                                                  */
/*       S01194 - NEW STANDING DATA                                 * /*S01194*/
/*                                                                  */
/*       E13205 -  Call SDC1774 instead of SDC1724                  * /*E13205*/
/*                Apply fix E80902. Chgjob *dft instead *SYSRPLY    * /*E13205*/
/*                ASP identifier is 2 bytes long                    * /*E13205*/
/*                Delete receiver NEWM001 after restore if it exists* /*E13205*/
/*                                                                  */
/*       E14638 -  CHECK IF EM0100 IS RUNNING BEFORE DOING THE      *  *E14638*/
/*                 INITIAL SETUP OF BACKUP MACHINE.  ALSO DELAY     *  *E14638*/
/*                 THE SETUP FOR 4 MINUTES TO GIVE EM0100 A CHANCE  *  *E14638*/
/*                 TO TERMINATE ITSELF NORMALLY.                    *  *E14638*/
/*       S01179  -  AS400 CONVERSION                                */
/*       S01173  -  USE SPECIFIED ASP FOR JOURNAL/RECIEVER          *  *S01173*/
/*       S01133  -  ADDS CALLS TO PROCESSING TO COPE WITH MULTI-    *  *S01133*/
/*                  MEMBER FILES                                    *  *S01133*/
/*       E80904 - WHEN COMPONENT ON NON - BACKUP SYSTEM IS CALLED   *  *E80904*/
/*                IT INCORRECTLY LEAVES 'RECOVERY' ON DATA AREA     *  *E80904*/
/*                'TSTATUS' WHEN IT IS CANCELLED.                   *  *E80904*/
/*                                                                  */
/********************************************************************/
/******      PGM        PARM(&SDC01 &FLAG)                            /*S01343*/
             PGM        PARM(&SCC01 &FLAG)                            /*S01343*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/******      DCL        VAR(&SDC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&SCC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&MONIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCVASP) TYPE(*CHAR) LEN(2)               /*S01173*/
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEDL) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DEVL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750INT                                          */
                                                                      /*S01408*/
/***         DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                /*E14638*/
             DCL        VAR(&EMMOD) TYPE(*CHAR) LEN(1)                /*E14638*/
             DCL        VAR(&EMUPD) TYPE(*CHAR) LEN(1)                /*E14638*/
             DCL        VAR(&RETRY) TYPE(*DEC) LEN(2) VALUE(1)        /*E14638*/
/**********  DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) VALUE(R)         /*RT0138*/
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
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
             DCL        VAR(&CLE006) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE001*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
             DCL        VAR(&CSTAT) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 +
                          'IASPgroup' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
             SNDPGMMSG  MSG('Initial Setup of Backup Machine')  +
                        TOMSGQ(MRUNQ)
/**/
/*   SEND WARNING MESSAGE TO MAKE SURE BEING RUN ON BACKUP MACHINE  */
/**/
             SNDPGMMSG  MSG('WARNING - THIS OPTION WILL SET UP THIS MACHINE +
                            AS THE BACKUP MACHINE. Enter "C" to cancel +
                            OR press ENTER to continue.') +
                            MSGTYPE(*INQ) TOPGMQ(*EXT)
/**/
/*********   RCVMSG     MSG(&RMSG) PGMQ(*EXT)*************/           /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&RMSG)                      /*095590*/
/**/
     IF         COND((&RMSG *EQ 'C') *OR (&RMSG *EQ 'c')) THEN(DO)    /*E80904*/
/*           IF         COND(&RMSG *EQ 'C') THEN(DO)                *  *E80904*/
                SNDPGMMSG  MSG('Initial setup of backup machine -  +
                           CANCELLED')
                CHGDTAARA  DTAARA(TSTATUS) VALUE('        ')          /*E80904*/
                CHGJOB SWS(XXXXXX1X)
                GOTO ENDPGM
             ENDDO
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(&JLIB) VALUE(&LIBID *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP7                                          */
                                                                      /*S01408*/
/**/                                                                  /*E14638*/
/*  IF EXPOSURE MANAGEMENT MODULE IS PRESENT AND UPDATING IS       */ /*E14638*/
/*  ACTIVE THEN STOP UPDATING IF PHASE IS 'B'/'X' OR PAUSE         */ /*E14638*/
/*  IF PHASE IS 'A'.                                               */ /*E14638*/
             RTVDTAARA  DTAARA(MMOD (7 1)) RTNVAR(&EMMOD)             /*E14638*/
/**/                                                                  /*CCM002*/
/*    Check if Lending Enhancements feature is active (CLE004)        /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE006)        /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE006')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE006) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CDE001*/
/*    Check if CCRM - Limits is active (CDE001)                       /*CDE001*/
/**/                                                                  /*CDE001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDE001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE001*/
             CHGVAR     VAR(&SAR) VALUE('CDE001')                     /*CDE001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CDE001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))                    /*CDE001*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE004*/
             IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
                          THEN(DO)                                    /*CLE004*/
                RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)               /*CLE004*/
             CALL       PGM(AOCOMSR0) PARM('SCC1711' '00001' &CSTAT)                      /*CCB020*/
/**********     IF         COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                             THEN(CALL PGM(LEC2011))                            */ /*CLE004 CCB020*/
             IF         COND(&PHASE *EQ 'X' *OR &CSTAT *EQ 'C   ') +
                          THEN(CALL PGM(LEC2011))                                         /*CCB020*/
             ENDDO                                                    /*CLE004*/
/**/                                                                  /*CDE001*/
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
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)                      /*CRE022*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                                          /*CRE020*/
/** If the APIs Retail Advices job is active, shut it down */                             /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0470)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/                                                                                     /*BUG2381*/
/* If the APIs Confirmations job is active, shut it down                                 /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0440)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
/**/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active, retrieve the values in       /*CCM002*/
/*    data area MPHAS and DLCDSTAT.                                   /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
/**********    RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)               */            /*CCM002 CCB020*/
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
                          COND(&PHASE *EQ 'X' *OR &CSTAT *EQ 'C   +
                          ') THEN(CALL PGM(QSNDDTAQ) +
                          PARM('DLCDDTAQ' '*LIBL' &LENGTH +
                          &MESSAGE)))                                                     /*CCB020*/
             ENDDO                                                    /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active and Exposure Management       /*CCM002*/
/*    is not used and &CDSTAT is set to 'Y', check the PHASE and      /*CCM002*/
/*    send appropriate Journal entry.                                 /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y' *AND &EMMOD *NE 'Y' +
                          *AND %SST(&CDSTAT 1 1) *EQ 'Y') THEN(DO)    /*CCM002*/
/**********    IF         COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                            THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                            ENTDTA('STOP CD UPDATE') FILE(SDBANKPD)) */       /*CCM002*/ /*BUG9619*/
/**********    IF         COND(&PHASE *EQ 'A') THEN(SNDJRNE +
                            JRN(ICJRN) TYPE('XJ') ENTDTA('PAUSE CD +
                            UPDATE') FILE(SDBANKPD)) */                       /*CCM002*/ /*BUG9619*/
/**********    IF         COND(&PHASE *EQ 'X' *OR &PHASE *EQ 'B') +
                          THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                          ENTDTA('STOP CD UPDATE') FILE(SDBANKPD) +
                          FORCE(*YES))                                         */ /*BUG9619 CCB020*/
               IF         COND(&PHASE *EQ 'X' *OR &CSTAT *EQ 'C   ') +
                          THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                          ENTDTA('STOP CD UPDATE') FILE(SDBANKPD) +
                          FORCE(*YES))                                                    /*CCB020*/
               IF         COND(&PHASE *EQ 'A') THEN(SNDJRNE JRN(ICJRN) +
                          TYPE('XJ') ENTDTA('PAUSE CD UPDATE') +
                          FILE(SDBANKPD) FORCE(*YES))                                    /*BUG9619*/
             ENDDO                                                    /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&EMMOD *EQ 'Y') THEN(DO)                 /*E14638*/
                RTVDTAARA  DTAARA(EMSTAT (2 1)) RTNVAR(&EMUPD)        /*E14638*/
                IF         COND(&EMUPD *EQ 'Y') THEN(DO)              /*E14638*/
/**********        RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)           */            /*E14638 CCB020*/
/**********        IF         COND((&PHASE *EQ 'X') +
                                *OR (&PHASE *EQ 'B')) THEN(DO)                  */ /*E14638 CCB020*/
                   IF         COND((&PHASE *EQ 'X') +
                                *OR (&CSTAT *EQ 'C   ')) THEN(DO)                         /*CCB020*/
/**********           SNDJRNE JRN(ICJRN) TYPE('XE') FILE(TABTB10) +
                                   ENTDTA('STOP EM UPDATE') */                /*E14638*/ /*BUG9619*/
                      SNDJRNE    JRN(ICJRN) TYPE('XE') ENTDTA('STOP EM +
                          UPDATE') FILE(TABTB10) FORCE(*YES)                             /*BUG9619*/
                   ENDDO                                              /*E14638*/
                   IF         COND(&PHASE *EQ 'A') THEN(DO)           /*E14638*/
/**********           SNDJRNE JRN(ICJRN) TYPE('XJ') FILE(TABTB10) +
                                   ENTDTA('PAUSE EM UPDATE') */               /*E14638*/ /*BUG9619*/
                      SNDJRNE    JRN(ICJRN) TYPE('XJ') ENTDTA('PAUSE EM +
                          UPDATE') FILE(TABTB10) FORCE(*YES)                             /*BUG9619*/
                   ENDDO                                              /*E14638*/
                ENDDO                                                 /*E14638*/
             ENDDO                                                    /*E14638*/
 
/* DELAY THE CHANGE JOURNAL FOR 2 MINUTES.  THIS OPERATION WILL BE */ /*E14638*/
/* EXECUTED TWICE IF NEEDED AND SHOULD GIVE EM0100 A CHANCE TO END */ /*E14638*/
/* NORMALLY.                                                          /*E14638*/
 
DELAY:       DLYJOB   DLY(240)                                        /*E14638*/
/**/
/**/
/*   CALL SD1750 TO OUTPUT & VALIDATE PROMPT SCREEN FOR MEDIA,      */
/*   DEVICES & VOLUME ID OF DATABASE SAVE TO BE RESTORED            */
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABICD)
RETRY:                                                                /*RT0138*/
             CALL       PGM(SD1750) PARM(&VOL1 &MEDL &DEVL &ENDP)
             IF    COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
             IF    COND(&ENDP *EQ '1') THEN(GOTO ENDPGM)
/**/
/*   CHECK UP OF THE DEVICE FOR DATABASE RESTORATION                          */
/*                                                                            */
 RESTORE1:   IF         COND(&MEDL *EQ 'DKTE') THEN(DO)
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
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*********   RCVMSG     MSG(&RMSG) PGMQ(*EXT)*************/           /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&RMSG)                      /*095590*/
/**/
/*************************** IF         COND(&RMSG *EQ 'C') THEN(DO)****095590*/
                             IF         COND((&RMSG *EQ 'C') *OR +
                                        (&RMSG *EQ 'c')) THEN(DO)     /*095590*/
                               SNDPGMMSG  MSG('Initial setup of backup +
                                              machine - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
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
 
             IF         COND(&MEDL *EQ 'TAPE') THEN(DO)
CHECK2:                 CHKTAP     DEV(&DEVL) VOL(&VOL1)
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available and +
                                             mount volume ' *CAT &VOL1 *CAT ' +
                                             or enter "C" to cancel and end +
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
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*********   RCVMSG     MSG(&RMSG) PGMQ(*EXT)*************/           /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&RMSG)                      /*095590*/
/**/
/*************************** IF         COND(&RMSG *EQ 'C') THEN(DO)****095590*/
                             IF         COND((&RMSG *EQ 'C') *OR +
                                        (&RMSG *EQ 'c')) THEN(DO)     /*095590*/
                               SNDPGMMSG  MSG('Initial setup of backup +
                                               machine - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK2
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
/*   RESTORE MASTER LIBRARY                                         */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP1                                          */
                                                                      /*S01408*/
/**/
             SNDMSG     MSG('Restore of library ' *CAT &LIBID *TCAT 'DMLIB'  +
                          *CAT ' in progress.') TOMSGQ(MOPERQ)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP2                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01133*/
/* REMOVE ALL MEMBERS FROM FILES */                                   /*S01133*/
             CALL SDC1770                                             /*S01133*/
/**/
/**                                                                     096935*/
/** ENSURE THAT COMMONLY USED ACCESS OBJECTS HAVE BEEN CLOSED.          096935*/
/**                                                                     096935*/
             CALL       AOBRCHR0 (' ' '*FREE  ' ' ')                  /*096935*/
             CALL       AOCURRR0 (' ' '*FREE  ' ' '' ')               /*096935*/
             CALL       AOBANKR0 (' ' '*FREE  ' ' ')                  /*096935*/
             CALL       AOGELRR0 (' ' '*FREE  ' ' ')                  /*096935*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP3                                          */
                                                                      /*S01408*/
RSTLIB1:                                                                                  /*207764*/
/*RSTLIB1:***RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVL) + */                      /*207764*/
/**********               VOL(*MOUNTED) MBROPT(*ALL)              */                      /*207764*/
             RSTLIB     SAVLIB(&LIBID *TCAT 'DMLIB') DEV(&DEVL) +
                          VOL(*MOUNTED) MBROPT(*ALL) OUTPUT(*PRINT)                       /*207764*/
/**/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP4                                          */
                                                                      /*S01408*/
/*   CALL SDC1724 TO OPEN AND CLOSE ALL LOGICAL FILES               */
/**/
/*           CALL       PGM(SDC1724)                               */ /*E13205*/
             CALL       PGM(SDC1774)                                  /*E13205*/
/**/
/*   CHECK UP OF THE DEVICE FOR JOURNAL LIBRARY RESTORATION                   */
/**/
 RESTORE2:   IF         COND(&MEDL *EQ 'DKTE') THEN(DO)
 CHECK3:     CHKDKT     DEV(DKT01) VOL(JNSAV)
 
             MONMSG     MSGID(CPF6162 CPF6165 CPF4128 CPF6708) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Diskette with volume ID JNSAV +
                                             not found. Mount the +
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
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*********   RCVMSG     MSG(&RMSG) PGMQ(*EXT)*************/           /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&RMSG)                      /*095590*/
/**/
/*************************** IF         COND(&RMSG *EQ 'C') THEN(DO)****095590*/
                             IF         COND((&RMSG *EQ 'C') *OR +
                                        (&RMSG *EQ 'c')) THEN(DO)     /*095590*/
                               SNDPGMMSG  MSG('Initial setup of backup +
                                              machine - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK3
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
 
             IF         COND(&MEDL *EQ 'TAPE') THEN(DO)
CHECK4:                 CHKTAP     DEV(&DEVL) VOL(JNSAV)
/**/
                        MONMSG     MSGID(CPF6718) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Unable to allocate device. Retry +
                                             if device becomes available and +
                                             mount volume JNSAV OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6720) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Tape with volume ID JNSAV +
                                             not found. Mount +
                                             the correct tape and retry OR +
                                             enter "C" to cancel and end +
                                             program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        MONMSG     MSGID(CPF6760) EXEC(DO)
                             CHGVAR     VAR(&MONIND) VALUE('1')
                             SNDPGMMSG  MSG('Device not ready. Mount volume +
                                             with ID JNSAV on +
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
                             SNDPGMMSG  MSG('Device not found. Mount the +
                                             volume with ID JNSAV on the +
                                             correct device and retry OR enter +
                                             "C" to cancel and end program.') +
                                        MSGTYPE(*INQ) TOPGMQ(*EXT)
                        ENDDO
/**/
                        IF         COND(&MONIND *EQ '1') THEN(DO)
/**/
/*********   RCVMSG     MSG(&RMSG) PGMQ(*EXT)*************/           /*095590*/
             RCVMSG     MSGTYPE(*RPY) MSG(&RMSG)                      /*095590*/
/**/
/*************************** IF         COND(&RMSG *EQ 'C') THEN(DO)****095590*/
                             IF         COND((&RMSG *EQ 'C') *OR +
                                        (&RMSG *EQ 'c')) THEN(DO)     /*095590*/
                               SNDPGMMSG  MSG('Initial setup of backup +
                                               machine - CANCELLED')
                               CHGJOB SWS(XXXXXX1X)
                               GOTO ENDPGM
                             ENDDO
/**/
                             ELSE DO
                               CHGVAR     VAR(&MONIND) VALUE('0')
                               GOTO CHECK4
                             ENDDO
/**/
                        ENDDO
/**/
             ENDDO
/**/
             ENDJRNPF   FILE(*ALL) JRN(ICJRN)
/**/                                                                  /*E13205*/
/**ADD*A*REPLY*LIST*ENTRY*SO*THAT*"RECEIVER*NEVER*HAD*FULL*SAVE"****/ /*E13205*/
/**MESSAGES*ARE*ANSWERED*AUTOMATICALLY*BY*THE*PROGRAM,*THEN*********/ /*E13205*/
/**REMOVE*THE*ENTRY*AFTER*RECEIVERS*HAVE*BEEN*DELETED***************/ /*E13205*/
/**/                                                                  /*E13205*/
/*           CHGJOB     INQMSGRPY(*SYSRPYL)   */                      /*E13205*/
/*           ADDRPYLE   SEQNBR(3) MSGID(CPA7025) RPY(I)          */   /*E13205*/
/**/                                                                  /*E13205*/
/* CHANGE JOB ATTRIBUTES FOR INQMSGRPY SO THAT "RECEIVER NEVER HAD */ /*E13205*/
/* FULL SAVE" MESSAGES ARE ANSWERED AUTOMATICALLY BY THE PROGRAM,  */ /*E13205*/
/* THEN CHANGE THE JOB AGAIN TO THE ORIGINAL STATE AFTER RECEIVERS */ /*E13205*/
/* HAVE BEEN DELETED                                               */ /*E13205*/
/**/                                                                  /*E13205*/
             CHGJOB     INQMSGRPY(*DFT)                               /*E13205*/
/**/
/*   CLEAR AND RESTORE JOURNAL LIBRARY                               */
/**/
             SNDPGMMSG  MSG('The journal and receivers are being +
                          deleted') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
             DLTJRN     JRN(&JLIB/ICJRN)
             DLTJRNRCV  JRNRCV(&JLIB/ICRCV*)
             MONMSG     MSGID(CPF7022 CPF2117 CPF2125)
             DLTJRNRCV  JRNRCV(&JLIB/NEWNM001)
             MONMSG     MSGID(CPF2105)
             DLTDTAQ    DTAQ(&JLIB/REBUILD)                           /*E13205*/
             MONMSG     MSGID(CPF2105)                                /*E13205*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP5                                          */
                                                                      /*S01408*/
/**/
             SNDMSG     MSG('Restore of library ' *CAT &LIBID *TCAT 'JLIB'  +
                          *CAT ' in progress.') TOMSGQ(MOPERQ)
/**/
RSTLIB2:                                                                                  /*207764*/
/*RSTLIB2:***RSTLIB     SAVLIB(&LIBID *TCAT 'JLIB') DEV(&DEVL) + */                       /*207764*/
/**********               VOL(*MOUNTED) MBROPT(*ALL)             */                       /*207764*/
             RSTLIB     SAVLIB(&LIBID *TCAT 'JLIB') DEV(&DEVL) +
                          VOL(*MOUNTED) MBROPT(*ALL) OUTPUT(*PRINT)                       /*207764*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1750MP6                                          */
                                                                      /*S01408*/
/**/
             SNDPGMMSG  MSG('The journal library has been restored') +
                          TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0005) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
/*           RTVDTAARA  DTAARA(JNSTAT (151 1)) RTNVAR(&RCVASP)     */ /*S01173*/
     RTVDTAARA  DTAARA(JNSTAT (151 2)) RTNVAR(&RCVASP)     /*S01173*/ /*E13205*/
             DLTJRNRCV  JRNRCV(&JLIB/NEWNM001)                        /*E13205*/
             MONMSG     MSGID(CPF2105)                                /*E13205*/
/*  CRTJRNRCV  JRNRCV(NEWNM001.&JLIB) PUBAUT(*NONE)  */   /*S01173*/  /*E13205*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTJRNRCV  JRNRCV(&JLIB/NEWNM001)    AUT(*CHANGE) +
                          ASP(*LIBASP)                                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTJRNRCV  JRNRCV(&JLIB/NEWNM001)    AUT(*CHANGE) +
                          ASP(&RCVASP)                                /*S01173*/
             ENDDO                                                                        /*CSC043*/
             CHGJRN     JRN(&JLIB/ICJRN) JRNRCV(&JLIB/NEWNM001)
             DLTJRNRCV  JRNRCV(&JLIB/ICRCV*)
/**/
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD)
/**/
/****CALL*SDC1730*TO*JOURNAL*PHYSICAL*FILES*****/                     /*S01345*/
/**/
/************CALL       PGM(SDC1730) **/                              /*S01345*/
/**/                                                                  /*S01345*/
/*   CALL SCJRN TO JOURNAL PHYSICAL FILES    */                       /*S01345*/
/**/                                                                  /*S01345*/
             CALL       PGM(SCJRN)                                    /*S01345*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDPGM)
/**/
/*   UPDATE RECEIVER NO. & BACKUP SYSYEM FLAG IN JNSTAT              */
/**/
             CHGDTAARA  DTAARA(JNSTAT (1 8)) VALUE(ICRCV001)
             CHGDTAARA  DTAARA(JNSTAT (82 1)) VALUE('B')
/**/                                                                  /*S01133*/
/* ADD ALL MEMBERS FROM FILES */                                      /*S01133*/
             CALL SDC1771                                             /*S01133*/
/**/
             GOTO ENDPGM
/**/
/*   DATABASE ERROR PROCESSING                                       */
/**/
/* DBERR: ** RCVDTAARA  DTAARA(LDA) *********************************  *S01179*/
DBERR:       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/***         CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         */ /*S01194*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ) +
             TOPGMQ(*EXT)
/**/
/*   OTHER ERROR PROCESSING                                          */
/**/
/***ABNOR:*******SNDPGMMSG  MSG('Initial Setup of Backup Machine +    /*RT0138*/
/***********            ENDED ABNORMALLY') TOPGMQ(*EXT) +             /*RT0138*/
/***********            TOMSGQ(MOPERQ MRUNQ)                          /*RT0138*/
ABNOR:                                                                /*RT0138*/
             SNDPGMMSG  MSG('Initial Setup of Backup Machine ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*RT0138*/
/* Call program to show restore fail and prompt for joblog */         /*RT0138*/
/**/                                                                  /*RT0138*/
             CALL       PGM(SCC0020) PARM('SDC1750' 'RESTFAILJ')      /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Call program to show abnormal end and prompt for retry */          /*RT0138*/
/**/                                                                  /*RT0138*/
             CHGVAR     VAR(&RPY) VALUE('R')                          /*RT0138*/
             CALL       PGM(RRC0010) PARM('SDC1750' 'SETBKUPABN' +
                          &RPY)                                       /*RT0138*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*RT0138*/
/**/                                                                  /*RT0138*/
/* Retry save if requested else end program                           /*RT0138*/
/**/                                                                  /*RT0138*/
             IF         COND(&RPY = 'R') THEN(DO)                     /*RT0138*/
                SNDPGMMSG  MSG('Initial Setup of Backup Machine +
                                RETRY ATTEMPT') TOMSGQ(MOPERQ MRUNQ)  /*RT0138*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             /*RT0138*/
                GOTO       CMDLBL(RETRY)                              /*RT0138*/
             ENDDO                                                    /*RT0138*/
                                                                      /*RT0138*/
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
