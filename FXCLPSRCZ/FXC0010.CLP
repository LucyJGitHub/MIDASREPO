/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas fx menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*     Midas - FX Dealer Module                                      */
/*                                                                   */
/*     FXC0010   - FX MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 116094             Date 06JUN06              */
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      103997             Date 17Sep97              */
/*                      S01408             Date 17SEP96              */
/*                    S01408              DATE 30OCT95               */
/*                    087845              DATE 17MAR95               */
/*                    084620              DATE 13MAR95               */
/*                    047073              DATE 13NOV92               */
/*                    E26955              DATE 04FEB92               */
/*                    E29018              DATE 30SEP91               */
/*                    E27535              DATE 05SEP91               */
/*                    S01310              DATE 06AUG91               */
/*     AMEND NO. LN1215                   DATE 18MAR91               */
/*     AMEND NO. E20773                   DATE 25FEB90               */
/*     AMEND NO. E16967                   DATE 04/05/89              */
/*     AMEND NO. S01154                   DATE 01/11/88              */
/*     AMEND NO. E14358                   DATE 26/08/88              */
/*     AMEND NO. E13300                   DATE 10/06/88              */
/*     AMEND NO. E13401                   DATE 01/06/88              */
/*     AMEND NO. E12693                   DATE 23/03/88              */
/*     AMEND NO. E12176                   DATE 24/02/88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     116094 - Call DLC0211 via FCC0201 instead of via FCC0202.     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*     103997 - Move change of DLSTAT position 6 ='Y', from          */
/*              FXC0010 & MMC0010 to the start of DLC0210A           */
/*              to prevent non-submission of pay/receive job.        */
/*     S01408 - ADDITION OF CORE HOOK FXC0010005                     */
/*              ADDITION OF CORE HOOK FXC0010004                     */
/*              ADDITION OF CORE HOOK FXC0010003                     */
/*     S01408 - ADDITION OF CORE HOOK FXC0010001                     */
/*              ADDITION OF CORE HOOK FXC0010002                     */
/*     087845 - From FX0820 and FX0830 we should not check DLSTAT    */
/*              postn 7 before submitting Confirmations. This just   */
/*              means DLC0211 is running just now. If it is we want  */
/*              to submit the jobs for any new confirmations.        */
/*     084620 - Output error screen to user if abnormal termination  */
/*     047073 - V2 OF OPERATING SYSTEM CAUSES CPF94FC, TYPEAHEAD     */
/*              DATA STREAM NOT SUPPORTED BY CONTROLLER.             */
/*     E26955 - WORKSTATION ID REQUIRED FOR PAY/RCV ERROR MSGS.      */
/*              CALL P/R PROCESSING VIA FCC0201 WHICH CALLS          */
/*              DUMMY PROMPT PROGRAM MGC6000.                        */
/*     E29018 - E27535 INCORRECT FIX - REMOVE ALL PROCESSING         */
/*              ASSOCIATED WITH SWSTAT - POSITION 9.                 */
/*     E27535 - MSSTAT USED IN PLACE OF SWSTAT IN R10                */
/*     S01310 - AUTO-GENERATION OF PAY/RECEIVES FOR MG               */
/*     LN1215 - SET OFF KEYBOARD BUFFERING BEFORE CALL TO FX0820     */
/*     E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)          */
/*              & INLLIBL(*JOBD).                                    */
/*     E16967 - ADD CONFIRMATION PROCESSING FOR DEAL RANGE           */
/*                                                 AUTHORISATIONS.   */
/*     S01154 - REAL TIME STATEMENTS - PRONO NEEDS TO HAVE ITS       */
/*              ACCESS PATH NOT SHARED WHEN CALLING FX0820           */
/*     E14358 - Reverse E13401 and correct Program Message text.     */
/*     E13300 - ADD CONFIRMATION PROCESSING                          */
/*     E13401 - Database error message sent to *PRV instead          */
/*              of *EXT.                                             */
/*     E12693 - Program level monitor message included with          */
/*              a reclaim resources statement.                       */
/*     E12176 - DATABASE ERROR MESSAGE NOW SENT TO *EXT AS WELL      */
/*              AS MOPERQ                                            */
/*                                                                   */
/*********************************************************************/
 
