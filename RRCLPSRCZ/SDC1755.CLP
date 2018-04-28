/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Convert backup mach to primary machine')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Restart Recovery Module                             */
/*                                                                   */
/*       SDC1755 - CONVERT BACKUP MACHINE INTO PRIMARY MACHINE       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG9619            Date 01Feb06              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408             DATE 10MAY95              */
/*                      059503             DATE 22JUN94              */
/*                      E44329             DATE 22JAN93              */
/*                      E44327             DATE 22JAN93              */
/*                      S01345             DATE 06NOV91              */
/*                      S01343             DATE 15AUG91              */
/*                      E13205             DATE 13/03/89             */
/*                      S01179             DATE 13/09/88             */
/*                      S01173             DATE 30/06/88             */
/*                      S01118             DATE 11/08/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CSC018 - Journaling options for high availability           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01408 - Addition of core hook SDC1755MPS                   * *E80903*/
/*       059503 - Workstation ID truncated when updated to file      */
/*                MNTYF.  Include the 10-char field WSTI to file     */
/*                MNTYF.  Update all programs using CMTTXT (COMMIT   */
/*                TEXT) accordingly.                                 */
/*       044329 - MONITOR FOR JOURNAL NOT EXISTING                   */
/*       044327 - MONITOR FOR JOURNAL RECEIVER NOT EXISTING          */
/*       S01345 - JOURNALLING SYSTEM RE-WRITE.                       */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SDCLRCL REDUNDANT AT R10.                        */
/*                - SCCLRDL RENAMED FROM SDCLRDL                     */
/*                - SCCLRFD RENAMED FROM SDCLRFD                     */
/*                - SCCLRFX RENAMED FROM SDCLRFX                     */
/*                - SCCLRGL RENAMED FROM SDCLRGL                     */
/*                - SCCLRSE RENAMED FROM SDCLRSE                     */
/*                - SCC1712 RENAMED FROM SDC1712                     */
/*                - SCC07 RENAMED FROM SDC07                         */
/*                - SCC01 RENAMED FROM SDC01                         */
/*                - SCC1716 RENAMED FROM SDC1716                     */
/*       E13205 - Apply fix E80902. Chgjob *dft instead *SYSRPLY     */
/*              - Use code from SCC07 to clear database daily files  */
/*                call to SCC01 removed as it steps on the date      */
/*              - Send 'BJ' entry and CM entry for user start up     */
/*    DELETE                                                         */
/*       S01179 - AS400 CONVERSION                                   */
/*       S01173 - USE SPECIFIED ASP FOR JOURNAL/RECEIVER             */
/*       S01118 - MIDAS/S.W.I.F.T. DIRECT LINK                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/******      PGM        PARM(&SDC01 &FLAG)                            /*S01343*/
             PGM        PARM(&SCC01 &FLAG)                            /*S01343*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&SUPPUPD) TYPE(*CHAR) LEN(20)                                 /*CSC018*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   Initial processing                                             */
/**/
/******      DCL        VAR(&SDC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&SCC01) TYPE(*CHAR) LEN(8)                /*S01343*/
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BKPS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
             DCL        VAR(&SWDR) TYPE(*CHAR) LEN(1)                 /*S01118*/
             DCL        VAR(&SEQN2) TYPE(*CHAR) LEN(10)               /*S01118*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*E13205*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*E13205*/
/************DCL        VAR(&CMTTXT) TYPE(*CHAR) LEN(112)  */ /*E13205 059503*/
             DCL        VAR(&CMTTXT) TYPE(*CHAR) LEN(460)            /*059503*/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(3)                 /*E13205*/
             DCL        VAR(&WSTI) TYPE(*CHAR) LEN(10)               /*059503*/
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)               /*E13205*/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)                 /*E13205*/
             DCL        VAR(&BLNK338) TYPE(*CHAR) LEN(338) +
                        VALUE(' ')                                   /*059503*/
/**********  DCLDTAARA  DTAARA(MNATN)                               *  *S01179*/
             DCL        VAR(&MNATN) TYPE(*CHAR) LEN(5)                /*S01179*/
