/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Input cycle processing')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     DEALING  MODULE                                  */
/*                                                                  */
/*       DLC02 - INPUT CYCLE PROCESSING                             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      116317             Date 19Sep97              */
/*                      S01408             Date 16Sep96              */
/*                      S01310            DATE  16APR91             */
/*                      DT0029            DATE  26MAR91             */
/*                      E23407            DATE  14SEP90             */
/*                      LN1001            DATE  23NOV90             */
/*                      E20773            DATE  12FEB90             */
/*                      LN0547            DATE  23JUL90             */
/*                      E16905            DATE  27SEP89             */
/*                      S01179            DATE  10/09/88            */
/*                      E11533            DATE  15/06/88            */
/*                      S01135            DATE  20/07/87            */
/*                      S01119            DATE  09/07/87            */
/*                      S01118            DATE  13/08/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.   */
/*                OUTQ must always be *JOBD.                        */
/*       116317 - Run Pay/Receives for Nostro Transfers             */
/*       S01408 - Addition of core hook DLC02INT                    */
/*              - Addition of core hook DLC02MPE                    */
/*       S01310 - SWIFT RATIONALISATION                             */
/*       DT0029 - DTAARA LDA SHOULD BE CLEARED BEFORE ANY PGM CALLS */
/*       E23407 - CHECK FOR MODULES RE(RETAIL 2 - MMOD POSITION     */
/*                16) OR IA(INTEREST ON ACCOUNTS - MMOD POSITION    */
/*                23), RATHER THAN RT(RETAIL 1 - MMOD POSITION      */
/*                3).                                               */
/*       LN1001 - CHANGE THE LENGTH OF THE DATA EXTRACTED FROM THE  */
/*                LDA FROM 44 TO 50                                 */
/*       E20773 - DEFAULTS CHANGED ON SBMJOB TO RTGDTA(*JOBD)       */
/*                & INLLIBL(*JOBD).                                 */
/*       LN0547 - REPLACE SWSTAT WITH MSSTAT                        */
/*       E16905 - NOSTRO TRANSFERS SHOULD NOT PRODUCE CONFIRMATIONS*/ /*E16905*/
/*                SO REMOVE FIX E11533                             */ /*E16905*/
/*       S01179 - AS400 CONVERSION                                  */
/*       E11533 - CALL CONFIRMATIONS PROCESSING FOLLOWING           */
/*                NOSTRO TRANSFERS PGM DL0213                       */
/*       S01135 - MIDAS/TELEX INCORPORATION                         */
/*       S01119 - FRA/IRS PROCESSING - INCLUDE CALL TO CONFIRMATIONS*/
/*                PROCESSING FOLLOWING CALL TO NEW PGM DLC1600      */
/*                ( FRA/IRS MAINTENANCE ), RETRIEVE DETAILS OF      */
/*                DATABASE ERRORS FROM LDA & SEND MIDAS MESSAGE.    */
/*       S01118 - MIDAS/S.W.I.F.T. DIRECT LINK                      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,DLC02001                                            */
             DCL        VAR(&PARM)  TYPE(*CHAR) LEN(7)
/*/COPY WNCPYSRC,DLC02002                                            */
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(50)
/**/                                                                  /*S01119*/
/************DCL********VAR(&MEM)***TYPE(*CHAR)*LEN(44)**********S01119*LN1001*/
             DCL        VAR(&MEM)   TYPE(*CHAR) LEN(50)               /*LN1001*/
/**/                                                                  /*S01119*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/*           DCL        VAR(&SWSTAT) TYPE(*CHAR) LEN(256)  /*S01179*/ /*LN0547*/
/************DCL********VAR(&MSSTAT) TYPE(*CHAR) LEN(256)       /*LN0547S01310*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC02INT                                             /*S01408*/
/**/                                                                  /*S01408*/
/**/
/*           DCLDTAARA  DTAARA(MMOD)                                    S01179*/
/*           DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/*           DCLDTAARA  DTAARA(SWSTAT)                                  S01179*/
/**/                                                                  /*116317*/
             DCLF       FILE(SDMGMEPD)                                /*116317*/
/**/                                                                  /*116317*/
/**/
/*     TEST FOR RETAIL AND COMMERCIAL LOANS MODULES                 */
/**/
             CHGJOB     SWS(00000000)
/*           RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/************IF         COND(%SUBSTRING(&MMOD 3 1) *EQ Y) THEN(DO)    /*E23407*/
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) THEN(DO)    /*E23407*/
                CHGJOB     SWS(11XXXXXX)
             ENDDO
             IF         COND(%SUBSTRING(&MMOD 4 1) *EQ Y) THEN(DO)
                CHGJOB     SWS(XX1XXXXX)
             ENDDO