/*/COPY WNCPYSRC,FXC0010011                                          */
     PGM PARM(&PARM)
/*/COPY WNCPYSRC,FXC0010006                                          */
     DCL VAR(&PARM) TYPE(*CHAR) LEN(8)
     DCL VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* DATA AREAS REQUIRED */ /*START OF E13300*/                         /*E13300*/
             DCL VAR(&MMOD)  TYPE(*CHAR) LEN(256)                     /*E13300*/
             DCL VAR(&DLSTAT) TYPE(*CHAR) LEN(256)                    /*E13300*/
/************DCL VAR(&SWSTAT) TYPE(*CHAR) LEN(256)            *E13300* *E27535*/
/************DCL VAR(&MSSTAT) TYPE(*CHAR) LEN(256)              /*E27535E29018*/
/**/                      /*END OF E13300*/                           /*E13300*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*084620*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*084620*/
             DCL VAR(&KEYBUF) TYPE(*CHAR) LEN(1)                      /*LN1215*/
 
/*/COPY WNCPYSRC,FXC0010003                                        */ /*S01408*/
 
                                              /*START S01310*/
             DCLF       FILE(SDMGMEPD)
                                              /*END   S01310*/
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
/* FIRST RESET THE JOB SWITHCHES */
     CHGJOB SWS(XXXXXX00)
/* IF PARAMTER IS FX0820 THEN PRONO NEEDS TO BE OVERRIDDEN SHARE(*NO)*/
     IF COND(&PARM *EQ 'FX0820') THEN(OVRDBF PRONO SHARE(*NO))        /*S01154*/
 
/*/COPY WNCPYSRC,FXC0010001                                        */ /*S01408*/
 
/* FIX 047073 STARTS HERE */
/*           IF         COND(&PARM *EQ 'FX0820') THEN(CALL +
                          PGM(QWSSETWS) PARM('0'))       */           /*LN1215*/
/*   IF COND(&PARM *EQ 'FX0820') THEN(OVRDBF PRONO SHARE(*NO))        /*S01154*/
             IF         COND(&PARM *EQ 'FX0820') THEN(DO)
             CALL       PGM(QWSSETWS) PARM('0')
             MONMSG     MSGID(CPF0000)
             ENDDO
/* FIX 047073 ENDS HERE */
/* CALL PROGRAM                  */
/*/COPY WNCPYSRC,FXC0010007                                          */
     CALL PGM(&PARM)
/*/COPY WNCPYSRC,FXC0010008                                          */
                                                /*START E16967*/      /*E16967*/
             IF         COND(&PARM *EQ 'FX0820') THEN(DO)             /*LN1215*/
             RTVDTAARA  DTAARA(SDSTAT (11 1)) RTNVAR(&KEYBUF)         /*LN1215*/
/* FIX 047073 STARTS HERE */
/*           IF         COND(&KEYBUF *NE N) THEN(CALL +
                          PGM(QWSSETWS) PARM('1'))         */         /*LN1215*/
             IF         COND(&KEYBUF *NE N) THEN(DO)
             CALL       PGM(QWSSETWS) PARM('1')
             MONMSG     MSGID(CPF0000)
             ENDDO
/* FIX 047073 ENDS HERE */
             ENDDO                                                    /*LN1215*/
     IF COND(&PARM *EQ 'FX0820') THEN(DLTOVR PRONO )                  /*E16967*/
 
/*/COPY WNCPYSRC,FXC0010002                                        */ /*S01408*/
 
 /***DLTOVR PRONO                                  */     /*S01154*/  /*E16967*/
                                                  /*END E16967*/      /*E16967*/
 /* IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
 /**AND**EXT:************                                  */  /*E12176 084620*/
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
          RTVDTAARA DTAARA(*LDA (134 50)) RTNVAR(&MSG)
          SNDPGMMSG MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) -
          TOMSGQ(MOPERQ)
