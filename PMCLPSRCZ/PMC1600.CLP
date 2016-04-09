/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control Calc. of Performance Statistics')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1600 - Control Calculation of Performance Statistics     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 18JUL96              */
/*       Prev Amend No. 097389             DATE 02JUL96              */
/*                      075998             DATE 20DEC95              */
/*                      CPM004             DATE 07FEB96              */
/*                      S01408             DATE 05MAY95              */
/*                      085855             DATE 14MAR95              */
/*                      081569             DATE 12JAN95              */
/*                      053103             DATE 24NOV94              */
/*                      S01486             DATE 11AUG94              */
/*                      056460             DATE 11JUN93              */
/*                      056986             DATE 13MAY93              */
/*                      049421             DATE 18JAN93              */
/*                      46921              DATE 11NOV92              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/1 - CHANGE PM CUSTOMER/PORTF BASE CCY         */
/*                PBFG/3 - DISPLAY OF UNREALISED P&L FORWARD SE TRADE*/
/*                PBFG/5 - INSTRUMENT ASSET / LIABILITY SPLIT        */
/*                PBFG/6 - ADDITIONAL CUSTOMER DETAILS               */
/*       097389 - PM1625 must be called the second time with 'M'     */
/*       075998 - Portfolio/Future & Options performance             */
/*       CPM004 - Bank Portfolios                                    */
/*       S01408 - Addition of core hook PMC1600MP1                   */
/*       085855 - UPGRADE ERROR                                      */
/*       053103 - Performance Reconciliation Enhancement             */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       056460 - CALL ADDITIONAL PROGRAM TO EXTRACT POOL POSITION   */
/*       056986 - PERFORMANCE IMPLEMENTATION                         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       46921  - EXTRA PROCESSING FOR LOANS & DEPOSITS INSERTED     */
/*                 AND DELETED DURING CURRENT PERFORMANCE PERIOD     */
/*       S01313 - PROGRAM WRITTEN FOR PORTFOLIO PERFORMANCE          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01486*/
             PGM        PARM(&RSEQ)                                   /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&WWPARQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWPOOL) TYPE(*CHAR) LEN(1)      /*056460 */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)             /*CPM005*/
 /* ACCESS SDPORTPD FOR TRADE/VALUE DATE POSITIONS INDICATOR */       /*53103*/
             DCLF       FILE(SDPORTPD)                                /*53103 */
             RCVF       RCDFMT(SDPORTD0)                              /*53103 */
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1600 - Portfolio Position for +
                          Performance Analysis') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**********  CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1600MP1                                          */
                                                                      /*S01408*/
 
/**CALL*PMC1610*TO*SET*UP*FILES*PMPFMRPP*PMFPPSPP*******************/ /*S01486*/
/* CALL PMC1610 TO SET UP FILES PMPFMRPD PMFPPSQ0 */                  /*S01486*/
             CALL       PGM(PMC1610)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/**********  SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**COPY*EMPTY*FILES*TO LIB/QTEMP */                                   /*CPM004*/
/**********  CPYF       FROMFILE(&FMLIB/PMPMIMPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMPMIMPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMPMIMPD) +                   /*CPM004*/
/**********               TOFILE(QTEMP/PMPMIMPD) MBROPT(*REPLACE) +   /*CPM004*/
/**********               CRTFILE(*YES)                       S01486  /*CPM004*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPMIMPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPMIMS01486  /*CPM004*/
/**********                                                           /*CPM004*/
/**********  CPYF       FROMFILE(&FMLIB/PMPIMTPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMPIMTPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMPIMTPD) +                   /*CPM004*/
/**********               TOFILE(QTEMP/PMPIMTPD) MBROPT(*REPLACE) +   /*CPM004*/
/**********               CRTFILE(*YES)                       S01486  /*CPM004*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPIMTPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPIMTS01486  /*CPM004*/
/**********                                                           /*CPM004*/
/**********  CPYF       FROMFILE(&FMLIB/PMPSTCPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMPSTCPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMPSTCPD) +                   /*CPM004*/
/**********               TOFILE(QTEMP/PMPSTCPD) MBROPT(*REPLACE) +   /*CPM004*/
/**********               CRTFILE(*YES)                       S01486  /*CPM004*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCS01486  /*CPM004*/
/* */                                                                 /*CPM004*/
/* CLEAR WORKFILES */                                                 /*CPM004*/
/* */                                                                 /*CPM004*/
             CLRPFM     FILE(PMPMIMPD)                                /*CPM004*/
             CLRPFM     FILE(PMPIMTPD)                                /*CPM004*/
             CLRPFM     FILE(PMPSTCPD)                                /*CPM004*/
             CLRPFM     FILE(PMFOPSPD)                                /*075998*/
 