/*/COPY WNCPYSRC,DLC02003                                            */
/**/                                                                  /*DT0029*/
/* CLEAR DOWN LDA                                                  */ /*DT0029*/
/**/                                                                  /*DT0029*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')                        /*DT0029*/
/**/
/*/COPY WNCPYSRC,DLC02005                                            */
             CALL       PGM(&PARM)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                     necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
             CHGJOB     SWS(000XXXXX)
/**/
/*/COPY WNCPYSRC,DLC02004                                            */
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
/**/                                                                  /*116317*/
/* The following processing is to submit a Pay/Receive run for */     /*116317*/
/* Nostro Transfers, if required */                                   /*116317*/
/**/                                                                  /*116317*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*116317*/
             RCVF                                                     /*116317*/
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'N' *AND &PARM +
                          *EQ DL0035 *AND &ENAPRG *EQ 'Y') THEN(DO)   /*116317*/
             IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)        /*116317*/
             CALL       PGM(FCC0201) PARM('DLC0211' '10001' 'DL0308' +
                          'B')                                        /*116317*/
             ENDDO                                                    /*116317*/
             ELSE       DO                                            /*116317*/
             CALL       PGM(FCC0202) PARM('DLC0211' '10001' 'DL0308' +
                          'B')                                        /*116317*/
             ENDDO                                                    /*116317*/
             ENDDO                                                    /*116317*/
/**/                                                                  /*116317*/
/**/
/**/                                                                  /*S01119*/
/***************IF         COND(&PARM *NE DLC0201 *AND &PARM *NE +
                           DLC0202 *AND &PARM *NE DLC0203 *AND &PARM +
                           *NE DLC0204 *AND &PARM *NE DLC0206) THEN+
                           (GOTO ENDPGM)*****************************/
/**/                                                                  /*E11533*/
/***************IF         COND(&PARM *NE DLC0201 *AND &PARM *NE +
                           DLC0202 *AND &PARM *NE DLC0203 *AND &PARM +
                           *NE DLC0204 *AND &PARM *NE DLC0206 *AND +
                           &PARM *NE DLC1600) THEN(GOTO ENDPGM)******/
/**/                                                                  /*S01119*/
/**/                                                                  /*E16905*/
/***************IF         COND(&PARM *NE DLC0201 *AND &PARM *NE +
                           DLC0202 *AND &PARM *NE DLC0203 *AND &PARM +
                           *NE DLC0204 *AND &PARM *NE DLC0206 *AND +
                           &PARM *NE DLC1600 *AND &PARM *NE DLC0213) +
                           THEN(GOTO ENDPGM)*************************/
/**/                                                                  /*E11533*/
                IF         COND(&PARM *NE DLC0201 *AND &PARM *NE +
                           DLC0202 *AND &PARM *NE DLC0203 *AND &PARM +
                           *NE DLC0204 *AND &PARM *NE DLC0206 *AND +
                           &PARM *NE DLC1600) THEN(GOTO ENDPGM)
/**/                                                                  /*E16905*/
/**/
         /**/
/************IF*SWIFT*OR*TELEX IS PRESENT THEN CHECK FOR PAY/RECEIVE  /*S01310*/
/************ACTIVE*AND*ALSO FOR CONFIRMATIONS ACTIVE                 /*S01310*/
         /**/
    /*       IF         COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +
                           (%SST(&MMOD 33 1) *EQ 'Y')) THEN(DO)   */  /*S01135*/
/************IF*********COND((%SST(&MMOD 25 1) *EQ 'Y') *OR  +        /*S01310*/
/**************************(%SST(&MMOD 33 1) *EQ 'Y')  *OR +          /*S01310*/
/**************************(%SST(&MMOD 51 1) *EQ 'Y') *AND +          /*S01310*/
/**************************(%SST(&MMOD 53 1) *EQ 'Y')) THEN(DO) /*S01135S01310*/
         /**/
/*              RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
                RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)             /*S01179*/
         /**/
                IF         COND(%SST(&DLSTAT 6 2) *EQ 'NN') THEN(DO)
                   ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
                   CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
                   DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC02MPE                                             /*S01408*/
/**/                                                                  /*S01408*/
         /**/
         /*     IF THE BATCH LINK IS BEING USED                     *  *S01118*/
         /*     CHECK IF SWIFT COMPRESSION IS ACTIVE                */
         /*       IF IT IS,THEN DO NOT RUN CONFIRMATIONS            */
         /*        RCVDTAARA  DTAARA(SWSTAT)                        *  *S01118*/
         /*        IF         COND(%SST(&SWSTAT 9 1) *EQ Y) THEN(DO)*  *S01118*/
         /*           ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))      *  *S01118*/
         /*           CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('N')    *  *S01118*/
         /*           DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))      *  *S01118*/
         /*        ENDDO                                            *  *S01118*/
