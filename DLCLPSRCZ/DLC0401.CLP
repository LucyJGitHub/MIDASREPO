/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL I/C termination confirmation print')         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0401 - INPUT CYCLE TERMINATION CONFIRMATION PRINT       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 111547                  DATE  26FEB97       */
/*       PREV AMEND NO. S01408                  DATE  13MAY96       */
/*                      083768                  DATE  16JAN95       */
/*                      S01522                  DATE  18NOV94       */
/*                      AUS009                  DATE  23JUL92       */
/*                      E252                    DATE  5MAR90        */
/*                      S01194                  DATE  04/09/89      */
/*                      S01117                  DATE  04/09/89      */
/*                      S01179                  DATE  12/09/88      */
/*                      S01144                  DATE  08/09/87      */
/*                      S01135                  DATE  22/06/87      */
/*                      S01118                  DATE  14/08/86      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       111547  -  You should not overide the printer file.        */
/*       S01408  -  Addition of core hook DLC0401002                */
/*                  Addition of core hook DLC0401001                */
/*                  Addition of core hook DLC0401INT                */
/*       083768  -  Reclaim resources after CG4000                  */
/*       S01522  -  USER DEFINED CORRESPONDENCE                     */
/*       AUS009  -  AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS */
/*       E252    -  CLOSE DOWN AOCURRR0 TO ALLOW COB PROCESSING     */
/*       S01117  -  MULTIBRANCHING CHANGES/RCF CHANGES              */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01135  -  MIDAS/TELEX INCORPORATION                       */
/*                                                                  */
/********************************************************************/
             PGM
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0401INT                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*********   DCLDTAARA  DTAARA(MMOD)                                    S01179*/
/**********  DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&SWIFT) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*AUS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*AUS009*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
/*/COPY WNCPYSRC,DLH00171                                            */
/*   PRINT CONFIRMATIONS                                        */
             SNDPGMMSG  MSG('Input Cycle Termination Confirmation +
                        Print') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLH00172                                            */
/*******     RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/********    RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
/********    IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y) THEN(DO) *  *S01118*/
             IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
                        (%SST(&MMOD 18 1) *EQ N)) THEN(DO)            /*S01118*/
                CHGJOB     SWS(XXX1XXXX)
                CHGVAR     VAR(&SWIFT) VALUE('Y')
                CALL       PGM(SWC0401)
             ENDDO
/**********  IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
                        (%SST(&MMOD 18 1) *EQ Y)) THEN(DO)*  *S01118*  *S01135*/
             IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
                        (%SST(&MMOD 18 1) *EQ Y)  *OR  +
                        (%SST(&MMOD 51 1) *EQ Y)  *AND  +
                        (%SST(&MMOD 53 1) *EQ Y)) THEN(DO)            /*S01135*/
                CHGJOB     SWS(XXX1XXXX)                              /*S01118*/
                CHGVAR     VAR(&SWIFT) VALUE('Y')                     /*S01118*/
/************   RCVDTAARA  DTAARA(DLSTAT)                        S01118 S01179*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01179*/
                IF         COND(%SUBSTRING(&DLSTAT 20 1) *EQ 'Y') +
                             THEN(CALL PGM(DLC0210E))                 /*S01118*/
             ENDDO                                                    /*S01118*/
/**/
/* CHECK IF DEALING TELEX RECOVERY IS REQUIRED */
/**/
             IF         COND(((%SUBSTRING(&MMOD 33 1)) *EQ Y) +
                           *AND ((%SUBSTRING(&DLSTAT 34 1)) *EQ Y)) +
                             THEN(DO)
/**/                                                                  /*S01144*/
                IF   COND((%SST(&MMOD 51 1) *EQ 'Y') *AND +
                     (%SST(&MMOD 53 1) *EQ 'Y'))  THEN(DO)
                     CALL    PGM(MTC1080)                             /*S01144*/
                     ENDDO                                            /*S01144*/
                ELSE DO                                               /*S01144*/
                     CALL    PGM(TXC0500)                             /*S01144*/
                     ENDDO                                            /*S01144*/
/**/                                                                  /*S01144*/
/**********  CALL      PGM(TXC0500)                                 *  *S01144*/
/**/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             CHGDTAARA  DTAARA(DLSTAT (34 1)) VALUE(N)
             ENDDO
/**/
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**/
             CHGJOB     SWS(101XXX00)
