/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA I/C 0 Rate Fix Days - Control 1')        */
/********************************************************************/
/*                                                                  */
/* Midas - FRA/IRS Module                                           */
/*                                                                  */
/* DLC1920 - ZERO RATE FIX CONTROL - 1                              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CSW011         DATE  10APR97                */
/*       PREV AMEND NO. S01408         DATE  14SEP95                */
/*                      CIR001         DATE  31AUG95                */
/*                      E27535         DATE  20AUG91                */
/*                      S01310         DATE  22JUL91                */
/*                      S01117         DATE  13AUG90                */
/*                      E20773         DATE  25FEB90                */
/*                      S01194         DATE  17NOV89                */
/*                      S01203         DATE  29/03/89               */
/*                      S01157         DATE  25/01/89               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*         CSW011 - FRA MT34n Message Generation only               */
/*         S01408 - Addition of core hook DLC1920INT                */
/*                  Addition of core hook DLC1920001                */
/*                  Addition of core hook DLC1920002                */
/*                  Addition of core hook DLC1920003                */
/*         CIR001 - Interest Rate Calendars.                        */
/*         E27535 - Remove use of SWSTAT and indicators on there -  */
/*                  (&COMP - SWIFT message Compression active and   */
/*                  (&DLMSG - Dealing messages Ready to go)         */
/*                  since no longer used.                           */
/*         S01310 - SWIFT RATIONALISATION CHANGES                   */
/*         S01117 - MULTIBRANCHING CHANGES (RELEASE 10) AND RCF     */
/*                                                                  */
/*         E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)     */
/*                  & INLLIBL(*JOBD).                               */
/*                                                                  */
/*         S01194 - NEW STANDING DATA (MAKE DLC1920A REDUNDANT)     */
/*                                                                  */
/*         S01203 - Conversion to RPG400                            */
/*                                                                  */
/*         S01157 - New program written for FRA/IRS enhancements.   */
/*                  This program has been written to allow I/C      */
/*                  settlement of FRA's with 0 rate fix days. It is */
/*                  based on DLC0211.                               */
/*                                                                  */
/********************************************************************/
/************PGM********PARM(&RERUN)************************************S01117*/
             PGM        PARM(&RERUN &RCMD)                            /*S01117*/
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*******     DCL        VAR(&MSG) TYPE(*CHAR) LEN(50) *************/  /*S01203*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&STRING) TYPE(*CHAR) LEN(20)               *E27535*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WID) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&DATE) TYPE(*CHAR) LEN(7)**********/      /*S01194*/
/* */
             DCL        VAR(&SWIFT) TYPE(*LGL) LEN(1) VALUE('0')
             DCL        VAR(&TELEX) TYPE(*LGL) LEN(1) VALUE('0')
/************DCL********VAR(&COMP)**TYPE(*CHAR)*LEN(1)**                E27535*/
/************DCL********VAR(&DLMSG)*TYPE(*CHAR)*LEN(1)*VALUE('N')       E27535*/
             DCL        VAR(&CONFS) TYPE(*CHAR) LEN(1) VALUE('N')
/*********   DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)       *********/ /*CIR001*/
             DCL        VAR(&LOOP) TYPE(*CHAR) LEN(1)
/* */
             DCLF       FILE(DLC1920DF)