/******* IF ******  COND(%SST(&MMOD 18 1) *EQ N) THEN(DO) /*S01118*/  /*S01135*/
/******************IF******COND((%SST(&MMOD 18 1) *EQ N) *AND +       /*S01310*/
/**************************(%SST(&MMOD 51 1) *EQ N)) THEN(DO)   /*S01135S01310*/
/*                    RCVDTAARA DTAARA(SWSTAT)                   S01118 S01179*/
/*****                RTVDTAARA DTAARA(SWSTAT) RTNVAR(&SWSTAT) /*S01179 LN0547*/
/*********************RTVDTAARA DTAARA(MSSTAT) RTNVAR(&MSSTAT)  /*LN0547S01310*/
/*****                IF COND(%SST(&SWSTAT 9 1) *EQ Y) THEN(DO)/*S01118 LN0547*/
/*********************IF COND(%SST(&MSSTAT 9 1) *EQ Y) THEN(DO) /*LN0547S01310*/
/*********************ALCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))   /*S01118S01310*/
/*********************CHGDTAARA DTAARA(DLSTAT (6 1)) VALUE('N') /*S01118S01310*/
/*********************DLCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))   /*S01118S01310*/
/*********************ENDDO                                     /*S01118S01310*/
/******************ENDDO                                        /*S01118S01310*/
         /*   SUBMIT CONFIRMATIONS TO JOBQ IF ALL CONDITIONS ARE OK */
         /*        ELSE   DO                                        *  *S01118*/
/*                 RCVDTAARA  DTAARA(DLSTAT)                     S01118 S01179*/
/******************RTVDTAARA DTAARA(DLSTAT) RTNVAR(&DLSTAT) S01118S01179S01310*/
/******************IF******COND(%SST(&DLSTAT 6 1) *EQ Y) THEN(DO) S01118S01310*/
                      SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
                                                                      /*E20773*/
/*/COPY WNCPYSRC,DLC02006                                            */
/**********           SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                         RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ)   */
/**********           SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD)  +
                         RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)   */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +                       /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
/*/COPY WNCPYSRC,DLC02007                                            */
                                                                      /*E20773*/
                   ENDDO
/***************ENDDO******                                           /*S01310*/
/************ENDDO*********                                           /*S01310*/
/**************IF*SWIFT*NOT PRESENT THEN CHECK IF CONFIRMATIONS       /*S01310*/
/****************ACTIVE****                                           /*S01310*/
/************ELSE***DO                                                /*S01310*/
         /**/
/*              RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA**DTAARA(DLSTAT) RTNVAR(&DLSTAT)       /*S01179S01310*/
         /**/
/***************IF*********COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)   /*S01310*/
/******************ALCOBJ**   OBJ((DLSTAT *DTAARA *EXCLRD))           /*S01310*/
/******************CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')         /*S01310*/
/******************DLCOBJ**   OBJ((DLSTAT *DTAARA *EXCLRD))           /*S01310*/
         /**/
/******************SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)            /*S01310*/
                                                                      /*E20773*/
/**********        SBMJOB  JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                      RQSDTA('CALL   DLC0210A') MSGQ(MOPERQ) */
/**********        SBMJOB  JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                      RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ) */
/************SBMJOB*****JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +      /*S01310*/
/*************************RTGDTA(*JOBD) RQSDTA('CALL   DLC0210A') +   /*S01310*/
/*************************INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*S01310*/
/************SBMJOB*****JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +      /*S01310*/
/*************************RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +     /*S01310*/
/*************************INLLIBL(*JOBD) MSGQ(MOPERQ)                 /*S01310*/
                                                                      /*E20773*/
/***************ENDDO******                                           /*S01310*/
/************ENDDO*********                                           /*S01310*/
         /**/
             GOTO     CMDLBL(ENDPGM)
         /**/
             ENDDO
/**/
/*                              ERROR MESSAGES                       */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED-DATABASE +
                                         IN ERROR')
                ROLLBACK
/**/                                                                  /*S01119*/
/*  FOR DATABASE ERRORS IN PGM/DLC1600, RECOVER DATA FROM LDA       */
             IF         COND(&PARM *EQ DLC1600) THEN(DO)
/***************RTVDTAARA**DTAARA(LDA*(134*44))*RTNVAR(&MEM)************LN1001*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*LN1001*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) MSGTYPE(*INFO)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             ENDDO
/**/                                                                  /*S01119*/
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('JOB TERMINATED-DEALS +
                                         TRANSACTION INDEX FULL')
                ROLLBACK
             ENDDO
/**/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INFO)
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
