/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Setup PM files with new base currency')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6400 - SETUP PM FILES WITH NEW BASE CURRENCY             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731             Date 11Jul01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM005             Date 24Jun96              */
/*                      S01124     VT      Date 13Jun94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
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
/*       S01124 - PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
/*                  VERSION RELEASE III                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
/**********  DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)               * *CPM005*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*CPM005*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&TOLLIB) TYPE(*CHAR) LEN(10)             * *CPM005*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)              * *CPM005*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(200)               /*CPM005*/
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
/**********  DCL        VAR(&DARUN) TYPE(*CHAR) LEN(5)               * *CPM005*/
/**********  DCL        VAR(&CPT) TYPE(*DEC) LEN(2 0) VALUE(0)       * *CPM005*/
/**********  DCL        VAR(&PLPPRQ) TYPE(*CHAR) LEN(1)              * *CPM005*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM005*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM005*/
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)               /*CPM005*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*CPM005*/
 
             DCLF       FILE(SDPORTPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*183309*/
                                                                      /*183309*/
             RCVF       RCDFMT(SDPORTD0)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC6400 - PM Setup PM Files with +
                          New Base Currency') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**********  CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')         * *CPM005*/
/**********  CHGVAR     VAR(&TOLLIB) VALUE(&PRE *TCAT 'DLLIB')       * *CPM005*/
             CHGVAR     VAR(&DILIB) VALUE(&PRE *TCAT 'DILIB')         /*CPM005*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*CPM005*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
 
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
             CHGDTAARA  DTAARA(PMSTAT (29 5)) VALUE(&DAECD)
             CHGDTAARA  DTAARA(PMSTAT (69 2)) VALUE('NN')
 
/*********** CPYF       FROMFILE(&DMLIB/PMEVCYPP) +                  * *CPM005*/
/***********              TOFILE(QTEMP/PMEVCYPP) MBROPT(*NONE) +     * *CPM005*/
/***********              CRTFILE(*YES) FMTOPT(*NONE)                * *CPM005*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)               * *CPM005*/
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMHOLDPP)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDZZ)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDX0)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDX1)                               * *CPM005*/
/*********** CLRPFM     FILE(PMEVCYPP)                               * *CPM005*/
             CLRPFM     FILE(PMHOLDPD)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDPA)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDQ0)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDQ1)                                /*CPM005*/
             CLRPFM     FILE(PMEVCYPD)                                /*CPM005*/
 
/* OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY */
             OVRDBF     FILE(PMPCBCL1) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/PMPCBCL1)) +
                          FORMAT(*LIBL/PMPCBCL1) QRYSLT('FMCDAA *LE +
                          "' *CAT &DAECD *CAT '" *AND FMRECI *EQ +
                          "D"') KEYFLD((FMCUST *ASCEND) (FMPTFR +
                          *ASCEND) (FMCDAT *ASCEND)) MAPFLD((FMCDA1 +
                          FMCDAT *ZONED 5 0) (FMCDAA FMCDA1 *CHAR 5))
/* CALL PM6450 */
             CALL       PGM(PM6450)
 
             DLTOVR     FILE(PMPCBCL1)
             CLOF       OPNID(PMPCBCL1)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* ONLY PERFORM EXTRACTS FOR PORTFOLIOS REQUIRING A STATEMENT */
 
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
/*********** IF         COND(%SST(&PMSTAT 70 1) *NE 'Y') THEN(GOTO +  /*183309*/
/***********              CMDLBL(ABNOR))                              /*183309*/
             IF         COND(%SST(&PMSTAT 70 1) *NE 'Y') THEN(GOTO +
                          CMDLBL(END))                                /*183309*/
 
/*********** CLRPFM     FILE(&TOLIB/PLBPLEGP)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PFIDEPOP)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PFILOANP)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PPMCPOSP)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PTRANSD)                         * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PDEALSDB)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PDEALSDC)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PCLOANCL)                        * *CPM005*/
/*********** CLRPFM     FILE(&TOLIB/PACCNTAB)                        * *CPM005*/
             CLRPFM     FILE(&TOLIB/PMBPLGPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBCPSPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBTRNPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBDLBPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBDLCPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBCLLPD)                         /*CPM005*/
             CLRPFM     FILE(&TOLIB/PMBACNPD)                         /*CPM005*/
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
                                                                      /*CPM005*/
