/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trades input')                               */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0210  -  TRADES INPUT                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      109800             Date 17Feb00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 15Aug96              */
/*                  S01408             DATE 14MAY96                  */
/*                  088717             DATE 23OCT95                  */
/*                  S01408             DATE 20OCT95                  */
/*                  CFF001             DATE 01JUN95                  */
/*                  073714             DATE 01MAR95                  */
/*                  088717             DATE 21JUN95                  */
/*                  E44676(FUJI-FF0004)   DATE 01AUG92               */
/*                  S01332             DATE 05JUN91                  */
/*                  S01195             DATE 05JUL90                  */
/*                  HK0000             DATE 22JUN90                  */
/*                  S01117             DATE 26MAR90                  */
/*                  S01240             DATE 03/03/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   109800  -  Deallocate all market centre data areas used, not    */
/*              just the last one.                                   */
/*   S01408  -  Core hook FFC0210MPS added.                          */
/*           -  Core hook FFC0210008 added.                          */
/*           -  Core hook FFC0210007 added.                          */
/*           -  Core hook FFC0210006 added.                          */
/*           -  Core hook FFC0210005 added.                          */
/*           -  Core hook FFC0210004 added.                          */
/*   S01408  -  Core hook FFC0210003 added.                          */
/*              Core hook FFC0210002 added.                          */
/*   088717  -  Original fix (21JUN95) incomplete.                   */
/*   S01408  -  Apply Core Hook FFC0210001                           */
/*   CFF001  -  ENHANCED OTC PROCESSING SWITCHABLE FEATURE           */
/*   073714  -  OTC ENHANCEMENTS                                     */
/*   088717  -  Allocation problem during EOC with reval. Job FFC0221*/
/*   E44676      - Automatically update unrealised P&L after         */
/*               - position closeout and trades input.               */
/*   S01332  -  Amended for Exposure Management Release 10           */
/*   S01195  -  HOLIDAY AMENDMENT                                    */
/*   HK0000  -  RETURN CODE PARAMETER IS NEEDED FOR CALLING FF0320   */
/*   S01117  -  MULTIBRANCHING                                       */
/*   S01240  -  ADDITION OF REAL-TIME STATEMENTS                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)             /*E44676*/
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)            /*E44676*/
             DCL        VAR(&PACTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMKTN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PMKLC) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMLOC) TYPE(*CHAR) LEN(3)                /*S01195*/
             DCL        VAR(&PBUSD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PPROT) TYPE(*CHAR) LEN(1)               /*073714*/
             DCL        VAR(&PRUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRUND) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PDATF) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&PDFBR) TYPE(*DEC) LEN(3 0)            */ /*S01117*/
             DCL        VAR(&PDFBR) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&PMBIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCD) TYPE(*DEC)  LEN(1 0)                /*S01117*/
             DCL        VAR(&RETND) TYPE(*CHAR) LEN(1)                /*S01332*/
             DCL        VAR(&PGN1D)  TYPE(*CHAR) LEN(8)              /*S01332*/
             DCL        VAR(&PFRST)  TYPE(*CHAR) LEN(1)              /*S01332*/
             DCL        VAR(&FFSTAT) TYPE(*CHAR) LEN(256)            /*073714*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CFF001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CFF001*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CFF001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CFF001*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210MPS                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01332*/
/*   IF POSITIONS 2 TO 9 ON DTAARA/EMSDS ARE BLANK, THIS IS THE   */ /*S01332*/
/*   FIRST ENQUIRY IN THE STACK, SO CLEAR DTAARA/EMSDS AND SET    */ /*S01332*/
/*   POSITIONS 2 TO 9 TO 'FFC0210' TO INDICATE THAT THIS IS FIRST */ /*S01332*/
/*   ENQUIRY IN STACK                                             */ /*S01332*/
                                                                     /*S01332*/
             RTVDTAARA DTAARA(EMSDS (2 8)) RTNVAR(&PGN1D)            /*S01332*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01332*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*S01332*/
                CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('FFC0210 ')     /*S01332*/
             ENDDO                                                   /*S01332*/
