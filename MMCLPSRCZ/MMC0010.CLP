/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM menu option control program.')               */
/*********************************************************************/
/*                                                                   */
/*       MIDAS MM MODULE                                             */
/*                                                                   */
/*       MMC0010 - MM MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 116094             DATE 06Jun06             */
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      103997             Date 17Sep97              */
/*                      S01408             DATE 17SEP96              */
/*                      S01408             DATE 07DEC95              */
/*                      S01408             DATE 30OCT95              */
/*                      084620             DATE 13MAR95              */
/*                      080570             DATE 07MAR95              */
/*                      055959             DATE 21JUL93              */
/*                      047741             DATE 17MAR93              */
/*                      047073             DATE 13NOV92              */
/*                      E26955            DATE  04FEB92              */
/*                      E29018            DATE  30SEP91              */
/*                      E27535            DATE  05SEP91              */
/*                      S01310            DATE  06AUG91              */
/*                      LN1215            DATE  18MAR91              */
/*                      E20773            DATE  05NOV90              */
/*                      E17147            DATE  11/07/89             */
/*                      E16242            DATE  13/12/88             */
/*                      E14358            DATE  30/10/88             */
/*                      E13300            DATE  30/10/88             */
/*                      S01154            DATE  24/08/88             */
/*                      E13401            DATE  01/06/88             */
/*                      E12693            DATE  23/03/88             */
/*                      E12176            DATE  24/02/88             */
/*                      S01136            DATE  12/01/88             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       116094 - Call DLC0211 via FCC0201 instead of via FCC0202.   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     103997 - Move change of DLSTAT position 6 ='Y', from          */
/*              FXC0010 & MMC0010 to the start of DLC0210A           */
/*              to prevent non-submission of pay/receive job.        */
/*     S01408 - Addition of core hooks MMC0010007                    */
/*                                     MMC0010006                    */
/*                                     MMC0010005                    */
/*     S01408 - Addition of core hooks MMC0010003                    */
/*                                     MMC0010004                    */
/*     S01408 - ADDITION OF CORE HOOK MMC0010001                     */
/*              ADDITION OF CORE HOOK MMC0010002                     */
/*     084620 - Output error screen to user if abnormal termination  */
/*      080570 - On return from call of MM0028 (deal amendments)     */
/*               subsequent Pay/Receive generation for any amended   */
/*               deal instructions does not work unless DTRIXHH      */
/*               field RRLC is set to reflect the correct number of  */
/*               detail records on DTRIXDD. To solve this on return  */
/*               from MM0028 call, a dummy confirmation run is       */
/*               submitted (DLC0210A) to ensure that DTRIXHH holds   */
/*               correct value in RRLC.                              */
/*       055959 - Additional fix to 047073.                          */
/*                                                                   */
/*  047741 - PRONO SHOULD BE OVERRIDDEN TO SHARE(*NO) FOR CALL TO ED */
/*           MM0025 (DEAMS RANGE AUTHORISATION) OR THERE MAY BE   ED */
/*           A SUBSEQUENT ERROR IN MM0087 IF A DEAM IS AMENDED.   ED */
/*           ALSO CHANGED FOR MM0069.                             ED */
/*                                                                ED */
/*      047073 - V2 OF OPERATING SYSTEM CAUSES CPF94FC, TYPEAHEAD    */
/*               DATA STREAM NOT SUPPORTED BY CONTROLLER.            */
/*      E26955 - WORKSTATION ID REQUIRED FOR PAY/RCV ERROR MSGS.     */
/*               CALL P/R PROCESSING VIA FCC0201 WHICH CALLS         */
/*               DUMMY PROMPT PROGRAM MGC6000.                       */
/*                                                                   */
/*      E29018 - E27535 INCORRECT FIX - REMOVE ALL PROCESSING        */
/*               ASSOCIATED WITH SWSTAT - POSITION 9.                */
/*                                                                   */
/*      E27535 - MSSTAT USED IN PLACE OF SWSTAT IN R10               */
/*                                                                  */
/*      S01310 - AUTO-GENERATION OF PAY/RECEIVES FOR MG             */
/*                                                                  */
/*      LN1215 - SET OFF KEYBOARD BUFFERING BEFORE CALL TO MM0089   */
/*               MM0026, MM0027, MM0028                             */
/*                                                                  */
/*      E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)        */
/*               & INLLIBL(*JOBD).                                  */
/*                                                                  */
/*      E17147 - MMC0010 should submit a job for confirmations for  */
/*               Range Authorisations (MM0069).                     */
/*                                                                  */
/*      E16242 - MMC0010 should submit a job for confirmations for  */
/*               MM0026 and MM0027 as well as for MM0089.           */
/*                                                                  */
/*      E14358 - Reverse E13401 and correct Program Message text.   */
/*                                                                  */
/*      E13300 - ADD CONFIRMATION PROCESSING.                       */
/*                                                                  */
/*      S01154 - Real time statements - overriding PRONO to         */
/*               share(*no) for four components                     */
/*                                                                  */
/*      E13401 - Database error message now sent to *PRV instead    */
/*               of *EXT.                                           */
/*                                                                  */
/*      E12693 - Program level monitor message included with        */
/*              a reclaim resources statement.                      */
/*                                                                  */
/*      E12176 - Database error message now sent to *EXT as well    */
/*      as MOPERQ.                                                  */
/*                                                                  */
/*      S01136 - MM BO programs should be called with 1 byte        */
/*      termination parameter set to blank.                         */
/*                                                                  */
/*                                                                  */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PARM)
             DCL        &PARM         TYPE(*CHAR)  LEN(8)
             DCL        &MSG          TYPE(*CHAR)  LEN(50)
