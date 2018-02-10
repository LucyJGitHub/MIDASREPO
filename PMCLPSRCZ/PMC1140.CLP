/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio generation holdings')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1140 - PM Portfolio Generation Holdings                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM005             Date 05Jul96              */
/*                      CPM003             DATE 02MAY96              */
/*                      077485             DATE 17OCT94              */
/*                      S71062             DATE 21DEC95              */
/*                      S01408             DATE 01APR96              */
/*                      099814             DATE 14FEB96              */
/*                      CPM004             DATE 07FEB96              */
/*                      094712             DATE 17OCT95              */
/*                      S01408             DATE 05MAY95              */
/*                      085819             DATE 13MAR95              */
/*                      085812             DATE 10MAR95              */
/*                      080735             DATE 22DEC94              */
/*                      S01486             DATE 11AUG94              */
/*                      058889             DATE 29JUL93              */
/*                      056856  SC         DATE 27JUL93              */
/*                      056986             DATE 21JUN93              */
/*                      SA9108             DATE 16OCT91              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      S01313             DATE 27APR92              */
/*                      B08253             DATE 10OCT91              */
/*                      B08255             DATE 07OCT91              */
/*                      B08040             DATE 07JUL91              */
/*                      R05767             DATE 27MAR91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       183309 - CPF4101 msg received because correct overrides     */
/*                not in place. Fix is to output error message       */
/*                if Trade/Value Date Position flag on SDPORTPD      */
/*                not set up correctly.                              */
/*              - Monitor for messages after CLOF and DLTOVR.        */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO            */
/*                instead of *YES                                    */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/3 - DISPLAY UNREALISED P&L ON FORWARD SE TRADE*/
/*   CPM003 - FF/PM Interface upgrade to Release 10                  */
/*       077485 - FF/PM INTERFACE : MATURE FLAT POSITIONS NOT        */
/*                EXTRACTED FOR FF TRADES                            */
/*       S71062 - FF/PM interface                                    */
/*                Re-apply 080735 - "Remove futures & options module"*/
/*       S01408 - Addition of core hook PMC1140001                   */
/*       099814 - Pool Trades should use CQQ001 feature not PMSTAT   */
/*       CPM004 - Bank Portfolios                                    */
/*       094712 - New parameter added to PM1146                      */
/*       S01408 - Addition of core hook PMC1140MP1                   */
/*       085819 - Remove PMHOLDL7 and PMHOLDL8 and use only PMHOLDL5 */
/*       085812 - CORRECT POSITION USED FROM MMOD                    */
/*       080735 - Remove futures and options module                  */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       058889 - CORRECTIONS TO SAVING OF CLOSED ACCOUNTS           */
/*       056856 - CHECK LOCK STATE ON DATA AREA FFSTAT               */
/*       056986 - AMENDED FOR PERFORMANCE IMPLEMENTATION             */
/*       SA9108 - CALL TO PMC1152 TO GENERATE POOL PORTOFOLIO POS.   */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01313 - CHANGES FOR PORTFOLIO PERFORMANCE                  */
/*       B08253 - EXTRACT MATURE/FLAT POSITION TO THE NEW            */
/*                'MATURED' HOLDINGS FILE                            */
/*       B08255 - SPLIT UP TOTALLINGS FILES TO SPEED UP COB          */
/*       B08040 - SUNDRY FIXES TO SPEED UP COB                       */
/*       R05767 - SAVE EVENT CONTROL DATE AS DATE ON WHICH EXTRACT   */
/*                LAST RUN                                           */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)       /*R05767*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)      /*B08040*/
/************DCL        VAR(&PLPPRQ) TYPE(*CHAR) LEN(1)     */ /*SA9108 099814*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)      /*S01486*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*085812*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*085812*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*099814*/
 
             DCLF       FILE(SDPORTPD)                       /*B08040*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*183309*/
                                                                      /*183309*/
             RCVF       RCDFMT(SDPORTD0)                     /*B08040*/
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
             CHGVAR     VAR(&DILIB) VALUE(&PRE *TCAT 'DILIB')         /*S01486*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB') /*B0804*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1140MP1                                          */
                                                                      /*S01408*/
 
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1140 - PM Generate Portfolio +
                          Holdings') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
                                                             /*R05767*/
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN            R05767*/
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)  /*R05767*/
             CHGDTAARA  DTAARA(PMSTAT (29 5)) VALUE(&DAECD)  /*R05767*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/**RETRIEVE*DTAARA*MMOD*TO*CHECK*MODULES*PRESENT************************085812*/