/**/                                                                  /*S01332*/
/*  INITIALISE RETURN VARIABLE IN EMSDS  */                           /*S01332*/
/**/                                                                  /*S01332*/
/**********  CHGDTAARA  DTAARA(EMSDS (161 1)) VALUE(' ')                    */ /*S01332*/ /*CGL029*/
             CHGDTAARA  DTAARA(EMSDS (167 1)) VALUE(' ')                                  /*CGL029*/
/**/
/*  INITIAL CONTROL PROGRAM - SELECT 'ACTION CODE' + 'MARKET CENTRE' */
/**/
INITL:
             CALL       PGM(FF0010) PARM(&PACTN &PMRKT &PMKTN &PMKLC +
                          &PMLOC &PBUSD &PPROT &PRUNA &PRUND &PDATF +
                          &PDFBR &PMBIN &PFRST)                       /*073714*/
/*********** CALL       PGM(FF0010) PARM(&PACTN &PMRKT &PMKTN &PMKLC +
 ***********              &PMLOC &PBUSD &PRUNA &PRUND &PDATF &PDFBR +
 ***********              &PMBIN &PFRST)                   /*S01332*/ /*073714*/
/***********              &PMBIN)                          /*S01195*/ /*S01332*/
/***********             &PBUSD &PRUNA &PRUND &PDATF &PDFBR &PMBIN)*/ /*S01195*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
/**/
/***CMD/1*TAKEN,*IF*ACTION*CODE*BLANK***/                             /*S01332*/
/*  CMD/3 TAKEN, IF ACTION CODE BLANK  */                             /*S01332*/
/**/
             IF         COND(&PACTN *EQ ' ') THEN(GOTO ENDPGM)
/**/                                                                  /*S01332*/
/*  CMD1 OR CMD12 TAKEN  */                                           /*S01332*/
/**/                                                                  /*S01332*/
/**********  RTVDTAARA  DTAARA(EMSDS (161 1)) RTNVAR(&RETND)                */ /*S01332*/ /*CGL029*/
             RTVDTAARA  DTAARA(EMSDS (167 1)) RTNVAR(&RETND)                              /*CGL029*/
             IF         COND(&RETND *EQ 'S')  THEN(GOTO ENDPGM)       /*S01332*/
             IF         COND(&RETND *EQ 'U')  THEN(GOTO ENDPGM)       /*S01332*/
/**/
/*  OVERRIDE FILES TO MARKET MEMBERS  */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                 OVRDBF     FILE(TRANS) MBR(&PMRKT)
                 OVRDBF     FILE(TRANS8) MBR(&PMRKT)
                 OVRDBF     FILE(TRANSA) MBR(&PMRKT)
                 OVRDBF     FILE(TRSET) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNC) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNK) MBR(&PMRKT)
                 OVRDBF     FILE(PRICS) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST2) MBR(&PMRKT)
                 OVRDBF     FILE(MEMOSM) MBR(&PMRKT)
                 OVRDBF     FILE(PRONOM) MBR(&PMRKT)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210004                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(&PMRKT)                /*S01240*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210005                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01240*/
/**/
                 OVRDBF     FILE(TRANSIN) TOFILE(TRANS) +
                             MBR(&PMRKT) SHARE(*NO)
                 OVRDBF     FILE(TRSETIN) TOFILE(TRSET) +
                             MBR(&PMRKT) SHARE(*NO)
                 OVRDBF     FILE(TRANSLK) TOFILE(TRANS) +
                             MBR(&PMRKT) SHARE(*NO)
             ENDDO
             ELSE DO
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210001                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                 OVRDBF     FILE(TRANS) MBR(OTC)
                 OVRDBF     FILE(TRANS8) MBR(OTC)
                 OVRDBF     FILE(TRANSA) MBR(OTC)
                 OVRDBF     FILE(TRSET) MBR(OTC)
                 OVRDBF     FILE(POSTNC) MBR(OTC)
                 OVRDBF     FILE(POSTNK) MBR(OTC)
                 OVRDBF     FILE(PRICS) MBR(OTC)
                 OVRDBF     FILE(CLOST) MBR(OTC)
                 OVRDBF     FILE(CLOST2) MBR(OTC)
                 OVRDBF     FILE(MEMOSM) MBR(OTC)
                 OVRDBF     FILE(PRONOM) MBR(OTC)
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(OTC)                   /*S01240*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210006                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01240*/
/**/
                 OVRDBF     FILE(TRANSIN) TOFILE(TRANS) +
                             MBR(OTC) SHARE(*NO)
                 OVRDBF     FILE(TRSETIN) TOFILE(TRSET) +
                             MBR(OTC) SHARE(*NO)
                 OVRDBF     FILE(TRANSLK) TOFILE(TRANS) +
                             MBR(OTC) SHARE(*NO)
             ENDDO