/*******     DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)               *  *S01136*/
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01136*/
/* DATA AREA VARIABLES */ /*START OF E13300*/                         /*E13300*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*E13300*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*E13300*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*084620*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*084620*/
/************DCL        VAR(&SWSTAT) TYPE(*CHAR) LEN(256)     *E13300* *E27535*/
/************DCL        VAR(&MSSTAT) TYPE(*CHAR) LEN(256)       /*E27535E29018*/
/**/                      /*END OF E13300*/                           /*E13300*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MMC0010005                                        */ /*S01408*/
                                                                      /*S01408*/
             DCL VAR(&KEYBUF) TYPE(*CHAR) LEN(1)                      /*LN1215*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01310*/
             DCLF       FILE(SDMGMEPD)
                                                                      /*S01310*/
/**/
/* Monitor for error messages not trapped in the rest of the */       /*E12693*/
/* program. If they occur reclaim resources and exit.        */       /*E12693*/
     MONMSG MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
            EXEC(GOTO CMDLBL(ERR))                                    /*E12693*/
     GOTO CMDLBL(RUN)                                                 /*E12693*/
ERR:                                                                  /*E12693*/
     RCLRSC                                                           /*E12693*/
     RETURN                                                           /*E12693*/
/**/
RUN:                                                                  /*E12693*/
/*  FIRST RESET JOB SWITCHES */
             CHGJOB     SWS(XXXXXX00)
/*  PRONO needs to have SHARE(*NO) for certain components otherwise *  *S01154*/
/*  they crash */                                                     /*S01154*/
                                                     /*047741*/
/***IF COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ 'MM0027') *OR +
            (&PARM *EQ 'MM0028') *OR (&PARM *EQ 'MM0089')) THEN(+
            OVRDBF PRONO  SHARE(*NO))******************************** /*S01154*/
 
/*/COPY WNCPYSRC,MMC0010001                                        */ /*S01408*/
                                                                      /*S01408*/
    IF COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ 'MM0027') *OR +
            (&PARM *EQ 'MM0028') *OR (&PARM *EQ 'MM0089') *OR +
            (&PARM *EQ 'MM0025') *OR (&PARM *EQ 'MM0069')) THEN(+
            OVRDBF PRONO  SHARE(*NO))                                 /*S01154*/
                                                     /*047741*/
/*/COPY WNCPYSRC,MMC0010002                                        */ /*S01408*/
 
