/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Performance Monthly Housekeeping')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1800 - Performance Monthly Housekeeping                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 111396             Date 14NOV96              */
/*       PREV AMEND NO. CPM005             Date 17Jul96              */
/*                      109564             DATE 01NOV96              */
/*                      075998             Date 20Dec95              */
/*                      S01408             Date 11May95              */
/*                      053103             DATE 24NOV94              */
/*                      S01486             DATE 11AUG94              */
/*                      038430             DATE 23AUG93              */
/*                      057020             DATE 16JUN93              */
/*                      056460             DATE 08JUN93              */
/*                      056986             DATE 04MAY93              */
/*                      049421             DATE 18JAN93              */
/*                      47890              DATE 28NOV92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       111396 - Restart processing not working as check date was   */
/*                updated before any changes. Moved update of date   */
/*                of last run to end of program.                     */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET / LIABILITY SPLIT        */
/*                PBFG/6 - ADDITIONAL CUSTOMER DETAILS               */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       109564 - Correct OPNQRYF for PMPSTMQ0                       */
/*       075998 - Portfolio/Future & Options performance             */
/*       S01408 - Addition of core hook PMC1800MP1                   */
/*       053103  -  Performance Reconciliation Enhancements          */
/*       S01486  -  Portfolio Management Upgrade to Release 10.      */
/*       038430  -  ENHANCEMENTS TO PORTFOLIO CUSTOMER INSERTION /   */
/*                  DELETION PROCESSING                              */
/*       057020  -  RECOMPILED FOR CHANGE TO FILES                   */
/*       056460  -  CALL PGM/PM1810 TO EXTRACT START OF MONTH        */
/*                  POSITIONS FOR POOL PORTFOLIOS                    */
/*       056986  -  AMENDED FOR PERFORMANCE IMPLEMENTATION           */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       47890   -  ADD COB PROCESSING                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/* >>> 47890 >>> */
 /***        PGM                                                     */
/************PGM        PARM(&CNAM &CSEQ)                          */ /*S01486*/
             PGM                                                      /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)             */ /*S01486*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)               */ /*S01486*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)              */ /*S01486*/
/* <<< 47890 <<< */
 
             DCL        VAR(&DARUN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DAPFMH) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WWSTMN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WWSTPP) TYPE(*CHAR) LEN(5)
/*********** DCL        VAR(&WWSTPD) TYPE(*DEC) LEN(5 0)           */ /*S01486*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(6)             */ /*S01486*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(7)                /*S01486*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/*********** DCL        VAR(&WWPAR1) TYPE(*CHAR) LEN(110)          */ /*S01486*/
             DCL        VAR(&WWPAR1) TYPE(*CHAR) LEN(111)             /*S01486*/
/************DCL********VAR(&WWPARM) TYPE(*CHAR) LEN(128)             /*075998*/
             DCL        VAR(&WWMLEN) TYPE(*DEC) LEN(15 5)
             DCL        VAR(&WWPPRC) TYPE(*CHAR) LEN(1) VALUE('N')
/*********** DCL        VAR(&WWPPRQ) TYPE(*CHAR) LEN(1)     */ /*056460 S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)               /*056460 */
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)                /*075998*/
             DCL        VAR(&WWPPR1) TYPE(*CHAR) LEN(3)               /*075998*/
             DCL        VAR(&WWSTM1) TYPE(*CHAR) LEN(4)               /*075998*/
             DCLF       FILE(SDMMODPD) RCDFMT(SDMMODD0)               /*075998*/
 
RCVF       DEV(*FILE) RCDFMT(SDMMODD0)                                /*075998*/
 
/*  RESET JOB SWITCHES  */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1800 - Performance Monthly House+
                          keeping') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CHECK WHETHER END OF MONTH HOUSEKEEPING NEEDS TO BE DONE */
 
             RTVDTAARA  DTAARA(PMSTAT (6 5)) RTNVAR(&DARUN)
/*           RTVDTAARA  DTAARA(PMSTAT (34 5)) RTNVAR(&DAPFMH)     056986 */
             RTVDTAARA  DTAARA(PMSTAT (36 5)) RTNVAR(&DAPFMH)  /* 056986 */
/***********RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&WWPPRQ)*/ /*056460 S01486*/
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)           /*075998*/
 
