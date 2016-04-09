/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off securities')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1001   DROP OFF SECURITIES                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 095907             DATE 31JAN07              */
/*       Prev Amend No. 227749             DATE 31JAN07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 27SEP96             */
/*                      086486             DATE 21JUN95             */
/*                      S01408             DATE 11MAY95             */
/*                      S01513             DATE 10AUG94             */
/*                      S01447             DATE 16NOV93             */
/*                      S01117             DATE 10JAN91             */
/*                      S01189             DATE 10JAN91             */
/*                      S01179             DATE 16/09/88            */
/*                      S01129             DATE 31/03/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
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
/*                ----------------------------------------------
/*              - SUPPRESS DROP OF ASTERIX RECORDS AND COPY BACK OF */
/*                LIVE RECORDS AS RECORDS TO BE DROPPED ARE PHYSIC. */
/*                DELETED BY PROGRAMS SE25XX.                       */
/*              - MONITOR END JOURNALING                            */
/*              - Also apply 227749                                 */
/*       227749 - Take file SESDX1PD into consideration for copy    */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408 - Addition of core hook SEC1001006                  */
/*                Addition of core hook SEC1001005                  */
/*                Addition of core hook SEC1001004                  */
/*                Addition of core hook SEC1001003                  */
/*                Addition of core hook SEC1001002                  */
/*                Addition of core hook SEC1001001                  */
/*       086486 - Stop journalling of files for this process        */
/*       S01408 - Addition of core hook SEC1001MPS                  */
/*       S01513 - SE drop runs separately from EOD.                 */
/*       S01447 - AMENDED TO TAKE SECURITY COPY OF PF/SESWHTPD      */
/*                BEFORE CALL TO SE2570 AND RESTORE IT IF THAT      */
/*                PROGRAM FAILS                                     */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
/*       S01179 - RELEASE                                           */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
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
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*S01513*/
             DCL        VAR(&DROP) TYPE(*CHAR) LEN(1)                 /*S01513*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)  +
                          VALUE('*FIRST')                             /*S01513*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01513*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01513) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01513*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001001                                        */ /*S01408*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*S01408*/
                                                                      /*S01129*/
/** CHECK FOR SE DROP FIELD IF SEQUENCE = 00003                */    /*S01513*/
             IF         COND(&CSEQ = 00003) THEN(DO)                  /*S01189*/
                RTVDTAARA  DTAARA(SESTAT (81 1)) RTNVAR(&DROP)        /*S01513*/
             IF         COND(&DROP *NE 'Y') THEN(DO)                  /*S01513*/
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
/*/COPY WNCPYSRC,SEC1001MPS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC1001  - Drop off +
                        Securities')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON            */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001002                                        */ /*S01408*/
                                                                      /*S01408*/
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
                                                                      /*086486*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(SECTYD SECTYA SEDEVD SEDEVA SNDEVD +
                             SNDEVA SESWHTPD) JRN(ICJRN)              /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
             ENDDO                                                    /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001003                                        */ /*S01408*/
                                                                      /*S01408*/
             ENDDO                                                    /*086486*/
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/********    IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSECTYA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSESWHTPD) SEQONLY(*YES 100)          /*S01447*/
                OVRDBF     FILE(XSESDX1PD) SEQONLY(*YES 100)          /*227749*/
/*/COPY WNCPYSRC,SEC1001008                                          */
 
/*  AND COPY FILES                                                  */
 
                CPYF       FROMFILE(XSECTYD) TOFILE(SECTYD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SECTYD)
                CPYF       FROMFILE(XSECTYA) TOFILE(SECTYA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SECTYA)
                CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVD)
                CPYF       FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVA)
                CPYF       FROMFILE(XSEDEVD) TOFILE(SEDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDEVD)
                CPYF       FROMFILE(XSEDEVA) TOFILE(SEDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDEVA)
                CPYF       FROMFILE(XSESWHTPD) TOFILE(SESWHTPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01447*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(SESWHTPD))                            /*S01447*/
                CPYF       FROMFILE(XSESDX1PD) TOFILE(SESDX1PD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*227749*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(SESDX1PD))                            /*227749*/
/*/COPY WNCPYSRC,SEC1001017                                          */
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/********       CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
/*/COPY WNCPYSRC,SEC1001009                                          */
 
             ENDDO
             ENDDO                                                    /*095907*/
 
/*  ELSE BACKUP FILES                                               */
 
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSECTYA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XSEDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(XSESWHTPD) SEQONLY(*YES 100)          /*S01447*/
                OVRDBF     FILE(XSESDX1PD) SEQONLY(*YES 100)          /*227749*/