/* FIX  047073 STARTS HERE */
/*********** IF         COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ +
                          'MM0027') *OR (&PARM *EQ 'MM0028') *OR +
                          (&PARM *EQ 'MM0089')) THEN(CALL +
                          PGM(QWSSETWS) PARM('0'))  ****/ /*LN1215*/
/*/COPY WNCPYSRC,MMC0010008                                          */
 
             IF         COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ +
                          'MM0027') *OR (&PARM *EQ 'MM0028') *OR +
                          (&PARM *EQ 'MM0089')) THEN(DO)
/*/COPY WNCPYSRC,MMC0010009                                          */
 
                      CALL       PGM(QWSSETWS) PARM('0')
                      MONMSG     MSGID(CPF0000)
/* FIX  047073 ENDS HERE */
 
             ENDDO
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MMC0010003                                        */ /*S01408*/
                                                                      /*S01408*/
/*  CALL PROGRAM             */
/*/COPY WNCPYSRC,MMC0010015                                          */
/************CALL       PGM(&PARM)                                   *S01136*/
     CALL PGM(&PARM) PARM(&TERM)                                    /*S01136*/
/*/COPY WNCPYSRC,MMC0010010                                          */
 
             IF         COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ +
                          'MM0027') *OR (&PARM *EQ 'MM0028') *OR +
                          (&PARM *EQ 'MM0089')) THEN(DO)              /*LN1215*/
/*/COPY WNCPYSRC,MMC0010011                                          */
             RTVDTAARA  DTAARA(SDSTAT (11 1)) RTNVAR(&KEYBUF)         /*LN1215*/
/************IF         COND(&KEYBUF *NE N) THEN(CALL +              /*055959*/
/************             PGM(QWSSETWS) PARM('1'))          /*LN1215* *055959*/
/* */                                                                /*055959*/
             IF         COND(&KEYBUF *NE N) THEN(DO)                 /*055959*/
                          CALL     PGM(QWSSETWS) PARM('1')           /*055959*/
                          MONMSG   MSGID(CPF0000)                    /*055959*/
                          ENDDO                                      /*055959*/
/* */                                                                /*055959*/
             ENDDO                                                    /*LN1215*/
 
                                                     /*047741*/
/************IF         COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ +
                          'MM0027') *OR (&PARM *EQ 'MM0028') *OR +
                          (&PARM *EQ 'MM0089')) THEN(DLTOVR +
                          FILE(PRONO)) /* E17147 */
/*/COPY WNCPYSRC,MMC0010012                                          */
             IF         COND((&PARM *EQ 'MM0026') *OR (&PARM *EQ +
                          'MM0027') *OR (&PARM *EQ 'MM0028') *OR +
                          (&PARM *EQ 'MM0089') *OR (&PARM *EQ +
                          'MM0025') *OR (&PARM *EQ 'MM0069')) +
                          THEN(DLTOVR FILE(PRONO))
                                                     /*047741*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MMC0010004                                        */ /*S01408*/
                                                                      /*S01408*/
/****DLTOVR PRONO                                          /*S01154*/ /*E17147*/
/*  IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
/*  AND *EXT:                                                  */     /*E12176*/
/*/COPY WNCPYSRC,MMC0010020                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*/COPY WNCPYSRC,MMC0010021                                          */
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)
/*                                                                  *  *E12176*/
/************** SNDPGMMSG MSG('Option ended in error - Press Reset') + *E14358*/
/***************SNDPGMMSG MSG('Transaction Failed. Re-input Necessary. +
/***************          Press ENTER to Continue.') TOPGMQ(*EXT)*E14358084620*/
/************** TOPGMQ(*PRV) ******************************  *E13401*  *E14358*/
/*              TOPGMQ(*EXT)                                        *  *E13401*/
                                                                      /*084620*/
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */              /*084620*/
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)   /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)     /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
             RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)   /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
             CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')             /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
             CALL       PGM(SCC0010) PARM('MMC0010' 'ENTER' &NOREPLY) /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
/*                                                                  *  *E12176*/
                ROLLBACK
             ENDDO
 /* ADD PROCESSING FOR CONFIRMATIONS */         /*START E13300*/      /*E13300*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 /* DO CONFIRMATIONS IF BACK OFFICE DEAL INPUT CALLED */