/* IF DATE OF PERFORMANCE HOUSEKEEPING *EQ RUN DATE (IE HOUSEKEEPING +
   ALREADY PERFORMED) END PROGRAM) */
 
             IF         COND(&DARUN *EQ &DAPFMH) THEN(GOTO +
                          CMDLBL(ENDPGM))
/* >>> 47890 >>> */
/***********       CHGVAR     VAR(&BUSY) VALUE('Y')                */ /*S01486*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01486*/
/* <<< 47890 <<< */
 
/**UPDATE*DTAARA/PMSTAT*WITH*DATE*HOUSEKEEPING*LAST*RUN*************** *111396*/
/*           CHGDTAARA  DTAARA(PMSTAT (34 5)) VALUE(&DARUN)       056986 */
/*********** CHGDTAARA  DTAARA(PMSTAT (36 5)) VALUE(&DARUN)   *056986* *111396*/
 
/* UPDATE DTAARA/PMSTAT WITH DATE HOUSEKEEPING LAST RUN */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1800MP1                                          */
                                                                      /*S01408*/
 
/* CALL PROGRAM PM1800 TO DETERMINE DATE PARAMETERS */
             CALL       PGM(PM1800) PARM(&WWSTMN &WWSTPP)
/**/                                                                  /*S01486*/
/** Process data base error */                                        /*S01486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01486*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM                                              /*S01486*/
             ENDDO                                                    /*S01486*/
 
