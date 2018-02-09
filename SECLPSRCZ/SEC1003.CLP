/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off depot movements')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1003   DROP OFF DEPOT MOVEMENTS                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 095907             Date 14Jun04              */
/*                      228542             Date 14Jun04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 30Nov01              */
/*                      CSE027             Date 25Jan01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086486             Date 21Jun95              */
/*                      S01408             Date 11May95              */
/*                      S01513             DATE 10AUG94             */
/*                      S01117             DATE 10JAN91             */
/*                      S01189             DATE 10JAN91             */
/*                      S01179             DATE 16/09/88            */
/*                      S01129             DATE 31/03/88            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
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
/*              - REMOVE CALL OF SEU510, EXTENSION FILES ON DPTMVD  */
/*                DIRECTLY DROPPED (DELETED) IN SE2525              */
/*              - IF MT5XX FEATURE IS ON BACKUP EXTENSION FILES     */
/*              - MONITOR END JOURNALING                            */
/*       228542 - RGZPFM has changed at V5R3                        */
/*       CPK014 - Release 4 packaging:                              */
/*                CPYF should specify field DTRECI not RECI.        */
/*       CSE027 - Bulk Depot Transfer                               */
/*       CCB009 - Journal files throughout close of business        */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)  */
/*       086486 - Stop journalling of files for this process        */
/*       S01408 - Addition of core hook SEC1003MPS                  */
/*       S01513 - SE drop runs separately from EOD.                 */
/*       S01117 - MULTIBRANCHING                                    */
/*       S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2            */
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
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
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
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&CSE027) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSE027*/
             DCL        VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE('N')    /*095907*/
/*/COPY WNCPYSRC,SEC1003001                                          */
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
/*/COPY WNCPYSRC,SEC1003MPS                                          */
                                                                      /*S01408*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC1003  - Drop off +
                        Depot Movements')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON                 /*S01513*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*095907*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*095907*/
             CHGVAR     VAR(&SAR) VALUE('S01401')                     /*095907*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*095907*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01401) VALUE('Y'))                    /*095907*/
                                                                                          /*CSE027*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSE027*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSE027*/
             CHGVAR     VAR(&SAR) VALUE('CSE027')                                         /*CSE027*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSE027*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CSE027) VALUE('Y'))                                        /*CSE027*/
 
/*/COPY WNCPYSRC,SEC1003002                                          */
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
                                                                      /*086486*/
             IF COND(&S01513 *EQ 'Y') THEN(DO)                        /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(DPTMVD DPTMVA) JRN(ICJRN)             /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
                   IF COND(&S01401 *EQ 'Y') THEN(DO)                  /*095907*/
                     ENDJRNPF   FILE(DPTMVDX1) JRN(ICJRN)             /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                     ENDJRNPF   FILE(DPTMVDX2) JRN(ICJRN)             /*095907*/
                     MONMSG     MSGID(CPF0000)                        /*095907*/
                   ENDDO                                              /*095907*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1003020                                          */
             ENDDO                                                    /*086486*/
                                                                                          /*CSE027*/
             IF         COND(&S01513 *EQ 'Y' *AND &CSE027 *EQ 'Y') +
                          THEN(DO)                                                        /*CSE027*/
                ENDJRNPF   FILE(SEDPTRPD) JRN(ICJRN)                                      /*CSE027*/
             ENDDO                                                                        /*CSE027*/
 
/*/COPY WNCPYSRC,SEC1003003                                          */
/*  CHECK FOR COMPONENT RESTART                                     */
 
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XDPTMVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XDPTMVA) SEQONLY(*YES 100)
                                                                                          /*CSE027*/
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
             OVRDBF     FILE(XSEDPTRPD) SEQONLY(*YES 100)                                 /*CSE027*/
             ENDDO                                                                        /*CSE027*/
 
/*/COPY WNCPYSRC,SEC1003004                                          */
/*  AND COPY FILES                                                  */
 
                CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPTMVD)
                CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM DPTMVA)
                                                                                          /*CSE027*/
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
                CPYF       FROMFILE(XSEDPTRPD) TOFILE(SEDPTRPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*CSE027*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDPTRPD)                                         /*CSE027*/
             ENDDO                                                                        /*CSE027*/
/* If MT5XX IS active, do recovery processing */                      /*095907*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                  CPYF       FROMFILE(XDPTMVDX1) TOFILE(DPTMVDX1) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM DPTMVDX1)                   /*095907*/
                  CPYF       FROMFILE(XDPTMVDX2) TOFILE(DPTMVDX2) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)          /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM DPTMVDX2)                   /*095907*/
                ENDDO                                                 /*095907*/
 
