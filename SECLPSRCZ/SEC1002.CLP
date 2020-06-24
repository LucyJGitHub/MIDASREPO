/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off historic trades')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1002   DROP OFF HISTORIC TRADES                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD52377            Date 28Nov18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      095907             Date 14Jun04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 09FEB96             */
/*                      086486             DATE 21JUN95             */
/*                      S01408             DATE 11MAY95             */
/*                      S01513             DATE 10AUG94             */
/*                      S01117             DATE 10JAN91             */
/*                      S01189             DATE 10JAN91             */
/*                      S01269             DATE 20/07/90            */
/*                      E18628             DATE 23/06/89            */
/*                      E14543             DATE 13/02/89            */
/*                      S01179             DATE 16/09/88            */
/*                      S01129             DATE 05/04/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD52377 - After COB Component SEC1002 finished running the */
/*                 journal for file TRADSD is removed resulting     */
/*                 to MSGW on SEC0304                               */
/*       MD046248 - Finastra Rebranding                             */
/*       095907 - CHANGE SE DROP PROCEDURE IF S01513 IS ON :        */
/*                ----------------------------------------------    */
/*              - DO NOT PROCESS RESTART PROCEDURE AND COPY BACK OF */
/*                FILES AS ALL FAILURES ARE NOW CONTROLED BY PGM    */
/*                SEC1000U                                          */
/*              - DO NOT CLEAR OR DELETE COPY FILES. ONLY DELETED BY*/
/*                SEC1000U WHEN ALL DROP PROCESSING IS COMPLETED    */
/*                NORMALLY                                          */
/*              - REMOVE STRJRNPF AS DONE BY SEC1000U AFTER PGM     */
/*                FAILURE OR FULL COMPLETION OF SE DROP             */
/*              - REMOVE CALL OF SEU500,EXTENSION FILES ON TRADSD   */
/*                DIRECLTY DROPPED (deletion) IN SE2515             */
/*                                                                  */
/*                FOR ALL CASES (PGM'S SE25XX HAVE BEEN CHANGED)    */
/*                ----------------------------------------------    */
/*              - SUPPRESS DROP OF ASTERIX RECORDS AND COPY BACK OF */
/*                LIVE RECORDS AS RECORDS TO BE DROPPED ARE PHYSIC. */
/*                DELETED BY PROGRAMS SE25XX.                       */
/*              - MONITOR END JOURNALING                            */
/*              - FILE HSTAUD CANNOT BE JOURNALED                   */
/*       CCB009 - Journal files throughout close of business        */
/*       S01408 - Addition of core hook SEC1002001                  */
/*                Addition of core hook SEC1002002                  */
/*                Addition of core hook SEC1002003                  */
/*       086486 - Stop journalling of files for this process        */
/*       S01408 - Addition of core hook SEC1002MPS                  */
/*       S01513 - SE drop runs separately from EOD.                 */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       S01269 - TRADE AUTHORISATION                               */
/*       E18628 - CHANGE CPYF COMMAND                               */
/*       E14543 - DROP OFF DELETED TRADES RECORDS.                  */
/*       S01179 - ABS RELEASE                                       */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/

/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SDSTAT)                       ********  *S01179*/
/*/COPY WNCPYSRC,SEC1002009                                          */
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/

/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*S01513*/
             DCL        VAR(&DROP) TYPE(*CHAR) LEN(1)                 /*S01513*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                          VALUE('*FIRST')                             /*S01513*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01513*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01513*/
             DCL        VAR(&S01513) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01513*/
             DCL        VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE('N')    /*095907*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,SEC1002004                                          */
                                                                      /*S01129*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/** CHECK FOR SE DROP FIELD IF SEQUENCE =  00003                */    /*S01513*/
             IF         COND(&CSEQ = 00003) THEN(DO)                  /*S01189*/
                RTVDTAARA  DTAARA(SESTAT (81 1)) RTNVAR(&DROP)        /*S01513*/
                IF         COND(&DROP *NE 'Y') THEN(DO)               /*S01513*/
                   GOTO       CMDLBL(ENDPGM)                          /*S01513*/
                ENDDO                                                 /*S01513*/
             ENDDO                                                    /*S01513*/
                                                                      /*S01513*/
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(SDSTAT)                      *********  *S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1002MPS                                          */
                                                                      /*S01408*/