/* CHECK FOR COMPONENT RESTART */                                     /*CPM005*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*CPM005*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*CPM005*/
                                                                      /*CPM005*/
/* IF RESTART AFTER ANY ERROR */                                      /*CPM005*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*CPM005*/
/**********  RSTOBJ     OBJ(PMCPOSPD PMCPOSPA) SAVLIB(&DMLIB) +       */       /*CPM005*/ /*207764*/
/**********              DEV(*SAVF) SAVF(&DILIB/PMCSAVF) MBROPT(*ALL) */       /*CPM005*/ /*207764*/
             RSTOBJ     OBJ(PMCPOSPD PMCPOSPA) SAVLIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/PMCSAVF) +
                          MBROPT(*ALL) OUTPUT(*PRINT)                                     /*207764*/
             ENDDO                                                    /*CPM005*/
                                                                      /*CPM005*/
/* IF FIRST RUN */                                                    /*CPM005*/
             IF         COND(&BUSY = 'N') THEN(DO)                    /*CPM005*/
             CHKOBJ     OBJ(&DILIB/PMCSAVF) OBJTYPE(*FILE)            /*CPM005*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                       /*CPM005*/
                   CRTSAVF    FILE(&DILIB/PMCSAVF)                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
             CLRSAVF    FILE(&DILIB/PMCSAVF)                          /*CPM005*/
/**********  SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) +
/**********               DEV(*SAVF) SAVF(&DILIB/PMCSAVF)             /*CPM005 192731*/
/**********  SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) + */                /*192731*/ /*207764*/
/**********               DEV(*SAVF) SAVF(&DILIB/PMCSAVF)  + */                /*192731*/ /*207764*/
/**********               USEOPTBLK(*NO)                     */                /*192731*/ /*207764*/
             SAVOBJ     OBJ(PMCPOSPD PMCPOSPA) LIB(&DMLIB) +
                          DEV(*SAVF) SAVF(&DILIB/PMCSAVF)  +
                          USEOPTBLK(*NO) OUTPUT(*PRINT)                                   /*207764*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')                   /*CPM005*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*CPM005*/
             ENDDO                                                    /*CPM005*/
 
/**RETRIEVE*DTAARA*MMOD*TO*CHECK*MODULES*PRESENT********************** *CPM005*/
/*********** RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                   * *CPM005*/
/* ACCESS SDMMODPD TO CHECK MODULES PRESENT                          * *CPM005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM005*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM005*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &MMOD)         /*CPM005*/
 
/* PERFORM PROCESSING TO UPDATE ALL PORTFOLIOS IN BASE CURRENCY IND */
/* BEFORE EXTRACTING POSITION DETAILS TO WORK FILE */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
             IF         COND((&FCTVPS *NE 'T') *AND (&FCTVPS *NE +
                          'V')) THEN(DO)                              /*183309*/
             SNDPGMMSG  MSGID(PEM0003) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*183309*/
             GOTO       CMDLBL(ABNOR)                                 /*183309*/
             ENDDO                                                    /*183309*/
                                                                      /*183309*/
/*********** IF         COND(&P9TVPS *EQ 'V') THEN(DO)               * *CPM005*/
             IF         COND(&FCTVPS *EQ 'V') THEN(DO)                /*CPM005*/
             OVRDBF     FILE(PMCPLTLL) TOFILE(PMCPLVLL) SHARE(*NO)
             ENDDO
 
             CALL       PGM(PM1134)
 
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
             CALL       PGM(PM6400)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*********** RMVM       FILE(PMHOLDL4) MBR(PMHOLDL4)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLDL6) MBR(PMHOLDL6)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLDL7) MBR(PMHOLDL7)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLDL8) MBR(PMHOLDL8)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLDL9) MBR(PMHOLDL9)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHDVNLL) MBR(PMHDVNLL)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLLX0) MBR(PMHOLLX0)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
/*********** RMVM       FILE(PMHOLLX1) MBR(PMHOLLX1)                 * *CPM005*/
/*********** MONMSG     MSGID(CPF5815 CPF7310)                       * *CPM005*/
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMHOLDPP)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDZZ)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDX0)                               * *CPM005*/
/*********** CLRPFM     FILE(PMHOLDX1)                               * *CPM005*/
 