/* SAVE RECORDS REQUIRED FROM PMPTRAPP AND PMPCAAPP TO BACKUP FILES */
/* USING PGM/QCMDEXC */
/*********** CHGVAR   VAR(&WWPAR1) VALUE('CPYF FROMFILE(PMPTRAPP) +*/ /*S01486*/
/***********              TOFILE(' *CAT &TOLIB *CAT '/XPMPTRAPP) + */ /*S01486*/
/***********              MBROPT(*REPLACE) CRTFILE(*YES) +         */ /*S01486*/
/***********              INCREL((*IF QUPDAT *GE ' *CAT &WWSTPP +  */ /*S01486*/
/***********              *CAT '))')                               */ /*S01486*/
             CHGVAR     VAR(&WWPAR1) VALUE('CPYF FROMFILE(PMPTRAPD) +
                          TOFILE(' *CAT &TOLIB *CAT '/XPMPTRAPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF QUPDAT *GE ' *CAT &WWSTPP +
                          *CAT '))')                                  /*S01486*/
/*********** CHGVAR     VAR(&WWMLEN) VALUE(110)                    */ /*S01486*/
             CHGVAR     VAR(&WWMLEN) VALUE(111)                       /*S01486*/
 
             CALL       PGM(QCMDEXC) PARM(&WWPAR1 &WWMLEN)
 
/*********** CHGVAR   VAR(&WWPAR1) VALUE('CPYF FROMFILE(PMPCAAPP) +*/ /*S01486*/
/***********              TOFILE(' *CAT &TOLIB *CAT '/XPMPCAAPP) + */ /*S01486*/
/***********              MBROPT(*REPLACE) CRTFILE(*YES) +         */ /*S01486*/
/***********              INCREL((*IF QSCSHD *GE ' *CAT &WWSTPP +  */ /*S01486*/
/***********              *CAT '))')                               */ /*S01486*/
             CHGVAR     VAR(&WWPAR1) VALUE('CPYF FROMFILE(PMPCAAPD) +
                          TOFILE(' *CAT &TOLIB *CAT '/XPMPCAAPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF QSCSHD *GE ' *CAT &WWSTPP +
                          *CAT '))')                                  /*S01486*/
/*********** CHGVAR     VAR(&WWMLEN) VALUE(110)                    */ /*S01486*/
             CHGVAR     VAR(&WWMLEN) VALUE(111)                       /*S01486*/
 
             CALL       PGM(QCMDEXC) PARM(&WWPAR1 &WWMLEN)
 
/* REMOVE LOGICAL FILE MEMBERS */
             RMVM       FILE(PMPTRALL) MBR(PMPTRALL)
             RMVM       FILE(PMPTRAL1) MBR(PMPTRAL1)
             RMVM       FILE(PMPTRAL2) MBR(PMPTRAL2)         /*53103 */
             RMVM       FILE(PMPTRAL3) MBR(PMPTRAL3)         /*53103 */
             RMVM       FILE(PMPTRAL4) MBR(PMPTRAL4)         /*53103 */
             RMVM       FILE(PMPTRAL5) MBR(PMPTRAL5)         /*53103 */
             RMVM       FILE(PMPTRAL6) MBR(PMPTRAL6)         /*53103 */
             RMVM       FILE(PMPTRAL7) MBR(PMPTRAL7)         /*53103 */
             RMVM       FILE(PMPTRAL8) MBR(PMPTRAL8)                  /*075998*/
             RMVM       FILE(PMPTRAL9) MBR(PMPTRAL9)                  /*075998*/
             RMVM       FILE(PMPCPTLL) MBR(PMPCPTLL)         /*53103 */
             RMVM       FILE(PMPEVTLL) MBR(PMPEVTLL)         /*53103 */
 
             RMVM       FILE(PMPCAALL) MBR(PMPCAALL)
             RMVM       FILE(PMPCAAL1) MBR(PMPCAAL1)
             RMVM       FILE(PMPCAAL2) MBR(PMPCAAL2)         /*53103 */
             RMVM       FILE(PMPCAAL3) MBR(PMPCAAL3)         /*53103 */
             RMVM       FILE(PMPCAAL4) MBR(PMPCAAL4)         /*53103 */
             RMVM       FILE(PMPCAAL5) MBR(PMPCAAL5)         /*53103 */
             RMVM       FILE(PMPCAAL6) MBR(PMPCAAL6)         /*53103 */
             RMVM       FILE(PMPCAAL7) MBR(PMPCAAL7)                  /*CPM005*/
/**/
/* COPY RECORDS BACK INTO PERFROMANCE EVENT FILES                    */
/*********** CPYF       FROMFILE(XPMPTRAPP) TOFILE(PMPTRAPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE)                         */ /*S01486*/
             CPYF       FROMFILE(XPMPTRAPD) TOFILE(PMPTRAPD) +
                          MBROPT(*REPLACE)                            /*S01486*/
             MONMSG     MSGID(CPF2817)
 
/*********** CPYF       FROMFILE(XPMPCAAPP) TOFILE(PMPCAAPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE)                         */ /*S01486*/
             CPYF       FROMFILE(XPMPCAAPD) TOFILE(PMPCAAPD) +
                          MBROPT(*REPLACE)                            /*S01486*/
             MONMSG     MSGID(CPF2817)
 
/* RESTORE LOGICAL FILE MEMBERS */
/*********** ADDLFM     FILE(PMPTRALL) MBR(PMPTRALL)                  /*53103*/
/*********** ADDLFM     FILE(PMPTRAL1) MBR(PMPTRAL1)                  /*53103*/
 
/*********** ADDLFM     FILE(PMPCAALL) MBR(PMPCAALL)                  /*53103*/
/*********** ADDLFM     FILE(PMPCAAL1) MBR(PMPCAAL1)                  /*53103*/
             ADDLFM     FILE(PMPTRALL) MBR(PMPTRALL) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL1) MBR(PMPTRAL1) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL2) MBR(PMPTRAL2) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL3) MBR(PMPTRAL3) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL4) MBR(PMPTRAL4) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL5) MBR(PMPTRAL5) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL6) MBR(PMPTRAL6) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL7) MBR(PMPTRAL7) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*53103 */
             ADDLFM     FILE(PMPTRAL8) MBR(PMPTRAL8) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*075998*/
             ADDLFM     FILE(PMPTRAL9) MBR(PMPTRAL9) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)))              /*075998*/
             ADDLFM     FILE(PMPCPTLL) MBR(PMPCPTLL) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)) (PMPCAAPD +
                          (PMPCAAPD)))                                /*53103 */
             ADDLFM     FILE(PMPEVTLL) MBR(PMPEVTLL) +
                          DTAMBRS((PMPTRAPD (PMPTRAPD)) (PMPCAAPD +
                          (PMPCAAPD)))                                /*53103 */
 
             ADDLFM     FILE(PMPCAALL) MBR(PMPCAALL) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL1) MBR(PMPCAAL1) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL2) MBR(PMPCAAL2) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL3) MBR(PMPCAAL3) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL4) MBR(PMPCAAL4) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL5) MBR(PMPCAAL5) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL6) MBR(PMPCAAL6) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*53103 */
             ADDLFM     FILE(PMPCAAL7) MBR(PMPCAAL7) +
                          DTAMBRS((PMPCAAPD (PMPCAAPD)))              /*CPM005*/
 
