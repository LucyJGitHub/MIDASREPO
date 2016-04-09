/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Extract Pool Securities Transactions')          */
/********************************************************************/
/*                                                                  */
/*       Midas     - Portfolio Manageement Module                   */
/*                                                                  */
/*       PMC1152  - Pool Portfolio Holdings                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 08JUL96              */
/*       Prev Amend No. 080734             DATE 11AUG94              */
/*                      S01486             DATE 11AUG94              */
/*                      056460             DATE 07JUN93             */
/*                      056986             DATE 11MAY93             */
/*                      041946             DATE 07JUL92             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/2 - CALCUL & REPORT PERF. FOR ALL CUST. PORT  */
/*                SELECT ONLY LIVE POOL RECORDS IN OPNQRYF COMMAND   */
/*       080734  -  Wrong file used                                 */
/*       S01486  -  Portfolio Management Upgrade to Release 10.     */
/*       056460  -  CONSOLIDATED POOL PORTFOLIO                     */
/*       056986  -  AMENDED FOR PERFORMANCE IMPLEMENTATION          */
/*       041946  -  RNMOBJ PM1152 IN PM1152B BECAUSE THIS PGM ALREAD*/
/*                  EXISTS IN ABSCE14 RELEASE.                      */
/*                  AND SUPPRESS THE CLEAR OF PMHOLDX0.             */
/*                                                                  */
/*       WRITTEN FOR SAR 91/08 - POOL SECURITIES TRANSACTIONS       */
/*                                                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*           PGM        PARM(&PARM)    */
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*           DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)       */
 
/* SET OFF SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR ALL TEMPORARY FILES */
/*           CLRPFM     FILE(PMHOLDX0)                    041946      */
/*********** CLRPFM     FILE(PMPLHLPP)                      */ /*056460 S01486*/
             CLRPFM     FILE(PMPLHLPD)                                /*S01486*/
/*********** CLRPFM     FILE(PMPLHLX0)                         /*056460 080734*/
             CLRPFM     FILE(PMPLHWPD)                                /*080734*/
 
/*********** OVRDBF     FILE(PMPPTHQ1) TOFILE(PMHOLDPP) SHARE(*YES)*/ /*S01486*/
/*********** OVRDBF     FILE(PMHOLDXX) TOFILE(PMHOLDPP) SHARE(*NO) */ /*S01486*/
             OVRDBF     FILE(PMPPTHQ1) TOFILE(PMHOLDPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMHOLDXX) TOFILE(PMHOLDPD) SHARE(*NO)    /*S01486*/
 
/*           OPNQRYF    FILE(PMHOLDPP PMPPTMPD) +
                        FORMAT(PMPPTHQ1) KEYFLD(PMPPTMPD/OSPCNU +
                        PMPPTMPD/OSPPTF PMHOLDPP/QFRECI +
                        PMHOLDPP/QFTVDA PMHOLDPP/QFMODI +
                        PMHOLDPP/QFBYSF PMHOLDPP/QFTDSS +
                        PMHOLDPP/QFFOIS PMHOLDPP/QFCCY1 +
                        PMHOLDPP/QFCCY2 PMHOLDPP/QFINNR +
                        PMHOLDPP/QFTXT1 PMHOLDPP/QFTXT2 +
                        PMHOLDPP/QFBFXR PMHOLDPP/QFOPCL +
                        PMHOLDPP/QFMFMD) +
                        JFLD((PMPPTMPD/OSCNUM PMHOLDPP/QFCNUM) +
                        (PMPPTMPD/OSPTFR PMHOLDPP/QFPTFR))    056460 */
 
