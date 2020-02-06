/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off position settlements')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1005   DROP OFF POSITION SETTLEMENTS                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. 095907             Date 14Jun04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086486             DATE 21JUN95             */
/*                      S01408             DATE 11MAY95             */
/*                      S01513             DATE 10AUG94             */
/*                      S01117             DATE 10JAN91             */
/*                      S01189             DATE 10JAN91             */
/*                      E18447             DATE 25/05/88            */
/*                      S01179             DATE 16/09/88            */
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
/*              - REMOVE CALL OF SEU520, EXTENSION FILES ON POSETD  */
/*                ARE NOW DIRECTLY DROPPED (DELETED) IN SE2560      */
/*              - IF MT5XX FEATURE IS ON BACKUP EXTENSION FILES     */
/*              - MONITOR END JOURNALING                            */
/*       CCB009 - Journal files throughout close of business         */
/*       086486  -  Stop journalling of files for this process      */
/*       S01408  -  Addition of core hook SEC1005MPS                */
/*       S01513  -  SE drop runs separately from EOD.               */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01189  -  CLOSE OF BUSINESS IMPROVEMENTS PHASE 2          */
/*       E18447  -  POSETA AND POSETD ARE MULTIMEMBER FILES SO      */
/*                  (*ALL) REQUIRED.                                */
/*                  REPLACE CLRFM BY DLTF.                          */
/*       S01179  -  ABS RELEASE                                     */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01513*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
 
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*E16876*/
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                 /*E16876*/
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
             DCL        VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE('N')    /*095907*/
/*/COPY WNCPYSRC,SEC1005001                                          */
 
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
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)             /*E16876*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *E16876 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1005MPS                                          */
                                                                      /*S01408*/
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC1005  - Drop off +
                        Position Settlements')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON            */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
/** CHECK IF SWITCHABLE FEATURE S01401 IS SWITCHED ON                 /*095907*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*095907*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*095907*/
             CHGVAR     VAR(&SAR) VALUE('S01401')                     /*095907*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*095907*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01401) VALUE('Y'))                    /*095907*/
 
/*/COPY WNCPYSRC,SEC1005002                                          */
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
                                                                      /*086486*/
             IF         COND(&S01513 *EQ 'Y') THEN(DO)                /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(POSETD POSETA) JRN(ICJRN)             /*086486*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   IF COND(&S01401 *EQ 'Y') THEN(DO)                  /*095907*/
                   ENDJRNPF   FILE(POSETDX1) JRN(ICJRN)               /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   ENDJRNPF   FILE(POSETDX2) JRN(ICJRN)               /*095907*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
                   ENDDO                                              /*095907*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC1005013                                          */
             ENDDO                                                    /*086486*/
/*/COPY WNCPYSRC,SEC1005003                                          */
 
/*  CHECK FOR COMPONENT RESTART                                     */
 
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1005014                                          */
/************RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/*  IF RESTART, DISABLE ACCESS PATHS                                */
 
/************IF         COND(&BUSY = 'NEW') THEN(DO)                 * *S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
             OVRDBF     FILE(XPOSETD) MBR(POSETD) SEQONLY(*YES 100)
             OVRDBF     FILE(XPOSETA) MBR(POSETA) SEQONLY(*YES 100)
 
/*/COPY WNCPYSRC,SEC1005004                                          */
/*  AND COPY FILES                                                  */
 
/*                                                                    /*E18447*/
/*********** CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +            /*E18447*/
/***********              FROMMBR(POSETD) TOMBR(POSETD) +             /*E18447*/
/***********              MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18447*/
             CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE) /*E18774*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETD) MBR(POSETD))
/*                                                                    /*E18447*/
/*********** CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +            /*E18447*/
/***********              FROMMBR(POSETA) TOMBR(POSETA) +             /*E18447*/
/***********              MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18447*/
             CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE) /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(POSETA) MBR(POSETA))
/* If MT5XX IS active, do recovery processing */                      /*095907*/
/*/COPY WNCPYSRC,SEC1005005                                          */
 
/*  CHANGE DATA AREA TO 'OLD'                                      */
 
/***************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')         * *S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1005015                                          */
 
/*  ELSE BACKUP FILES                                               */
 
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
/*/COPY WNCPYSRC,SEC1005016                                          */
 
/*  OVERRIDE TO SEQONLY(*YES 100)                                   */
 
             OVRDBF     FILE(XPOSETD) MBR(POSETD) SEQONLY(*YES 100)
             OVRDBF     FILE(XPOSETA) MBR(POSETA) SEQONLY(*YES 100)
             OVRDBF     FILE(POSETD) MBR(POSETD) SEQONLY(*YES 100)
             OVRDBF     FILE(POSETA) MBR(POSETA) SEQONLY(*YES 100)
 
/*/COPY WNCPYSRC,SEC1005006                                          */
/*  AND COPY FILES                                                 */
 
/*                                                                    /*E18447*/
/**********  CPYF       FROMFILE(POSETD) TOFILE(XPOSETD) +            /*E18447*/
/**********               FROMMBR(POSETD) TOMBR(POSETD) +             /*E18447*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18447*/
             CPYF       FROMFILE(POSETD) TOFILE(&TOLIB/XPOSETD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETD) MBR(POSETD))
/*                                                                    /*E18447*/
/**********  CPYF       FROMFILE(POSETA) TOFILE(XPOSETA) +            /*E18447*/
/**********               FROMMBR(POSETA) TOMBR(POSETA) +             /*E18447*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)              /*E18447*/
             CPYF       FROMFILE(POSETA) TOFILE(&TOLIB/XPOSETA) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE) /*E18447*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPOSETA) MBR(POSETA))
 
/*/COPY WNCPYSRC,SEC1005007                                          */
             ENDDO
 