/* DELETE BACKUP FILES */
/*********** DLTF       FILE(XPMPTRAPP)                            */ /*S01486*/
/*********** DLTF       FILE(XPMPCAAPP)                            */ /*S01486*/
             DLTF       FILE(XPMPTRAPD)                               /*S01486*/
             DLTF       FILE(XPMPCAAPD)                               /*S01486*/
 
/**SAVE*RECORDS*REQUIRED*FROM*PMPSTMPP******************************/ /*S01486*/
/*********** CPYF     FROMFILE(PMPSTMPP) TOFILE(&TOLIB/XPMPSTMPP) +*/ /*S01486*/
/***********              MBROPT(*REPLACE) CRTFILE(*YES) +         */ /*S01486*/
/***********              INCREL((*IF QFSTMN *NE &WWSTMN))         */ /*S01486*/
/* SAVE RECORDS REQUIRED FROM PMPSTMQ0 */                             /*S01486*/
             CPYF       FROMFILE(PMPSTMQ0) TOFILE(&TOLIB/XPMPSTMQ0) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF QFSTMN *NE &WWSTMN))            /*S01486*/
             MONMSG     MSGID(CPF2817)
 
/* COPY RECORDS BACK INTO START OF MONTH HISTORY FILES               */
/*********** CPYF       FROMFILE(XPMPSTMPP) TOFILE(PMPSTMPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE)                         */ /*S01486*/
             CPYF       FROMFILE(XPMPSTMQ0) TOFILE(PMPSTMQ0) +
                          MBROPT(*REPLACE)                            /*S01486*/
             MONMSG     MSGID(CPF2817)
 
/*********** DLTF       FILE(XPMPSTMPP)                            */ /*S01486*/
             DLTF       FILE(XPMPSTMQ0)                               /*S01486*/
 
/* SET UP START OF MONTH FILE DETAILS */
/*********** OVRDBF     FILE(PMPSTMPP) SEQONLY(*YES 100)           */ /*S01486*/
/*********** CHGVAR     VAR(&WWPARM) VALUE('OPNQRYF    +           */ /*S01486*/
/***********              FILE((PMHOLDPP)) FORMAT(PMPSTMPP) +      */ /*S01486*/
/***********              QRYSLT(''QFPFMR *EQ "Y" *AND QFHLDV *EQ +*/ /*S01486*/
/***********              "Y"'') MAPFLD((QFSTMN ''"' *CAT &WWSTMN +*/ /*S01486*/
/***********            *CAT '"'') (QFPPRC ''"' *CAT &WWPPRC *CAT +*/ /*S01486*/
/***********              '"''))')                                 */ /*S01486*/
             OVRDBF     FILE(PMPSTMQ0) SEQONLY(*YES 100)              /*S01486*/
/**********  CHGVAR     VAR(&WWPARM) VALUE('OPNQRYF    +               *075998*/
/**********               FILE((PMHOLDPD)) FORMAT(PMPSTMQ0) +          *075998*/
/**********               QRYSLT(''QFPFMR *EQ "Y" *AND QFHLDV *EQ +    *075998*/
/**********               "Y"'') MAPFLD((QFSTMN ''"' *CAT &WWSTMN +    *075998*/
/**********               *CAT '"'') (QFPPRC ''"' *CAT &WWPPRC *CAT +  *075998*/
/**********               '"''))')                            *S01486* *075998*/
/*********** CHGVAR     VAR(&WWMLEN) VALUE(128)                        *075998*/
/*********** CALL       PGM(QCMDEXC) PARM(&WWPARM &WWMLEN)             *075998*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDPP) TOFILE(PMPSTMPP) +     */ /*S01486*/
/***********              MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
/*********** CLOF       OPNID(PMHOLDPP)                            */ /*S01486*/
             CHGVAR     VAR(&WWSTM1) VALUE('"' *CAT &WWSTMN *CAT '"') /*075998*/
             CHGVAR     VAR(&WWPPR1) VALUE('"' *CAT &WWPPRC *CAT '"') /*075998*/