/*/COPY WNCPYSRC,SEC1001018                                          */
                OVRDBF     FILE(SECTYD) SEQONLY(*YES 100)
                OVRDBF     FILE(SECTYA) SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(SNDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVD) SEQONLY(*YES 100)
                OVRDBF     FILE(SEDEVA) SEQONLY(*YES 100)
                OVRDBF     FILE(SESWHTPD) SEQONLY(*YES 100)           /*S01447*/
/*/COPY WNCPYSRC,SEC1001010                                          */
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSECTYA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSESWHTPD)                            /*S01447*/
                   MONMSG MSGID(CPF0000)                              /*S01447*/
                DLTF       FILE(XSESDX1PD)                            /*227749*/
                   MONMSG MSGID(CPF0000)                              /*227749*/
/*/COPY WNCPYSRC,SEC1001011                                          */
 
/*  AND COPY FILES                                                 */
 
/*              CPYF       FROMFILE(SECTYD) TOFILE(XSECTYD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSECTYD)                    *  *S01129*/
/*              CPYF       FROMFILE(SECTYA) TOFILE(XSECTYA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSECTYA)                    *  *S01129*/
/*              CPYF       FROMFILE(SNDEVD) TOFILE(XSNDEVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSNDEVD)                    *  *S01129*/
/*              CPYF       FROMFILE(SNDEVA) TOFILE(XSNDEVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSNDEVA)                    *  *S01129*/
/*              CPYF       FROMFILE(SEDEVD) TOFILE(XSEDEVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSEDEVD)                    *  *S01129*/
/*              CPYF       FROMFILE(SEDEVA) TOFILE(XSEDEVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XSEDEVA)                    *  *S01129*/
                CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSECTYD)                      /*S01129*/
                CPYF       FROMFILE(SECTYA) TOFILE(&TOLIB/XSECTYA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSECTYA)                      /*S01129*/
                CPYF       FROMFILE(SNDEVD) TOFILE(&TOLIB/XSNDEVD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSNDEVD)                      /*S01129*/
                CPYF       FROMFILE(SNDEVA) TOFILE(&TOLIB/XSNDEVA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSNDEVA)                      /*S01129*/
                CPYF       FROMFILE(SEDEVD) TOFILE(&TOLIB/XSEDEVD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSEDEVD)                      /*S01129*/
                CPYF       FROMFILE(SEDEVA) TOFILE(&TOLIB/XSEDEVA)  +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XSEDEVA)                      /*S01129*/
             CPYF       FROMFILE(SESWHTPD) TOFILE(&TOLIB/XSESWHTPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSESWHTPD))                            /*S01447*/
             CPYF       FROMFILE(SESDX1PD) TOFILE(&TOLIB/XSESDX1PD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*227749*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSESDX1PD))                            /*227749*/
/*/COPY WNCPYSRC,SEC1001012                                          */
 
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/********    CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')             /*S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*095907*/
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE2570)
 
/* IF NO ERRORS - CALL NEXT PROGRAM                              */
 
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(SE2510))
             ENDDO                                                    /*095907*/
             /* CONTINUE PROCESS IF FOOB */                           /*095907*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*095907*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*095907*/
                CHGVAR  VAR(&MEM) VALUE('SEC1001 - File Controls Out +
                        Of Balance')                                  /*095907*/
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)             /*095907*/
             CHGJOB SWS(XXXXXX00)                                     /*095907*/
             ENDDO                                                    /*095907*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CALL PGM(SE2510))
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1001019                                          */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1001  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1001  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
                                                                      /*S01513*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/*********** IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)    */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF  FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
/***********                 SEDEVD SESWHTPD) JRN(ICJRN)    */ /*S01513 086486*/
/***********      MONMSG    MSGID(CPF0000 MCH0000)          */ /*S01513 086486*/
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                               S01513*/
                                                                      /*S01513*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*086486*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CPYF      FROMFILE(XSECTYD) TOFILE(SECTYD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SECTYD)                       /*S01513*/
                  CPYF      FROMFILE(XSECTYA) TOFILE(SECTYA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SECTYA)                       /*S01513*/
                  CPYF      FROMFILE(XSNDEVD) TOFILE(SNDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVD)                       /*S01513*/
                  CPYF      FROMFILE(XSNDEVA) TOFILE(SNDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SNDEVA)                       /*S01513*/
                  CPYF      FROMFILE(XSEDEVD) TOFILE(SEDEVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDEVD)                       /*S01513*/
                  CPYF      FROMFILE(XSEDEVA) TOFILE(SEDEVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDEVA)                       /*S01513*/
                  CPYF      FROMFILE(XSESWHTPD) TOFILE(SESWHTPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01513*/
                  MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SESWHTPD))                           /*S01513*/
                  CPYF      FROMFILE(XSESDX1PD) TOFILE(SESDX1PD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*227749*/
                  MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SESDX1PD))                           /*227749*/
