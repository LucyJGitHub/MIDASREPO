/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Setup jrn lib for restore to BOB')           */
/********************************************************************/
/*                                                                  */
/*        Midas - Restart Recovery Module                           */
/*                                                                  */
/*       SCC1713 - SET UP JOURNAL LIBRARY FOR RESTORATION TO        */
/*                 BEGINNING OF BUSINESS                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      BUG7286            Date 23May05              */
/*                      CSC020             Date 31Mar04              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            DATE  10MAY95             */
/*                      037744            DATE  27MAR92             */
/*                      S01345            DATE  06NOV91             */
/*                      S01343            DATE  15AUG91             */
/*                      E13205            DATE  01/03/89            */
/*                      S01179            DATE  12/09/88            */
/*                      S01173            DATE  30/06/88            */
/*                      S01118            DATE  13/03/87            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSC018 - Journaling options for High Availability           */
/*       S01408 - Addition of core hook SCC1713MP1                  */
/*       037744 - REPLACE SWIFT I VERSION OF REPORT ON SWIFT        */
/*                INCOMING MESSAGES THAT MAY BE LOST DUE            */
/*                TO RECOVERY WITH SWIFT II VERSION.                */
/*       S01345 - JOURNALLING SYSTEM RE-WRITE.                      */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SCC1713 RENAMED FROM SDC1713                    */
/*                - SCC1716 RENAMED FROM SDC1716                    */
/*                                                                  */
/*       E13205 - Correct file name MILSPF to MSILSPF               * /*E13205*/
/*                Apply fix E80902. Chgjob *dft instead *SYSRPLY    * /*E13205*/
/*                                                                  */
/*       S01179 - AS400 CONVERSION                                  */
/*       S01173 - USE SPECIFIED ASP FOR JOURNAL/RECEIVERS           */
/*       S01118 - MIDAS/S.W.I.F.T. DIRECT LINK                      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&VOL1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*  INITIAL PROCESSING                                               */
/**/
             DCL        VAR(&FSAV) TYPE(*CHAR) LEN(8) VALUE('  DMLIB ')
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(8) VALUE('  JLIB  ')
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LSAV) TYPE(*CHAR) LEN(8) VALUE('  JLIB  ')
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SMSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SWDR) TYPE(*CHAR) LEN(1)                 /*S01118*/
/**/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/**********  DCLDTAARA  DTAARA(MNATN)                               *  *S01179*/
             DCL        VAR(&MNATN) TYPE(*CHAR) LEN(5)                /*S01179*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*CSC018*/
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling options for High Availability                /*CSC018*/
/*                                                                                        /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&THRESHOLDB) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&THRESHOLDK) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&SIZOPT1) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT2) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT3) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(150)                                    /*CSC018*/
             DCL        VAR(&STRRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/*/COPY WNCPYSRC,SCC1713005                                          */
/**/
/*  GLOBAL MONITOR MESSAGE                                           */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Set up Journal Library for Restoration +
                             to Beginning of Business') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,SCC1713006                                          */
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
/*                                                                                        /*CSC018*/
/*  Check for Switchable feature CSC018.                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                                /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If feature CSC018 is present,                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CSC018*/
                CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'HighAvlRcvSizeOption' &SVAL1 +
                             'HighAvlJrnRcvThld' &SVAL2 +
                             'HighAvlRmvIntJrnEnt' &SVAL3 +
                             'HighAvlMinFixLenJrnE' &SVAL4 +
                             &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                             &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                             &SVALK10 &SVAL10)                                            /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/*  Determine journal receiver threshold.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRES6) VALUE(%SST(&SVAL2 1 10))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If threshold is blank on the system value file.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&THRES6 *EQ '          ') THEN(DO)                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.5 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&THRES6) VALUE('0001500000')                                /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Calculate threshold value in KB.                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDK) VALUE(&THRES6)                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Multiply by 1000 to give value in bytes.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&THRESHOLDB) VALUE(&THRESHOLDK * 1000)                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If threshold defined on the system value is too big,                                  /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&THRES6 *GE '1000000000') THEN(DO)                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.5 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&THRES6) VALUE('0001500000')                                /*CSC018*/
               CHGVAR     VAR(&THRESHOLDK) VALUE(1500000)                                 /*CSC018*/
               CHGVAR     VAR(&THRESHOLDB) VALUE(1500000000)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001500000')                      /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether internal journal entries are to be removed.                         /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMVIN6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If value is blank on the system value file.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ ' ') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set a default value of 'N',                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&RMVIN6) VALUE('N')                                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value file.                                                     /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL3 1 1)) VALUE('N')                                /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlRmvIntJrnEnt' +
                            &SVAL3 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether miminal fixed length journal entries are                            /*CSC018*/