/**CALL*PM1620*TO*WRITE*CURRENT*POSITIONS*TO*PMPMIMPP***************/ /*S01486*/
/* CALL PM1620 TO WRITE CURRENT POSITIONS TO PMPMIMPD */              /*S01486*/
/*           CALL       PGM(PM1620)                            056460 */
/*********** CALL       PGM(PM1620) PARM(&WWPOOL)            /*056460  081569*/
 
/* PROCESS ANY DATA BASE ERROR */
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                081569*/
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)           081569*/
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              /*S01486 081569*/
/*********** GOTO       CMDLBL(ABNOR)                                   081569*/
/*********** ENDDO                                                      081569*/
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
/*********** IF         COND(%SWITCH(XXXXXX01)) THEN(DO)                081569*/
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)           081569*/
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/************** SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              /*S01486 081569*/
/*********** GOTO       CMDLBL(ABNOR)                                   081569*/
/*********** ENDDO                                                      081569*/
 /*053103>>*/
/*********** IF         COND(&FCTVPS *EQ 'T') THEN(DO)          /*53103 CPM005*/
             OVRDBF     FILE(PMHDVNLL) TOFILE(PMHOLDL4) SHARE(*NO) /*53103 */
/*********** ENDDO                                              /*53103 CPM005*/
 
/*********** IF         COND(&FCTVPS *EQ 'V') THEN(DO)          /*53103 CPM005*/
/*********** OVRDBF  FILE(PMHDVNLL) TOFILE(PMHOLDL5) SHARE(*NO) /*53103 CPM005*/
/*********** ENDDO                                              /*53103 CPM005*/
             CALL       PGM(PM1620) PARM(&WWPOOL 'L')              /*53103 */
/* PROCESS ANY DATA BASE ERROR */                                  /*53103*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           /*53103*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      /*53103*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  /*53103*/
             GOTO       CMDLBL(ABNOR)                              /*53103*/
             ENDDO                                                 /*53103*/
                                                                   /*53103*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */         /*53103*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)           /*53103*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      /*53103*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  /*53103*/
             GOTO       CMDLBL(ABNOR)                              /*53103*/
             ENDDO                                                 /*53103*/
 
/* CALL PM1620 TO WRITE MATURED AND FLAT POSITIONS TO PMPMIMWW */
             OVRDBF     FILE(PMHDVNLL) TOFILE(PMMFHLL2)
/*           CALL       PGM(PM1620)                            056460 */
/************CALL       PGM(PM1620) PARM(&WWPOOL)      056460  053103*/
             CALL       PGM(PM1620) PARM(&WWPOOL 'M')        /*053103 */
 
             DLTOVR     FILE(*ALL)                           /*056460 */
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+   /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**CALL*PM1625*TO*WRITE*POOL*POSITIONS*TO*PMPMIMPP******************/ /*S01486*/
/* CALL PM1625 TO WRITE POOL POSITIONS TO PMPMIMPD */                 /*S01486*/
             IF         COND(&WWPOOL *EQ 'Y') THEN(DO)       /*056460 */
 
/**********  OVRDBF FILE(PMFPPLPP) TOFILE(SDPLCSPD) SHARE(*YES)/*056460 S01486*/
             OVRDBF     FILE(PMFPPLQ0) TOFILE(SDPLCSPD) SHARE(*YES)   /*S01486*/
/**********  OPNQRYF    FILE((*LIBL/SDPLCSPD) (PMFPPSPP)) +        */ /*S01486*/
/**********             FORMAT(PMFPPLPP) QRYSLT('QBPPCS *EQ "Y"') +*/ /*S01486*/
/**********               JFLD((SDPLCSPD/QBCUST *MAPFLD/W1CNUM)) + */ /*S01486*/
/**********         MAPFLD((W1CNUM 'PMFPPSPP/QPCNUM' *CHAR 6)) /*056460 S01486*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (PMFPPSQ0)) +
                          FORMAT(PMFPPLQ0) QRYSLT('QBPPCS *EQ "Y"') +
                          JFLD((SDPLCSPD/QBCUST *MAPFLD/W1CNUM)) +
                          MAPFLD((W1CNUM 'PMFPPSQ0/QPCNUM' *CHAR 6))  /*S01486*/
 
/*********** IF         COND(&FCTVPS *EQ 'T') THEN(DO)          /*53103 CPM005*/
             OVRDBF     FILE(PMHDVNLL) TOFILE(PMHOLDL4) SHARE(*NO) /*53103 */