/*/COPY WNCPYSRC,SEC1001013                                          */
                DLTF       FILE(XSECTYD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSECTYA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSNDEVD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSNDEVA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSEDEVD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSEDEVA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSESWHTPD)                            /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XSESDX1PD)                            /*227749*/
                   MONMSG MSGID(CPF0000)                              /*227749*/
/*/COPY WNCPYSRC,SEC1001014                                          */
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                         S01513*/
                                                                      /*S01513*/
                  STRJRNPF  FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                            SEDEVD SESWHTPD) JRN(ICJRN) IMAGES(*BOTH) +
                            OMTJRNE(*OPNCLO)                          /*S01513*/
/***********      MONMSG    MSGID(CPF0000 MCH0000)          */ /*S01513 086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001004                                        */ /*S01408*/
                                                                      /*S01408*/
                  CHGVAR    VAR(&BUSY) VALUE('N')                     /*S01513*/
                  CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)            /*S01513*/
                ENDDO                                                 /*S01513*/
                ENDDO                                                 /*S01513*/
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
               ENDDO                                                  /*095907*/
 
/*  CLEAR FILES                                                    */
 
/**********    CLRPFM     FILE(XSECTYD)                               /*095907*/
/**********    CLRPFM     FILE(XSECTYA)                               /*095907*/
/**********    CLRPFM     FILE(XSEDEVD)                               /*095907*/
/**********    CLRPFM     FILE(XSEDEVA)                               /*095907*/
/**********    CLRPFM     FILE(XSESWHTPD)                             /*095907*/
/**********    CLRPFM     FILE(XSNDEVD)                               /*095907*/
/**********    CLRPFM     FILE(XSNDEVD)                               /*095907*/
/*/COPY WNCPYSRC,SEC1001015                                          */
 
/*  DROP ASTERISKED RECORDS                                        */
 
/**********  CPYF       FROMFILE(SECTYD) TOFILE(XSECTYD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(SNDEVD) TOFILE(XSNDEVD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
/**********  CPYF       FROMFILE(SEDEVD) TOFILE(XSEDEVD) +            /*095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                               /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*095907*/
 
/*  COPY BACK LIVE RECORDS                                         */
 
/**********     CPYF       FROMFILE(XSECTYD) TOFILE(SECTYD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM SECTYD)                       /*095907*/
/*/COPY WNCPYSRC,SEC1001007                                          */
/**********     CPYF       FROMFILE(XSNDEVD) TOFILE(SNDEVD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM SNDEVD)                       /*095907*/
/**********     CPYF       FROMFILE(XSEDEVD) TOFILE(SEDEVD) +         /*095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)            /*095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                /*095907*/
/**********                 EXEC(CLRPFM SEDEVD)                       /*095907*/
/*/COPY WNCPYSRC,SEC1001016                                          */
 
/***  CLEAR WORK FILES                                               */
/*                                                                  *  *S01129*/
/*             CLRPFM     FILE(XSECTYD)                             *  *S01129*/
/*             CLRPFM     FILE(XSNDEVD)                             *  *S01129*/
/*             CLRPFM     FILE(XSEDEVD)                             *  *S01129*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                DLTF       FILE(XSECTYD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSECTYA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSNDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEDEVA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSESWHTPD)                            /*S01447*/
                   MONMSG MSGID(CPF0000)                              /*S01447*/
                DLTF       FILE(XSESDX1PD)                            /*227749*/
                   MONMSG MSGID(CPF0000)                              /*227749*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001005                                        */ /*S01408*/
                                                                      /*S01408*/
                                                                      /*086486*/
/**********  IF COND(&S01513 *EQ 'Y') THEN(DO)                *086486* *095907*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  STRJRNPF  FILE(SECTYA SECTYD SNDEVA SNDEVD SEDEVA +
                            SEDEVD SESWHTPD) JRN(ICJRN) IMAGES(*BOTH) +
                            OMTJRNE(*OPNCLO)                          /*086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1001006                                        */ /*S01408*/
                                                                      /*S01408*/
                ENDDO                                                 /*086486*/
 
             ENDDO
 
ENDPGM:                                                               /*S01513*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