/*  required.  (Not recommended!!)                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MINFI6) VALUE(%SST(&SVAL4 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If value is blank on the system value file.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MINFI6 *EQ ' ') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/*  set a default value of 'N',                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&MINFI6) VALUE('N')                                         /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL4 1 1)) VALUE('N')                                /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlMinFixLenJrnE' +
                            &SVAL4 &SUPPUPD)                                              /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Construct the variable for receiver size options.                                     /*CSC018*/
/*  Insert *MAXOPT1 or *MAXOPT2, if required.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MAXOP6 *EQ '2') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT2  ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               IF         COND(&MAXOP6 *EQ '1') THEN(DO)                                  /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('*MAXOPT1  ')                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
               ELSE       CMD(DO)                                                         /*CSC018*/
                CHGVAR     VAR(&SIZOPT1) VALUE('          ')                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *RMVINTENT, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMVIN6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('*RMVINTENT')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               CHGVAR     VAR(&SIZOPT2) VALUE('          ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Insert *MINFIXLEN, if required.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MINFI6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('*MINFIXLEN')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
              ELSE       CMD(DO)                                                          /*CSC018*/
               CHGVAR     VAR(&SIZOPT3) VALUE('          ')                               /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If no options are required, insert '*NONE'.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&SIZOPT1 *EQ '          ') *AND +
                          (&SIZOPT2 *EQ '          ') *AND +
                          (&SIZOPT3 *EQ '          ')) THEN(DO)                           /*CSC018*/
               CHGVAR     VAR(&SIZOPT1) VALUE('*NONE')                                    /*CSC018*/
              ENDDO                                                                       /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/**/
/*  RETRIEVE SWIFT DIRECT LINK BYTE FROM DATA AREA MMOD                 S01118*/
/**/                                                                  /*S01118*/
             RTVDTAARA  DTAARA(MMOD (18 1)) RTNVAR(&SWDR)             /*S01118*/
/**/                                                                  /*S01118*/
/*  IF SWIFT DIRECT LINK PRESENT, RETRIEVE JOURNAL ENTRIES FOR          S01118*/
/*  INCOMING MESSAGES WHICH ARE GOING TO BE LOST BECAUSE OF THE         S01118*/
/***RECOVERY*AND*CALL*MSC1700*TO*REPORT*THEM*                  /*S01118 037744*/
/*  RECOVERY AND CALL MSC5040 TO REPORT THEM                   /*S01118 037744*/
/**/                                                                  /*S01118*/
             IF         COND(&SWDR *EQ 'Y') THEN(DO)                  /*S01118*/
/******************DSPJRN JRN(ICJRN) FILE((MSIMSPF)) RCVRNG(ICRCV001) + 037744*/
/******************       PGM(MS4010) OUTPUT(*OUTFILE) +              /*037744*/
/******************       OUTFILE(MSILSPF)                     /*E13205 037744*/
/*                        OUTFILE(MILSPF)                          */ /*S01118*/
/**/                                                                  /*037744*/
/*/COPY WNCPYSRC,SCC1713007                                          */
/*                                                                                          CSC020*/
/*  Determine journal sequence number of next day set up.                                   CSC020*/
/*  (Equivalent to beginning of ICRCV001 in previous releases)                              CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV)                           *CSC020**BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/
/*                                                                                          CSC020*/
/********    DSPJRN     JRN(ICJRN) FILE((MSMSI2PD)) RCVRNG(ICRCV001) +                      CSC020*/
/********                 PGM(MS5070) OUTPUT(*OUTFILE) +                                    CSC020*/
/********                 OUTFILE(MSJRI2PD)                            *037744**************CSC020*/
             DSPJRN     JRN(ICJRN) FILE((MSMSI2PD)) RCVRNG(&STRRCV) +
                          PGM(MS5070) OUTPUT(*OUTFILE) +
                          OUTFILE(MSJRI2PD)                                               /*CSC020*/
                   MONMSG     MSGID(CPF7062)                          /*S01118*/
/*/COPY WNCPYSRC,SCC1713008                                          */
/******************CALL       PGM(MSC1700)                     /*S01118 037744*/
                   CALL       PGM(MSC5040)                            /*037744*/
/**/                                                                  /*S01118*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(DO)        /*S01118*/
                      CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                                 - Lost incoming messages report +
                                 ended because of Data Base Error')   /*S01118*/
                      SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)               /*S01118*/
                      GOTO       CMDLBL(ENDPGM)                       /*S01118*/
                   ENDDO                                              /*S01118*/