/*********** ENDDO                                              /*53103 CPM005*/
 
/*********** IF         COND(&FCTVPS *EQ 'V') THEN(DO)          /*53103 CPM005*/
/*********** OVRDBF  FILE(PMHDVNLL) TOFILE(PMHOLDL5) SHARE(*NO) /*53103 CPM005*/
/*********** ENDDO                                              /*53103 CPM005*/
/*           CALL       PGM(PM1625)                          /*56460 53103*/
             CALL       PGM(PM1625) PARM('L')                      /*53103 */
 
             DLTOVR     FILE(*ALL)                           /*056460 */
             CLOF       OPNID(SDPLCSPD)                      /*056460 */
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)     /*056460 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) /*056460*/
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)           */ /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                        /*056460 */
             ENDDO                                           /*056460 */
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)     /*056460 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) /*056460*/
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)           */ /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                        /*056460 */
             ENDDO                                           /*056460 */
 
/* CALL PM1620 TO WRITE MATURED AND FLAT POSITIONS TO PMPMIMWW */
             OVRDBF     FILE(PMHDVNLL) TOFILE(PMMFHLL2)      /*056460 */
 
/**********  OVRDBF     FILE(PMFPPLPP) TOFILE(SDPLCSPD) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMFPPLQ0) TOFILE(SDPLCSPD) SHARE(*YES)   /*S01486*/
/**********  OPNQRYF    FILE((*LIBL/SDPLCSPD) (PMFPPSPP)) +        */ /*S01486*/
/**********             FORMAT(PMFPPLPP) QRYSLT('QBPPCS *EQ "Y"') +*/ /*S01486*/
/**********               JFLD((SDPLCSPD/QBCUST *MAPFLD/W1CNUM)) + */ /*S01486*/
/**********         MAPFLD((W1CNUM 'PMFPPSPP/QPCNUM' *CHAR 6)) /*056460 S01486*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (PMFPPSQ0)) +
                          FORMAT(PMFPPLQ0) QRYSLT('QBPPCS *EQ "Y"') +
                          JFLD((SDPLCSPD/QBCUST *MAPFLD/W1CNUM)) +
                          MAPFLD((W1CNUM 'PMFPPSQ0/QPCNUM' *CHAR 6))  /*S01486*/
 
/*           CALL       PGM(PM1625)                          /*56460 53103*/
/******      CALL       PGM(PM1625) PARM('L')               /*53103  097389*/
             CALL       PGM(PM1625) PARM('M')                      /*097389 */
 
             DLTOVR     FILE(*ALL)                           /*056460 */
             CLOF       OPNID(SDPLCSPD)                      /*056460 */
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)     /*056460 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) /*056460*/
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)           */ /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                        /*056460 */
             ENDDO                                           /*056460 */
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)     /*056460 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) /*056460*/
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)           */ /*056460 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)                        /*056460 */
             ENDDO                                           /*056460 */
             ENDDO                                           /*056460 */
/**CALL*PM1640*TO*WRITE*STARTING*POSITIONS*TO*PMPSTCPP**************/ /*S01486*/
/**CALL*PM1640 TO WRITE STARTING POSITIONS TO PMPSTCPD     /*S01486*/ /*CPM004*/
/*********** CPYF       FROMFILE(&FMLIB/PMCPIMQ0) +                   /*CPM004*/
/***********              TOFILE(QTEMP/PMCPIMQ0) MBROPT(*REPLACE) +   /*CPM004*/
/***********              CRTFILE(*YES)                       72242   /*CPM004*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCPIM72242   /*CPM004*/
/***********                                                          /*CPM004*/
/*********** CPYF       FROMFILE(&FMLIB/PMCPSTQ0) +                   /*CPM004*/
/***********              TOFILE(QTEMP/PMCPSTQ0) MBROPT(*REPLA        /*CPM004*/
/***********              CRTFILE(*YES)                       72242   /*CPM004*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCPST72242   /*CPM004*/
/***********                                                          /*CPM004*/
/*********** CPYF       FROMFILE(QTEMP/PMPMIMPD) +                    /*CPM004*/
/***********              TOFILE(QTEMP/PMCPIMQ0) MBROPT(*ADD) 72242   /*CPM004*/
/* */                                                                 /*CPM004*/
/* CLEAR WORKFILES */                                                 /*CPM004*/
/* */                                                                 /*CPM004*/
             CLRPFM     FILE(PMCPIMQ0)                                /*CPM004*/
             CLRPFM     FILE(PMCPSTQ0)                                /*CPM004*/