/**********  DCLDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - journaling options for high availability                /*CSC018*/
/*                                                                                        /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&THRES6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&MAXOP6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&RMVIN6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MINFI6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&THRESHOLDB) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&THRESHOLDK) TYPE(*DEC) LEN(15 0)                             /*CSC018*/
             DCL        VAR(&THRESHOLDA) TYPE(*CHAR) LEN(10)                              /*CSC018*/
             DCL        VAR(&SIZOPT1) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT2) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&SIZOPT3) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(150)                                    /*CSC018*/
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)                                   /*CSC018*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
/**/
/*   Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('Convert Backup Machine to Primary Machine') +
                          TOMSGQ(MRUNQ)
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
/**/
/**********  RCVDTAARA  DTAARA(SDSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(%SST(&SDSTAT 6 2))
/*                                                                                        /*CSC018*/
/*  Check for Switchable feature CSC018 (Journaling options for high                      /*CSC018*/
/*  availability)                                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                                /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If feature CSC018 is present,                                                         /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
                                                                                          /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CSC018*/
                CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'HighAvlRcvSizeOption' &SVAL1 +
                             'HighAvlJrnRcvThld' &SVAL2 +
                             'HighAvlRmvIntJrnEnt' &SVAL3 +
                             'HighAvlMinFixLenJrnE' &SVAL4 +
                             'HighAvlContJrnSeqNum' &SVAL5 +
                             'HighAvlRmtJrnActive' &SVAL6 +
                             'HighAvlIgnTgtOnDel' &SVAL7 +
                             'HighAvlMangBackUpJrn' &SVAL8 +
                             'HighAvlJrnDtaaras' &SVAL9 +
                             'HighAvlJrnDtaqueues' &SVAL10)                               /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine the 2-character system I.D.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether *MAXOPT1 or *MAXOPT2 are to be used.                                /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MAXOP6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
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
/*  Check whether threshold defined on the system value is too big.                       /*CSC018*/
/*  If *MAXOPT1 or *MAXOPT2 is being used,                                                /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&MAXOP6 *EQ '1') *OR (&MAXOP6 *EQ +
                          '2')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater to or equal to 900 GB,                          /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRESHOLDA *GE '0900000000') THEN(DO)
/*                                                                                        /*CSC018*/
/*  set the value to a default of 10 gigabytes,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRESHOLDA) VALUE('0010000000')                           /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(10000000)                               /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(10000000000)                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0010000000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  if *MAXOPT1 or *MAXOPT2 are NOT being used,                                           /*CSC018*/
/*                                                                                        /*CSC018*/
              ELSE       CMD(DO)
/*                                                                                        /*CSC018*/
/*  if the requested threshold is greater to or equal to 1.5 GB,                          /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND(&THRESHOLDA *GE '0001500000') THEN(DO)
/*                                                                                        /*CSC018*/
/*  set the value to a default of 1.4 gigabytes,                                          /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&THRESHOLDA) VALUE('0001400000')                           /*CSC018*/
                CHGVAR     VAR(&THRESHOLDK) VALUE(1400000)                                /*CSC018*/
                CHGVAR     VAR(&THRESHOLDB) VALUE(1400000000)                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  and update the system value.                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&SVAL2 1 10)) VALUE('0001400000')                      /*CSC018*/
/*                                                                                        /*CSC018*/
               CALL       PGM(SD009510) PARM('HighAvlJrnRcvThld  ' +
                            &SVAL2 &SUPPUPD)                                              /*CSC018*/
               ENDDO                                                                      /*CSC018*/
              ENDDO                                                                       /*CSC018*/
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
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1755MPS                                          */
                                                                      /*S01408*/
