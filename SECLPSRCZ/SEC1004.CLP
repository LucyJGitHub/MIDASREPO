/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Drop off posn-depot customer book')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1004   DROP OFF POSITIONS - DEPOT  CUSTOMER  BOOK        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. 260765             Date 29Jun09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 095907             DATE 14Jun04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086486             DATE 21JUN95             */
/*                      S01408             DATE 11MAY95             */
/*                      S01513             DATE 10AUG94             */
/*                      S01117             DATE 10JAN91             */
/*                      S01189             DATE 10JAN91             */
/*                      S01179             DATE 16/09/88            */
/*                      S01158             DATE 31/05/88            */
/*                      S01129             DATE 31/03/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       260765 - Partially applied fix 182818. Fixed to add        */
/*                DSPFD command and make CHECK file its output      */
/*                before calling pgm/SE2540.                        */
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
/*                                                                  */
/*                FOR ALL CASES (PGM'S SE25XX HAVE BEEN CHANGED)    */
/*                ----------------------------------------------    */
/*              - SUPPRESS DROP OF ASTERIX RECORDS AND COPY BACK OF */
/*                LIVE RECORDS AS RECORDS TO BE DROPPED ARE PHYSIC. */
/*                DELETED BY PROGRAMS SE25XX.                       */
/*              - MONITOR END JOURNALING                            */
/*       CCB009 - Journal files throughout close of business        */
/*       086486 - Stop journalling of files for this process;       */
/*                replace the repeated STRJRNPF commands with an    */
/*                externalised version, SEC1004JRN.                 */
/*       S01408 - Addition of core hook SEC1004MPS                  */
/*       S01513 - SE drop runs separately from EOD.                 */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       S01179  -  ABS RELEASE                                     */
/*       S01129  -  SECURITIES TRADING RELEASE 2                    *  *S01129*/
/*       S01158  -  POST INCORPORATION FIX                          *  *S01158*/
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01513*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
 
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SDSTAT)                       ********  *S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*S01513*/
             DCL        VAR(&DROP) TYPE(*CHAR) LEN(1)                 /*S01513*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                          VALUE('*FIRST')                             /*S01513*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01513*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01513*/
             DCL        VAR(&S01513) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01513*/
             DCL        VAR(&S01511) TYPE(*CHAR) LEN(1) VALUE('N')    /*086486*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,SEC1004001                                          */
                                                                      /*S01129*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/** CHECK FOR SE DROP FIELD IF SEQUENCE = 00003                  */   /*S01513*/
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
/*/COPY WNCPYSRC,SEC1004MPS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MSG) VALUE('SEC1004 - Drop off +
                        Positions - Depot  Customer  Book')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON                 /*S01513*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
 
/** CHECK IF SWITCHABLE FEATURE S01511 IS SWITCHED ON                 /*086486*/
 
             IF         COND(&S01513 *EQ 'Y') THEN(DO)                /*086486*/
                CHGVAR     VAR(&RTCD) VALUE('       ')                /*086486*/
                CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                /*086486*/
                CHGVAR     VAR(&SAR) VALUE('S01511')                  /*086486*/
                CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                             &SCSARD)                                 /*086486*/
                IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                             VAR(&S01511) VALUE('Y'))                 /*086486*/
             ENDDO                                                    /*086486*/
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/** Attempt to start journalling; ignore if it fails because a file     086486*/
/** is journalled. */                                                 /*086486*/
               IF         COND(&S01513 *EQ 'Y') THEN(DO)              /*086486*/
 
/** Start journalling the bulk of the files: this code is in */
/** member SEC1004JRN in SECPYSRC. */
/*/COPY SECPYSRC,SEC1004JRN                                             086486*/
                MONMSG     MSGID(CPF7030)                             /*086486*/
 
                  IF         COND(&S01511 = 'Y') THEN(DO)             /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                     STRJRNPF   FILE(BKMTHD) JRN(ICJRN) +
                                  IMAGES(*BOTH) OMTJRNE(*OPNCLO)      /*086486*/
                     MONMSG     MSGID(CPF7030)                        /*086486*/
             ENDDO                                                    /*CCB009*/
                  ENDDO                                               /*086486*/
/*/COPY WNCPYSRC,SEC1004002                                          */
                ENDDO                                                 /*086486*/
                                                                      /*086486*/