/*******     IF         COND(&PARM *EQ 'MM0089') THEN(DO)   *****/    /*E16242*/
/** E17147   IF         COND((&PARM *EQ 'MM0089') *OR        + **/
/** E17147                   (&PARM *EQ 'MM0026') *OR        + **/
/** E17147                   (&PARM *EQ 'MM0027')) THEN(DO) *****/    /*E16242*/
/**********  IF         COND((&PARM *EQ 'MM0089') *OR (&PARM *EQ +
/**********               'MM0026') *OR (&PARM *EQ 'MM0027') *OR +
/**********               (&PARM *EQ 'MM0069')) THEN(DO)*/ /*E17147*/ /*080570*/
/*/COPY WNCPYSRC,MMC0010013                                          */
             IF         COND((&PARM *EQ 'MM0089') *OR (&PARM *EQ +
                          'MM0026') *OR (&PARM *EQ 'MM0027') *OR +
                          (&PARM *EQ 'MM0069') *OR (&PARM *EQ +
                          'MM0028')) THEN(DO)                         /*080570*/
/*/COPY WNCPYSRC,MMC0010014                                          */
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MMC0010006                                        */ /*S01408*/
                                                                      /*S01408*/
/************      ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/************      CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *103997*/
/************      DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/************RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&SWSTAT)                 *E27535*/
/************         IF        COND(%SST(&SWSTAT 9 1) *EQ Y) THEN(DO) *E27535*/
/************RTVDTAARA  DTAARA(MSSTAT) RTNVAR(&MSSTAT)          /*E27535E29018*/
/************        IF        COND(%SST(&MSSTAT 9 1) *EQ Y) THE/*E27535E29018*/
/************            ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))     /*E29018*/
/************            CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('N')   /*E29018*/
/************            DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))     /*E29018*/
/************         ENDDO                                           /*E29018*/
/************ELSE   DO                                                /*E29018*/
                      SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
                                                                      /*E20773*/
/*/COPY WNCPYSRC,MMC0010016                                          */
/**********           SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) + */
/**********              RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ) */
/**********           SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD)  + */
/**********              RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/*/COPY WNCPYSRC,MMC0010017                                          */
                                                                      /*E20773*/
                                                                      /*S01310*/
                     RCVF
         /********** IF         COND(&ENAPRG *EQ 'Y') THEN(DO)         *E26955*/
         /********** CALL  PGM(FCC0202) PARM('DLC0211' '10001' +       *E26955*/
         /********** 'DL0308' 'B')                                     *E26955*/
                     IF         COND(&ENAPRG *EQ 'Y') THEN(DO)        /*E26955*/
                     CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                     'DL0308' 'B')                                    /*E26955*/
                     ENDDO
                                                                      /*S01310*/
/******************ENDDO                                              /*E29018*/
                ENDDO
             ENDDO
             ELSE   DO
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MMC0010007                                        */ /*S01408*/
                                                                      /*S01408*/
/***********       ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/***********       CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *103997*/
/***********       DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
                                                                      /*E20773*/
/*/COPY WNCPYSRC,MMC0010018                                          */
/**********        SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) + */
/**********           RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ) */
/**********        SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) + */
/**********           RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/*/COPY WNCPYSRC,MMC0010019                                          */
                                                                      /*E20773*/
                                                                      /*S01310*/
                     RCVF
                     IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
/******************* CALL  PGM(FCC0202) PARM('DLC0211' '10001' + */                       /*116094*/
/******************* 'DL0308' 'B')                               */                       /*116094*/
                       CALL       PGM(FCC0201) PARM('DLC0211' '10001' 'DL0308' +
                                    'B')                                                  /*116094*/
                     ENDDO
                                                                      /*S01310*/
                ENDDO
             ENDDO
                ENDDO
             ENDDO
  /*                                          *  *END E13300*          *E13300*/
/**/
/*  RECLAIM RESOURCES TO PURGE THE FX UPDATE PROGRAMS FROM */
/*  MEMORY, AND RELEASE THEIR FILES                        */
             RCLRSC
/**/
/*  END THE PROGRAM */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