/*********** OVRDBF     FILE(PMHOLDPP) SEQONLY(*YES 100)             * *CPM005*/
/*********** OVRDBF     FILE(PMHOLDX0) SEQONLY(*YES 100)             * *CPM005*/
/*********** OVRDBF     FILE(PMHOLDX1) SEQONLY(*YES 100)             * *CPM005*/
 
             CLRPFM     FILE(PMHOLDPD)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDPA)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDQ0)                                /*CPM005*/
             CLRPFM     FILE(PMHOLDQ1)                                /*CPM005*/
 
             OVRDBF     FILE(PMHOLDPD) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMHOLDQ0) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMHOLDQ1) SEQONLY(*YES 100)              /*CPM005*/
 
/* CALL LOMBARD CREDITS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 82 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 76 1))
             IF         COND(&MDID = 'Y') THEN(DO)
/*********** OVRDBF     FILE(PMPLEGPO) TOFILE(SDPLCSPD) SHARE(*YES)  * *CPM005*/
/*********** OVRDBF     FILE(PMPLEGPN) TOFILE(SDPLCSLL) SHARE(*YES)  * *CPM005*/
/***********                                                         * *CPM005*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSPD) (PLBPLEGP)) +          * *CPM005*/
/***********              FORMAT(PMPLEGPO) QRYSLT('QBRECI = "D" & +  * *CPM005*/
/***********              (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +* *CPM005*/
/***********              = "C" *OR PGTYPE = "S" *OR PGTYPE = +      * *CPM005*/
/***********              "G")') KEYFLD((PGCNUM) (PGCCY)) +          * *CPM005*/
/***********              JFLD((PGCNUM *MAPFLD/WWCUST)) +            * *CPM005*/
/***********              MAPFLD((WWCUST QBCUST *ZONED 6 0))         * *CPM005*/
/***********                                                         * *CPM005*/
/*********** OPNQRYF    FILE((*LIBL/SDPLCSLL) (PLBPLEGP)) +          * *CPM005*/
/***********              FORMAT(PMPLEGPN) QRYSLT('QBRECI = "D" & +  * *CPM005*/
/***********              (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +* *CPM005*/
/***********              = "C" *OR PGTYPE = "S" *OR PGTYPE = +      * *CPM005*/
/***********              "G")') KEYFLD((PGISSB) (PGCCY)) +          * *CPM005*/
/***********              JFLD((PGISSB *MAPFLD/WWCUST)) +            * *CPM005*/
/***********              MAPFLD((WWCUST QBCUST *ZONED 6 0))         * *CPM005*/
             OVRDBF     FILE(PMPLEGQ0) TOFILE(SDPLCSPD) SHARE(*YES)   /*CPM005*/
             OVRDBF     FILE(PMPLEGQ1) TOFILE(SDPLCSL1) SHARE(*YES)   /*CPM005*/
 
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (PMBPLGPD)) +
                          FORMAT(PMPLEGQ0) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +
                          = "C" *OR PGTYPE = "S" *OR PGTYPE = +
                          "G")') KEYFLD((PGCNUM) (PGCCY)) +
                          JFLD((PGCNUM *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*CPM005*/
 
             OPNQRYF    FILE((*LIBL/SDPLCSL1) (PMBPLGPD)) +
                          FORMAT(PMPLEGQ1) QRYSLT('QBRECI = "D" & +
                          (PGRECI = "D") & (PGTYPE = "P" *OR PGTYPE +
                          = "C" *OR PGTYPE = "S" *OR PGTYPE = +
                          "G")') KEYFLD((PGISSB) (PGCCY)) +
                          JFLD((PGISSB *MAPFLD/WWCUST)) +
                          MAPFLD((WWCUST QBCUST *ZONED 6 0))          /*CPM005*/
 
/*********** CALL       PGM(PM1136) PARM(&P9TVPS 'L')                * *CPM005*/
             CALL       PGM(PM1136) PARM(&FCTVPS 'L')                 /*CPM005*/
 
             CLOF       OPNID(SDPLCSPD)
/**********  CLOF       OPNID(SDPLCSLL)                              * *CPM005*/
             CLOF       OPNID(SDPLCSL1)                               /*CPM005*/
 
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
 
/**CALL*FIDUCIARY*DETAILS*EXTRACT************************************* *CPM005*/
/**********  CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))           * *CPM005*/
/**********  IF         COND(&MDID = 'Y') THEN(DO)                   * *CPM005*/
/**********  OVRDBF     FILE(FIDPLNP2) TOFILE(PFIDPLN2) SHARE(*YES)  * *CPM005*/
/**********  CALL       PGM(PM1138) PARM(&P9TVPS 'L')                * *CPM005*/
/**********                                                          * *CPM005*/
/**PROCESS*ANY*DATA*BASE*ERROR**************************************** *CPM005*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             * *CPM005*/
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
/**********     GOTO       CMDLBL(ABNOR)                             * *CPM005*/
/**********  ENDDO                                                   * *CPM005*/
/**********                                                          * *CPM005*/
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM*************** *CPM005*/
/**********  IF         COND(%SWITCH(XXXXXX01)) THEN(DO)             * *CPM005*/
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
/**********     GOTO       CMDLBL(ABNOR)                             * *CPM005*/
/**********  ENDDO                                                   * *CPM005*/
/**********  ENDDO                                                   * *CPM005*/
 
/* CALL SECURITY DETAILS EXTRACT */
/*********** CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)
             OVRDBF     FILE(SECET) TOFILE(SECET) SHARE(*NO)
 
/**********  IF         COND(&P9TVPS *EQ 'T') THEN(DO)               * *CPM005*/
/**********  OVRDBF     FILE(PMCPOSXX) TOFILE(PPMCPSTL) SHARE(*NO)   * *CPM005*/
             IF         COND(&FCTVPS *EQ 'T') THEN(DO)                /*CPM005*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMBCSTLL) SHARE(*NO)    /*CPM005*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO
 
/**********  IF         COND(&P9TVPS *EQ 'V') THEN(DO)               * *CPM005*/
/**********  OVRDBF     FILE(PMCPOSXX) TOFILE(PPMCPSVL) SHARE(*NO)   * *CPM005*/
             IF         COND(&FCTVPS *EQ 'V') THEN(DO)                /*CPM005*/
             OVRDBF     FILE(PMCPOSXX) TOFILE(PMBCSVLL) SHARE(*NO)    /*CPM005*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             ENDDO
 
/**********  OVRDBF     FILE(PMAPOSLL) TOFILE(PPMAPOSL) SHARE(*NO)   * *CPM005*/
/**********  OVRDBF     FILE(PMAPOSLX) TOFILE(PPMAPOSL) SHARE(*NO)   * *CPM005*/
/**********  OVRDBF     FILE(PMCPOSL0) TOFILE(PPMCPOS0) SHARE(*NO)   * *CPM005*/
/**********  OVRDBF     FILE(PMHPOSLL) TOFILE(PPMHPOSL) SHARE(*NO)   * *CPM005*/
/**********  OVRDBF     FILE(PMCPOSLL) TOFILE(PPMCPOSL)              * *CPM005*/
             OVRDBF     FILE(PMAPOSLL) TOFILE(PMBAPSLL) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMAPOSLX) TOFILE(PMBAPSLL) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMCPOSL0) TOFILE(PMBCPSL0) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMHPOSLL) TOFILE(PMBHPSLL) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMCPOSLL) TOFILE(PMBCPSLL)               /*CPM005*/
 