/* SETUP AND SEND PGM MESSAGE                                    */

             CHGVAR     VAR(&MEM) VALUE('SEC1002  - Drop off +
                        Historic Trades')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*/COPY WNCPYSRC,SEC1002008                                          */

/** Check IF SWITCHABLE FEATURE S01513 IS SWITCHED ON                 /*S01513*/

             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
/** Check IF SWITCHABLE FEATURE S01401 IS SWITCHED ON                 /*095907*/

             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*095907*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*095907*/
             CHGVAR     VAR(&SAR) VALUE('S01401')                     /*095907*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*095907*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01401) VALUE('Y'))                    /*095907*/
/*/COPY WNCPYSRC,SEC1002005                                          */
/* CLEAR SWITCHES                                                */

             CHGJOB SWS(00000000)
                                                                      /*086486*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(HSTTRD HSTTRA SETLED SETLEA TRAUTD +
                             TRATXD) JRN(ICJRN)                       /*086486*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                ENDJRNPF   FILE(TRADSD) JRN(ICJRN)                    /*MD52377*/
                MONMSG     MSGID(CPF0000)                             /*MD52377*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1002010                                          */
             ENDDO                                                    /*086486*/
/**********  ENDJRNPF   FILE(TRADSD) JRN(ICJRN)                 095907 MD52377 */
/**********  MONMSG     MSGID(CPF0000)                          095907 MD52377 */
             IF COND(&S01401 *EQ 'Y') THEN(DO)
             ENDJRNPF   FILE(TRADSDX1 TRADSDX2) JRN(ICJRN)            /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   ENDDO                                              /*095907*/

/*  CHECK FOR COMPONENT RESTART                                     */

/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1002011                                          */
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/

/*  IF RESTART, DISABLE ACCESS PATHS                                */

/************IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/

/*  OVERRIDE TO SEQONLY(*YES 100)                                   */

                OVRDBF     FILE(XHSTTRD) SEQONLY(*YES 100)
                OVRDBF     FILE(XHSTTRA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLED) SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLEA) SEQONLY(*YES 100)
                OVRDBF     FILE(XTRAUTD) SEQONLY(*YES 100)            /*S01269*/
                OVRDBF     FILE(XTRATXD) SEQONLY(*YES 100)            /*S01269*/
                OVRDBF     FILE(XHSTAUD) SEQONLY(*YES 100)            /*S01269*/
                OVRDBF     FILE(XTRADSD) SEQONLY(*YES 100)            /*095907*/
/*/COPY WNCPYSRC,SEC1002012                                          */

/*  AND COPY FILES                                                  */

                CPYF       FROMFILE(XHSTTRD) TOFILE(HSTTRD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM HSTTRD)
                CPYF       FROMFILE(XHSTTRA) TOFILE(HSTTRA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM HSTTRA)
                CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SETLED)
                CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SETLEA)
                CPYF       FROMFILE(XTRAUTD) TOFILE(TRAUTD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM TRAUTD)                       /*S01269*/
                CPYF       FROMFILE(XTRATXD) TOFILE(TRATXD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM TRATXD)                       /*S01269*/
                CPYF       FROMFILE(XHSTAUD) TOFILE(HSTAUD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM HSTAUD)                       /*S01269*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
             CPYF       FROMFILE(XTRADSDX1) TOFILE(TRADSDX1) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*095907*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSDX1))                             /*095907*/
             CPYF       FROMFILE(XTRADSDX2) TOFILE(TRADSDX2) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*095907*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSDX2))                             /*095907*/
                   ENDDO                                              /*095907*/
/*/COPY WNCPYSRC,SEC1002013                                          */
             CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE)                /*095907*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(TRADSD))                               /*095907*/


/*  CHANGE DATA AREA TO 'OLD'                                      */

/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/

             ENDDO
             ENDDO                                                    /*095907*/

/*/COPY WNCPYSRC,SEC1002014                                          */
/*  ELSE BACKUP FILES                                               */

/*/COPY WNCPYSRC,SEC1002015                                          */
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
/*/COPY WNCPYSRC,SEC1002016                                          */