/**/
/*   Check JNSTAT to make sure pgm being run on backup machine      */
/**/
             RTVDTAARA  DTAARA(JNSTAT (82 1)) RTNVAR(&BKPS)
             IF         COND(&BKPS *NE 'B') THEN(DO)
                SNDPGMMSG  MSG('This option can only be run on +
                                the backup machine') +
                                MSGTYPE(*INQ) TOPGMQ(*EXT)
                CHGJOB     SWS(XXXXXX1X)
                GOTO       END
             ENDDO
/**/
/*  Call SDC1756 to update database                                         */
/**/
             CALL       PGM(SDC1756)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*  Call SDC1757 to report last successful transactions on primary machine  */
/**/
             CALL       PGM(SDC1757)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/                                                                  /*S01118*/
/*  IF SWIFT DIRECT LINK PRESENT, RETRIEVE RECOVR TO POINT FROM         S01118*/
/*  JNSTAT DATA AREA AND RUN LOST INCOMING MESSAGES REPORT.             S01118*/
/**/                                                                  /*S01118*/
             IF         COND(&SWDR *EQ 'Y') THEN(DO)                  /*S01118*/
                   RTVDTAARA  DTAARA(JNSTAT (137 10)) +
                                RTNVAR(&SEQN2)                        /*S01118*/
             DSPJRN     JRN(ICJRN) FILE((MSIMSPF)) RCVRNG(ICRCV001) +
                          FROMENT(&SEQN2) PGM(MS4010) +
                          OUTPUT(*OUTFILE) OUTFILE(MSILSPF) /*S01118*/
                   MONMSG     MSGID(CPF7062)                          /*S01118*/
                   CALL       PGM(MSC1700)                            /*S01118*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO END)  /*S01118*/
/**/                                                                  /*S01118*/
/*  CALL PROGRAM TO AMEND MESSAGES WITH STATUT P or R To A              S01118*/
/**/                                                                  /*S01118*/
                   CALL       PGM(MS1701)                             /*S01118*/
/**/                                                                  /*S01118*/
             ENDDO                                                    /*S01118*/
/**/
/*  Call SD1740 to output 'Save Parameters Maintenance' screen                */
/*  and set on U6 so as not to allow Cmd/1 to be taken                        */
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABICD)
             CHGJOB     SWS(XXXXX1XX)
/**/
             CALL       PGM(SD1740) PARM('S')
/**/
             CHGJOB     SWS(XXXXX0XX)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*  End journalling and delete existing journal & receivers                 */
/**/
             ENDJRNPF   FILE(*ALL) JRN(ICJRN)
             MONMSG     MSGID(CPF9801)                                /*044329*/
             SNDPGMMSG  MSG('The journal and receivers are being +
                          deleted') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DLTJRN     JRN(ICJRN)
             MONMSG     MSGID(CPF2105)                                /*044329*/
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
/*   Delete all journal receivers                                   */
/**/
             DLTJRNRCV  JRNRCV(&JLIB/NEWNM001)
             MONMSG     MSGID(CPF7022 CPF2117 CPF2105)
             DLTJRNRCV  JRNRCV(&JLIB/ICRCV*)
/*********** MONMSG     MSGID(CPF7022 CPF2117)                     */ /*044327*/
             MONMSG     MSGID(CPF7022 CPF2117 CPF2125)                /*044327*/
/**/
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD)
/**/
/*  Create the new journal & receiver(s) -                                    */
/*  (a) if dual receivers are to be used                                      */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
             IF         COND(%SUBSTRING(&JNSTAT 70 1) *EQ 'Y') THEN(DO)
/**/
/*             CRTJRNRCV  JRNRCV(ICRCV001.&JLIB) TEXT('receiver for +
                          journal icjrn')  */                         /*S01173*/
/*             CRTJRNRCV  JRNRCV(ICRCV002.&JLIB) TEXT('receiver for +
                          journal icjrn')  */                         /*S01173*/