/*********** OPNQRYF    FILE((PMHOLDPP))(PMPPTMPD))PFORMAT(PMPPTHQ1)+ /*S01486*/
/***********              QRYSLT('QFMODI *NE "LB"') +              */ /*S01486*/
/***********              KEYFLD((PMPPTMPD/OSPCNU) +               */ /*S01486*/
/***********              (PMPPTMPD/OSPPTF) (PMHOLDPP/QFRECI) +    */ /*S01486*/
/***********              (PMHOLDPP/QFTVDA) (PMHOLDPP/QFMODI) +    */ /*S01486*/
/***********              (PMHOLDPP/QFBYSF) (PMHOLDPP/QFTDSS) +    */ /*S01486*/
/***********              (PMHOLDPP/QFFOIS) (PMHOLDPP/QFCCY1) +    */ /*S01486*/
/***********              (PMHOLDPP/QFCCY2) (PMHOLDPP/QFINNR) +    */ /*S01486*/
/***********              (PMHOLDPP/QFTXT1) (PMHOLDPP/QFTXT2) +    */ /*S01486*/
/***********              (PMHOLDPP/QFBFXR) (PMHOLDPP/QFOPCL) +    */ /*S01486*/
/***********              (PMHOLDPP/QFMFMD)) JFLD((PMPPTMPD/OSCNUM */ /*S01486*/
/***********              PMHOLDPP/QFCNUM) (PMPPTMPD/OSPTFR +      */ /*S01486*/
/***********              PMHOLDPP/QFPTFR))               /*056460 */ /*S01486*/
/*********** OPNQRYF   FILE((PMHOLDPD) (PMPPTMPD)) FORMAT(PMPPTHQ1) + /*CPM005*/
/************************ QRYSLT('QFMODI *NE "LB"') +                 /*CPM005*/
/************************ KEYFLD((PMPPTMPD/OSPCNU) +                  /*CPM005*/
/************************ (PMPPTMPD/OSPPTF) (PMHOLDPD/QFRECI) +       /*CPM005*/
/************************ (PMHOLDPD/QFTVDA) (PMHOLDPD/QFMODI) +       /*CPM005*/
/************************ (PMHOLDPD/QFBYSF) (PMHOLDPD/QFTDSS) +       /*CPM005*/
/************************ (PMHOLDPD/QFFOIS) (PMHOLDPD/QFCCY1) +       /*CPM005*/
/************************ (PMHOLDPD/QFCCY2) (PMHOLDPD/QFINNR) +       /*CPM005*/
/************************ (PMHOLDPD/QFTXT1) (PMHOLDPD/QFTXT2) +       /*CPM005*/
/************************ (PMHOLDPD/QFBFXR) (PMHOLDPD/QFOPCL) +       /*CPM005*/
/************************ (PMHOLDPD/QFMFMD)) JFLD((PMPPTMPD/OSCNUM +  /*CPM005*/
/************************ PMHOLDPD/QFCNUM) (PMPPTMPD/OSPTFR +         /*CPM005*/
/************************ PMHOLDPD/QFPTFR))                    /*056460 CPM005*/
             OPNQRYF    FILE((PMHOLDPD) (PMPPTMPD)) FORMAT(PMPPTHQ1) +
                          QRYSLT('(QFMODI *NE "LB") & (OSRECI *EQ +
                          "D")') KEYFLD((PMPPTMPD/OSPCNU) +
                          (PMPPTMPD/OSPPTF) (PMHOLDPD/QFRECI) +
                          (PMHOLDPD/QFTVDA) (PMHOLDPD/QFMODI) +
                          (PMHOLDPD/QFBYSF) (PMHOLDPD/QFTDSS) +
                          (PMHOLDPD/QFFOIS) (PMHOLDPD/QFCCY1) +
                          (PMHOLDPD/QFCCY2) (PMHOLDPD/QFINNR) +
                          (PMHOLDPD/QFTXT1) (PMHOLDPD/QFTXT2) +
                          (PMHOLDPD/QFBFXR) (PMHOLDPD/QFOPCL) +
                          (PMHOLDPD/QFMFMD) (PMHOLDPD/QFNOPO)) +
                          JFLD((PMPPTMPD/OSCNUM PMHOLDPD/QFCNUM) +
                          (PMPPTMPD/OSPTFR PMHOLDPD/QFPTFR))          /*CPM005*/
/*           CALL       PGM(PM1152) PARM(&PARM)          041946  ***/
/*041946     CALL       PGM(PM1152B) PARM(&PARM)     */
             CALL       PGM(PM1150) /*056986 */
 
/*********** CLOF       OPNID(PMHOLDPP)                            */ /*S01486*/
             CLOF       OPNID(PMHOLDPD)
 
             DLTOVR     FILE(*ALL)
 
/* PROCESS DATA BASE ERROR */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM                                             /*056460 */
             ENDDO
 
/* IF PROCESSING COMPLETED NORMALLY COPY WORKFILES TO MASTER FILES     056460 */
/*********** CPYF       FROMFILE(PMPLHLPP) TOFILE(PMHOLDPP) +         /*S01486*/
/***********              MBROPT(*ADD)                      */ /*056460 S01486*/
/*********** CPYF       FROMFILE(PMPLHLX0) TOFILE(PMHOLDX0) +         /*S01486*/
/***********              MBROPT(*ADD)                      */ /*056460 S01486*/
             CPYF       FROMFILE(PMPLHLPD) TOFILE(PMHOLDPD) +
                          MBROPT(*ADD)                               /*S01486 */
/*********** CPYF       FROMFILE(PMPLHLX0) TOFILE(PMHOLDQ0) +
                          MBROPT(*ADD)                         /*056460 080734*/
             CPYF       FROMFILE(PMPLHWPD) TOFILE(PMHOLDQ0) +
                          MBROPT(*ADD)                                /*080734*/
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