/************                                                         /*109564*/
/************OPNQRYF    FILE((PMHOLDPD)) FORMAT(PMPSTMPD) +           /*109564*/
/************             QRYSLT('QFPFMR *EQ "Y" *AND QFHLDV *EQ +    /*109564*/
/************             "Y"') MAPFLD((QFSTMN &WWSTM1) (QFPPRC +     /*109564*/
/************             &WWPPR1) (QFTKDM '0') (QFMNPF '0') +        /*109564*/
/************             (QFTKVL '0') (QFFPSI +                      /*109564*/
/************             '"                    "'))         /*075998/*109564*/
             OPNQRYF    FILE((PMHOLDPD)) FORMAT(PMPSTMQ0) +
                          QRYSLT('QFPFMR *EQ "Y" *AND QFHLDV *EQ +
                          "Y"') MAPFLD((QFSTMN &WWSTM1) (QFPPRC +
                          &WWPPR1) (QFTKDM '0') (QFMNPF '0') +
                          (QFTKVL '0') (QFFPSI +
                          '"                    "'))                  /*109564*/
             CPYFRMQRYF FROMOPNID(PMHOLDPD) TOFILE(PMPSTMQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
             CLOF       OPNID(PMHOLDPD)                               /*S01486*/
 
/*IF*POOL*PORTFOLIO*PROCESSING*SUPPORTED*CALL*PGM**PM1810*TO*EXTRAC*/ /*S01486*/
/**STARTING*POSITIONS*FOR*POOL*PORTFOLIOS***************************/ /*S01486*/
/**/                                                                  /*S01486*/
/** Call PM1810 to extract starting positions for pool portfolios  */ /*S01486*/
/**/                                                                  /*S01486*/
/*********** IF         COND(&WWPPRQ *EQ 'Y') THEN(DO)      */ /*056460 S01486*/
 
             OVRDBF     FILE(SDPLCSPD) SHARE(*YES)                   /*056460*/
             OPNQRYF    FILE((SDPLCSPD)) QRYSLT('QBPPCS *EQ "Y" *AND +
                          QBRECI *EQ "D"')                           /*056460*/
 
             CALL       PGM(PM1810) PARM(&WWSTMN)                     /*056460*/
 
             CLOF       OPNID(SDPLCSPD)                               /*056460*/
             DLTOVR     FILE(*ALL)
 
/* PROCESS DATA BASE ERROR */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*056460*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*056460*/
/***********SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)           */ /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM                                              /*056460*/
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*056460*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*056460*/
/***********SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)              /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM                                              /*056460*/
             ENDDO                                                    /*056460*/
/*********** ENDDO                                          */ /*056460 S01486*/
/** IF FUTURE & OPTIONS MODULE PRESENT                                /*075998*/
             IF         COND(&BGFUOP = 'Y') THEN(DO)                  /*075998*/
                                                                      /*075998*/
             CPYF       FROMFILE(&TOLIB/PMFOPSPD) TOFILE(QTEMP/PMFOPSPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*075998*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMFOPSPD))    /*075998*/
                                                                      /*075998*/
             OVRDBF     FILE(PMPORTPD) SHARE(*YES)                    /*075998*/
             OPNQRYF    FILE((PMPORTPD)) OPTION(*ALL) QRYSLT('PNRECI +
                          *EQ "D" *AND *MAPFLD/PSD1 *LE "' *CAT +
                          &DAECD *CAT '"') MAPFLD((PSDT PNPSDT +
                          *ZONED 5) (PSD1 PSDT *CHAR 5)) +
                          IGNDECERR(*YES)                             /*075998*/
                                                                      /*075998*/
/* EXTRACT FF POSITIONS */                                            /*075998*/
             CALL       PGM(PM1820) PARM(&WWSTMN)                     /*075998*/
                                                                      /*075998*/
             CLOF       OPNID(PMPORTPD)                               /*075998*/
             DLTOVR     FILE(*ALL)                                    /*075998*/
                                                                      /*075998*/
/* PROCESS DATA BASE ERROR */                                         /*075998*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*075998*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*075998*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*075998*/
             GOTO ENDPGM                                              /*075998*/
             ENDDO                                                    /*075998*/
                                                                      /*075998*/
          ENDDO                                                       /*075998*/
 
/* CALL PROGRAM TO DROP CUSTOMER DETAILS SAVED BEFORE RETENTION DATE */
             CALL       PGM(PM1005)                          /*038430 */
 
/* PROCESS DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*038430*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*038430*/
/***********SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)              /*038430 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM                                              /*038430*/
             ENDDO
 
/* >>> 47890 >>> */
/***********       CHGVAR     VAR(&BUSY) VALUE('N')                */ /*S01486*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01486*/
/* <<< 47890 <<< */
 
/* UPDATE DTAARA/PMSTAT WITH DATE HOUSEKEEPING LAST RUN              * *111396*/
             CHGDTAARA  DTAARA(PMSTAT (36 5)) VALUE(&DARUN)           /*111396*/
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