/* */
/**********  DCLDTAARA  DTAARA(DLSTAT)                              *  *S01203*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01203*/
/**********  DCLDTAARA  DTAARA(SWSTAT)                              *  *S01203*/
/************DCL********VAR(&SWSTAT)*TYPE(*CHAR)*LEN(256)      /*S01203*E27535*/
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01203*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01203*/
/**********  DCLDTAARA  DTAARA(CHSTAT)                              *  *S01203*/
             DCL        VAR(&CHSTAT) TYPE(*CHAR) LEN(256)             /*S01203*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)              /*S01194*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*CIR001*/
             DCL        VAR(&OPIO) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CIR001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CIR001')  /*CIR001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CIR001*/
             DCL        VAR(&CIR001) TYPE(*CHAR) LEN(1) VALUE('0')    /*CIR001*/
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW011*/
             DCL        VAR(&CSW011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW011*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1920INT                                          */
                                                                      /*S01408*/
/* */
/* MONITOR FOR ALL ERRORS */
/* */
             MONMSG     MSGID(CPA0000 MCH0000 RPG0000 CPF0000) +
                          EXEC(GOTO CMDLBL(ERROR))
/* */
/* RETRIEVE THE USER AND WORKSTATION ID FOR DISPLAY FILE */
/* */
             RTVJOBA    JOB(&WID) USER(&USER)
 
/**Call DLC1921A to get MIDAS date for displaying on screen */        /*S01194*/
/*****                                                  *****/        /*S01194*/
/*****       CALL  PGM(DLC1920A)  PARM(&DATE)           *****/        /*S01194*/
/*****                                                  *****/        /*S01194*/
/*****       CHGVAR  VAR(&RUND)  VALUE(&DATE)           *****/        /*S01194*/
                                                                      /*S01194*/
/* ACCESS RUNDAT to get MIDAS date for displaying on screen */        /*S01194*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                /*S01194*/
             CHGVAR     VAR(&RUND) VALUE(%SST(&RUNDAT 1 7))           /*S01194*/
/**/                                                                  /*CIR001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPIO &SAR &SCSARD)  /*CIR001*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CIR001*/
               CHGVAR     VAR(&CIR001) VALUE('1')                     /*CIR001*/
             ENDDO                                                    /*CIR001*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW011*/
             CHGVAR     VAR(&OPIO) VALUE('*VERIFY')                   /*CSW011*/
             CHGVAR     VAR(&SAR) VALUE('CSW011')                     /*CSW011*/
             CHGVAR     VAR(&SCSARD) VALUE(' ')                       /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPIO &SAR &SCSARD)  /*CSW011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSW011*/
               CHGVAR     VAR(&CSW011) VALUE('Y')                     /*CSW011*/
             ENDDO                                                    /*CSW011*/
             ELSE       CMD(DO)
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW011*/
             CHGVAR     VAR(&OPIO) VALUE('*VERIFY')                   /*CSW011*/
             CHGVAR     VAR(&SAR) VALUE('CSW005')                     /*CSW011*/
             CHGVAR     VAR(&SCSARD) VALUE(' ')                       /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPIO &SAR &SCSARD)  /*CSW011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CSW011*/
               CHGVAR     VAR(&CSW005) VALUE('Y')                     /*CSW011*/
             ENDDO                                                    /*CSW011*/
             ENDDO                                                    /*CSW011*/
 
/*/COPY WNCPYSRC,DLC1920001                                          */
                                                                      /*S01408*/
/* LOOP ROUND UNTIL SUCCESSFUL JOB OR RCMD SET TO 'F' OR 'E'            S01117*/
LOOP:                                                                 /*S01117*/
             CHGVAR     VAR(&IN03) VALUE('0')                         /*S01117*/
             CHGVAR     VAR(&OPTN) VALUE(' ')                         /*S01117*/
/* */
/* CHECK THE PARAMETER TO SEE WHICH OPTION HAS BEEN CHOSEN AND SEND */
/* THE APPROPRIATE WARNING MESSAGE */
/**/
                                                                      /*S01408*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') +
                 THEN(DO)                                             /*CSW011*/
                            SNDRCVF RCDFMT(DLC1920F5)                 /*CSW011*/
               CHGVAR     VAR(&RCMD) VALUE('E')                       /*CSW011*/
               GOTO       CMDLBL(END)                                 /*CSW011*/
             ENDDO                                                    /*CSW011*/
                                                                      /*CSW011*/
/*/COPY WNCPYSRC,DLC1920002                                          */
                                                                      /*S01408*/
             IF         COND(&CIR001 *EQ '0') THEN(DO)                /*CIR001*/
             IF         COND(&RERUN *EQ 'N') THEN(SNDRCVF +
                          RCDFMT(DLC1920F1))                          /*S01117*/
             ELSE       CMD(SNDRCVF RCDFMT(DLC1920F2))                /*S01117*/
             ENDDO                                                    /*CIR001*/
             ELSE       CMD(DO)                                       /*CIR001*/
               IF         COND(&RERUN *EQ 'N') THEN(SNDRCVF +
                            RCDFMT(DLC1920F3))                        /*CIR001*/
               ELSE       CMD(SNDRCVF RCDFMT(DLC1920F4))              /*CIR001*/
             ENDDO                                                    /*CIR001*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1920003                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01117*/