/**/                                                                  /*S01118*/
             ENDDO                                                    /*S01118*/
/**/
/*  END JOURNALLING ALL FILES                                        */
/**/
/*/COPY WNCPYSRC,SCC1713009                                          */
             ENDJRNPF   FILE(*ALL) JRN(ICJRN)
/**/
/*  SEND MESSAGE TO WARN USER THAT JOURNAL & RECEIVERS ARE BEING DELETED      */
/**/
             SNDPGMMSG  MSG('The journal and receivers are being +
                          deleted') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
/*  DELETE JOURNAL & JOURNAL RECEIVERS                                        */
/**/
             DLTJRN     JRN(ICJRN)
/**/
/* IF ERROR OCCURS, JOURNAL NOT DELETED, ERROR MSG SENT & PROGRAM ENDS        */
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - Journal cannot be deleted')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,SCC1713010                                          */
               CHGJOB     SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/                                                                  /*E13205*/
/**ADD*A*REPLY*LIST*ENTRY*SO*THAT*"RECEIVER*NEVER*HAD*FULL*SAVE"***** /*E13205*/
/**MESSAGES*ARE*ANSWERED*AUTOMATICALLY*BY*THE*PROGRAM,*THEN********** /*E13205*/
/**REMOVE*THE*ENTRY*AFTER*RECEIVERS*HAVE*BEEN*DELETED**************** /*E13205*/
/**/                                                                  /*E13205*/
/*           CHGJOB     INQMSGRPY(*SYSRPYL)   */                      /*E13205*/
/*           ADDRPYLE   SEQNBR(3) MSGID(CPA7025) RPY(I)          */   /*E13205*/
/**/                                                                  /*E13205*/
/* CHANGE JOB ATTRIBUTES FOR INQMSGRPY SO THAT "RECEIVER NEVER HAD  * /*E13205*/
/* FULL SAVE" MESSAGES ARE ANSWERED AUTOMATICALLY BY THE PROGRAM,   * /*E13205*/
/* THEN CHANGE THE JOB AGAIN TO THE ORIGINAL STATE AFTER RECEIVERS  * /*E13205*/
/* HAVE BEEN DELETED                                                * /*E13205*/
/**/                                                                  /*E13205*/
             CHGJOB     INQMSGRPY(*DFT)                               /*E13205*/
/**/
/* IF ERROR OCCURS, RECEIVERS NOT DELETED, ERROR MSG IS SENT & PROGRAM ENDS   */
/**/
/*/COPY WNCPYSRC,SCC1713011                                          */
/************DLTJRNRCV**JRNRCV(ICRCV*)******************************************************CSC020*/
             DLTJRNRCV  JRNRCV(IR*)                                                       /*CSC020*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
               CHGVAR     VAR(&SMSG) VALUE('Job terminated +
                          - Receivers cannot be deleted')
               SNDMSG  MSG(&SMSG) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,SCC1713012                                          */
/*             RMVRPYLE   SEQNBR(3)                                */ /*E13205*/
               CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX11)
               GOTO       CMDLBL(ENDPGM)
/**/
             ENDDO