/************OVRDBF     FILE(TABLE) TOFILE(TABDLI)                    /*S01194*/
/************CALL       PGM(DL0110) PARM(&SWIFT)                      /*S01117*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*AUS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*AUS009*/
             CHGVAR     VAR(&SAR) VALUE('AUS007')                     /*AUS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*AUS009*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*AUS009*/
/*/COPY WNCPYSRC,DLC0401003                                          */
/*********   OVRPRTF    FILE(DL0110P1) PAGESIZE(42 90) OVRFLW(42) AUS009111547*/
/*********   OVRPRTF    FILE(DL0110P2) PAGESIZE(42 90) OVRFLW(42) AUS009111547*/
/*/COPY WNCPYSRC,DLC0401004                                          */
             ENDDO                                                    /*AUS007*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
             CALL       PGM(CG4000) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
             RCLRSC                                                   /*083768*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             SNDPGMMSG  MSG('User Defined Correspondence Extract +
                          failure') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ) MSGTYPE(*INFO) /*S01522*/
             ENDDO                                                    /*S01522*/
             ENDDO                                                    /*S01522*/
/* SEQUENCE PASSED AS BLANKS B'COS THIS IS MANDATORY REPORT IN IC TERM  S01117*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0401001                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             CALL       PGM(DL0110) PARM('     ' 'ALL' &SWIFT)        /*S01117*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0401002                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/*********** DLTOVR     FILE(*ALL)                                    /*S01194*/
/**/
             IF         COND(%SUBSTRING(&MMOD 25 1) *EQ Y) THEN(DO)
                CHGVAR     VAR(%SUBSTRING(&DLSTAT 20 1)) VALUE('Y')
/***********    SNDDTAARA  DTAARA(DLSTAT)                               S01179*/
                CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)              /*S01179*/
             ENDDO
/**/
/*  NORMAL PRODUCTION OF TELEX */
/**/
             IF         COND(%SUBSTRING(&MMOD 33 1) *EQ Y) THEN(DO)
               IF         COND((*NOT %SWITCH(XXXXXX00))  +
                          *AND (*NOT %SWITCH(XXX00XXX)) ) THEN(DO)
               ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
               CHGDTAARA  DTAARA(&DLSTAT (34 1)) VALUE(Y)
               DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
               ENDDO
/**/
               ELSE DO
/**/                                                                  /*S01144*/
                   IF   COND((%SST(&MMOD 51 1) *EQ 'Y') *AND +
                        (%SST(&MMOD 53 1) *EQ 'Y'))  THEN(DO)
                        CALL    PGM(MTC1083)                          /*S01144*/
                        ENDDO                                         /*S01144*/
                   ELSE DO                                            /*S01144*/
                        CALL      PGM(TXC0603)                        /*S01144*/
                   ENDDO                                              /*S01144*/
/**/                                                                  /*S01144*/
/***********   CALL       PGM(TXC0603)                              *  *S01144*/
               ENDDO
             ENDDO
/**/
             CHGJOB     SWS(0X0XXXXX)
/**/
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
                        (%SST(&MMOD 18 1) *EQ N)) THEN(CALL SWC0210E) /*S01118*/
/******* /*  IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
             (%SST(&MMOD 18 1) *EQ Y)) THEN(CALL DLC0210E)*  *S01118*  *S01135*/
             IF         COND((%SST(&MMOD 25 1) *EQ Y) *AND +
                        (%SST(&MMOD 18 1) *EQ Y) *OR +
                        (%SST(&MMOD 51 1) *EQ Y) *AND +
                        (%SST(&MMOD 53 1) *EQ Y)) THEN(CALL DLC0210E) /*S01135*/
/*********   IF COND(%SWITCH(XXX1XXXX)) THEN(CALL +                 *  *S01118*/
/**********               PGM(SWC0210E))                            *  *S01118*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01135*/
                IF         COND((%SST(&MMOD 51 1) *EQ 'Y') *AND +
                             (%SST(&MMOD 53 1) *EQ 'Y'))           +
                THEN(CALL PGM(MTC0010) PARM('Y' 'ALL'))               /*S01117*/
/***************           THEN(CALL PGM(MTC0010))         /*S01135*/ /*S01117*/
             ENDDO                                                    /*S01135*/
                                                                      /*E252*/
/* MUST CLOSE DOWN AOCURRR0 SO THAT SDC1711 CAN ENDJRN ON SDCURRPD */ /*E252*/
                                                                      /*E252*/
/* CALL AOCURRR0 (' ' '*FREE' ' ' ' ')                                /*E252*/
             RCLRSC     LVL(*CALLER)                                  /*E252*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