/* IF F1 HAS BEEN HIT THEN SET UP &RCMD AND RETURN */                 /*S01117*/
             IF         COND(&IN03 *EQ '1') THEN(DO)                  /*S01117*/
               CHGVAR     VAR(&RCMD) VALUE('E')                       /*S01117*/
               GOTO       CMDLBL(END)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
/**/
/**IF*THE*REPLY*FROM*EITHER*OF*THESE*IS*NOT*'Y'*THEN*GO*TO*END**********S01117*/
/* IF THE REPLY FROM EITHER OF THESE IS NOT 'Y' THEN SET RCMD TO F3     S01117*/
/* EQUIVALENT AND THEN GO TO END                                        S01117*/
/**/
             IF         COND(&OPTN *NE 'Y' *AND &OPTN *NE 'y') +
                         THEN(DO)                                     /*S01117*/
/*************************THEN(GOTO CMDLBL(END))*******************   /*S01117*/
               CHGVAR     VAR(&RCMD) VALUE('E')                       /*S01117*/
               GOTO       CMDLBL(END)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
/**/
/* ELSE PROCESS PAY/RECEIVE AS FOR INPUT CYCLE */
/**/
/**/
/**********  RCVDTAARA  DTAARA(MMOD)                                *  *S01203*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01203*/
/**/
             IF         COND((%SST(&MMOD 25 1) = 'Y') *AND (%SST+
                        (&MMOD 18 1) ='N')) THEN(DO)
/**/
/**********IF*SWIFT-DEALING*PRESENT*THEN*CHECK*FOR**********       */ /*E27535*/
/**********SWIFT*MESSAGE*TRANSFER*ACTIVE*AND*IF*************       */ /*E27535*/
/**********THERE*ARE*SWIFT-DEALING*MESSAGES*READY*TO*GO*****       */ /*E27535*/
/***********************************************************          /*E27535*/
/**********     RCVDTAARA  DTAARA(SWSTAT)                           *  *S01203*/
/***************RTVDTAARA  DTAARA(SWSTAT) RTNVAR(&SWSTAT)      /*S01203*E27535*/
/*         IF SWIFT-DEALING PRESENT THEN SET &SWIFT INDICATOR      */ /*E27535*/
                CHGVAR     VAR(&SWIFT)  VALUE('1')
/***************CHGVAR     VAR(&COMP)  VALUE(%SUBSTRING(&SWSTAT 9 1))  *E27535*/
/***************CHGVAR     VAR(&DLMSG) VALUE(%SST(&SWSTAT 23 1))       *E27535*/
/**/
             ENDDO
/**/
             IF         COND((%SUBSTRING(&MMOD 33 1) = 'Y')) THEN(DO)
                CHGVAR     VAR(&TELEX)  VALUE('1')
             ENDDO
/**/
/*    CHECK IF THE C.H.I.P.S. DEALING MODULE IS IN THE SYSTEM       */
             IF         COND(%SST(&MMOD 41 1) *EQ 'Y') THEN(DO)
/**/
/**********     RCVDTAARA  DTAARA(CHSTAT)                           *  *S01203*/
                RTVDTAARA  DTAARA(CHSTAT) RTNVAR(&CHSTAT)             /*S01203*/
/**/
                IF         COND(%SST(&CHSTAT 1 1) *EQ 'Y') THEN(DO)
