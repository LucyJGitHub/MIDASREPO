/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off position profit centres')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1006 -  DROP OFF POSITION PROFIT CENTRES                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. 095907             DATE 14JUN04              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086486             DATE 21JUN95              */
/*                      S01408             DATE 11MAY95              */
/*                      078484             DATE 10AUG94              */
/*                      S01513             DATE 10AUG94              */
/*                      S01117             DATE 05AUG94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       095907 - CHANGE SE DROP PROCEDURE IF S01513 IS ON :         */
/*                ----------------------------------------------     */
/*              - DO NOT PROCESS RESTART PROCEDURE AND COPY BACK OF  */
/*                FILES AS ALL FAILURES ARE NOW CONTROLED BY PGM     */
/*                SEC1000U                                           */
/*              - DO NOT CLEAR OR DELETE COPY FILES. ONLY DELETED BY */
/*                SEC1000U WHEN ALL DROP PROCESSING IS COMPLETED     */
/*                NORMALLY                                           */
/*              - REMOVE STRJRNPF AS DONE BY SEC1000U AFTER PGM      */
/*                FAILURE OR FULL COMPLETION OF SE DROP              */
/*                FOR ALL CASES (PGM'S SE25XX HAVE BEEN CHANGED)     */
/*                ----------------------------------------------     */
/*              - SUPPRESS DROP OF ASTERIX RECORDS AND COPY BACK OF  */
/*                LIVE RECORDS AS RECORDS TO BE DROPPED ARE PHYSIC.  */
/*                DELETED BY PROGRAMS SE25XX.                        */
/*              - MONITOR END JOURNALING                             */
/*       CCB009 - Journal files throughout close of business         */
/*       086486  -  Stop journalling of files for this process       */
/*       S01408  -  Addition of core hook SEC1006MPS                 */
/*       078484  -  File SEPCA must be copied to XSEPCA for          */
/*                  backup purposes.                                 */
/*       S01513  -  SE drop runs separately from EOD.                */
/*       S01117  -  Multibranching  (new program)                    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&CNAM &CSEQ)                             /*S01513*/
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
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
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1006MPS                                          */
                                                                      /*S01408*/
/* */
/** Setup and send program message                                 */
/* */
             CHGVAR     VAR(&MEM) VALUE('SEC1006  - Drop off +
                        Position Profit Centres')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/** CHECK IF SWITCHABLE FEATURE S01513 IS SWITCHED ON                 /*S01513*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01513*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01513*/
             CHGVAR     VAR(&SAR) VALUE('S01513')                     /*S01513*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01513*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))                    /*S01513*/
/* */
/** Clear switches                                                 */
/* */
             CHGJOB SWS(00000000)
                                                                      /*086486*/
             IF         COND(&S01513 *EQ 'Y') THEN(DO)                /*086486*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(SEPCBD SEPCCD SEPCA) JRN(ICJRN)       /*086486*/
             MONMSG     MSGID(CPF0000)                                /*095907*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*086486*/
/* */
/** Check for component restart                                    */
/* */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/* */
/** If restart, disable access paths                               */
/* */
             IF         COND(&BUSY = 'Y') THEN(DO)
/* */
/** Override to SEQONLY(*YES 100)                                  */
/* */
             OVRDBF     FILE(XSEPCBD) MBR(SEPCBD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEPCCD) MBR(SEPCCD) SEQONLY(*YES 100)
/* */
/** and copy files                                                 */
/* */
             CPYF       FROMFILE(XSEPCBD) TOFILE(SEPCBD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCBD) MBR(SEPCBD))
/* */
             CPYF       FROMFILE(XSEPCCD) TOFILE(SEPCCD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCCD) MBR(SEPCCD))
/* */
             CPYF       FROMFILE(XSEPCA) TOFILE(SEPCA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*078484*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEPCA))                                /*078484*/
/* */
/** Change &BUSY to 'N'                                            */
/* */
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/* */
             ENDDO
             ENDDO                                                    /*095907*/
/* */
/** Else backup files                                              */
/* */
/**********  ELSE       CMD(DO)                                       /*095907*/
             IF         COND(&BUSY *NE 'Y') THEN(DO)                  /*095907*/
/* */
/** Override to SEQONLY(*YES 100)                                  */
/* */
             OVRDBF     FILE(XSEPCBD) MBR(SEPCBD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEPCCD) MBR(SEPCCD) SEQONLY(*YES 100)
             OVRDBF     FILE(SEPCBD) MBR(SEPCBD) SEQONLY(*YES 100)
             OVRDBF     FILE(SEPCCD) MBR(SEPCCD) SEQONLY(*YES 100)
/* */
/** and copy files                                                 */
/* */
             CPYF       FROMFILE(SEPCBD) TOFILE(&TOLIB/XSEPCBD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSEPCBD) MBR(SEPCBD))
/* */
             CPYF       FROMFILE(SEPCCD) TOFILE(&TOLIB/XSEPCCD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSEPCCD) MBR(SEPCCD))
/* */
             CPYF       FROMFILE(SEPCA) TOFILE(&TOLIB/XSEPCA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*078484*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSEPCA))                               /*078484*/
/* */
             ENDDO
/* */
/** Change &BUSY to 'Y'                                            */
/* */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO                                                    /*095907*/
/* */
/** Call program                                                   */
/* */
             CALL       PGM(SE2590)