/*  OVERRIDE TO SEQONLY(*YES 100)                                   */

                OVRDBF     FILE(XHSTTRD) SEQONLY(*YES 100)
                OVRDBF     FILE(XHSTTRA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLED) SEQONLY(*YES 100)
                OVRDBF     FILE(XSETLEA) SEQONLY(*YES 100)
                OVRDBF     FILE(HSTTRD) SEQONLY(*YES 100)
                OVRDBF     FILE(HSTTRA) SEQONLY(*YES 100)
                OVRDBF     FILE(SETLED) SEQONLY(*YES 100)
                OVRDBF     FILE(SETLEA) SEQONLY(*YES 100)
                OVRDBF     FILE(TRAUTD) SEQONLY(*YES 100)             /*S01269*/
                OVRDBF     FILE(TRATXD) SEQONLY(*YES 100)             /*S01269*/
                OVRDBF     FILE(HSTAUD) SEQONLY(*YES 100)             /*S01269*/
                OVRDBF     FILE(TRADSD) SEQONLY(*YES 100)             /*095907*/
/*/COPY WNCPYSRC,SEC1002017                                          */
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XHSTTRD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XHSTTRA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLEA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XTRAUTD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XTRATXD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XHSTAUD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XTRADSD)                              /*095907*/
                   MONMSG MSGID(CPF0000)                              /*095907*/
                IF         COND(&S01401 = 'Y') THEN(DO)               /*095907*/
                   DLTF       FILE(XTRADSDX1)                         /*095907*/
                      MONMSG MSGID(CPF0000)                           /*095907*/
                   DLTF       FILE(XTRADSDX2)                         /*095907*/
                      MONMSG MSGID(CPF0000)                           /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1002018                                          */

/*  AND COPY FILES                                                 */

/*              CPYF       FROMFILE(HSTTRD) TOFILE(XHSTTRD) +      */ /*S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)         */ /*S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +             */ /*S01129*/
/*                          EXEC(CLRPFM XHSTTRD)                   */ /*S01129*/
/*              CPYF       FROMFILE(HSTTRA) TOFILE(XHSTTRA) +      */ /*S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)         */ /*S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +             */ /*S01129*/
/*                          EXEC(CLRPFM XHSTTRA)                   */ /*S01129*/
/*              CPYF       FROMFILE(SETLED) TOFILE(XSETLED) +      */ /*S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)         */ /*S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +             */ /*S01129*/
/*                          EXEC(CLRPFM XSETLED)                   */ /*S01129*/
/*              CPYF       FROMFILE(SETLEA) TOFILE(XSETLEA) +      */ /*S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)         */ /*S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +             */ /*S01129*/
/*                          EXEC(CLRPFM XSETLEA)                   */ /*S01129*/
                CPYF       FROMFILE(HSTTRD) TOFILE(&TOLIB/XHSTTRD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XHSTTRD)                      /*S01129*/
                CPYF       FROMFILE(HSTTRA) TOFILE(&TOLIB/XHSTTRA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XHSTTRA)                      /*S01129*/
                CPYF       FROMFILE(SETLED) TOFILE(&TOLIB/XSETLED) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSETLED)                      /*S01129*/
                CPYF       FROMFILE(SETLEA) TOFILE(&TOLIB/XSETLEA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSETLEA)                      /*S01129*/
                CPYF       FROMFILE(TRAUTD) TOFILE(&TOLIB/XTRAUTD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XTRAUTD)                      /*S01269*/
                CPYF       FROMFILE(TRATXD) TOFILE(&TOLIB/XTRATXD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XTRATXD)                      /*S01269*/
                CPYF       FROMFILE(HSTAUD) TOFILE(&TOLIB/XHSTAUD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01269*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XHSTAUD)                      /*S01269*/
/*/COPY WNCPYSRC,SEC1002019                                          */
                CPYF       FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*095907*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XTRADSD)                      /*095907*/

                IF         COND(&S01401 = 'Y') THEN(DO)               /*095907*/
                   CPYF       FROMFILE(TRADSDX1) TOFILE(&TOLIB/+
                              XTRADSDX1) MBROPT(*REPLACE) +
                              FMTOPT(*NONE) CRTFILE(*YES)             /*095907*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XTRADSDX1)                  /*095907*/
                   CPYF       FROMFILE(TRADSDX2) TOFILE(&TOLIB/+
                              XTRADSDX2) MBROPT(*REPLACE) +
                              FMTOPT(*NONE) CRTFILE(*YES)             /*095907*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XTRADSDX2)                  /*095907*/
                ENDDO                                                 /*095907*/

             ENDDO