/**/
                   SNDPGMMSG   MSG('Previous C.H.I.P.S. Messages still +
                    outstanding - JOB CANNOT BE RUN')                          +
                          TOMSGQ(MOPERQ) TOPGMQ(*EXT)
                   GOTO        CMDLBL(INACT)
/**/
                ENDDO
/**/
             ENDDO
/**/
/***CHECK*WHETHER*SWIFT*MODULE*PRESENT**AND*************                E27535*/
/***WHETHER*SWIFT*MESSAGE*COMPRESSION*ACTIVE************                E27535*/
/*******************************************************                E27535*/
/************IF*********COND((&SWIFT)**AND*(&COMP*=*'Y')) THEN(DO)      E27535*/
/*******************************************************                E27535*/
/**************SNDPGMMSG*MSG('JOB*CANNOT*BE*RUN*AT*THIS*TIME') +
/************************TOMSGQ(MOPERQ)*TOPGMQ(*EXT)****                E27535*/
/*******************************************************                E27535*/
/************ENDDO**************************************                E27535*/
/*******************************************************                E27535*/
/************ELSE*******CMD(DO)*************************                E27535*/
/*******************************************************                E27535*/
/**********     RCVDTAARA  DTAARA(DLSTAT)                           *  *S01203*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01203*/
/**/
/* S01310 - ADD EXTRA CONDITIONING TO CHECK DL P/R HAS NOT FAILED     /*S01310*/
                                                                      /*S01310*/
/*              IF         COND(%SUBSTRING(&DLSTAT 7 1) *EQ Y) +              */
/*                         THEN(SNDPGMMSG  MSG('PAY/RECEIVE PRINT REQUESTED + */
/*                          BUT ACTIVE') TOMSGQ(MOPERQ)  +                    */
/*                           TOPGMQ(*EXT) MSGTYPE(*INFO))                     */
                                                                      /*S01310*/
             IF         COND((%SUBSTRING(&DLSTAT 7 1) *EQ Y) *OR +
                          (%SUBSTRING(&DLSTAT 99 1) *NE ' ')) +
                          THEN(SNDPGMMSG MSG('PAY/RECEIVE PRINT +
                          REQUESTED BUT ACTIVE') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))
                                                                      /*S01310*/
                ELSE       DO
/**/
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**********        RCVDTAARA  DTAARA(DLSTAT)                        *  *S01203*/
                   RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)          /*S01203*/
                   CHGVAR     VAR(%SUBSTRING(&DLSTAT 7 1)) VALUE(Y)
/***********       SNDDTAARA  DTAARA(DLSTAT)                          /*S01203*/
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)                 /*S01203*/
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**/
/*******************************************************                E27535*/
/**********IF*SWIFT*IS*PRESENT*AND*DEALING*MESSAGES*ARE*READY TO        E27535*/
/**********GO*THEN*SEND*A*WARNING*MESSAGE*TO*OPERATOR***                E27535*/
/**********AND*CHECK*IF*WISH*TO*CONTINUE****************                E27535*/
/*******************************************************                E27535*/
/****************IF*****COND((&SWIFT)**AND*(&DLMSG**EQ*'Y')) THEN(DO)   E27535*/
/*******************************************************                E27535*/
/*******************SNDPGMMSG**MSG('PAY/RECEIVE*-*SWIFT/DEALING MESSAGES +
/**********************ARE*WAITING*TO*BE*TRANSFERRED')*TOMSGQ(MOPERQ)   E27535*/
/*******************************************************                E27535*/
/*RETRY:************SNDPGMMSG**MSG('Previous*SWIFT*Messages have not +
/***************been*sent*-*Do*you*wish*to*continue*(Y/N)') +
/*************************TOPGMQ(*EXT)*MSGTYPE(*INQ) +
/*******************RCVMSG*****PGMQ(*EXT)*MSGTYPE(*RPY)*WAIT(*MAX) +
/******************************RMV(*YES)*MSG(&RPY)******                E27535*/
/*******************IF*********COND((&RPY**EQ*'Y')**OR*(&RPY *EQ 'y')) +
/******************************THEN(GOTO*CMDLBL(CONTINUE))              E27535*/
/*******************************************************                E27535*/
/*******************IF*********COND((&RPY**EQ*'N')**OR*(&RPY *EQ 'n')) +
/**********************THEN(DO)*************************                E27535*/
/**********************ALCOBJ*****OBJ((DLSTAT**DTAARA**EXCLRD))         E27535*/
/******************RCVDTAARA**DTAARA(DLSTAT)************                S01203*/
/******************RTVDTAARA**DTAARA(DLSTAT)*RTNVAR(&DLSTAT)    /*S01203E27535*/
/**********************CHGVAR***VAR(%SUBSTRING(&DLSTAT*7 1)) VALUE(N)   E27535*/
/******************SNDDTAARA**DTAARA(DLSTAT)************              /*S01203*/
/************CHGDTAARA**DTAARA(DLSTAT)*VALUE(&DLSTAT)***        /*S01203E27535*/
/**********************DLCOBJ*****OBJ((DLSTAT**DTAARA**EXCLRD))         E27535*/
/**SET*RCMD*TO*EQUIVALENT*OF*F3*************************        /*S01117E27535*/
/**********************CHGVAR*****VAR(&RCMD)*VALUE('E')*        /*S01117E27535*/
/**********************GOTO*******CMDLBL(INACT)*********                E27535*/
/**********************ENDDO****************************                E27535*/
/*******************************************************                E27535*/
/*******************ELSE*******CMD(GOTO*CMDLBL(RETRY))**                E27535*/
/*******************************************************                E27535*/
/****************ENDDO**********************************                E27535*/
/*CONTINUE:*********************************************                E27535*/
/*******************************************************                E27535*/
/**/
/*     ALLOCATE DLSTAT AND SET BUSY FLAG                         */
/**/
             IF         COND((&SWIFT) *OR (&TELEX) *OR ((%SST(&MMOD +
                          18 1) = 'Y') *AND (%SST(&MMOD 25 1) = 'Y')) +
                          *OR (%SST(&MMOD 51 1) = Y) *AND (%SST(&MMOD +
                          53 1) = Y)) THEN(DO)                        /*S01135*/
/**/
/**********        RCVDTAARA  DTAARA(DLSTAT)                        *  *S01203*/
                   RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)          /*S01203*/