/** Then end journalling again. */                                    /*086486*/
             IF         COND(&S01513 *EQ 'Y') THEN(DO)                /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(DPOSNA DPOSND UDEPPA UDEPPD CDEPPA +
                             CDEPPD CPOSNA CPOSND +
                             BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
                             BKPOSD BPACHA BPACHD) JRN(ICJRN)         /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
             ENDDO                                                    /*CCB009*/
                IF         COND(&S01511 *EQ 'Y') THEN(DO)             /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                   ENDJRNPF   FILE(BKMTHD) JRN(ICJRN)                 /*086486*/
                   MONMSG     MSGID(CPF0000)                          /*095907*/
             ENDDO                                                    /*CCB009*/
                ENDDO                                                 /*086486*/
/*/COPY WNCPYSRC,SEC1004003                                          */
             ENDDO                                                    /*086486*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XDPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(XDPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(XUDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(XUDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCAPRHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCAPRHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHA) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC1004004                                          */
 
/*  AND COPY FILES                                                  */
 
                CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPOSND)
                CPYF       FROMFILE(XDPOSNA) TOFILE(DPOSNA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPOSNA)
                CPYF       FROMFILE(XUDEPPD) TOFILE(UDEPPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM UDEPPD)
                CPYF       FROMFILE(XUDEPPA) TOFILE(UDEPPA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM UDEPPA)
                CPYF       FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CDEPPD)
                CPYF       FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CDEPPA)
                CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CPOSND)
                CPYF       FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CPOSNA)
                CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CAPRHD)
                CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CAPRHA)
                CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHD)
                CPYF       FROMFILE(XBKMTHA) TOFILE(BKMTHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHA)
                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)
                CPYF       FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDA)
                CPYF       FROMFILE(XBKPHHD) TOFILE(BKPHHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHD)
                CPYF       FROMFILE(XBKPHHA) TOFILE(BKPHHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHA)
                CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSD)
                CPYF       FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSA)
                CPYF       FROMFILE(XBPACHD) TOFILE(BPACHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHD)
                CPYF       FROMFILE(XBPACHA) TOFILE(BPACHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHA)
/*/COPY WNCPYSRC,SEC1004005                                          */
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
             ENDDO                                                    /*095907*/
 