/*/COPY WNCPYSRC,SEC1003005                                          */
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1003021                                          */
 
/*  ELSE BACKUP FILES                                               */
 
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
/*/COPY WNCPYSRC,SEC1003022                                          */
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
                OVRDBF     FILE(XDPTMVD) SEQONLY(*YES 100)
                OVRDBF     FILE(XDPTMVA) SEQONLY(*YES 100)
                OVRDBF     FILE(DPTMVD) SEQONLY(*YES 100)
                OVRDBF     FILE(DPTMVA) SEQONLY(*YES 100)
                                                                      /*S01129*/
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
                OVRDBF     FILE(XSEDPTRPD) SEQONLY(*YES 100)                              /*CSE027*/
                OVRDBF     FILE(SEDPTRPD) SEQONLY(*YES 100)                               /*CSE027*/
             ENDDO                                                                        /*CSE027*/
                                                                                          /*CSE027*/
/*/COPY WNCPYSRC,SEC1003006                                          */
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XDPTMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XDPTMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                                                                                          /*CSE027*/
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
                   DLTF       FILE(XSEDPTRPD)                                             /*CSE027*/
                   MONMSG     MSGID(CPF0000)                                              /*CSE027*/
             ENDDO                                                                        /*CSE027*/
 
/*/COPY WNCPYSRC,SEC1003007                                          */
/*  AND COPY FILES                                                 */
 
/*              CPYF       FROMFILE(DPTMVD) TOFILE(XDPTMVD) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XDPTMVD)                    *  *S01129*/
/*              CPYF       FROMFILE(DPTMVA) TOFILE(XDPTMVA) +       *  *S01129*/
/*                          MBROPT(*REPLACE) FMTOPT(*NONE)          *  *S01129*/
/*              MONMSG     (CPF2817) CMPDTA(CPF2869) +              *  *S01129*/
/*                          EXEC(CLRPFM XDPTMVA)                    *  *S01129*/
                CPYF     FROMFILE(DPTMVD) TOFILE(&TOLIB/XDPTMVD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM XDPTMVD)                        /*S01129*/
                CPYF     FROMFILE(DPTMVA) TOFILE(&TOLIB/XDPTMVA) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01129*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM XDPTMVA)                        /*S01129*/
 
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
                CPYF     FROMFILE(SEDPTRPD) TOFILE(&TOLIB/XSEDPTRPD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)                     /*CSE027*/
                MONMSG   (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM XSEDPTRPD)                                          /*CSE027*/
             ENDDO                                                                        /*CSE027*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                  CPYF       FROMFILE(DPTMVDX1) TOFILE(&TOLIB/XDPTMVDX1) +
                             MBROPT(*REPLACE) FMTOPT(*NONE) +
                             CRTFILE(*YES)                            /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XDPTMVDX1)                  /*095907*/
                  CPYF       FROMFILE(DPTMVDX2) TOFILE(&TOLIB/XDPTMVDX2) +
                             MBROPT(*REPLACE) FMTOPT(*NONE) +
                             CRTFILE(*YES)                            /*095907*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XDPTMVDX2)                  /*095907*/
                ENDDO                                                 /*095907*/
                                                                                          /*CSE027*/
/*/COPY WNCPYSRC,SEC1003008                                          */
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
/*/COPY WNCPYSRC,SEC1003023                                          */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1003024                                          */
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE2525)
/*/COPY WNCPYSRC,SEC1003025                                          */
 
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)                      /*095907*/
               IF COND(&S01401 *EQ 'Y') THEN(DO)                      /*095907*/
/**********      RGZPFM     FILE(DPTMVDX1)                  */        /*095907*/ /*228542*/
/**********      MONMSG MSGID(CPF0000)                      */        /*095907*/ /*228542*/
             CALL       PGM(SCC000060) PARM('DPTMVDX1' '*FIRST')                 /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********      RGZPFM     FILE(DPTMVDX2)                  */        /*095907*/ /*228542*/
/**********      MONMSG MSGID(CPF0000)                      */        /*095907*/ /*228542*/
             CALL       PGM(SCC000060) PARM('DPTMVDX2' '*FIRST')                 /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
               ENDDO                                                  /*095907*/
             ENDDO                                                    /*095907*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1003  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                */ /*S01513 086486*/