/* */                                                                 /*CPM004*/
/* ADD PERFORMANCE MID-MONTH POSITIONS */                             /*CPM004*/
/* */                                                                 /*CPM004*/
             CPYF       FROMFILE(PMPMIMPD) +
                          TOFILE(PMCPIMQ0) MBROPT(*ADD)               /*CPM004*/
/* */                                                                 /*CPM004*/
/* CALL PM1640 TO WRITE STARTING POSITIONS TO PMPSTCPD */             /*CPM004*/
/* */                                                                 /*CPM004*/
             CALL       PGM(PM1640)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**COPY*PMPSTCPP*TO*BAKUP*FILE.*FILE*RESTORED*BEFORE*EACH*CALL*TO*PM1640**/
/* COPY PMPSTCPD TO BAKUP FILE. FILE RESTORED BEFORE EACH CALL TO PM1640 */
/**********  CPYF       FROMFILE(QTEMP/PMPSTCPP) +                 */ /*S01486*/
/**********               TOFILE(QTEMP/XPMPSTCPP) MBROPT(*ADD) +   */ /*S01486*/
/**********               CRTFILE(*YES)                      */ /*46921 S01486*/
/*********** CPYF       FROMFILE(QTEMP/PMPSTCPD) +
                          TOFILE(QTEMP/XPMPSTCPD) MBROPT(*ADD) +
                          CRTFILE(*YES)                    /*S01486     053103*/
 
/* CHECK WHETEHR AUDIT REPORT REQUIRED AND SET SWITCHES */
/*           RTVDTAARA  DTAARA(PMSTAT (39 1)) RTNVAR(&WWPARQ)       056986 */
             RTVDTAARA  DTAARA(PMSTAT (41 1)) RTNVAR(&WWPARQ)    /* 056986 */
             IF         COND(&WWPARQ *EQ 'Y') THEN(CHGJOB +
                          SWS(10000000))
             IF         COND(&WWPARQ *NE 'Y') THEN(CHGJOB +
                          SWS(00000000))
 
/* CALL PM1630 TO CALCULATE PERFORMANCE FIGURES FOR PERIOD 1 */
/*********** CALL       PGM(PM1630) PARM('1')                      */ /*S01486*/
             CALL       PGM(PM1630) PARM('1' &RSEQ)                   /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**RESTORE*BACKUP*VERSION*OF*PMPSTCPP*******************************/ /*S01486*/
/* RESTORE BACKUP VERSION OF PMPSTCPD */                              /*S01486*/
/**********  CPYF       FROMFILE(QTEMP/XPMPSTCPP) +                */ /*S01486*/
/**********         TOFILE(QTEMP/PMPSTCPP) MBROPT(*REPLACE)  */ /*46921 S01486*/
/**********  CPYF       FROMFILE(QTEMP/XPMPSTCPD) +
                          TOFILE(QTEMP/PMPSTCPD) MBROPT(*REPLACE)S01486 053103*/
/**********  MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPP))  /*46921 S01486*/
/**********  MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPD))   S01486 053103*/
 
/* CALL PM1630 TO CALCULATE PERFORMANCE FIGURES FOR PERIOD 2 */
/*********** CALL       PGM(PM1630) PARM('2')                      */ /*S01486*/
/*********** CALL       PGM(PM1630) PARM('1' &RSEQ)           *S01486* *085855*/
             CALL       PGM(PM1630) PARM('2' &RSEQ)                   /*085855*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/**RESTORE*BACKUP*VERSION*OF*PMPSTCPP*******************************/ /*S01486*/
/* RESTORE BACKUP VERSION OF PMPSTCPD */                              /*S01486*/
/**********  CPYF       FROMFILE(QTEMP/XPMPSTCPP) +                */ /*S01486*/
/**********         TOFILE(QTEMP/PMPSTCPP) MBROPT(*REPLACE)  */ /*46921 S01486*/
/**********  CPYF       FROMFILE(QTEMP/XPMPSTCPD) +
                          TOFILE(QTEMP/PMPSTCPD) MBROPT(*REPLACE)S01486 053103*/
/**********  MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPP))  /*46921 S01486*/
/**********  MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPD)) /*S01486 053103*/
 
/* CALL PM1630 TO CALCULATE PERFORMANCE FIGURES FOR PERIOD 3 */
/*********** CALL       PGM(PM1630) PARM('3')                      */ /*S01486*/
/*********** CALL       PGM(PM1630) PARM('1' &RSEQ)           *S01486* *085855*/
             CALL       PGM(PM1630) PARM('3' &RSEQ)                   /*085855*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL PROGRAM PMC1650 TO CALCULATE PERFORMANCE TOTALS */
             CALL       PGM(PMC1650)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ABNOR:       ENDPGM