/**/
             OVRDBF     FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
/**/
/*  MAIN DETAILS PROGRAM  */
/**/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210002                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             CALL       PGM(FF0020) PARM(&PACTN &PMRKT &PMKTN &PMKLC +
                    &PMLOC &PBUSD &PPROT &PRUNA &PRUND &PDATF &PDFBR +
                    &PMBIN &PFRST)                                    /*073714*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210003                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/*********CALL       PGM(FF0020) PARM(&PACTN &PMRKT &PMKTN &PMKLC +*/ /*S01117*/
/***********              &PBUSD &PRUNA &PRUND &PDATF &PDFBR)      */ /*S01117*/
/*********** CALL       PGM(FF0020) PARM(&PACTN &PMRKT &PMKTN &PMKLC +
 ***********        &PMLOC &PBUSD &PRUNA &PRUND &PDATF &PDFBR &PMBIN +
 ***********        &PFRST)                                /*S01332*/ /*073714*/
/***********        &PMLOC &PBUSD &PRUNA &PRUND &PDATF &PDFBR &PMBIN) /*S01332*/
/***********  &PBUSD &PRUNA &PRUND &PDATF &PDFBR &PMBIN)*/ /*S01117*/ /*S01195*/
/**/
/*  DEALLOCATE  MARKET DATA AREA, + DELETE FILE OVERRIDES  */
/**/
/************IF         COND(&PMRKT *NE '  ') THEN(DO)                /*088717*/
/************    DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))              /*088717*/
/************ENDDO                                                    /*088717*/
/**/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ENDPGM)
/**/
/*  CLOSE OUT SET REVERSAL, IF U1 ON  */
/**/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
                 CHGJOB SWS(0XXXXXXX)
                 OVRDBF     FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
                 OVRDBF     FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
                 OVRDBF     FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
                 OVRDBF     FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
/**/
                 IF         COND(&PMRKT *NE '  ') THEN(DO)
                 OVRDBF     FILE(CLOST3) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST4) MBR(&PMRKT)
                 OVRDBF     FILE(CLOST5) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNC) MBR(&PMRKT)
                 OVRDBF     FILE(POSTNK) MBR(&PMRKT)
                 OVRDBF     FILE(MEMOSM) MBR(&PMRKT)
                 OVRDBF     FILE(PRONOM) MBR(&PMRKT)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210007                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(&PMRKT)                /*S01240*/
                                                                     /*S01240*/
                 OVRDBF     FILE(TRANSP) TOFILE(TRANS) MBR(&PMRKT) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRANSS) TOFILE(TRANS) MBR(&PMRKT) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRSETP) TOFILE(TRSET) MBR(&PMRKT) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRSETS) TOFILE(TRSET) MBR(&PMRKT) +
                             SHARE(*NO)
                 ENDDO
/**/
                 ELSE DO
                 OVRDBF     FILE(CLOST3) MBR(OTC)
                 OVRDBF     FILE(CLOST4) MBR(OTC)
                 OVRDBF     FILE(CLOST5) MBR(OTC)
                 OVRDBF     FILE(POSTNC) MBR(OTC)
                 OVRDBF     FILE(POSTNK) MBR(OTC)
                 OVRDBF     FILE(MEMOSM) MBR(OTC)
                 OVRDBF     FILE(PRONOM) MBR(OTC)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0210008                                   */      /*S01408*/