/**/
             CHGVAR  VAR(&CONFS) VALUE(%SST(&DLSTAT 6 1))
/**/
                IF         COND(&CONFS *EQ 'Y') THEN(DO)
/**/
                   CALL PGM(DL0105)
/**/
/**/
                ENDDO
/**/
             ENDDO
/**/
/******************SNDPGMMSG**MSG('MIDAS')*TOMSGQ(MSTATUS)**************S01117*/
/***********************************************************************S01117*/
/************CHGVAR*****VAR(&STRING)*VALUE('CALL*DLC1921*'**CAT*+*******S01117*/
/*************************&RERUN)***************************************S01117*/
/***********************************************************************S01117*/
/**E20773****SBMJOB*****JOB(DLC1921)*JOBD(MBATCH)*USER(*JOBD)*+*********S01117*/
/*************************RQSDTA(&STRING)*MSGQ(MOPERQ)**E20773**********S01117*/
/************SBMJOB*****JOB(DLC1921)*JOBD(MBATCH)*USER(*JOBD)*+*********S01117*/
/*************************RTGDTA(*JOBD)*RQSDTA(&STRING)*+***************S01117*/
/*************************INLLIBL(*JOBD)*MSGQ(MOPERQ)****E20773*********S01117*/
/**E20773****SBMJOB*****JOB(MIDASRMV)*JOBD(MBATCH)*USER(*JOBD)*+********S01117*/
/*************************RQSDTA('CALL*MIDASRMV')*MSGQ(MOPERQ)*+********S01117*/
/*************************E20773****************************************S01117*/
/************SBMJOB*****JOB(MIDASRMV)*JOBD(MBATCH)*USER(*JOBD)*+********S01117*/
/*************************RTGDTA(*JOBD)*RQSDTA('CALL*MIDASRMV')*+*******S01117*/
/*************************INLLIBL(*JOBD)*MSGQ(MOPERQ)*******************S01117*/
                   RETURN
/*****SETOFF*BUSY*FLAG*AND*DEALLOCATE*DLSTAT***********************/  /*E27535*/
INACT:
                ENDDO
   /**/
/************ENDDO**************************************                E27535*/
/**/                                                                  /*S01117*/
/* IF RCMD NOT SET UP TO 'F' OR 'E' THEN REDISPLAY DISPLAY FILE */    /*S01117*/
/* (IF GONE THROUGH WITHOUT PROBLEMS THEN PROGRAM ALREADY 'RETURNED'  /*S01117*/
/* WITH RCMD BLANK) */                                                /*S01117*/
             IF         COND((&RCMD *NE 'F') *AND (&RCMD *NE 'E')) +
                          THEN(GOTO CMDLBL(LOOP))                     /*S01117*/
             GOTO       CMDLBL(END)
/**/
 ERROR:      IF         COND(&LOOP *NE 'Y') THEN(DO)
 
             CHGVAR     VAR(&LOOP) VALUE(Y)
             SNDPGMMSG  MSGID(FIS0023) MSGF(DRSMM) TOMSGQ(MOPERQ)
             SNDPGMMSG  MSGID(FIS0023) MSGF(DRSMM) TOPGMQ(*EXT)
 
             ENDDO
 
/************ELSE*******CMD(RETURN)*************************************S01117*/
 END:        RETURN                                                   /*S01117*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/*END:*********ENDPGM***************************************************S01117*/
             ENDPGM                                                   /*S01117*/