/* */
/** For database errors recover data from LDA                      */
/* */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC1006  - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                */ /*S01513 086486*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(SEPCBD SEPCCD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CPYF       FROMFILE(XSEPCBD) TOFILE(SEPCBD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCBD)                      /*S01513*/
                  CPYF       FROMFILE(XSEPCCD) TOFILE(SEPCCD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCCD)                      /*S01513*/
                  CPYF       FROMFILE(XSEPCA)  TOFILE(SEPCA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*078484*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCA)                       /*078484*/
             DLTF       FILE(XSEPCBD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XSEPCCD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XSEPCA)                                  /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
/***********      STRJRNPF   FILE(SEPCBD SEPCCD) JRN(ICJRN) +
/***********                 IMAGES(*BOTH) OMTJRNE(*OPNCLO) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  STRJRNPF   FILE(SEPCBD SEPCCD SEPCA) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
               ENDDO                                                  /*095907*/
                ENDDO                                                 /*S01513*/
                GOTO ENDPGM
             ENDDO
/* */
/** For file controls out of balance error                         */
/* */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC1006  - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
/***********                                                */ /*S01513 086486*/
/***IF*CORE*FEATURE*S01513*IS*SWITCHED*ON,*END*JOURNAL*THE*F*/ /*S01513 086486*/
/***********                                                */ /*S01513 086486*/
/***********    IF         COND(&S01513 = 'Y') THEN(DO)     */ /*S01513 086486*/
/***********      ENDJRNPF   FILE(SEPCBD SEPCCD) JRN(ICJRN) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                                                                      /*S01513*/
/** COPY THE BACKUP FILES                                        */   /*S01513*/
                                                                      /*S01513*/
/**********     IF         COND(&S01513 = 'Y') THEN(DO)      *086486*  *095907*/
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
                  CPYF       FROMFILE(XSEPCBD) TOFILE(SEPCBD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCBD)                      /*S01513*/
                  CPYF       FROMFILE(XSEPCCD) TOFILE(SEPCCD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*S01513*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCCD)                      /*S01513*/
                  CPYF       FROMFILE(XSEPCA)  TOFILE(SEPCA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)           /*078484*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                             EXEC(CLRPFM SEPCA)                       /*078484*/
             DLTF       FILE(XSEPCBD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XSEPCCD)                                 /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
             DLTF       FILE(XSEPCA)                                  /*S01513*/
                MONMSG MSGID(CPF0000)                                 /*S01513*/
                                                                      /*S01513*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/** START JOURNALLING THE FILES                                  */   /*S01513*/
                                                                      /*S01513*/
/***********      STRJRNPF   FILE(SEPCBD SEPCCD) JRN(ICJRN) +
/***********                 IMAGES(*BOTH) OMTJRNE(*OPNCLO) */ /*S01513 086486*/
/***********      MONMSG     MSGID(CPF0000 MCH0000)         */ /*S01513 086486*/
                  STRJRNPF   FILE(SEPCBD SEPCCD SEPCA) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*086486*/
                  MONMSG     MSGID(CPF0000)                           /*095907*/
             ENDDO                                                    /*CCB009*/
                  CHGVAR     VAR(&BUSY) VALUE('N')                    /*S01513*/
                  CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)           /*S01513*/
                ENDDO                                                 /*S01513*/
                GOTO ENDPGM
             ENDDO
/* */
/** If no errors                                                   */
/* */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
               CHGVAR     VAR(&BUSY) VALUE('N')
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
               ENDDO                                                  /*095907*/
/* */
/** Clear files                                                    */
/* */
/**********  CLRPFM     FILE(XSEPCBD) MBR(SEPCBD)                      *095907*/
/**********  CLRPFM     FILE(XSEPCCD) MBR(SEPCCD)                      *095907*/
/**********                                                            *095907*/
/***Drop*asterisked records                                        *   *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(SEPCBD) TOFILE(XSEPCBD) +             *095907*/
/**********               FROMMBR(SEPCBD) TOMBR(SEPCBD) +              *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(SEPCCD) TOFILE(XSEPCCD) +             *095907*/
/**********               FROMMBR(SEPCCD) TOMBR(SEPCCD) +              *095907*/
/**********               MBROPT(*REPLACE) INCREL((*IF RECI *NE '*')) +*095907*/
/**********               FMTOPT(*NONE)                                *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                 *095907*/
/**********                                                            *095907*/
/***Copy*back live records                                         *   *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(XSEPCBD) TOFILE(SEPCBD) +             *095907*/
/**********               FROMMBR(SEPCBD) TOMBR(SEPCBD) +              *095907*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)               *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *095907*/
/**********               FILE(SEPCBD) MBR(SEPCBD))                    *095907*/
/**********                                                            *095907*/
/**********  CPYF       FROMFILE(XSEPCCD) TOFILE(SEPCCD) +             *095907*/
/**********               FROMMBR(SEPCCD) TOMBR(SEPCCD) +              *095907*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)               *095907*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *095907*/
/**********               FILE(SEPCCD) MBR(SEPCCD))                    *095907*/
/* */
/** Clear work files                                               */
/* */
             IF COND(&S01513 *NE 'Y') THEN(DO)                        /*095907*/
             DLTF       FILE(XSEPCBD)
                MONMSG MSGID(CPF0000)
             DLTF       FILE(XSEPCCD)
                MONMSG MSGID(CPF0000)
             DLTF       FILE(XSEPCA)                                  /*078484*/
                MONMSG MSGID(CPF0000)                                 /*078484*/
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                STRJRNPF   FILE(SEPCBD SEPCCD SEPCA) JRN(ICJRN) +
                             IMAGES(*BOTH) OMTJRNE(*OPNCLO)           /*086486*/
                MONMSG     MSGID(CPF0000)                             /*095907*/
             ENDDO                                                    /*CCB009*/
/* */
             ENDDO                                                    /*095907*/
             ENDDO
/* */
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