/**********  CALL       PGM(PM1140) PARM('F' &P9TVPS 'L')            * *CPM005*/
             CALL       PGM(PM1140) PARM('F' &FCTVPS 'L')             /*CPM005*/
 
             DLTOVR     FILE(*ALL)
 
/**********  OVRDBF     FILE(PMHOLDPP) SEQONLY(*YES 100)             * *CPM005*/
/**********  OVRDBF     FILE(PMHOLDX0) SEQONLY(*YES 100)             * *CPM005*/
/**********  OVRDBF     FILE(PMHOLDX1) SEQONLY(*YES 100)             * *CPM005*/
             OVRDBF     FILE(PMHOLDPD) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMHOLDQ0) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMHOLDQ1) SEQONLY(*YES 100)              /*CPM005*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL FUTURES AND OPTIONS DETAILS EXTRACT */
/**********  CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 41 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('Y')
 
/**********  OVRDBF     FILE(TRANS2) TOFILE(PTRANS2)                 * *CPM005*/
             OVRDBF     FILE(TRANS2) TOFILE(PMBTRNL2)                 /*CPM005*/
             OPNQRYF    FILE((TRANS2)) QRYSLT('PTFR *NE "    " *AND +
                          RECI *EQ "D"') KEYFLD((ISTT) (YRNO) (MTHN) +
                          (PCAL) (STRP) (CUSC))
 