/*  CHANGE DATA AREA TO 'NEW'                                       */

             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1002020                                          */
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1002021                                          */

/* CALL PROGRAM                                                  */

             CALL       PGM(SE2520)
/*/COPY WNCPYSRC,SEC1002007                                          */
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*095907*/
                 CALL PGM(SE2515)                                     /*095907*/
             ENDDO                                                    /*095907*/

/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */

 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1002  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                          /*S01513*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(HSTTRA HSTTRD SETLEA SETLED  +
/***********                 TRAUTD TRATXD HSTAUD) JRN(ICJRN)*/ /*S01513086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1002022                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1002023                                          */
                  CPYF       FROMFILE(XHSTTRA) TOFILE(HSTTRA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTTRA)                      /*S01513*/
                  CPYF       FROMFILE(XHSTTRD) TOFILE(HSTTRD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTTRD)                      /*S01513*/
                  CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SETLEA)                      /*S01513*/
                  CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SETLED)                      /*S01513*/
                  CPYF       FROMFILE(XTRAUTD) TOFILE(TRAUTD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRAUTD)                      /*S01513*/
                  CPYF       FROMFILE(XTRATXD) TOFILE(TRATXD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRATXD)                      /*S01513*/
                  CPYF       FROMFILE(XHSTAUD) TOFILE(HSTAUD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTAUD)                      /*S01513*/
                  CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                             MBROPT(*REPLACE) FMTOPT(*NOCHK)          /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRADSD)                      /*095907*/
                  IF         COND(&S01401 = 'Y') THEN(DO)             /*095907*/
                    CPYF       FROMFILE(XTRADSDX1) TOFILE(TRADSDX1) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)         /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TRADSDX1)                   /*095907*/
                    CPYF       FROMFILE(XTRADSDX2) TOFILE(TRADSDX2) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)         /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TRADSDX2)                   /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1002024                                          */
                DLTF       FILE(XHSTTRA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSETLEA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRAUTD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRATXD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XHSTAUD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRADSD)                              /*095907*/
                   MONMSG MSGID(CPF0000)                              /*095907*/
                IF         COND(&S01401 = 'Y') THEN(DO)               /*095907*/
                  DLTF       FILE(XTRADSDX1)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                  DLTF       FILE(XTRADSDX2)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1002025                                          */
                                                                      /*S01513*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  STRJRNPF   FILE(HSTTRA HSTTRD SETLEA SETLED +
                             TRAUTD TRATXD HSTAUD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1002026                                          */
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  STRJRNPF   FILE(TRADSD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)                         /*095907*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
                  IF         COND(&S01401 = 'Y') THEN(DO)             /*095907*/
                     STRJRNPF   FILE(TRADSDX1) JRN(ICJRN) +
                                IMAGES(*BOTH) OMTJRNE(*OPNCLO)        /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                     STRJRNPF   FILE(TRADSDX2) JRN(ICJRN) +
                                IMAGES(*BOTH) OMTJRNE(*OPNCLO)        /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                  ENDDO                                               /*095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
               ENDDO                                                  /*095907*/
/*/COPY WNCPYSRC,SEC1002027                                          */
                ENDDO                                                 /*S01513*/
                GOTO ENDPGM
             ENDDO