/*********** RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                     *085812*/
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
/* ACCESS SDMMODPD TO CHECK MODULES PRESENT                          * *085812*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*085812*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*085812*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &MMOD)         /*085812*/
                                                                      /*085812*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*085812*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*085812*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*085812*/
             GOTO       CMDLBL(ABNOR)                                 /*085812*/
             ENDDO                                                    /*085812*/
 
/*           RMVM       FILE(PMHOLDL1) MBR(PMHOLDL1)  B08253  *B08040*/
/*           MONMSG     MSGID(CPF5815 CPF7310)        B08253  *B08040*/
/*           RMVM       FILE(PMHOLDL2) MBR(PMHOLDL2)  B08253  *B08040*/
/*           MONMSG     MSGID(CPF5815 CPF7310)        B08253  *B08040*/
             RMVM       FILE(PMHOLDL4) MBR(PMHOLDL4)         /*B08040*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08040*/
/*********** RMVM       FILE(PMHOLDL5) MBR(PMHOLDL5) ***/      /*B08040 CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310) ***/            /*B08040 CPM005*/
             RMVM       FILE(PMHOLDL6) MBR(PMHOLDL6)         /*B08040*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08040*/
             RMVM       FILE(PMHOLDLA) MBR(PMHOLDLA)                  /*CPM005*/
             MONMSG     MSGID(CPF5815 CPF7310)                        /*CPM005*/
             RMVM       FILE(PMHOLDLB) MBR(PMHOLDLB)                  /*CPM005*/
             MONMSG     MSGID(CPF5815 CPF7310)                        /*CPM005*/
             RMVM       FILE(PMHOLDL9) MBR(PMHOLDL9)                  /*CPM005*/
             MONMSG     MSGID(CPF5815 CPF7310)                        /*CPM005*/
             RMVM       FILE(PMHDVNLL) MBR(PMHDVNLL)         /*B08040*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08040*/
/*********** RMVM       FILE(PMHOLLX0) MBR(PMHOLLX0)        */ /*S01313 S01486*/
/*********** RMVM       FILE(PMHOLDL7) MBR(PMHOLDL7)          *S01486* *085819*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                *S01313* *085819*/
/*********** RMVM       FILE(PMHOLLX1) MBR(PMHOLLX1)        */ /*S01313 S01486*/
/*********** RMVM       FILE(PMHOLDL8) MBR(PMHOLDL8)          *S01486* *085819*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                *S01313* *085819*/
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMHOLDPP)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMHOLDZZ)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMHOLDX0)                      */ /*B08040 S01486*/
/*********** CLRPFM     FILE(PMHOLDX1)                      */ /*B08255 S01486*/
                                                                      /*S01486*/
             CLRPFM     FILE(PMHOLDPD)                                /*S01486*/
             CLRPFM     FILE(PMHOLDPA)                                /*S01486*/
             CLRPFM     FILE(PMHOLDQ0)                                /*S01486*/
             CLRPFM     FILE(PMHOLDQ1)                                /*S01486*/
                                                                      /*S01486*/
 
/*           CLRPFM     FILE(PMDSGTPP)                         B08040*/
/*           CLRPFM     FILE(PMVLGTPP)                         B08040*/
/*           CLRPFM     FILE(PMCCYTPP)                         B08040*/
/*           CLRPFM     FILE(PMCNTTPP)                         B08040*/
/*           CLRPFM     FILE(PMINDTPP)                         B08040*/
/*           CLRPFM     FILE(PMPOTTPP)                         B08040*/
/*           CLRPFM     FILE(PMISTTPP)                         B08040*/
 