/*  ELSE BACKUP FILES                                               */
 
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XDPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(XDPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(XUDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(XUDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(XCPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(XCAPRHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XCAPRHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKMTHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHDA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPHHA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBKPOSA) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHD) SEQONLY(*YES 100)
                OVRDBF     FILE(XBPACHA) SEQONLY(*YES 100)
                OVRDBF     FILE(DPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(DPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(UDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(UDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(CDEPPD) SEQONLY(*YES 100)
                OVRDBF     FILE(CDEPPA) SEQONLY(*YES 100)
                OVRDBF     FILE(CPOSND) SEQONLY(*YES 100)
                OVRDBF     FILE(CPOSNA) SEQONLY(*YES 100)
                OVRDBF     FILE(CAPRHD) SEQONLY(*YES 100)
                OVRDBF     FILE(CAPRHA) SEQONLY(*YES 100)
                OVRDBF     FILE(BKMTHD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKMTHA) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHDD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHDA) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHHD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPHHA) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPOSD) SEQONLY(*YES 100)
                OVRDBF     FILE(BKPOSA) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACHD) SEQONLY(*YES 100)
                OVRDBF     FILE(BPACHA) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SEC1004006                                          */
                                                                      /*S01129*/
/*  DELETE WORK FILES                                              */ /*S01129*/
                                                                      /*S01129*/
/*             DLTF       FILE(XDPOSND)                     /*S01129*  *S01158*/
/*                 MONMSG MSGID(CPF0000)                    /*S01129*  *S01158*/
               DLTF       FILE(XDPOSNA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XUDEPPD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XUDEPPA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCDEPPD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCDEPPA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCAPRHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCAPRHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKMTHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKMTHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHDD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHDA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPOSD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPOSA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBPACHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBPACHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC1004007                                          */
 
/*  AND COPY FILES                                                 */
 
/*              CPYF       FROMFILE(DPOSND) TOFILE(XDPOSND) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XDPOSND)                    *  *S01129*/
/*              CPYF       FROMFILE(DPOSNA) TOFILE(XDPOSNA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XDPOSNA)                    *  *S01129*/
/*              CPYF       FROMFILE(UDEPPD) TOFILE(XUDEPPD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XUDEPPD)                    *  *S01129*/
/*              CPYF       FROMFILE(UDEPPA) TOFILE(XUDEPPA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XUDEPPA)                    *  *S01129*/
/*              CPYF       FROMFILE(CDEPPD) TOFILE(XCDEPPD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCDEPPD)                    *  *S01129*/
/*              CPYF       FROMFILE(CDEPPA) TOFILE(XCDEPPA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCDEPPA)                    *  *S01129*/
/*              CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCPOSND)                    *  *S01129*/
/*              CPYF       FROMFILE(CPOSNA) TOFILE(XCPOSNA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCPOSNA)                    *  *S01129*/
/*              CPYF       FROMFILE(CAPRHD) TOFILE(XCAPRHD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCAPRHD)                    *  *S01129*/
/*              CPYF       FROMFILE(CAPRHA) TOFILE(XCAPRHA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XCAPRHA)                    *  *S01129*/
/*              CPYF       FROMFILE(BKMTHD) TOFILE(XBKMTHD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKMTHD)                    *  *S01129*/
/*              CPYF       FROMFILE(BKMTHA) TOFILE(XBKMTHA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKMTHA)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHDD)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPHDA) TOFILE(XBKPHDA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHDA)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPHHD) TOFILE(XBKPHHD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHHD)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPHHA) TOFILE(XBKPHHA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPHHA)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPOSD) TOFILE(XBKPOSD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPOSD)                    *  *S01129*/
/*              CPYF       FROMFILE(BKPOSA) TOFILE(XBKPOSA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBKPOSA)                    *  *S01129*/
/*              CPYF       FROMFILE(BPACHD) TOFILE(XBPACHD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBPACHD)                    *  *S01129*/
/*              CPYF       FROMFILE(BPACHA) TOFILE(XBPACHA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XBPACHA)                    *  *S01129*/
                CPYF       FROMFILE(DPOSND) TOFILE(&TOLIB/XDPOSND) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XDPOSND)                      /*S01129*/
                CPYF       FROMFILE(DPOSNA) TOFILE(&TOLIB/XDPOSNA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XDPOSNA)                      /*S01129*/
                CPYF       FROMFILE(UDEPPD) TOFILE(&TOLIB/XUDEPPD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XUDEPPD)                      /*S01129*/
                CPYF       FROMFILE(UDEPPA) TOFILE(&TOLIB/XUDEPPA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XUDEPPA)                      /*S01129*/
                CPYF       FROMFILE(CDEPPD) TOFILE(&TOLIB/XCDEPPD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCDEPPD)                      /*S01129*/
                CPYF       FROMFILE(CDEPPA) TOFILE(&TOLIB/XCDEPPA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCDEPPA)                      /*S01129*/
                CPYF       FROMFILE(CPOSND) TOFILE(&TOLIB/XCPOSND) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCPOSND)                      /*S01129*/
                CPYF       FROMFILE(CPOSNA) TOFILE(&TOLIB/XCPOSNA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCPOSNA)                      /*S01129*/
                CPYF       FROMFILE(CAPRHD) TOFILE(&TOLIB/XCAPRHD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCAPRHD)                      /*S01129*/
                CPYF       FROMFILE(CAPRHA) TOFILE(&TOLIB/XCAPRHA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XCAPRHA)                      /*S01129*/
                CPYF       FROMFILE(BKMTHD) TOFILE(&TOLIB/XBKMTHD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKMTHD)                      /*S01129*/
                CPYF       FROMFILE(BKMTHA) TOFILE(&TOLIB/XBKMTHA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKMTHA)                      /*S01129*/
                CPYF       FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDD)                      /*S01129*/
                CPYF       FROMFILE(BKPHDA) TOFILE(&TOLIB/XBKPHDA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDA)                      /*S01129*/
                CPYF       FROMFILE(BKPHHD) TOFILE(&TOLIB/XBKPHHD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHHD)                      /*S01129*/
                CPYF       FROMFILE(BKPHHA) TOFILE(&TOLIB/XBKPHHA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHHA)                      /*S01129*/
                CPYF       FROMFILE(BKPOSD) TOFILE(&TOLIB/XBKPOSD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPOSD)                      /*S01129*/
                CPYF       FROMFILE(BKPOSA) TOFILE(&TOLIB/XBKPOSA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPOSA)                      /*S01129*/
                CPYF       FROMFILE(BPACHD) TOFILE(&TOLIB/XBPACHD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACHD)                      /*S01129*/
                CPYF       FROMFILE(BPACHA) TOFILE(&TOLIB/XBPACHA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBPACHA)                      /*S01129*/
/*/COPY WNCPYSRC,SEC1004008                                          */
                                                                      /*086486*/
/** End journalling. */                                               /*086486*/
             IF         COND(&S01513 *EQ 'Y') THEN(DO)                /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(DPOSNA DPOSND UDEPPA UDEPPD CDEPPA +
                             CDEPPD CPOSNA CPOSND +
                             BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
                             BKPOSD BPACHA BPACHD) JRN(ICJRN)         /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
             ENDDO                                                    /*CCB009*/
                IF         COND(&S01511 *EQ 'Y') THEN(DO)             /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                   ENDJRNPF   FILE(BKMTHD) JRN(ICJRN)                 /*086486*/
                   MONMSG     MSGID(CPF0000)                          /*095907*/
             ENDDO                                                    /*CCB009*/
                ENDDO                                                 /*086486*/
/*/COPY WNCPYSRC,SEC1004009                                          */
             ENDDO                                                    /*086486*/
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*095907*/
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE2530)
 