/**/
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD)
/**/
/*  OBTAIN LIBRARY ID FROM SDSTAT                                    */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(%SST(&LIB 1 2)) VALUE(&LIBID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC1713MP1                                          */
                                                                      /*S01408*/
/**/
/*  CREATE THE NEW JOURNAL & RECEIVER(S) -                                    */
/***(A)*IF*DUAL*RECEIVERS*ARE*TO*BE*USED****************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************RCVDTAARA**DTAARA(JNSTAT)**********************************S01179**************CSC020*/
/************RTVDTAARA**DTAARA(JNSTAT)*RTNVAR(&JNSTAT)******************S01179**************CSC020*/
/************IF*********COND(%SUBSTRING(&JNSTAT*70*1)**EQ*'Y')*THEN(DO)*********************CSC020*/
/*******************************************************************************************CSC020*/
/**COPY*WNCPYSRC,SCC1713013*****************************************************************CSC020*/
/**************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*******************************S01173**************CSC020*/
/**************CRTJRNRCV**JRNRCV(&LIB/ICRCV002)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*******************************S01173**************CSC020*/
/**************CRTJRN*****JRN(&LIB*ICJRN)*JRNRCV(ICRCV001*ICRCV002)*****S01173**************CSC020*/
/**************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*ASP(%SST(&JNSTAT*151*2))******S01173**************CSC020*/
/**************CRTJRNRCV**JRNRCV(&LIB/ICRCV002)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*ASP(%SST(&JNSTAT*151*2))******S01173**************CSC020*/
/**************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001*ICRCV002)*+***********************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))**********************S01173**************CSC020*/
/*/COPY*WNCPYSRC,SCC1713014*****************************************************************CSC020*/
/**************CHGVAR*****VAR(%SUBSTRING(&JNSTAT*68*1))*+***********************************CSC020*/
/*************************VALUE('Y')********************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ENDDO**************************************************************************CSC020*/
/*******************************************************************************************CSC020*/
/***(B)*IF*SINGLE*RECEIVERS*ARE*TO*BE*USED**************************************************CSC020*/
/*******************************************************************************************CSC020*/
/************ELSE*******CMD(DO)*************************************************************CSC020*/
/**/
/*/COPY WNCPYSRC,SCC1713015                                          */
/*             CRTJRNRCV  JRNRCV(&LIB/ICRCV001) TEXT('receiver for +
                          journal icjrn')  */                         /*S01173*/
/*             CRTJRN     JRN(&LIB/ICJRN) JRNRCV(ICRCV001)  */        /*S01173*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are not being used,                                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *NE '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/**************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*TEXT('receiver*for*+************************CSC020*/
/*************************journal*icjrn')*ASP(%SST(&JNSTAT*151*2))******S01173**************CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(*LIBASP) +
                          THRESHOLD(1500000) TEXT('receiver for +
                          journal icjrn')                                                 /*CSC043*/
               CRTJRN     JRN(&LIB/ICJRN) JRNRCV(IR00000001) +
                          ASP(*LIBASP)                                                    /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(%SST(&JNSTAT 151 +
                          2)) THRESHOLD(1500000) TEXT('receiver for +
                          journal icjrn')                                                 /*CSC020*/
/**************CRTJRN*****JRN(&LIB/ICJRN)*JRNRCV(ICRCV001)*+********************************CSC020*/
/*************************ASP(%SST(&JNSTAT*149*2))**********************S01173**************CSC020*/
               CRTJRN     JRN(&LIB/ICJRN) JRNRCV(IR00000001) +
                          ASP(%SST(&JNSTAT 149 2))                                        /*CSC020*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are being used,                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* Create journal receiver with required threshold.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*************CRTJRNRCV**JRNRCV(&LIB/ICRCV001)*ASP(%SST(&JNSTAT*151*+***********************CSC020*/
/*************************2))*THRESHOLD(&THRESHOLDK)*TEXT('receiver*+***********************CSC020*/
/*************************for*journal*icjrn')***************************************CSC018**CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(*LIBASP) +
                          THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal icjrn')                                             /*CSC043*/
/*                                                                                        /*CSC043*/
/** Create journal with required size options. */                                         /*CSC043*/
/*                                                                                        /*CSC043*/
             CHGVAR     VAR(&CMD) VALUE(' ')                                              /*CSC043*/
             CHGVAR     VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &LIB *CAT +
                          '/ICJRN) JRNRCV(IR00000001) ASP(*LIBASP) +
                          RCVSIZOPT(' *CAT &SIZOPT1 *BCAT &SIZOPT2 +
                          *BCAT &SIZOPT3 *TCAT ')')                                       /*CSC043*/
             CALL       PGM(QCMDEXC) PARM(&CMD 150)                                       /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
              CRTJRNRCV  JRNRCV(&LIB/IR00000001) ASP(%SST(&JNSTAT 151 +
                          2)) THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal icjrn')                                             /*CSC020*/
/*                                                                                        /*CSC018*/
/* Create journal with required size options.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&CMD) VALUE(' ')                                             /*CSC018*/
/*************CHGVAR*****VAR(&CMD)*VALUE('CRTJRN*JRN('**CAT*&LIB**CAT*+*********************CSC020*/
/*************************'/ICJRN)*JRNRCV(ICRCV001)*ASP('**CAT*+****************************CSC020*/
/*************************%SST(&JNSTAT*149*2)**CAT*')*RCVSIZOPT('*+*************************CSC020*/
/**************************CAT*&SIZOPT1**BCAT*&SIZOPT2**BCAT*+******************************CSC020*/
/*************************&SIZOPT3**TCAT*')')***************************************CSC018**CSC020*/
              CHGVAR     VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &LIB *CAT +
                          '/ICJRN) JRNRCV(IR00000001) ASP(' *CAT +
                          %SST(&JNSTAT 149 2) *CAT ') RCVSIZOPT(' +
                          *CAT &SIZOPT1 *BCAT &SIZOPT2 *BCAT +
                          &SIZOPT3 *TCAT ')')                                             /*CSC020*/
              CALL       PGM(QCMDEXC) PARM(&CMD 150)                                      /*CSC018*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC018*/
/*/COPY WNCPYSRC,SCC1713016                                          */
               CHGVAR     VAR(%SUBSTRING(&JNSTAT 68 1)) +
                          VALUE('N')
/**/
/************ENDDO**************************************************************************CSC020*/
/**/
/*  SEND MESSAGE TO USER AS NEW JOURNAL & RECEIVERS HAVE BEEN CREATED         */
/**/
             SNDPGMMSG  MSG('The new journal and associated +
                          receiver(s) have been created') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0004) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
/*  INITIALISE MNATN & JNSTAT DATA AREAS                                      */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**********  RCVDTAARA  DTAARA(MNATN)                               *  *S01179*/
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&MNATN)                  /*S01179*/
/**/
             CHGVAR     VAR(&MNATN) VALUE('00001')
/**/
/************CHGVAR*****VAR(%SUBSTRING(&JNSTAT*1*20))*+*************************************CSC020*/
/*************************VALUE('ICRCV001**ICRCV001**')*************************************CSC020*/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 1 20)) +
                          VALUE('IR00000001IR00000001')                                   /*CSC020*/