/*             CRTJRN     JRN(ICJRN.&JLIB) JRNRCV(ICRCV001 ICRCV002)*  *S01173*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) TEXT('receiver for +
                          journal icjrn') ASP(*LIBASP)                                    /*CSC043*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV002) TEXT('receiver for +
                          journal icjrn') ASP(*LIBASP)                                    /*CSC043*/
               CRTJRN     JRN(&JLIB/ICJRN) JRNRCV(ICRCV001 ICRCV002) +
                            ASP(*LIBASP)                                                  /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) TEXT('receiver for +
                          journal icjrn') ASP(%SST(&JNSTAT 151 2))    /*S01173*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV002) TEXT('receiver for +
                          journal icjrn') ASP(%SST(&JNSTAT 151 2))    /*S01173*/
               CRTJRN     JRN(&JLIB/ICJRN) JRNRCV(ICRCV001 ICRCV002) +
                            ASP(%SST(&JNSTAT 149 2))                  /*S01173*/
             ENDDO                                                                        /*CSC043*/
               CHGVAR     VAR(%SST(&JNSTAT 68 1)) VALUE('Y')
/**/
             ENDDO
/**/
/*  (b) if single receivers are to be used                                    */
/**/
             ELSE       CMD(DO)
/**/
/*             CRTJRNRCV  JRNRCV(ICRCV001.&JLIB) TEXT('receiver for +
                          journal icjrn')  */                         /*S01173*/
/*             CRTJRN     JRN(&JLIB/ICJRN) JRNRCV(ICRCV001) */        /*S01173*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are not being used,                                   /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND((&CSC018 *NE '       ') *OR ((&CSC018 +
                          *EQ '       ') *AND (&MAXOP6 *EQ ' '))) +
                          THEN(DO)                                                        /*CSC018*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) TEXT('receiver for +
                          journal icjrn') ASP(*LIBASP)                                    /*CSC043*/
               CRTJRN     JRN(&JLIB/ICJRN) JRNRCV(ICRCV001)  +
                            ASP(*LIBASP)                                                  /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
               CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) TEXT('receiver for +
                          journal icjrn') ASP(%SST(&JNSTAT 151 2))    /*S01173*/
               CRTJRN     JRN(&JLIB/ICJRN) JRNRCV(ICRCV001)  +
                            ASP(%SST(&JNSTAT 149 2))                  /*S01173*/
             ENDDO                                                                        /*CSC043*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If journal receiver size options are being used,                                       /*CSC018*/
/*                                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
/*                                                                                        /*CSC018*/
/* Create journal receiver with required threshold.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
              CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) ASP(*LIBASP) +
                          THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal ICJRN')                                             /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
              CRTJRNRCV  JRNRCV(&JLIB/ICRCV001) ASP(%SST(&JNSTAT 151 +
                          2)) THRESHOLD(&THRESHOLDK) TEXT('receiver +
                          for journal ICJRN')                                             /*CSC018*/
             ENDDO                                                                        /*CSC043*/
/*                                                                                        /*CSC018*/
/* Create journal with required size options.                                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR    VAR(&CMD) VALUE(' ')                                              /*CSC018*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CHGVAR     VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &JLIB +
                          *CAT '/ICJRN) JRNRCV(ICRCV001) +
                          ASP(*LIBASP) RCVSIZOPT(' *CAT &SIZOPT1 +
                          *BCAT &SIZOPT2 *BCAT &SIZOPT3 *TCAT ')')                        /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
              CHGVAR    VAR(&CMD) VALUE('CRTJRN JRN(' *CAT &JLIB *CAT +
                          '/ICJRN) JRNRCV(ICRCV001) ASP(' *CAT +
                          %SST(&JNSTAT 149 2) *CAT ') RCVSIZOPT(' +
                          *CAT &SIZOPT1 *BCAT &SIZOPT2 *BCAT +
                          &SIZOPT3 *TCAT ')')                                             /*CSC018*/
             ENDDO                                                                        /*CSC043*/
              CALL       PGM(QCMDEXC) PARM(&CMD 150)                                      /*CSC018*/
             ENDDO                                                                        /*CSC018*/
               CHGVAR     VAR(%SST(&JNSTAT 68 1)) VALUE('N')
/**/
             ENDDO
/**/
             SNDPGMMSG  MSG('The new journal and associated +
                          receiver(s) have been created') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSGID(MEM0004) MSGF(MIDAS) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
/***Call*SDC1730*to*start*journalling*the*physical*files***/          /*S01345*/
/**/
/************CALL       PGM(SDC1730) **/                              /*S01345*/
/**/                                                                  /*S01345*/
/*  Call SCJRN to start journalling the physical files  */            /*S01345*/
/**/                                                                  /*S01345*/
             CALL       PGM(SCJRN)                                    /*S01345*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*  Initialise MNATN & JNSTAT data areas                                      */
/**/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**********  RCVDTAARA  DTAARA(MNATN)                               *  *S01179*/
             RTVDTAARA  DTAARA(MNATN) RTNVAR(&MNATN)                  /*S01179*/
/**/
             CHGVAR     VAR(&MNATN) VALUE('00001')
/**/
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 1 20)) +
                          VALUE('ICRCV001  ICRCV001  ')