/* IF NO ERRORS - CALL NEXT PROGRAM                              */
 
             CHKOBJ     OBJ(&TOLIB/CHECK) OBJTYPE(*FILE)                                  /*260765*/
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)                                   /*260765*/
             DSPFD      FILE(CAPRHD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          FILEATR(*PF) OUTFILE(&TOLIB/CHECK)                              /*260765*/
             ENDDO                                                                        /*260765*/
                                                                                          /*260765*/
/**********  IF         COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(SE2540))     095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                                                                      /*095907*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*095907*/
             CALL PGM(SE2540)                                         /*095907*/
             ENDDO                                                    /*095907*/
                                                                      /*095907*/
             ENDDO                                                    /*095907*/
             /* CONTINUE PROCESS IF FOOB */                           /*095907*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*095907*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*095907*/
                CHGVAR  VAR(&MEM) VALUE('SEC1004  - File Controls Out +
                        Of Balance')                                  /*095907*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)             /*095907*/
             CHGJOB SWS(XXXXXX00)                                     /*095907*/
             ENDDO                                                    /*095907*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*095907*/
             CALL PGM(SE2540)                                         /*095907*/
             ENDDO                                                    /*095907*/
 
             ENDDO                                                    /*095907*/
                                                                                          /*260765*/
             DLTF FILE(&TOLIB/CHECK)                                                      /*260765*/
                                                                                          /*260765*/
 
 
/* IF NO ERRORS - CALL NEXT PROGRAM                              */
 
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(SE2550))
             ENDDO                                                    /*095907*/
             /* CONTINUE PROCESS IF FOOB */                           /*095907*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*095907*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*095907*/
                CHGVAR  VAR(&MEM) VALUE('SEC1004  - File Controls Out +
                        Of Balance')                                  /*095907*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)             /*095907*/
             CHGJOB SWS(XXXXXX00)                                     /*095907*/
             ENDDO                                                    /*095907*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(SE2550))
             ENDDO                                                    /*095907*/
 
/****IF*ERROR*AND***/                                          /*S01513 086486*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/*********** IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)    */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(DPOSNA DPOSND UDEPPA UDEPPD CDEPPA +
/***********                 CDEPPD CPOSNA CPOSND CAPRHA CAPRHD BKMTHA +
/***********                 BKMTHD BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
/***********                 BKPOSD BPACHA BPACHD) JRN(ICJRN)  /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*086486*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPOSND)                       /*S01513*/
                CPYF       FROMFILE(XDPOSNA) TOFILE(DPOSNA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPOSNA)                       /*S01513*/
                CPYF       FROMFILE(XUDEPPD) TOFILE(UDEPPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM UDEPPD)                       /*S01513*/
                CPYF       FROMFILE(XUDEPPA) TOFILE(UDEPPA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM UDEPPA)                       /*S01513*/
                CPYF       FROMFILE(XCDEPPD) TOFILE(CDEPPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CDEPPD)                       /*S01513*/
                CPYF       FROMFILE(XCDEPPA) TOFILE(CDEPPA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CDEPPA)                       /*S01513*/
                CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CPOSND)                       /*S01513*/
                CPYF       FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CPOSNA)                       /*S01513*/
                CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CAPRHD)                       /*S01513*/
                CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM CAPRHA)                       /*S01513*/
                CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHD)                       /*S01513*/
                CPYF       FROMFILE(XBKMTHA) TOFILE(BKMTHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKMTHA)                       /*S01513*/
                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)                       /*S01513*/
                CPYF       FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDA)                       /*S01513*/
                CPYF       FROMFILE(XBKPHHD) TOFILE(BKPHHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHD)                       /*S01513*/
                CPYF       FROMFILE(XBKPHHA) TOFILE(BKPHHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHHA)                       /*S01513*/
                CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSD)                       /*S01513*/
                CPYF       FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPOSA)                       /*S01513*/
                CPYF       FROMFILE(XBPACHD) TOFILE(BPACHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHD)                       /*S01513*/
                CPYF       FROMFILE(XBPACHA) TOFILE(BPACHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BPACHA)                       /*S01513*/
               CLRPFM     FILE(XDPOSND)                               /*S01513*/