/* CHECK FOR COMPONENT RESTART */
/*>>S01189>>*/
/**********  RTVDTAARA  DTAARA(PMSTAT (16 3)) RTNVAR(&BUSY)            */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'NEW') THEN(DO)                  */
             IF         COND(&BUSY = 'Y') THEN(DO)
 /*          OVRDBF     FILE(XPMCPOSPP) SEQONLY(*YES 100)      B08040*/
 /*          CPYF       FROMFILE(XPMCPOSPP) TOFILE(PMCPOSPP) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)       B08040*/
 /*          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPP))                      B08040*/
 /*          CPYF       FROMFILE(XPMCPOSZZ) TOFILE(PMCPOSZZ) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)       B08040*/
 /*          MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSZZ))                      B08040*/
/*********** RSTOBJ     OBJ(PMCPOSPP PMCPOSZZ) SAVLIB(&DMLIB) +    */ /*S01486*/
/***********              DEV(*SAVF) SAVF(&TOLIB/PMCSAVF) +        */ /*S01486*/
/***********              MBROPT(*ALL)                      */ /*B08040 S01486*/
/**********  RSTOBJ     OBJ(PMCPOSPD PMCPOSPA) SAVLIB(&DMLIB) + */             /*S01486*/ /*207764*/
/**********               DEV(*SAVF) SAVF(&DILIB/PMCSAVF) +     */             /*S01486*/ /*207764*/
/**********               MBROPT(*ALL)                          */             /*S01486*/ /*207764*/
             RSTOBJ     OBJ(PMCPOSPD PMCPOSPA) SAVLIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/PMCSAVF) +
                          MBROPT(*ALL) OUTPUT(*PRINT)                                     /*207764*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'OLD') THEN(DO)                  */
             IF         COND(&BUSY = 'N') THEN(DO)
/*           OVRDBF     FILE(PMCPOSPP) SEQONLY(*YES 100)       B08040*/
/*           CPYF       FROMFILE(PMCPOSPP) TOFILE(&TOLIB/XPMCPOSPP) +
                 MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)  B08040*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPP))                     B08040*/
/*           CPYF       FROMFILE(PMCPOSZZ) TOFILE(&TOLIB/XPMCPOSZZ) +
                MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)   B08040*/
/*           MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSZZ))                     B08040*/
             CHKOBJ     OBJ(&DILIB/PMCSAVF) OBJTYPE(*FILE)   /*B08040*/
             MONMSG     MSGID(CPF9801) EXEC(DO)              /*B08040*/
             CRTSAVF    FILE(&DILIB/PMCSAVF)                 /*B08040*/
             ENDDO                                           /*B08040*/
             CLRSAVF    FILE(&DILIB/PMCSAVF)                /*B08040*/
/*********** SAVOBJ     OBJ(PMCPOSPP PMCPOSZZ) LIB(&DMLIB) +       */ /*S01486*/
/***********              DEV(*SAVF) SAVF(&TOLIB/PMCSAVF)      /*B08040 S01486*/
/**********  SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) +
/**********               DEV(*SAVF) SAVF(&DILIB/PMCSAVF)             /*S01486 192731*/
/**********  SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) + */                /*192731*/ /*207764*/
/**********               DEV(*SAVF) SAVF(&DILIB/PMCSAVF)  + */                /*192731*/ /*207764*/
/**********               USEOPTBLK(*NO)                     */                /*192731*/ /*207764*/
             SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/PMCSAVF)  +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*207764*/
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/*********** OVRDBF     FILE(PMHOLDPP) SEQONLY(*YES 100)       /*B08040 S01486*/
/*********** OVRDBF     FILE(PMHOLDX0) SEQONLY(*YES 100)       /*B08040 S01486*/
/*********** OVRDBF     FILE(PMHOLDX1) SEQONLY(*YES 100)       /*B08255 S01486*/
             OVRDBF     FILE(PMHOLDPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMHOLDQ0) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMHOLDQ1) SEQONLY(*YES 100)              /*S01486*/
 
             IF         COND((&FCTVPS *NE 'T') *AND (&FCTVPS *NE +
                          'V')) THEN(DO)                              /*183309*/
             SNDPGMMSG  MSGID(PEM0003) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*183309*/
             GOTO       CMDLBL(ABNOR)                                 /*183309*/
             ENDDO                                                    /*183309*/
                                                                      /*183309*/
