/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CASH FLOW REPORT')                              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       GLC0802A - CASH FLOW REPORT                                */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. CLE174             Date 07Aug23              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10May96              */
/*                      S01408             Date 13Dec95              */
/*                      E40440         DATE  22MAY92                */
/*                      E22608            DATE  04SEP90             */
/*                      S01211            DATE  04/05/89            */
/*                      S01117            DATE  18/07/89            */
/*                      S01194            DATE  18/07/89            */
/*                      S01179            DATE  12/09/88            */
/*                      S01129            DATE  03/08/87            */
/*                      S0630             DATE  16/12/85            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CLE174 - Include all loans in Cash Flow Report             */
/*                 (Autosettle Ind)                                 */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hooks GLC0802A03                 */
/*       S01408 - Addition of core hooks GLC0802A01                 */
/*                                       GLC0802A02                 */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*  E22608 - PROGRAM RENAMED FROM DLC0802A AND ALL DL PROGRAMS       */
/*           CALLED RENAMED TO GL                                    */
/*  S01211 - Strategic Risk Management Incorporation.                */
/*           If the user has Strategic Risk Management installed,    */
/*           control generation of PC Cashflow Files in PF/RMPCCF    */
/*           and transfer these files to FLR/RMFOLDER so that the    */
/*           data can be accessed by CENTAUR.                        */
/*           (This SAR has not been incorporated for R10)            */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01194 - NEW STANDING DATA FILES                           */
/*       S01179  -  AS400 CONVERSION                                */
/********************************************************************/
/*********** PGM        PARM(&PARM)                                   /*S01117*/
             PGM        PARM(&PARM &RSEQ &RLEV &RENT)                 /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,GLC0802A09                                          */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE174*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CLE174*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE174*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CLE174*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CLE174*/
             DCL        VAR(&CLE174) TYPE(*CHAR) LEN(1)                                   /*CLE174*/
/*/COPY WNCPYSRC,GLC0802A08                                          */
/**/
/**********  DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/**/
/**********  RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/                                                                                      /*CLE174*/
/** Access SAR file to determine if switchable feature CLE174     */                      /*CLE174*/
/** is switched ON.  If ON, override to new LF DLEVNTV6           */                      /*CLE174*/
/**/                                                                                      /*CLE174*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE174*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE174*/
             CHGVAR     VAR(&SAR) VALUE('CLE174')                                         /*CLE174*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE174*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE174) VALUE('Y'))                                        /*CLE174*/
/**/
             CHGJOB     SWS(00000000)
/**/
             IF         COND(%SUBSTRING(&MMOD 4 1) = 'Y') +
                        THEN(CHGJOB   SWS(X1XXXXXX))
/**/
             SNDMSG     MSG('CASH FLOW REPORT')  TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,GLC0802A10                                          */
/**********  OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)                 /*S01194*/
/**********  OVRDBF     FILE(TABLE2)  TOFILE(TABDLEE)                 /*S01194*/

/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC0802A03                                           /*S01408*/
/**/                                                                  /*S01408*/
             IF         COND(&PARM *EQ '1') THEN(DO)
/***************OVRDBF    FILE(EVNTM) TOFILE(STEVE)      */           /*S01129*/

                IF      COND(%SST(&MMOD 21 1) *NE 'Y') THEN(DO)       /*S01129*/
                        OVRDBF FILE(EVNTM) TOFILE(STEVE)              /*S01129*/
                        CHGJOB SWS(XXXX1XXX)                          /*S01129*/
                ENDDO                                                 /*S01129*/
                IF      COND(%SST(&MMOD 21 1) *EQ 'Y') +
                        THEN(OVRDBF FILE(EVNTM) TOFILE(DLMEV))        /*S01129*/
                CHGJOB    SWS(XXX1XXXX)
             ENDDO

/*********** CALL       PGM(DL0540)                                   /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802A01                                           /*S01408*/
                                                                      /*S01408*/

 /* CLE174 - OVERRIDE TO NEW LF */                                                        /*CLE174*/
             IF         COND((&CLE174 *EQ 'Y') *AND ((&RLEV *EQ 'S') +
                          *OR (&RLEV *EQ ' ')))                                           /*CLE174*/
             OVRDBF     FILE(DLEVNTL6) TOFILE(DLEVNTV6)                                   /*CLE174*/
                                                                                          /*CLE174*/
/* REPORT BY SYSTEM   */
/***************IF   COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0540) +
                                  PARM(&RSEQ))          */ /*S01117*/ /*E22608*/
/*              IF   COND(&RLEV *EQ 'S') THEN(CALL PGM(GL0540) +
                                  PARM(&RSEQ))             E22608E40440*/
/*/COPY WNCPYSRC,GLC0802A04                                          */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GL0540) PARM(&RSEQ)) /* +
                          E40440 */
/*/COPY WNCPYSRC,GLC0802A05                                          */

/* REPORT BY BRANCH   */
/***************IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0541) +
                                  PARM(&RSEQ &RENT))    */ /*S01117*/ /*E22608*/
/*/COPY WNCPYSRC,GLC0802A06                                          */
                IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(GL0541) +
                                  PARM(&RSEQ &RENT))                  /*E22608*/
/*/COPY WNCPYSRC,GLC0802A07                                          */

/* REPORT BY COMPANY  */
/***************IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0542) +
                                  PARM(&RSEQ &RENT))    */ /*S01117*/ /*E22608*/
/*/COPY WNCPYSRC,GLC0802A11                                          */
                IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(GL0542) +
                                  PARM(&RSEQ &RENT))                  /*E22608*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802A02                                           /*S01408*/
                                                                      /*S01408*/

             IF         COND(&PARM = '1') THEN(DLTOVR FILE(EVNTM))
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE TABLE2)                            /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))

/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