/*  CHANGE DATA AREA TO 'NEW'                                       */
 
/************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('NEW')            * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1005017                                          */
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
             ENDDO                                                    /*095907*/
/*/COPY WNCPYSRC,SEC1005018                                          */
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE2560)
/*/COPY WNCPYSRC,SEC1005019                                          */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1005  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                                                                      /*S01513*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(POSETA POSETD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1005020                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1005021                                          */
                  CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM POSETA)                      /*S01513*/
                  CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM POSETD)                      /*S01513*/
/*/COPY WNCPYSRC,SEC1005022                                          */
             DLTF       FILE(XPOSETD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XPOSETA)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                 DLTF       FILE(XPOSETDX1)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 DLTF       FILE(XPOSETDX2)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 ENDDO                                                /*095907*/
/*/COPY WNCPYSRC,SEC1005023                                          */
                                                                      /*S01513*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                  STRJRNPF   FILE(POSETA POSETD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(POSETDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(POSETDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1005011                                          */
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
               ENDDO                                                  /*095907*/
/*/COPY WNCPYSRC,SEC1005024                                          */
                ENDDO                                                 /*S01513*/
/*/COPY WNCPYSRC,SEC1005008                                          */
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1005  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                                                                      /*S01513*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(POSETA POSETD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
/*/COPY WNCPYSRC,SEC1005025                                          */
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1005026                                          */
                  CPYF       FROMFILE(XPOSETA) TOFILE(POSETA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM POSETA)                      /*S01513*/
                  CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM POSETD)                      /*S01513*/
/*/COPY WNCPYSRC,SEC1005027                                          */
             DLTF       FILE(XPOSETD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XPOSETA)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                  DLTF       FILE(XPOSETDX1)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                  DLTF       FILE(XPOSETDX2)                          /*095907*/
                     MONMSG MSGID(CPF0000)                            /*095907*/
                ENDDO                                                 /*095907*/
/*/COPY WNCPYSRC,SEC1005028                                          */
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
                  STRJRNPF   FILE(POSETA POSETD) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*S01513*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(POSETDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(POSETDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
/*/COPY WNCPYSRC,SEC1005012                                          */
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
                ENDDO                                                 /*S01513*/
/*/COPY WNCPYSRC,SEC1005009                                          */
                GOTO ENDPGM
             ENDDO
 
/*  IF U7 AND U8 OFF, CHANGE SESTAT TO "OLD"                       */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**************CHGDTAARA  DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*/COPY WNCPYSRC,SEC1005029                                          */
               CHGVAR     VAR(&BUSY) VALUE('N')                       /*S01189*/
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
               ENDDO                                                  /*095907*/
/*/COPY WNCPYSRC,SEC1005030                                          */
 
/*  CLEAR FILES                                                    */
 
/**********  CLRPFM     FILE(XPOSETD) MBR(POSETD)                      *095907*/
/**********  CLRPFM     FILE(XPOSETA) MBR(POSETA)                      *095907*/
/**********                                                            *095907*/
/***DROP*ASTERISKED RECORDS                                        *   *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(POSETD) TOFILE(XPOSETD) +             *095907*/
/**********               FROMMBR(POSETD) TOMBR(POSETD) +              *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 *095907*/
/**********                                                            *095907*/
/***COPY*BACK LIVE RECORDS                                         *   *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(XPOSETD) TOFILE(POSETD) +             *095907*/
/**********               FROMMBR(POSETD) TOMBR(POSETD) +              *095907*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)               *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *095907*/
/**********               FILE(POSETD) MBR(POSETD))                    *095907*/
/*/COPY WNCPYSRC,SEC1005031                                          */
 
/*  CLEAR WORK FILES                                               */
 
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
/*********** CLRPFM     FILE(XPOSETD) MBR(POSETD)                     /*E18447*/
             DLTF       FILE(XPOSETD)                                 /*E18447*/
                MONMSG MSGID(CPF0000)                                 /*E18447*/
             DLTF       FILE(XPOSETA)                                 /*E18447*/
                MONMSG MSGID(CPF0000)                                 /*E18447*/
             IF COND(&S01401 *EQ 'Y') THEN(DO)                        /*095907*/
                 DLTF       FILE(XPOSETDX1)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 DLTF       FILE(XPOSETDX2)                           /*095907*/
                 MONMSG MSGID(CPF0000)                                /*095907*/
                 ENDDO                                                /*095907*/
/*/COPY WNCPYSRC,SEC1005032                                          */
 
/**********  IF COND(&S01513 *EQ 'Y') THEN(DO)                *086486* *095907*/
/*/COPY WNCPYSRC,SEC1005033                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                STRJRNPF   FILE(POSETD POSETA) JRN(ICJRN) +
                             OMTJRNE(*OPNCLO)                         /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
                  IF         COND(&S01401 *EQ 'Y') THEN(DO)           /*095907*/
                    STRJRNPF   FILE(POSETDX1) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                    STRJRNPF   FILE(POSETDX2) JRN(ICJRN) +
                               IMAGES(*BOTH) OMTJRNE(*OPNCLO)         /*095907*/
                    MONMSG     MSGID(CPF0000)                         /*095907*/
                  ENDDO                                               /*095907*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*086486*/
/*/COPY WNCPYSRC,SEC1005010                                          */
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