/*/COPY WNCPYSRC,SEC1004010                                          */
               DLTF       FILE(XDPOSNA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XUDEPPD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XUDEPPA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XCDEPPD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XCDEPPA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XCAPRHD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XCAPRHA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKMTHD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKMTHA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPHDD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPHDA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPHHD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPHHA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPOSD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBKPOSA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBPACHD)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
               DLTF       FILE(XBPACHA)                               /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
/*/COPY WNCPYSRC,SEC1004011                                          */
 
/** START JOURNALLING THE FILES                                  */
 
/***********      STRJRNPF   FILE(DPOSNA DPOSND UDEPPA UDEPPD CDEPPA +
                             CDEPPD CPOSNA CPOSND CAPRHA CAPRHD BKMTHA +
                             BKMTHD BKPHDA BKPHDD BKPHHA BKPHHD BKPOSA +
                             BKPOSD BPACHA BPACHD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
 
/** Start journalling the bulk of the files: this code is in */
/** member SEC1004JRN in SECPYSRC. */
/*/COPY SECPYSRC,SEC1004JRN                                             086486*/
                MONMSG     MSGID(CPF7030)                             /*CCB009*/
 
                  IF         COND(&S01511 = 'Y') THEN(DO)             /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  STRJRNPF   FILE(BKMTHD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                  ENDDO                                               /*086486*/
/*/COPY WNCPYSRC,SEC1004012                                          */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
               ENDDO                                                  /*095907*/
                ENDDO                                                 /*S01513*/
                ENDDO                                                 /*S01513*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1004  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1004  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
               ENDDO                                                  /*095907*/
 
/*  CLEAR FILES                                                    */
 
/*                                                                    /*095907*/
/*             CLRPFM     FILE(XDPOSND)                               /*095907*/
/*             CLRPFM     FILE(XDPOSNA)                               /*095907*/
/*             CLRPFM     FILE(XUDEPPD)                               /*095907*/
/*             CLRPFM     FILE(XUDEPPA)                               /*095907*/
/*             CLRPFM     FILE(XCDEPPD)                               /*095907*/
/*             CLRPFM     FILE(XCDEPPA)                               /*095907*/
/*             CLRPFM     FILE(XCPOSND)                               /*095907*/
/*             CLRPFM     FILE(XCPOSNA)                               /*095907*/
/*             CLRPFM     FILE(XCAPRHD)                               /*095907*/
/*             CLRPFM     FILE(XCAPRHA)                               /*095907*/
/*             CLRPFM     FILE(XBKMTHD)                               /*095907*/
/*             CLRPFM     FILE(XBKMTHA)                               /*095907*/
/*             CLRPFM     FILE(XBKPHDD)                               /*095907*/
/*             CLRPFM     FILE(XBKPHDA)                               /*095907*/
/*             CLRPFM     FILE(XBKPHHD)                               /*095907*/
/*             CLRPFM     FILE(XBKPHHA)                               /*095907*/
/*             CLRPFM     FILE(XBKPOSD)                               /*095907*/
/*             CLRPFM     FILE(XBKPOSA)                               /*095907*/
/*             CLRPFM     FILE(XBPACHD)                               /*095907*/
/*             CLRPFM     FILE(XBPACHA)                               /*095907*/
/*                                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1004013                                          */
 
/***DROP*ASTERISKED RECORDS                                        */ /*095907*/
/**********                                                           /*095907*/
/**********  CPYF       FROMFILE(DPOSND) TOFILE(XDPOSND) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(UDEPPD) TOFILE(XUDEPPD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(CDEPPD) TOFILE(XCDEPPD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(CAPRHD) TOFILE(XCAPRHD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(BKMTHD) TOFILE(XBKMTHD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF BKID *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(BKPHDD) TOFILE(XBKPHDD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(BKPHHD) TOFILE(XBKPHHD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(BKPOSD) TOFILE(XBKPOSD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(BPACHD) TOFILE(XBPACHD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********                                                           /*095907*/
/*/COPY WNCPYSRC,SEC1004014                                          */
 
/***COPY*BACK LIVE RECORDS                                         */ /*095907*/
/**********                                                           /*095907*/
/**********     CPYF       FROMFILE(XDPOSND) TOFILE(DPOSND) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM DPOSND)                       /*095907*/
/**********     CPYF       FROMFILE(XUDEPPD) TOFILE(UDEPPD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM UDEPPD)                       /*095907*/
/**********     CPYF       FROMFILE(XCDEPPD) TOFILE(CDEPPD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM CDEPPD)                       /*095907*/
/**********     CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM CPOSND)                       /*095907*/
/**********     CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM CAPRHD)                       /*095907*/
/**********     CPYF       FROMFILE(XBKMTHD) TOFILE(BKMTHD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM BKMTHD)                       /*095907*/
/**********     CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM BKPHDD)                       /*095907*/
/**********     CPYF       FROMFILE(XBKPHHD) TOFILE(BKPHHD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM BKPHHD)                       /*095907*/
/**********     CPYF       FROMFILE(XBKPOSD) TOFILE(BKPOSD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM BKPOSD)                       /*095907*/
/**********     CPYF       FROMFILE(XBPACHD) TOFILE(BPACHD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM BPACHD)                       /*095907*/
/*/COPY WNCPYSRC,SEC1004015                                          */
 
/*  CLEAR WORK FILES                                               */
 
/*             CLRPFM     FILE(XDPOSND)                            */ /*S01129*/
/*             CLRPFM     FILE(XUDEPPD)                            */ /*S01129*/
/*             CLRPFM     FILE(XCDEPPD)                            */ /*S01129*/
/**********    CLRPFM     FILE(XCPOSND)                    /*S01129   /*095907*/
/*             CLRPFM     FILE(XCAPRHD)                            */ /*S01129*/
/*             CLRPFM     FILE(XBKMTHD)                            */ /*S01129*/
/*             CLRPFM     FILE(XBKPHDD)                            */ /*S01129*/
/*             CLRPFM     FILE(XBKPHHD)                            */ /*S01129*/
/*             CLRPFM     FILE(XBKPOSD)                            */ /*S01129*/
/*             CLRPFM     FILE(XBPACHD)                            */ /*S01129*/
                                                                      /*S01129*/
/*  DELETE WORK FILES                                              */ /*S01129*/
                                                                      /*S01129*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*             DLTF       FILE(XDPOSND)                     /*S01129*  *S01158*/
/*                 MONMSG MSGID(CPF0000)                    /*S01129*  *S01158*/
               CLRPFM     FILE(XDPOSND)                               /*S01158*/
               DLTF       FILE(XDPOSNA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XUDEPPD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XUDEPPA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCDEPPD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCDEPPA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCAPRHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XCAPRHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKMTHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKMTHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHDD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHDA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPHHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPOSD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBKPOSA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBPACHD)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
               DLTF       FILE(XBPACHA)                               /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC1004016                                          */
 
/**********  IF COND(&S01513 *EQ 'Y') THEN(DO)                *086486* *095907*/
 
/** Start journalling the bulk of the files: this code is in */
/** member SEC1004JRN in SECPYSRC. */
/*/COPY SECPYSRC,SEC1004JRN                                             086486*/
                MONMSG     MSGID(CPF7030)                             /*CCB009*/
 
                  IF         COND(&S01511 = 'Y') THEN(DO)             /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                     STRJRNPF   FILE(BKMTHD) JRN(ICJRN) +
                                  IMAGES(*BOTH) OMTJRNE(*OPNCLO)      /*086486*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
             ENDDO                                                    /*CCB009*/
                  ENDDO                                               /*086486*/
/*/COPY WNCPYSRC,SEC1004017                                          */
                ENDDO                                                 /*086486*/
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