/* PERFROM PROCESSING TO UPDATE ALL PORTFOLIOS IN BASE CURRENCY IND */
/*********** IF         COND(&P9TVPS *EQ 'V') THEN(DO)             */ /*S01486*/
             IF         COND(&FCTVPS *EQ 'V') THEN(DO)                /*S01486*/
             OVRDBF     FILE(PMCPLTLL) TOFILE(PMCPLVLL) SHARE(*NO)
             ENDDO
 
             CALL       PGM(PM1134)                                   /*B08255*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*B08255*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*B08255*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)           */ /*B08255 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*B08255*/
             ENDDO                                                    /*B08255*/
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*B08255*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*B08255*/
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)           */ /*B08255 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*B08255*/
             ENDDO                                                    /*B08255*/
 
/* CALL LOMBARD CREDITS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 82 1))           * *085812*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 76 1))            /*085812*/
             IF         COND(&MDID = 'Y') THEN(DO)
/*           CALL       PGM(PMC1136)                      */ /*B08040*/
/*********** CALL       PGM(PMC1136) PARM(&P9TVPS)                 */ /*S01486*/
             CALL       PGM(PMC1136) PARM(&FCTVPS)                    /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
 
/**CALL*FIDUCIARY*DETAILS*EXTRACT***********************************/ /*S01486*/
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))         */ /*S01486*/
/*********** IF         COND(&MDID = 'Y') THEN(DO)                 */ /*S01486*/
/*           CALL       PGM(PM1138)                            B08040*/
/*           CALL       PGM(PM1138) PARM(&P9TVPS)      B08253 *B08040*/
/*********** CALL       PGM(PM1138) PARM(&P9TVPS 'L')       */ /*B08253 S01486*/
/***********                                                       */ /*S01486*/
/**PROCESS*ANY*DATA*BASE*ERROR**************************************/ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                              */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/***********                                                       */ /*S01486*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM*************/ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX01)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** GOTO       CMDLBL(ABNOR)                              */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1140001                                          */
                                                                      /*S01408*/
/**CALL*SECURITY*DETAILS*EXTRACT**/                                   /*CPM004*/
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))           * *085812*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*085812*/
/*********** IF ********COND(&MDID = 'Y') THEN(DO)                    /*CPM004*/
/* CALL SECURITY DETAILS EXTRACT - CUSTOMER PORTFOLIOS */             /*CPM004*/
             IF         COND(&MDID = 'Y' *AND &FCPORS *NE 'B') +
             THEN(DO)                                                 /*CPM004*/
 
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)
             OVRDBF     FILE(SECET) TOFILE(SECET) SHARE(*NO) /*B08040*/
 
/*********** IF         COND(&P9TVPS *EQ 'T') THEN(DO)      */ /*B08040 S01486*/
             IF         COND(&FCTVPS *EQ 'T') THEN(DO)                /*S01486*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMCPSTLL) SHARE(*NO) /*B08040*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO
 
/*********** IF         COND(&P9TVPS *EQ 'V') THEN(DO)      */ /*B08040 S01486*/
             IF         COND(&FCTVPS *EQ 'V') THEN(DO)                /*S01486*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMCPSVLL) SHARE(*NO) /*B08040*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO                                           /*B08040*/
 
             OVRDBF     FILE(PMAPOSLL) SHARE(*NO)                  /*B08040*/
             OVRDBF     FILE(PMAPOSLX) TOFILE(PMAPOSLL) SHARE(*NO) /*B08040*/
             OVRDBF     FILE(PMCPOSL0) SHARE(*NO)            /*B08040*/
             OVRDBF     FILE(PMHPOSLL) SHARE(*NO)            /*B08040*/
 
/*           CALL       PGM(PM1140) PARM('F')                  B08040*/
/*           CALL       PGM(PM1140) PARM('F' &P9TVPS)  B08253 *B08040*/
/*********** CALL       PGM(PM1140) PARM('F' &P9TVPS 'L')   */ /*B08253 S01486*/
             CALL       PGM(PM1140) PARM('F' &FCTVPS 'L')             /*S01486*/
             DLTOVR     FILE(*ALL)                           /*B08040*/
 