/*/COPY WNCPYSRC,SDC1755001                                          */
             CHGVAR     VAR(%SUBSTRING(&JNSTAT 63 5)) +
                          VALUE('DB001')
/*/COPY WNCPYSRC,SDC1755002                                          */
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
/***Call*SDC1716*to*change*journal*receivers                          /*S01343*/
/*  Call SCC1716 to change journal receivers                          /*S01343*/
/**/
/******      CALL       PGM(SDC1716) PARM(0)                          /*S01343*/
             CALL       PGM(SCC1716) PARM(0)                          /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*  Call SD1050 to update LDA with name of day for B.O.B. save                */
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABSDM)
             CALL       PGM(SD1050)
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                             TOPGMQ(*EXT)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/***Call*SDC1712 to save the master library (B.O.B. save)             /*S01343*/
/*****       CALL       PGM(SDC1712) PARM('B' ' ')                    /*S01343*/
/**/
/*  Call SCC1712 to save the master library (B.O.B. save)             /*S01343*/
/**/
             CALL       PGM(SCC1712) PARM('B' ' ')                    /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*  Change backup system flag in JNSTAT to 'P'                                */
/**/
             CHGDTAARA  DTAARA(JNSTAT (82 1)) VALUE('P')
/**/
/*  Change parameters to initiate I-C on return to calling program            */
/**/
/*           CHGVAR     VAR(&SCC01) VALUE('SCC01')                 */ /*E13205*/
/*           CHGVAR     VAR(&FLAG) VALUE('D')                      */ /*E13205*/
/**/                                                                  /*E13205*/
/*    Clear General Ledger Daily files.                            */ /*E13205*/
/**/                                                                  /*E13205*/
             CALL       PGM(SCCLRGL)                                  /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
/**/                                                                  /*E13205*/
/*    Clear Dealing Daily files.                                   */ /*E13205*/
/**/                                                                  /*E13205*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND((%SUBSTRING(&MMOD 2 1)) *EQ 'Y') +
                          THEN(CALL PGM(SCCLRDL))                     /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
/**/                                                                  /*E13205*/
/*   Clear Retail Daily files.                                     */ /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND(%SST(&MMOD 16 1) *EQ 'Y') THEN(CALL +
                          PGM(SDCLRRE))                               /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
/**/                                                                  /*E13205*/
/****Clear*Commercial*Loans*Daily*files.******          */ /*E13205*/ /*S01343*/
/*****/                                                    /*E13205*/ /*S01343*/
/*****       IF         COND((%SUBSTRING(&MMOD 4 1)) *EQ 'Y') +
/*****                    THEN(CALL PGM(SDCLRCL))          /*E13205*/ /*S01343*/
/*****       IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
/*****                    CMDLBL(ABNOR))                   /*E13205*/ /*S01343*/
/**/                                                                  /*E13205*/
/*  Call SCCLRFD for D.R.S. Users       Amendment F00070              /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND((%SUBSTRING(&MMOD 11 1)) *EQ 'Y') +
                          THEN(CALL PGM(SCCLRFD))                     /*E13205*/
                                                                      /*E13205*/