/*/COPY WNCPYSRC,SCC1713001                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 63 5)) +
                          VALUE('DB001')
/*/COPY WNCPYSRC,SCC1713002                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 74 1)) +
                          VALUE('N')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 75 5)) +
                          VALUE('     ')
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 81 1)) +
                          VALUE('N')
/**/
/**********  SNDDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             CHGDTAARA  DTAARA(JNSTAT) VALUE(&JNSTAT)                 /*S01179*/
/**********  SNDDTAARA  DTAARA(MNATN)                               *  *S01179*/
             CHGDTAARA  DTAARA(MNATN) VALUE(&MNATN)                   /*S01179*/
/**/
/***CALL*SDC1730*TO*START*JOURNALLING*THE*PHYSICAL*FILES***/          /*S01345*/
/**/
/************CALL       PGM(SDC1730) */                               /*S01345*/
/**/                                                                  /*S01345*/
/*  CALL SCJRN TO START JOURNALLING THE PHYSICAL FILES  */            /*S01345*/
/**/                                                                  /*S01345*/
             CALL       PGM(SCJRN)                                    /*S01345*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDPGM)
/**/
/***CALL*SDC1716*TO*CHANGE*JOURNAL*RECEIVERS                          /*S01343*/
/*  CALL SCC1716 TO CHANGE JOURNAL RECEIVERS                          /*S01343*/
/**/
/*****       CALL       PGM(SDC1716) PARM(0)                          /*S01343*/
             CALL       PGM(SCC1716) PARM(0)                          /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDPGM)
/**/
/*  SEND MESSAGE TO RE-INITIALIZE JRNIC TAPE/DKTE                             */
/**/
/*/COPY WNCPYSRC,SCC1713003                                          */
             SNDPGMMSG  MSG('Re-initialize JRNIC tape/diskette, then +
                          press ENTER to continue') TOPGMQ(*EXT) +
                          MSGTYPE(*INQ)
/*/COPY WNCPYSRC,SCC1713004                                          */
             RCVMSG     MSG(&RMSG) PGMQ(*EXT)
/**/
/*  SEND 'SV' ENTRY TO JOURNAL                                                */
/**/
             RTVDTAARA  DTAARA(JNSTAT (35 4)) RTNVAR(&SAVD)
             CHGVAR     VAR(%SUBSTRING(&FSAV 1 2)) VALUE(&LIBID)
             CHGVAR     VAR(%SUBSTRING(&LSAV 1 2)) VALUE(&LIBID)
/**/
             CHGVAR     VAR(%SUBSTRING(&JRNE 1 5)) VALUE(&VOL1)
             CHGVAR     VAR(%SUBSTRING(&JRNE 6 8)) VALUE(&FSAV)
             CHGVAR     VAR(%SUBSTRING(&JRNE 16 8)) VALUE(&LSAV)
             CHGVAR     VAR(%SUBSTRING(&JRNE 26 4)) VALUE(&SAVD)
/*/COPY WNCPYSRC,SCC1713017                                          */
/**********  SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('SV') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/*/COPY WNCPYSRC,SCC1713018                                          */
/**/
             GOTO       ENDPGM
/**/
/*  ERROR PROCESSING                                                          */
/**/
ABNOR:       SNDPGMMSG  MSG('Set up Journal Library for Restoration +
                        to Beginning of Business - ENDED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,SCC1713019                                          */
 ENDPGM:     ENDPGM
/*/COPY WNCPYSRC,SCC1713020                                          */