/*********** OVRDBF     FILE(PMHOLDPP) SEQONLY(*YES 100)       /*B08040 S01486*/
/*********** OVRDBF     FILE(PMHOLDX0) SEQONLY(*YES 100)       /*B08040 S01486*/
/*********** OVRDBF     FILE(PMHOLDX1) SEQONLY(*YES 100)       /*B08255 S01486*/
             OVRDBF     FILE(PMHOLDPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMHOLDQ0) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMHOLDQ1) SEQONLY(*YES 100)              /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/* CALL SECURITY DETAILS EXTRACT - BANK PORTFOLIOS */                 /*CPM004*/
             IF         COND(&MDID = 'Y' *AND &FCPORS *EQ 'B') +
             THEN(DO)                                                 /*CPM004*/
             OVRDBF     FILE(SECEOX) TOFILE(SECEO) SHARE(*NO)         /*CPM004*/
                                                                      /*CPM004*/
             CALL       PGM(PM1141) PARM(&FCTVPS 'L')                 /*CPM004*/
             DLTOVR     FILE(*ALL)                                    /*CPM004*/
                                                                      /*CPM004*/
             OVRDBF     FILE(PMHOLDPD) SEQONLY(*YES 100)              /*CPM004*/
             OVRDBF     FILE(PMHOLDQ0) SEQONLY(*YES 100)              /*CPM004*/
             OVRDBF     FILE(PMHOLDQ1) SEQONLY(*YES 100)              /*CPM004*/
                                                                      /*CPM004*/
/* PROCESS ANY DATA BASE ERROR */                                     /*CPM004*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM004*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*CPM004*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM004*/
             GOTO       CMDLBL(ABNOR)                                 /*CPM004*/
             ENDDO                                                    /*CPM004*/
                                                                      /*CPM004*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*CPM004*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*CPM004*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*CPM004*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM004*/
             GOTO       CMDLBL(ABNOR)                                 /*CPM004*/
             ENDDO                                                    /*CPM004*/
             ENDDO                                                    /*CPM004*/
 
/**CALL*FUTURES*AND*OPTIONS*DETAILS*EXTRACT                             080735*/
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))              080735*/
/*********** IF         COND(&MDID = 'Y') THEN(DO)                      080735*/
/**/
/***********                                                  /* 056856 080735*/
/*********** CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('Y')       /* 056856 080735*/
/***********                                                  /* 056856 080735*/
/*********** OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D"') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))                       /*080735*/
/**/
/*********** CALL       PGM(PM1142) PARM('F' &P9TVPS)*/ /*B08040 S01486 080735*/
/*********** CALL       PGM(PM1142) PARM('F' &FCTVPS)          /*S01486 080735*/
/*********** CLOF       OPNID(TRANS2)                                   080735*/
/***********                                                  /* 056856 080735*/
/*********** CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('N')       /* 056856 080735*/
/***********                                                  /* 056856 080735*/
 
/**PROCESS*ANY*DATA*BASE*ERROR */                                     /*080735*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*080735*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*080735*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)/*S01486 080735*/
/*                                                                    /*R00300*/
/*********** GOTO       CMDLBL(ABNOR)                                 /*080735*/
/*********** ENDDO                                                    /*080735*/
 
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM               /*080735*/
/*********** IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*080735*/
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*080735*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)/*S01486 080735*/
/*                                                                    /*R00300*/
/*********** GOTO       CMDLBL(ABNOR)                                   080735*/
/*********** ENDDO                                                      080735*/
/*********** ENDDO                                                      080735*/
                                                                      /*S71062*/
/* CALL FUTURES AND OPTIONS DETAILS EXTRACT                           /*S71062*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 41 1))            /*S71062*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*S71062*/
/**/                                                                  /*S71062*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             IF         COND(&FCPORS *NE 'B') THEN(DO)                /*CPM003*/
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('Y')               /*S71062*/
/**/                                                                  /*S71062*/
             OVRDBF     FILE(TRANS2) TOFILE(TRANS2) SHARE(*YES)       /*S71062*/
             OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D"') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))                       /*S71062*/