/**/                                                                  /*E13205*/
/*  Call SCCLRFX for D.R.S. Users       Amendment F00070              /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND((%SUBSTRING(&MMOD 13 1)) *EQ 'Y') +
                           THEN(CALL PGM(SCCLRFX))                    /*E13205*/
/**/                                                                  /*E13205*/
/*   Clear Securities Trading Daily files.                         */ /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND((%SUBSTRING(&MMOD 5 1)) *EQ 'Y') +
                          THEN(CALL PGM(SDCLRST))                     /*E13205*/
/**/                                                                  /*E13205*/
/*   Clear Letters of Credit Daily files.                          */ /*E13205*/
/**/                                                                  /*E13205*/
             IF         COND((%SUBSTRING(&MMOD 6 1)) *EQ 'Y') +
                          THEN(CALL PGM(SDCLRBC))                     /*E13205*/
/**/                                                                  /*E13205*/
/*   Clear Securities Trading Rel. 2 Daily files.                  */ /*E13205*/
/**/                                                                  /*E13205*/
/******      IF         COND((%SUBSTRING(&MMOD 21 1)) *EQ 'Y') +
                          THEN(CALL PGM(SDCLRSE))          /*E13205*/ /*S01343*/
             IF         COND((%SUBSTRING(&MMOD 21 1)) *EQ 'Y') +
                          THEN(CALL PGM(SCCLRSE))                     /*S01343*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))                              /*E13205*/
/**/                                                                  /*E13205*/
/****Send*journal*entries*to*simulate*start*up*like*SDC07 /*E13205*/  /*S01343*/
/*   Send journal entries to simulate start up like SCC07          */ /*S01343*/
/**/                                                                  /*E13205*/
/**********  SNDJRNE    JRN(ICJRN) TYPE('BJ') */                              /*E13205*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('BJ') FORCE(*YES)                                /*BUG9619*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*E13205 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/**/                                                                  /*E13205*/
             RTVJOBA    JOB(&JOB) USER(&USRID)                        /*E13205*/
             CHGVAR     VAR(&WSID) VALUE(&JOB)                        /*E13205*/
             CHGVAR     VAR(&WSTI) VALUE(&JOB)                       /*059503*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)                   /*E13205*/
/************CHGVAR     VAR(&CMTTXT) VALUE('       +       */ /*E13205 059503*/
/************           MIDAS   ' *CAT +  &WSID *CAT +     */ /*E13205 059503*/
/************           &TIME *CAT' ' *CAT &USRID *CAT +   */ /*E13205 059503*/
/************           '               MIDAS Initial +    */ /*E13205 059503*/
/************           Program - No committed +           */ /*E13205 059503*/
/************           transactions for this job')        */ /*E13205 059503*/
             CHGVAR     VAR(&CMTTXT) VALUE('       MIDAS   ' *CAT +
                        &WSID *CAT &TIME *CAT ' ' *CAT &USRID +
                        *CAT '               MIDAS Initial Program +
                        - No committed transactions for this +
                        job' *CAT &BLNK338 *CAT &WSTI)               /*059503*/
             OPNDBF     FILE(TABTB10) OPTION(*INP) COMMIT(*YES)       /*E13205*/
             COMMIT     CMTID(&CMTTXT)                                /*E13205*/
             CLOF       OPNID(TABTB10)                                /*E13205*/
             ENDCMTCTL                                                /*E13205*/
/**/                                                                  /*E13205*/
/*  START AUTOBACKUP IF REQUIRED                                   */ /*E13205*/
/**/                                                                  /*E13205*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*E13205*/
             IF         COND((%SUBSTRING(&JNSTAT 106 5)) *NE '00000') +
                          THEN(CALL PGM(SDC1760))                     /*E13205*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              /*E13205*/
             GOTO       CMDLBL(ABNOR)                                 /*E13205*/
             ENDDO                                                    /*E13205*/
/**/
             GOTO       END
/**/
ABNOR:       SNDPGMMSG  MSG('Convert Backup Machine to Primary Machine +
                        ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*           RMVRPYLE   SEQNBR(3)                                  */ /*E13205*/
/*           MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*E13205*/
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
/**/