/**********  CALL       PGM(PM1142) PARM('F' &P9TVPS)                * *CPM005*/
             CALL       PGM(PM1142) PARM('F' &FCTVPS 'L')             /*CPM005*/
             CLOF       OPNID(TRANS2)
             DLTOVR     FILE(*ALL)
 
             CHGDTAARA  DTAARA(FFSTAT (2 1)) VALUE('N')
 
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL DEALING DETAILS EXTRACT */
/*********   CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))            * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 23 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
/* OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY */
/**********  OVRDBF     FILE(DEALSP2) TOFILE(PDEALSP2)               * *CPM005*/
/**********  CALL       PGM(PM1144) PARM('F' &P9TVPS 'L')            * *CPM005*/
             OVRDBF     FILE(PMDEALL2) TOFILE(PMBDELL2)               /*CPM005*/
             CALL       PGM(PM1144) PARM('F' &FCTVPS 'L')             /*CPM005*/
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL LENDING DETAILS EXTRACT */
/**********  CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 28 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
/* OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY */
/**********    OVRDBF     FILE(CLOANP2) TOFILE(PCLOANP2)             * *CPM005*/
/**********    CALL       PGM(PM1146) PARM('F' &P9TVPS 'L')          * *CPM005*/
               OVRDBF     FILE(PMCLONL2) TOFILE(PMBCLNL2)             /*CPM005*/
               CALL       PGM(PM1146) PARM('F' &FCTVPS 'L' ' ')       /*CPM005*/
               DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* CALL RETAIL DETAILS EXTRACT */
/**********  CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 29 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
/**********     OVRDBF     FILE(ACCNTP2) TOFILE(PACCNTP2)            * *CPM005*/
                OVRDBF     FILE(PMACCNL3) TOFILE(PMBACNL3)            /*CPM005*/
/* OPEN QUERY FILE TO SELECT RECORD CHANGED TODAY */
/**********     CALL       PGM(PM1148) PARM('F' &P9TVPS 'L')         * *CPM005*/
/**********     DLTOVR     FILE(ACCNTP2)                             * *CPM005*/
                CALL       PGM(PM1148) PARM('F' &FCTVPS 'L')          /*CPM005*/
                DLTOVR     FILE(PMACCNL3)                             /*CPM005*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* EXTRACT FORWARD SECURITY POSITIONS  */
/**********  CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))           * *CPM005*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 31 1))            /*CPM005*/
             IF         COND(&MDID = 'Y') THEN(DO)
 
             CALL       PGM(PMC6200)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        * *CPM005*/
/**********   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + *CPM005*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                    * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/**RESTORE*LF*MEMBERS************************************************* *CPM005*/
/**********  ADDLFM     FILE(PMHOLDL4) MBR(PMHOLDL4)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLDL6) MBR(PMHOLDL6)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLDL7) MBR(PMHOLDL7)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLDL8) MBR(PMHOLDL8)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLDL9) MBR(PMHOLDL9)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHDVNLL) MBR(PMHDVNLL)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLLX0) MBR(PMHOLLX0)                 * *CPM005*/
/**********  ADDLFM     FILE(PMHOLLX1) MBR(PMHOLLX1)                 * *CPM005*/
 
/**********  DLTF       FILE(QTEMP/PMEVCYPP)                         * *CPM005*/
/**********  MONMSG     MSGID(CPF2105)                               * *CPM005*/
                                                                      /*CPM005*/
/* IF JOB ENDED NORMALLY */                                           /*CPM005*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CPM005*/
                   CHGVAR     VAR(&BUSY) VALUE('N')                   /*CPM005*/
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*CPM005*/
             DLTF       FILE(PMCSAVF)                                 /*CPM005*/
             MONMSG     MSGID(CPF2105)                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
             GOTO       CMDLBL(END)                                   /*183309*/
 
ABNOR:
                                                                      /*183309*/
             DMPCLPGM                                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
             CHGJOB     SWS(XXXXXX11)                                 /*183309*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*183309*/
                                                                      /*183309*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