/**/                                                                  /*S71062*/
/************CALL       PGM(PM1142) PARM('F' &FCTVPS)         *S71062* *077485*/
             CALL       PGM(PM1142) PARM('F' &FCTVPS 'L')             /*077485*/
             DLTOVR     FILE(TRANS2)                                  /*S71062*/
             CLOF       OPNID(TRANS2)                                 /*S71062*/
/**/                                                                  /*S71062*/
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('N')               /*S71062*/
/**/                                                                  /*S71062*/
                                                                      /*S71062*/
/* PROCESS ANY DATA BASE ERROR */                                     /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S71062*/
/**/                                                                  /*S71062*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S71062*/
             GOTO       CMDLBL(ABNOR)                                 /*S71062*/
             ENDDO                                                    /*S71062*/
                                                                      /*S71062*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM               /*S71062*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S71062*/
/**/                                                                  /*S71062*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S71062*/
             GOTO       CMDLBL(ABNOR)                                 /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*S71062*/
 
/* CALL DEALING DETAILS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))            * *085812*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 23 1))            /*085812*/
             IF         COND(&MDID = 'Y') THEN(DO)
/*           CALL       PGM(PM1144) PARM('F')                  B08040*/
/*           CALL       PGM(PM1144) PARM('F' &P9TVPS)   B08253*B08040*/
/*********** CALL       PGM(PM1144) PARM('F' &P9TVPS 'L')   */ /*B08253 S01486*/
             CALL       PGM(PM1144) PARM('F' &FCTVPS 'L')             /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL LENDING DETAILS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))           * *085812*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 28 1))            /*085812*/
             IF         COND(&MDID = 'Y') THEN(DO)
/*             CALL       PGM(PM1146) PARM('F')               B08040*/
/*           CALL       PGM(PM1146) PARM('F' &P9TVPS)  B08253*B08040*/
/*********** CALL       PGM(PM1146) PARM('F' &P9TVPS 'L')   */ /*B08253 S01486*/
/************CALL       PGM(PM1146) PARM('F' &FCTVPS 'L')     /*S01486  094712*/
             CALL       PGM(PM1146) PARM('F' &FCTVPS 'L' ' ')         /*094712*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL RETAIL DETAILS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))           * *085812*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 29 1))            /*085812*/
             IF         COND(&MDID = 'Y') THEN(DO)
/*           CALL       PGM(PM1148) PARM('F')                  B08040*/
/*           CALL       PGM(PM1148) PARM('F' &P9TVPS)   058889 *B08040*/
/*********** CALL       PGM(PM1148) PARM('F' &P9TVPS 'M')   */ /*058889 S01486*/
             CALL       PGM(PM1148) PARM('F' &FCTVPS 'L')             /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/**CHECK*FOR*POOL*PORTOFOLIO*REQUIRED*INDICATOR */             /*SA9108 099814*/
/************RTVDTAARA  DTAARA(PMSTAT (35 1)) RTNVAR(&PLPPRQ)   *SA9108 099814*/
/************                                                   *SA9108 099814*/
/**CALL*GENERATION*OF*POOL*PORTOFOLIO*POSITIONS */             /*SA9108 099814*/
/************IF         COND(&PLPPRQ = 'Y') THEN(DO)            *SA9108 099814*/
/************CALL       PGM(PMC1152) PARM(&P9TVPS) /*SA9108*/
/**/                                                                  /*099814*/
/* If Pool Trades Optional Feature present Gen. Pool Positions        /*099814*/
/**/                                                                  /*099814*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CQQ001' +
                          &FMT)                                       /*099814*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*099814*/
             CALL       PGM(PMC1152) /*056986*/
                                                                      /*SA9108*/
/* PROCESS ANY DATA BASE ERROR */                                     /*SA9108*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*SA9108*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*SA9108*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)           */ /*SA9108 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*SA9108*/
             ENDDO                                                    /*SA9108*/
                                                                      /*SA9108*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*SA9108*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*SA9108*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*SA9108*/
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)           */ /*SA9108 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
             GOTO       CMDLBL(ABNOR)                                 /*SA9108*/
             ENDDO                                                    /*SA9108*/
                                                                      /*SA9108*/
             CPYF       FROMFILE(PMPPTDPD) TOFILE(PMSBPDPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*SA9108*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMSBPDPD))                             /*SA9108*/
                                                                      /*SA9108*/
             CPYF       FROMFILE(PMPPTMPD) TOFILE(PMSBPMPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*SA9108*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMSBPMPD))                             /*SA9108*/
             ENDDO                                                    /*SA9108*/
                                                                      /*SA9108*/