/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */

             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1002  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                          /*S01513*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(HSTTRA HSTTRD SETLEA SETLED  +
/***********                 TRAUTD TRATXD HSTAUD) JRN(ICJRN)*/ /*S01513086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1002028                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1002029                                          */
                  CPYF       FROMFILE(XHSTTRA) TOFILE(HSTTRA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTTRA)                      /*S01513*/
                  CPYF       FROMFILE(XHSTTRD) TOFILE(HSTTRD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTTRD)                      /*S01513*/
                  CPYF       FROMFILE(XSETLEA) TOFILE(SETLEA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SETLEA)                      /*S01513*/
                  CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SETLED)                      /*S01513*/
                  CPYF       FROMFILE(XTRAUTD) TOFILE(TRAUTD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRAUTD)                      /*S01513*/
                  CPYF       FROMFILE(XTRATXD) TOFILE(TRATXD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRATXD)                      /*S01513*/
                  CPYF       FROMFILE(XHSTAUD) TOFILE(HSTAUD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM HSTAUD)                      /*S01513*/
                  CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +
                             MBROPT(*REPLACE) FMTOPT(*NOCHK)          /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM TRADSD)                      /*095907*/
                  IF         COND(&S01401 = 'Y') THEN(DO)             /*095907*/
                    CPYF       FROMFILE(XTRADSDX1) TOFILE(TRADSDX1) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)         /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TRADSDX1)                   /*095907*/
                    CPYF       FROMFILE(XTRADSDX2) TOFILE(TRADSDX2) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)         /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM TRADSDX2)                   /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1002030                                          */
                DLTF       FILE(XHSTTRA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSETLEA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRAUTD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRATXD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XHSTAUD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XTRADSD)                              /*095907*/
                   MONMSG MSGID(CPF0000)                              /*095907*/
                IF         COND(&S01401 = 'Y') THEN(DO)               /*095907*/
                  DLTF       FILE(XTRADSDX1)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                  DLTF       FILE(XTRADSDX2)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1002031                                          */
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
                  STRJRNPF   FILE(HSTTRA HSTTRD SETLEA SETLED +
                             TRAUTD TRATXD HSTAUD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                  STRJRNPF   FILE(TRADSD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)                         /*095907*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
                  IF         COND(&S01401 = 'Y') THEN(DO)             /*095907*/
                     STRJRNPF   FILE(TRADSDX1) JRN(ICJRN) +
                                IMAGES(*BOTH) OMTJRNE(*OPNCLO)        /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                     STRJRNPF   FILE(TRADSDX2) JRN(ICJRN) +
                                IMAGES(*BOTH) OMTJRNE(*OPNCLO)        /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1002032                                          */
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
                ENDDO                                                 /*S01513*/
                GOTO ENDPGM
             ENDDO

/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)

/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1002033                                          */
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
               ENDDO                                                  /*095907*/
/*/COPY WNCPYSRC,SEC1002034                                          */

/*        CLEAR FILES                                              */
/*                                                                 */ /*S01129*/
/**********    CLRPFM     FILE(XHSTTRD)                                *095907*/
/*             CLRPFM     FILE(XHSTTRA)                            */ /*S01129*/
/**********    CLRPFM     FILE(XSETLED)                                *095907*/
/*             CLRPFM     FILE(XSETLEA)                            */ /*S01129*/
/**********    CLRPFM     FILE(XTRAUTD)                       *S01269* *095907*/
/**********    CLRPFM     FILE(XTRATXD)                       *S01269* *095907*/
/**********    CLRPFM     FILE(XHSTAUD)                       *S01269* *095907*/
/**********                                                   *S01129* *095907*/
/**DELETE*COPY FILES                                          *S01129* *095907*/
/**********                                                   *S01129* *095907*/
/**********     DLTF       FILE(XHSTTRA)                      *S01129* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01129* *095907*/
/**********     DLTF       FILE(XSETLEA)                      *S01129* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01129* *095907*/
/**********     DLTF       FILE(XTRAUTD)                      *S01269* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01269* *095907*/
/**********     DLTF       FILE(XTRATXD)                      *S01129* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01129* *095907*/
/**********     DLTF       FILE(XHSTAUD)                      *S01269* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01269* *095907*/
/**********                                                            *095907*/
/**********                                                            *095907*/
/***DROP*ASTERISKED RECORDS                                            *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(HSTTRD) TOFILE(XHSTTRD) +             *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                   *095907*/
/**********  CPYF       FROMFILE(SETLED) TOFILE(XSETLED) +             *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                   *095907*/
/*                                                                    /*E14543*/
/*           CPYF       FROMFILE(TRADSD) TOFILE(XTRADSD) +              E18628*/
/*                      MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +   E18628*/
/*                      FMTOPT(*NONE) CRTFILE(*YES)             /*E14543E18628*/
/**********  CPYF       FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) +      *095907*/
/**********             MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF +   *095907*/
/**********             RECI *NE '*')) FMTOPT(*NONE)          *E18628* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                   *095907*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1002001                                          */
                                                                      /*S01408*/