/*                                                                  *  *E12176*/
/*********SNDPGMMSG MSG('Option ended in error - Press Reset') + ****  *E14358*/
/*********SNDPGMMSG MSG('Transaction Failed. Re-input Necessary. +
/*********          Press ENTER to Continue.') TOPGMQ(*EXT)    /*E14358 084620*/
/*********TOPGMQ(*PRV) ************************************  *E13401*  *E14358*/
/*********TOPGMQ(*EXT)                                              *  *E13401*/
/*                                                                  *  *E12176*/
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN */               /*084620*/
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
             CALL       PGM(SCC0010) PARM('FXC0010' 'ENTER' &NOREPLY) /*084620*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*084620*/
                                                                      /*084620*/
          ROLLBACK
     ENDDO
 /*                                                                */
 /* ADD PROCESSING FOR CONFIRMATIONS */         /*START E13300*/      /*E13300*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 /* DO CONFIRMATIONS IF BACK OFFICE DEAL INPUT CALLED */
          /* OR DEAL RANGE AUTHORISATION */     /*START E16967*/      /*E16967*/
 /***********IF         COND(&PARM *EQ 'FX0820') THEN(DO) */
/*/COPY WNCPYSRC,FXC0010009                                          */
             IF         COND((&PARM *EQ 'FX0830') *OR +
                            (&PARM *EQ 'FX0820')) THEN(DO)
/*/COPY WNCPYSRC,FXC0010010                                          */
                                                  /*END E16967*/      /*E16967*/
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
/*************  IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)    087845*/
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)   /*087845*/
 
/*/COPY WNCPYSRC,FXC0010004                                        */ /*S01408*/
 
/************      ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/************      CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *103997*/
/************      DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/************RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&SWSTAT)               * *E27535*/
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
/*/COPY WNCPYSRC,FXC0010012                                          */
/**********           SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) + */
/**********              RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ)  */
/**********           SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) + */
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
/*/COPY WNCPYSRC,FXC0010013                                          */
                                                                      /*E20773*/
                                                    /*START S01310*/
                     RCVF
 /***********        IF         COND(&ENAPRG *EQ 'Y') THEN(DO)         *E26955*/
 /***********        CALL  PGM(FCC0202) PARM('DLC0211' '10001' +       *E26955*/
 /***********        'DL0308' 'B')                                     *E26955*/
/*/COPY WNCPYSRC,FXC0010016                                          */
             IF         COND(&ENAPRG *EQ 'Y') THEN(DO)                /*E26955*/
             CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
             'DL0308' 'B')                                            /*E26955*/
                     ENDDO
/*/COPY WNCPYSRC,FXC0010017                                          */
                                                    /*END   S01310*/
/******************ENDDO                                              /*E29018*/
                ENDDO
             ENDDO
             ELSE   DO
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 /* CHECK THAT CONFIRMATION PROCESS IS NOT ALREADY RUNNING */
                IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
/*/COPY WNCPYSRC,FXC0010005                                        */ /*S01408*/
 
/***********       ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
/***********       CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')          *103997*/
/***********       DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))            *103997*/
                   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
                                                                      /*E20773*/
/*/COPY WNCPYSRC,FXC0010014                                          */
/**********        SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) + */
/**********           RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ)  */
/**********        SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +  */
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
/*/COPY WNCPYSRC,FXC0010015                                          */
                                                                      /*E20773*/
                                                 /*START S01310*/
                     RCVF
                     IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
/******************* CALL  PGM(FCC0202) PARM('DLC0211' '10001' +                     *****  116094*/
/******************* 'DL0308' 'B')                                                   *****  116094*/
                     CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                     'DL0308' 'B')                                                        /*116094*/
                     ENDDO
                                                 /*END   S01310*/
                ENDDO
             ENDDO
                ENDDO
             ENDDO
  /*                                          *  *END E13300*/        /*E13300*/
 /**/
 /* RECLAIM RESOURCES TO PURGE THE FX UPDATE PROGRAMS FROM     */
 /* MEMORY,AND RELEASE THEIR FILES                             */
     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END: +
     ENDPGM