/**  Extract forward security positions  */                           /*CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*CPM005*/
                                                                      /*CPM005*/
             CALL       PGM(PMC6200)                                  /*CPM005*/
                                                                      /*CPM005*/
/**  Process any data base errors */                                  /*CPM005*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
             GOTO       CMDLBL(ABNOR)                                 /*CPM005*/
             ENDDO                                                    /*CPM005*/
                                                                      /*CPM005*/
/**  Check for file control errors trapped by the program */          /*CPM005*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
             GOTO       CMDLBL(ABNOR)                                 /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
                                                                      /*CPM005*/
/* RESTORE LF MEMBERS */
/*           ADDLFM     FILE(PMHOLDL1) MBR(PMHOLDL1)   B08253 *B08040*/
/*           ADDLFM     FILE(PMHOLDL2) MBR(PMHOLDL2)   B08253 *B08040*/
             ADDLFM     FILE(PMHOLDL4) MBR(PMHOLDL4)         /*B08040*/
/*********** ADDLFM     FILE(PMHOLDL5) MBR(PMHOLDL5) ***/      /*B08040 CPM005*/
             ADDLFM     FILE(PMHOLDL6) MBR(PMHOLDL6)         /*B08040*/
             ADDLFM     FILE(PMHOLDLA) MBR(PMHOLDLA)                  /*CPM005*/
             ADDLFM     FILE(PMHOLDLB) MBR(PMHOLDLB)                  /*CPM005*/
             ADDLFM     FILE(PMHOLDL9) MBR(PMHOLDL9)                  /*CPM005*/
             ADDLFM     FILE(PMHDVNLL) MBR(PMHDVNLL)         /*B08040*/
/*********** ADDLFM     FILE(PMHOLLX0) MBR(PMHOLLX0)        */ /*S01313 S01486*/
/*********** ADDLFM     FILE(PMHOLLX1) MBR(PMHOLLX1)        */ /*S01313 S01486*/
/*********** ADDLFM     FILE(PMHOLDL7) MBR(PMHOLDL7)          *S01486* *085819*/
/*********** ADDLFM     FILE(PMHOLDL8) MBR(PMHOLDL8)          *S01486* *085819*/
                                                             /*B08040*/
/* CALL PORTFOLIO TOTALS UPDATE PROGRAM */
/*           CALL       PGM(PM1150)                            B08040*/
 
/* PROCESS ANY DATA BASE ERROR */
/*           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)       B08040*/
/*              RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)  B08040*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/*              SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              B08040*/
/*                                                                    /*R00300*/
/*           GOTO       CMDLBL(ABNOR)                          B08040*/
/*           ENDDO                                             B08040*/
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
/*           IF         COND(%SWITCH(XXXXXX01)) THEN(DO)       B08040*/
/*              RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)  B08040*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/*              SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              B08040*/
/*                                                                    /*R00300*/
/*           GOTO       CMDLBL(ABNOR)                          B08040*/
/*           ENDDO                                             B08040*/
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*           DLTF       FILE(XPMCPOSPP)                        B08040*/
/*           MONMSG     MSGID(CPF2105)                         B08040*/
 /*          DLTF       FILE(XPMCPOSZZ)                        B08040*/
 /*          MONMSG     MSGID(CPF2105)                         B08040*/
             DLTF       FILE(PMCSAVF)                         /*B08040*/
             MONMSG     MSGID(CPF2105)                       /*B08040*/
             ENDDO
             GOTO       CMDLBL(ENDPGM)                                /*183309*/
ABNOR:
                                                                      /*183309*/
             DMPCLPGM                                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
             CHGJOB     SWS(XXXXXX11)                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
                                                                      /*183309*/
/*ENDPGM                                                           */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