/**********  CPYF       FROMFILE(TRAUTD) TOFILE(&TOLIB/XTRAUTD) +      *095907*/
/**********             MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF +   *095907*/
/**********             RECI *NE '*')) FMTOPT(*NONE)          *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/
/**********  CPYF       FROMFILE(TRATXD) TOFILE(&TOLIB/XTRATXD) +      *095907*/
/**********             MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF +   *095907*/
/**********             RECI *NE '*')) FMTOPT(*NONE)          *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/
/**********  CPYF       FROMFILE(HSTAUD) TOFILE(&TOLIB/XHSTAUD) +      *095907*/
/**********             MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF +   *095907*/
/**********             RECI *NE '*')) FMTOPT(*NONE)          *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/
/***COPY*BACK LIVE RECORDS                                             *095907*/
/**********                                                            *095907*/
/**********     CPYF       FROMFILE(XHSTTRD) TOFILE(HSTTRD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)             *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                 *095907*/
/**********                 EXEC(CLRPFM HSTTRD)                        *095907*/
/**********     CPYF       FROMFILE(XSETLED) TOFILE(SETLED) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)             *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                 *095907*/
/**********                 EXEC(CLRPFM SETLED)                        *095907*/
/**********                                                   *E14543* *095907*/
/**********     CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)    *E14543* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *E14543* *095907*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1002002                                          */
                                                                      /*S01408*/
/**********     CPYF       FROMFILE(XTRAUTD) TOFILE(TRAUTD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)    *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/
/**********                                                            *095907*/
/**********     CPYF       FROMFILE(XTRATXD) TOFILE(TRATXD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)    *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/
/**********     CPYF       FROMFILE(XHSTAUD) TOFILE(HSTAUD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)    *S01269* *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)          *S01269* *095907*/

/*******  CLEAR WORK FILES                                         */ /*S01129*/
/*                                                                 */ /*S01129*/
/*             CLRPFM     FILE(XHSTTRD)                            */ /*S01129*/
/*             CLRPFM     FILE(XSETLED)                            */ /*S01129*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
/*/COPY WNCPYSRC,SEC1002035                                          */
                                                                      /*S01129*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                DLTF       FILE(XHSTTRD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLED)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XTRADSD)                              /*E14543*/
                   MONMSG MSGID(CPF0000)                              /*E14543*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1002003                                          */
                                                                      /*S01408*/
                DLTF       FILE(XTRAUTD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XTRATXD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XHSTAUD)                              /*S01269*/
                   MONMSG MSGID(CPF0000)                              /*S01269*/
                DLTF       FILE(XTRADSD)                              /*095907*/
                   MONMSG MSGID(CPF0000)                              /*095907*/
                IF         COND(&S01401 = 'Y') THEN(DO)               /*095907*/
                   DLTF       FILE(XTRADSDX1)                         /*095907*/
                      MONMSG MSGID(CPF0000)                           /*095907*/
                   DLTF       FILE(XTRADSDX2)                         /*095907*/
                      MONMSG MSGID(CPF0000)                           /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1002006                                          */
                                                                      /*086486*/
/**********  IF COND(&S01513 *EQ 'Y') THEN(DO)                *086486* *095907*/
/*/COPY WNCPYSRC,SEC1002036                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                   STRJRNPF   FILE(HSTTRD HSTTRA SETLED SETLEA TRAUTD +
                                TRATXD) JRN(ICJRN) OMTJRNE(*OPNCLO)   /*086486*/
                   MONMSG     MSGID(CPF0000)                          /*095907*/
             STRJRNPF   FILE(TRADSD) JRN(ICJRN) OMTJRNE(*OPNCLO)      /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   IF COND(&S01401 *EQ 'Y') THEN(DO)                  /*095907*/
             STRJRNPF   FILE(TRADSDX1) JRN(ICJRN) OMTJRNE(*OPNCLO)    /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
             STRJRNPF   FILE(TRADSDX2) JRN(ICJRN) OMTJRNE(*OPNCLO)    /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   ENDDO                                              /*095907*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1002037                                          */
                ENDDO                                                 /*086486*/

             ENDDO

/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