/****F*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(DPTMVA DPTMVD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1003026                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1003027                                          */
                  CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM DPTMVA)                      /*S01513*/
                  CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM DPTMVD)                      /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                    CPYF       FROMFILE(XDPTMVDX1) TOFILE(+
                               DPTMVDX1) MBROPT(*REPLACE) +
                               FMTOPT(*NONE)                          /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM DPTMVDX1)                  /*095907*/
                    CPYF       FROMFILE(XDPTMVDX2) TOFILE(+
                               DPTMVDX2) MBROPT(*REPLACE) +
                               FMTOPT(*NONE)                          /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM DPTMVDX2)                  /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1003028                                          */
                DLTF       FILE(XDPTMVD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XDPTMVA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                  DLTF       FILE(XDPTMVDX1)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                  DLTF       FILE(XDPTMVDX2)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1003014                                          */
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
                  STRJRNPF   FILE(DPTMVA DPTMVD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
                                                                                          /*CSE027*/
                IF         COND(&CSE027 = 'Y') THEN(DO)                                   /*CSE027*/
                  CPYF       FROMFILE(XSEDPTRPD) TOFILE(SEDPTRPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                               /*CSE027*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEDPTRPD)                                        /*CSE027*/
                DLTF       FILE(XSEDPTRPD)                                                /*CSE027*/
                   MONMSG MSGID(CPF0000)                                                  /*CSE027*/
                                                                                          /*CSE027*/
/* Start Journalling the Files */                                                         /*CSE027*/
                                                                                          /*CSE027*/
                  STRJRNPF   FILE(SEDPTRPD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               /*CSE027*/
             ENDDO                                                                        /*CSE027*/
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(DPTMVDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(DPTMVDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
                                                                                          /*CSE027*/
/*/COPY WNCPYSRC,SEC1003012                                          */
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
             ENDDO                                                    /*CCB009*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
               ENDDO                                                  /*095907*/
/*/COPY WNCPYSRC,SEC1003029                                          */
                ENDDO                                                 /*S01513*/
/*/COPY WNCPYSRC,SEC1003009                                          */
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1003  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                */ /*S01513 086486*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086846*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(DPTMVA DPTMVD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1003030                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1003031                                          */
                  CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM DPTMVA)                      /*S01513*/
                  CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM DPTMVD)                      /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                    CPYF       FROMFILE(XDPTMVDX1) TOFILE(+
                               DPTMVDX1) MBROPT(*REPLACE) +
                               FMTOPT(*NONE)                          /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM DPTMVDX1)                  /*095907*/
                    CPYF       FROMFILE(XDPTMVDX2) TOFILE(+
                               DPTMVDX2) MBROPT(*REPLACE) +
                               FMTOPT(*NONE)                          /*095907*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM DPTMVDX2)                  /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1003032                                          */
                DLTF       FILE(XDPTMVD)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
                DLTF       FILE(XDPTMVA)                              /*S01513*/
                   MONMSG MSGID(CPF0000)                              /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                 DLTF       FILE(XDPTMVDX1)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 DLTF       FILE(XDPTMVDX2)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 ENDDO                                                /*095907*/
/*/COPY WNCPYSRC,SEC1003015                                          */
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
                  STRJRNPF   FILE(DPTMVA DPTMVD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(DPTMVDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(DPTMVDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
             ENDDO                                                    /*CCB009*/
                                                                                          /*CSE027*/
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
                  CPYF       FROMFILE(XSEDPTRPD) TOFILE(SEDPTRPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                               /*CSE027*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEDPTRPD)                                        /*CSE027*/
                DLTF       FILE(XSEDPTRPD)                                                /*CSE027*/
                   MONMSG MSGID(CPF0000)                                                  /*CSE027*/
                                                                                          /*CSE027*/
                  STRJRNPF   FILE(SEDPTRPD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               /*CSE027*/
             ENDDO                                                                        /*CSE027*/
                                                                                          /*CSE027*/
/*/COPY WNCPYSRC,SEC1003013                                          */
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
                ENDDO                                                 /*S01513*/
/*/COPY WNCPYSRC,SEC1003010                                          */
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
/*/COPY WNCPYSRC,SEC1003033                                          */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
/*/COPY WNCPYSRC,SEC1003034                                          */
             ENDDO                                                    /*095907*/
 
/*        CLEAR FILES                                               */
/*                                                                  *  *S01129*/
/**********    CLRPFM     FILE(XDPTMVD)                                *095907*/
/*             CLRPFM     FILE(XDPTMVA)                             *  *S01129*/
/*/COPY WNCPYSRC,SEC1003016                                          */
/*                                                                  *  *S01129*/
/**DELETE*COPY FILES                                          *S01129* *095907*/
/**********                                                   *S01129* *095907*/
/**********     DLTF       FILE(XDPTMVA)                      *S01129* *095907*/
/**********        MONMSG MSGID(CPF0000)                      *S01129* *095907*/
/**********                                                            *095907*/
/***DROP*ASTERISKED RECORDS                                            *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(DPTMVD) TOFILE(XDPTMVD) +             *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869)                   *095907*/
/**********                                                            *095907*/
/**********                                                            *095907*/
/***COPY*BACK LIVE RECORDS                                             *095907*/
/**********                                                            *095907*/
/**********     CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)             *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                 *095907*/
/**********                 EXEC(CLRPFM DPTMVD)                        *095907*/
/*/COPY WNCPYSRC,SEC1003017                                          */
 
/***COPY*BACK LIVE RECORDS                                             *095907*/
/**********                                                            *095907*/
/**********     CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +          *095907*/
/**********                 MBROPT(*REPLACE) FMTOPT(*NONE)             *095907*/
/**********     MONMSG     (CPF2817) CMPDTA(CPF2869) +                 *095907*/
/**********                 EXEC(CLRPFM DPTMVD)                        *095907*/
/*/COPY WNCPYSRC,SEC1003018                                          */
 
/********  CLEAR WORK FILES                                         *  *S01129*/
/*                                                                  *  *S01129*/
/*             CLRPFM     FILE(XDPTMVD)                             *  *S01129*/
/*                                                                  *  *S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
/*/COPY WNCPYSRC,SEC1003035                                          */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                DLTF       FILE(XDPTMVD)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
/*/COPY WNCPYSRC,SEC1003019                                          */
                                                                      /*086486*/
/*           IF COND(&S01513 *EQ 'Y') THEN(DO)                *086486* *095907*/
/*/COPY WNCPYSRC,SEC1003036                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                   STRJRNPF   FILE(DPTMVD DPTMVA) JRN(ICJRN) +
                                OMTJRNE(*OPNCLO)                      /*086486*/
                   MONMSG     MSGID(CPF0000)                          /*095907*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1003037                                          */
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(DPTMVDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(DPTMVDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
                ENDDO                                                 /*086486*/
 
             IF         COND(&CSE027 *EQ 'Y') THEN(DO)                                    /*CSE027*/
               CLRPFM     FILE(XSEDPTRPD)                                                 /*CSE027*/
                                                                                          /*CSE027*/
/* Drop Asterisked Records */                                                             /*CSE027*/
                                                                                          /*CSE027*/
/**********  CPYF       FROMFILE(SEDPTRPD) TOFILE(XSEDPTRPD) +          */                /*CPK014*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) + */                /*CPK014*/
/**********               FMTOPT(*NONE)                                 */     /*CSE027*/ /*CPK014*/
             CPYF       FROMFILE(SEDPTRPD) TOFILE(XSEDPTRPD) +
                          MBROPT(*REPLACE) INCREL((*IF DTRECI *NE '*')) +
                          FMTOPT(*NONE)                                                   /*CPK014*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*CSE027*/
                                                                                          /*CSE027*/
/* Copy Back Live Records */                                                              /*CSE027*/
                                                                                          /*CSE027*/
                CPYF       FROMFILE(XSEDPTRPD) TOFILE(SEDPTRPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*CSE027*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM SEDPTRPD)                                         /*CSE027*/
                                                                                          /*CSE027*/
/* DELETE COPY FILES */                                                                   /*CSE027*/
                                                                                          /*CSE027*/
                DLTF       FILE(XSEDPTRPD)                                                /*CSE027*/
                   MONMSG MSGID(CPF0000)                                                  /*CSE027*/
                                                                                          /*CSE027*/
                IF COND(&S01513 *EQ 'Y') THEN(DO)                                         /*CSE027*/
                   STRJRNPF   FILE(SEDPTRPD) JRN(ICJRN) +
                                OMTJRNE(*OPNCLO)                                          /*CSE027*/
                ENDDO                                                                     /*CSE027*/
                                                                                          /*CSE027*/
         ENDDO                                                                            /*CSE027*/
                                                                                          /*CSE027*/
/*/COPY WNCPYSRC,SEC1003011                                          */
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
