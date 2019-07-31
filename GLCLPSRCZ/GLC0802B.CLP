/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Daily Events By Currency')                      */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0802B - DAILY EVENTS BY CURRENCY                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 13Dec95              */
/*                      AUS017             Date 14Aug92              */
/*                      E40440             DATE 22MAY92             */
/*                      E22608             DATE 04SEP90             */
/*                      E193               DATE 22FEB90             */
/*                      S01117             DATE 02/08/89            */
/*                      S01179             DATE 12/09/88            */
/*                      S03220             DATE 16/05/88            */
/*                      S01129             DATE 03/08/87            */
/*                      S01098             DATE 22/09/86            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook GLC0802B01                  */
/*       AUS017  -  Australian Release - FX/MM Daily Events by      */
/*                  Customer                                        */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       E22608  -  PROGRAM RENAMED FROM DLC0802B AND ALL DL        */
/*                  PROGRAMS CALLED RENAMED TO GL                   */
/*       E193    -  REMOVE NOSEX PROCESSING                         */
/*       S01196  -  REMOVE LETTERS OF CREDIT (BC)                   */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01117  -  RELEASE 10 MULTIBRANCHING                       */
/*       S01179  -  AS400 CONVERSION                                */
/*       S03220  -  FUNDS TRANSFER INTERFACE                        */
/*       S01129  -  INCLUDE FILES REQUIRED FOR SECURITIES TRADING 2 */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&PARM)                                   /*S01117*/
/*********** PGM        PARM(&PARM &RSEQ &RLEV &RENT)   */ /*S01117*/ /*AUS017*/
             PGM        PARM(&TYPE &PARM &RSEQ &RLEV &RENT)           /*AUS017*/
/**/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS017*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/*/COPY WNCPYSRC,GLC0802B04                                          */
/**/
/**********  DCLDTAARA  DTAARA(MMOD)                             S01129 S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/*/COPY WNCPYSRC,GLC0802B02                                          */
/**********  RCVDTAARA  DTAARA(MMOD)                             S01129 S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/                                                                  /*S01129*/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('EVENTS BY CURRENCY REPORT')  TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,GLC0802B05                                          */
/**/
/************CLRPFM     FILE(NOSEXCC)                             */ /*E193 */
/************CLRPFM     FILE(NOSEXEC)                             */ /*E193 */
/************CLRPFM     FILE(NOSEXEL)                             */ /*E193 */
/*********** CLRPFM     FILE(NSXBCED)                                 /*S01196*/
/************CLRPFM     FILE(NOSEXES)                             */ /*193    */
/************CLRPFM     FILE(NOSEXED)                             */ /*193    */
/************CLRPFM     FILE(NOSEXZZ)                             */ /*193    */
/************CLRPFM     FILE(NOSEXSE)                     /*S01129*/ /*193    */
/************CLRPFM     FILE(NOSEXFP)                    /*S03220*/  /*193    */
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEI)                 /*S01194*/
             IF         COND(&PARM = '1') THEN(DO)
/***********    OVRDBF    FILE(EVNTM) TOFILE(STEVE)      */           /*S01129*/
 
                IF      COND(%SST(&MMOD 21 1) *NE 'Y') THEN(DO)       /*S01129*/
                        OVRDBF FILE(EVNTM) TOFILE(STEVE)              /*S01129*/
                        CHGJOB SWS(XXXX1XXX)                          /*S01129*/
                ENDDO                                                 /*S01129*/
                IF      COND(%SST(&MMOD 21 1) *EQ 'Y') +
                        THEN(OVRDBF FILE(EVNTM) TOFILE(DLMEV))        /*S01129*/
                CHGJOB  SWS(XXX1XXXX)
             ENDDO
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
/************OVRDBF     FILE(NOSEXED) SEQONLY(*YES 100)    /*S01098*/ /*E193 */
/************OVRDBF     FILE(NOSEXCC) SEQONLY(*YES 100)    /*S01098*/ /*E193 */
/*********** OVRDBF     FILE(NSXBCED) SEQONLY(*YES 100)    /*S01098*/ /*S01196*/
/*********** OVRDBF     FILE(NOSEXES) SEQONLY(*YES 100)    /*S01098*/ /*E193  */
/************OVRDBF     FILE(NOSEXSE) SEQONLY(*YES 100)    /*S01129*/ /*E193  */
/**/                                                                  /*S01098*/
/*********** CALL       PGM(DL0550)                                   /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC0802B01                                           /*S01408*/
                                                                      /*S01408*/
 
/* REPORT BY SYSTEM   */
/***************IF   COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0550) +
                                  PARM(&RSEQ))          */ /*S01117*/ /*E22608*/
/*              IF   COND(&RLEV *EQ 'S') THEN(CALL PGM(GL0550) +
                                  PARM(&RSEQ))                E22608E40440*/
/************IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GL0550) PARM(&RSEQ)) /* +
                          E40440 */                                   /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B06                                          */
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(CALL PGM(GL0550) PARM(&TYPE &RSEQ))    /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B07                                          */
 
/* REPORT BY BRANCH   */
/***************IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0551) +
                                  PARM(&RSEQ &RENT))    */ /*S01117*/ /*E22608*/
/***************IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(GL0551) +
                                  PARM(&RSEQ &RENT))    */ /*E22608*/ /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B08                                          */
                IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(GL0551) +
                                  PARM(&TYPE &RSEQ &RENT))            /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B09                                          */
 
/* REPORT BY COMPANY  */
/***************IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0552) +
                                  PARM(&RSEQ &RENT))    */ /*S01117*/ /*E22608*/
/***************IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(GL0552) +
                                  PARM(&RSEQ &RENT))    */ /*E22608*/ /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B10                                          */
                IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(GL0552) +
                                  PARM(&TYPE &RSEQ &RENT))            /*AUS017*/
/*/COPY WNCPYSRC,GLC0802B11                                          */
/**/                                                                  /*S01098*/
/*********** DLTOVR     FILE(NOSEXED)                      /*S01098*/ /*E193  */
/*********** DLTOVR     FILE(NOSEXCC)                      /*S01098*/ /*E193  */
/*********** DLTOVR     FILE(NSXBCED)                      /*S01098*/ /*S01196*/
/*********** DLTOVR     FILE(NOSEXES)                      /*S01098*/ /*E193  */
/************DLTOVR     FILE(NOSEXSE)                      /*S01129*/ /*E193  */
/**/                                                                  /*S01098*/
             IF         COND(&PARM = '1') THEN(DLTOVR FILE(EVNTM))
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))
/*/COPY WNCPYSRC,GLC0802B03                                          */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