/**/                                                                  /*S01408*/
                                                                     /*S01240*/
                 OVRDBF     FILE(FFACMVD) MBR(OTC)                   /*S01240*/
                                                                     /*S01240*/
                 OVRDBF     FILE(TRANSP) TOFILE(TRANS) MBR(OTC) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRANSS) TOFILE(TRANS) MBR(OTC) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRSETP) TOFILE(TRSET) MBR(OTC) +
                             SHARE(*NO)
                 OVRDBF     FILE(TRSETS) TOFILE(TRSET) MBR(OTC) +
                             SHARE(*NO)
                 ENDDO
/*               CALL       PGM(FF0320) PARM(&PMRKT)               */ /*HK0000*/
                 CALL       PGM(FF0320) PARM(&PMRKT &RCD)             /*HK0000*/
                 DLTOVR     FILE(*ALL)
/**/
             ENDDO
/**/                                                                  /*E44676*/
/* Submit job to update unrealised P&L                             */ /*E44676*/
/**/                                                                  /*E44676*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E44676*/
/*                                                        */          /*E44676*/
/** Pass the market parameter as 'OTC' for OTC's          */          /*E44676*/
/*                                                        */          /*E44676*/
                                                                      /*E44676*/
             IF         COND(&PMRKT *EQ '  ') THEN(DO)                /*E44676*/
                CHGVAR     VAR(&MARKT) VALUE('OTC')                   /*E44676*/
             ENDDO                                                    /*E44676*/
             ELSE       CMD(DO)                                       /*E44676*/
             CHGVAR     VAR(&MARKT) VALUE(&PMRKT)                     /*E44676*/
             ENDDO                                                    /*E44676*/
                                                                      /*E44676*/
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')                            /*E44676*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*E44676*/
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)           /*E44676*/ /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)               /*E44676*/ /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
             ENDDO                                                    /*E44676*/
/**/                                                                  /*E44676*/
             IF         COND(&PMRKT *NE '  ') THEN(DO)                /*109800*/
                 DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))              /*109800*/
             ENDDO                                                    /*109800*/
/**/
/***CMD/5*TAKEN,*IF*U3*ON***/                                         /*S01117*/
/*  CMD/9 TAKEN, IF U3 ON  */                                         /*S01117*/
/**/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
                 CHGJOB SWS(XX0XXXXX)
                 GOTO INITL
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*073714*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CFF001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CFF001*/
             CHGVAR     VAR(&SAR) VALUE('CFF001')                     /*CFF001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CFF001*/
/**/                                                                 /*073714*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CFF001*/
             RTVDTAARA  DTAARA(FFSTAT) RTNVAR(&FFSTAT)                /*073714*/
             IF         COND(%SUBSTRING(&FFSTAT 37 1) *NE 'Y') +
                        THEN(DO)                                      /*073714*/
                CHGDTAARA  DTAARA(FFSTAT (37 1)) VALUE('Y')
                CALL       PGM(FF0582)                                /*073714*/
                CHGDTAARA  DTAARA(FFSTAT (37 1)) VALUE('N')           /*073714*/
             ENDDO                                                    /*073714*/
             ENDDO                                                    /*CFF001*/
/**/                                                                 /*073714*/
             ENDDO                                                    /*073714*/
/**/                                                                 /*073714*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                     /*S01332*/
/*   RESET POSITIONS 2 TO 9 ON EMSDS TO BLANK                     */ /*S01332*/
                                                                     /*S01332*/
ENDPGM:                                                              /*S01332*/
             IF         COND(&PMRKT *NE '  ') THEN(DO)               /*088717*/
                 DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))             /*088717*/
             ENDDO                                                   /*088717*/
             RTVDTAARA DTAARA(EMSDS (2 8)) RTNVAR(&PGN1D)            /*S01332*/
             IF COND(&PGN1D *EQ 'FFC0210 ') THEN(DO)                 /*S01332*/
             CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('        ')        /*S01332*/
             ENDDO                                                   /*S01332*/
/*ENDPGM:****ENDPGM************/                                     /*S01332*/
             ENDPGM                                                  /*S01332*/
