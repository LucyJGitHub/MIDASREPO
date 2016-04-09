/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM COB Valuation Statements')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/********PMC0951 - REGULAR PORTFOLIO VALUATION STATEMENTS          */ /*CCG009*/
/*       PMC0951 - EXTRACT REGULAR PORTFOLIO VALUATION STATEMENTS  */ /*CCG009*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 19JUL96              */
/*       Prev Amend No. 101266             DATE 07FEB96              */
/*                      094891             DATE 23OCT95              */
/*                      CCG009             DATE 01JUN95              */
/*                      S01408             DATE 11MAY95              */
/*                      085868             DATE 16MAR95              */
/*                      085853             DATE 14MAR95              */
/*                      081504             DATE 11JAN95              */
/*                      S01486             DATE 14SEP94              */
/*                      073300   JSV       DATE 20SEP94              */
/*                      071348   JSV       DATE 20SEP94              */
/*                      053103   JSV       DATE 20SEP94              */
/*                      058937             DATE 27JUL93              */
/*                      049421     BZ      DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      S01313     DHW     DATE 10JUN92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       101266 - Bank Portfolios                                    */
/*       094891 - Change names of QTEMP files to make them unique    */
/*                and allow QTEMP to appear anywhere in the job's    */
/*                library list                                       */
/*       CCG009 - Private Banking UDC                                */
/*       S01408 - Addition of core hook PMC0951MP1                   */
/*       085868 - ALTERNATE KEY FILES TO BE CREATED IN LIB/QTEMP     */
/*       085853 - Missing parameters                                 */
/*       081504 - OPNQRYF error. Fields do not exist anymore.        */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       073300 - ONLY OUPUT PERFORMANE REPORTS IF VALUATION         */
/*                STATEMENTS TO BE PRINTED WITH PERFORMANCE FIGS     */
/*       071348 - CORRECTION TO FILE NAMES FOR LEUMI                 */
/*       053103 - ADD PARAM. CUSTOMER,PORTFOLIO TO CALLING PMC1160   */
/*                  CALLS TO PMC1660 AND PMC4200 ADDED               */
/*       058937 - ALTERATION TO SEQUENCE OF COB VALUATION STMTS.     */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01313 - REWRITTEN FOR PORTFOLIO PERFORMANCE                */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
/************PGM        PARM(&CNAM &CSEQ)                              *S01486*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLVL &RENT)           /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 S01189*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&WWCNUM) TYPE(*DEC) LEN(6 0)              /*053103*/
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)               /*053103*/
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)               /*053103*/
             DCL        VAR(&WWPODF) TYPE(*CHAR) LEN(1) VALUE('Y')    /*053103*/
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1) VALUE('1')    /*053103*/
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)               /*053103*/
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)               /* 73300*/
 
/************SNDPGMMSG  MSG('PMC0951 - Print Regular Portfolio +   */ /*CCG009*/
/************             Valuation Statements') TOMSGQ(MRUNQ)     */ /*CCG009*/
             SNDPGMMSG  MSG('PMC0951 - Extract Regular Portfolio +
                          Valuation Statements') TOMSGQ(MRUNQ)        /*CCG009*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0951MP1                                          */
                                                                      /*S01408*/
 
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
/*<<S01189<<*/
/************OVRDBF     FILE(XPMPORTPP) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMPORTPP) TOFILE(PMPORTPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMPORTPP))                              *S01486*/
/************CPYF       FROMFILE(XPMRQXSPP) TOFILE(PMRQXSPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMRQXSPP))                              *S01486*/
             OVRDBF     FILE(XPMPORTPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMPORTPD) TOFILE(PMPORTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMPORTPD))                             /*S01486*/
             CPYF       FROMFILE(XPMRQXSPD) TOFILE(PMRQXSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMRQXSPD))                             /*S01486*/
             CPYF       FROMFILE(XSDPLCSPD) TOFILE(SDPLCSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDPLCSPD))
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                **/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/************OVRDBF     FILE(PMPORTPP) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMPORTPP) TOFILE(&TOLIB/XPMPORTPP) +  *S01486*/
/************    MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)          *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMPORTPP))                             *S01486*/
/************CPYF       FROMFILE(PMRQXSPP) TOFILE(&TOLIB/XPMRQXSPP) +  *S01486*/
/************   MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)           *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMRQXSPP))                             *S01486*/
             OVRDBF     FILE(PMPORTPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMPORTPD) TOFILE(&TOLIB/XPMPORTPD) +
                 MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)         /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMPORTPD))                            /*S01486*/
             CPYF       FROMFILE(PMRQXSPD) TOFILE(&TOLIB/XPMRQXSPD) +
                MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)          /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMRQXSPD))                            /*S01486*/
             CPYF       FROMFILE(SDPLCSPD) TOFILE(&TOLIB/XSDPLCSPD) +
                MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDPLCSPD))
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* CALL PGM/PMC1160 TO CALCULATE PERFORMANCE FIGURES */
 
/************CALL       PGM(PMC1160) PARM('    ' '    ' ' ' 'C' +      *053103*/
/************             '     ')                                     *053103*/
/************CALL       PGM(PMC1160) PARM('    ' '    ' ' ' 'C' +      *073300*/
/************             '     ' &WWCNUM &WWPTFR)            *053103* *073300*/
/************CALL       PGM(PMC1160) PARM('    ' '    ' ' ' 'C' +      *S01486*/
/************             '     ' &WWCNUM &WWPTFR &WWPFMR)    *073300* *S01486*/
             CALL       PGM(PMC1160) PARM('    ' '    ' ' ' 'C' +
                          '     ' &WWCNUM &WWPTFR &WWPFMR &RSEQ)      /*S01486*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +   *S01486*/
/************             TOMSGQ(MOPERQ)                               *S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                              /*S01486*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/**OPEN*QRYF*SELECTING STATEMENTS TO BE PRINTED USING STANDARD ACT */ /*CCG009*/
/**FORMAT*AND CALL PM0950 TO PRINT STATEMENTS                      */ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OVRDBF     FILE(PMPTDVPP) SHARE(*YES)                     *S01486*/
/************OVRDBF     FILE(PMPTDVPD) SHARE(*YES)         *S01486**/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *071348*/
/************             QNHLDM *EQ "S" *AND QNVLNT *EQ "A" *OR +     *071348*/
/************             QNVLSR *EQ "Y" *AND QNHLDM *EQ "S" *AND +    *071348*/
/************             QNVLNT *EQ "L"') KEYFLD((QNHLDM) (QNVLNT) +  *071348*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +        *071348*/
/************             (QNADCD) (QNPTFR))                           *071348*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *S01486*/
/************             QNFRMT *EQ "S"') KEYFLD((QNHLDM) (QNVLNT) +  *S01486*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +        *S01486*/
/************             (QNADCD) (QNPTFR))                  *071348* *S01486*/
/************OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +/*CCG009*/
/************             QNFRMT *EQ "S"') KEYFLD((QNHLDM) (QNVLNT) + /*CCG009*/
/************             (QNACOC) (QNLANG) (QNCNUM) (QNRQNO) +       /*CCG009*/
/************             (QNADCD) (QNPTFR))               /*S01486*/ /*CCG009*/
/**/                                                                  /*053103*/
/**CHECK/CREATE*FILE*PMPTRRPP*IN*LIB/QTEMP*********************053103* *S01486*/
/**CHECK/CREATE*FILE*PMPTRRQ0*IN*LIB/QTEMP******************* *S01486* *094891*/
/**CHECK/CREATE*FILE*PMPTRRT0*IN*LIB/QTEMP********************094891* /*101266*/
             IF         COND(&WWPFMR *EQ 'Y') THEN(DO)                /*073300*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRPP) OBJTYPE(*FILE)    *053103* *S01486*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRPP) +  *S01486*/
/************             TOFILE(QTEMP/PMPTRRPP) MBROPT(*ADD) +        *S01486*/
/************             CRTFILE(*YES) NBRRCDS(1))           *053103* *S01486*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) +  *094891*/
/************             TOFILE(QTEMP/PMPTRRQ0) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRT0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPTRRT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/                                                                  /*053103*/
/**CLEAR*FILE*PMPTRRPP*IN*LIB/QTEMP****************************053103* *S01486*/
/************CLRPFM     FILE(QTEMP/PMPTRRPP)                  *053103* *S01486*/
/**CLEAR*FILE*PMPTRRQ0 IN LIB/QTEMP                          *S01486* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTRRQ0)                 *S01486* /*101266*/
/**/                                                                  /*053103*/
/**OPEN*QRYF*PMPFMRPP******************************************053103* *S01486*/
/************OVRDBF     FILE(PMPFMRPP) SHARE(*YES)            *053103* *S01486*/
/************OPNQRYF    FILE((PMPFMRPP)) KEYFLD((QRPRRE) (QRPRTL) +    *S01486*/
/************             (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))*053103* *S01486*/
/**OPEN*QRYF*PMPFMRPD******************************************S01486* *085868*/
/*********** OVRDBF     FILE(PMPFMRPD) SHARE(*YES)            *S01486* *085868*/
/************OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRPRRE) (QRPRTL) +
                          (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))*S01486* *081504*/
/*********** OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRACOC) (QRCNUM) +  * *085868*/
/***********              (QRPTFR) (QRPFMP))                  *081504* *085868*/
/**CREATE*FILE*WITH*ALTERNATE*INDEXES************************ *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRQ2) TOFILE(QTEMP/PMPFMRQ2) +
/************             CRTFILE(*YES)                       *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRQ2) +
/************             MBROPT(*REPLACE)                    *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************                                                 *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRQ3) TOFILE(QTEMP/PMPFMRQ3) +
/************             CRTFILE(*YES)                       *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRQ3) +
/************             MBROPT(*REPLACE)                    *085868* *094891*/
/************MONMSG     MSGID(CPF2817)                        *085868* *094891*/
/**CREATE*FILE WITH ALTERNATE INDEXES                        *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRQ2) TOFILE(QTEMP/PMPFMRT2) +   /*101266*/
/************             CRTFILE(*YES)                      *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRT2) +   /*101266*/
/************             MBROPT(*REPLACE)                   *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************                                                *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRQ3) TOFILE(QTEMP/PMPFMRT3) +   /*101266*/
/************             CRTFILE(*YES)                      *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/************CPYF       FROMFILE(PMPFMRPD) TOFILE(QTEMP/PMPFMRT3) +   /*101266*/
/************             MBROPT(*REPLACE)                   *094891* /*101266*/
/************MONMSG     MSGID(CPF2817)                       *094891* /*101266*/
/* */                                                                 /*101266*/
/* CLEAR/SET WORKFILES */                                             /*101266*/
/* */                                                                 /*101266*/
             CLRPFM     FILE(PMPTRRQ0)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ2) +
                          MBROPT(*REPLACE)                            /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
/* */                                                                 /*101266*/
/**/                                                                  /*053103*/
/* SET PARAMETERS WWMODE, WWRRRQ                                     * *053103*/
                                                                      /*053103*/
             CHGVAR     VAR(&WWRRRQ) VALUE(' ')                       /*053103*/
/**/                                                                  /*053103*/
/* CALL PM1660 TO REPORT PORTFOLIO PERFORMANCE RECONCILIATION    */   /*053103*/
/************CALL    PGM(PM1660) PARM(&WWMODE &WWRRRQ &WWACOC)*053103* *S01486*/
/*********** CALL       PGM(PM1660) PARM(&WWMODE &WWRRRQ &WWACOC +
                          &RSEQ)  *****************/                  /*S01486*/
             CALL       PGM(PM1661) PARM(&WWMODE &WWRRRQ)             /*S01486*/
/**/                                                                  /*053103*/
/**CLOSE*AND*DLTOVR*OF*FILE*PMPFMRPP***************************053103* *S01486*/
/************CLOF       OPNID(PMPFMRPP)                       *053103* *S01486*/
/************DLTOVR     FILE(PMPFMRPP)                        *053103* *S01486*/
/**CLOSE*AND*DLTOVR*OF*FILE*PMPFMRPD***************************S01486* *085868*/
/*********** CLOF       OPNID(PMPFMRPD)                       *S01486* *085868*/
/*********** DLTOVR     FILE(PMPFMRPD)                        *S01486* *085868*/
/**/                                                                  /*053103*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*053103*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*053103*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)          /*053103*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)             *053103* *S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ENDPGM)                                /*053103*/
             ENDDO                                                    /*053103*/
             ENDDO                                                    /*073300*/
 
/************CALL       PGM(PM0950)                                    *S01486*/
/************CALL       PGM(PM0950) PARM(&RSEQ)           /*S01486 */ /*CCG009*/
/************                                                      */ /*CCG009*/
/************DLTOVR     FILE(*ALL)                                 */ /*CCG009*/
/************CLOF       OPNID(PMPTDVPP)                                *S01486*/
/************CLOF       OPNID(PMPTDVPD)                   /*S01486*/  /*CCG009*/
/************                                                      */ /*CCG009*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*CCG009*/
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)          */ /*CCG009*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +   *S01486*/
/************             TOMSGQ(MOPERQ)                               *S01486*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +  /*CCG009*/
/************             TOMSGQ(MOPERQ)                   /*S01486*/ /*CCG009*/
/************GOTO       CMDLBL(ENDPGM)                             */ /*CCG009*/
/************ENDDO                                                 */ /*CCG009*/
 
/**OPEN*QRYF*SELECTING STATEMENTS TO BE PRINTED USING SPECIAL BANK */ /*CCG009*/
/**FORMAT*AND*CALL PM9950 TO PRINT STATEMENTS                      */ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OVRDBF     FILE(PMPTDVPP) SHARE(*YES)                     *S01486*/
/************OVRDBF     FILE(PMPTDVPD) SHARE(*YES          /*S01486*/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND +/*CCG009*/
/************             QNHLDM *EQ "B" *OR QNVLSR *EQ "Y" *AND +    /*CCG009*/
/************             QNVLNT *EQ "C"') KEYFLD((QNHLDM) (QNVLNT) + /*CCG009*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +       /*CCG009*/
/************             (QNADCD) (QNPTFR))                058937 */ /*CCG009*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *071348*/
/************             QNHLDM *EQ "B" *OR QNVLSR *EQ "Y" *AND +     *071348*/
/************             QNVLNT *EQ "C"') KEYFLD((QNHLDM) (QNVLNT) +  *071348*/
/************          (QNPRTL) (QNACOC) (QNCNUM) (QNADCD) (QNPTFR)) + *071348*/
/************              *058937 *                                   *071348*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *S01486*/
/************             QNFRMT *EQ "B"') KEYFLD((QNHLDM) (QNVLNT) +  *S01486*/
/************             (QNPRTL) (QNACOC) (QNCNUM) (QNADCD) +        *S01486*/
/************             (QNPTFR))                           *071348* *S01486*/
/************OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +/*CCG009*/
/************             QNFRMT *EQ "B" ') KEYFLD((QNHLDM) (QNVLNT) +/*CCG009*/
/************             (QNACOC) (QNCNUM) (QNADCD) (QNPTFR*S01486*/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************CALL       PGM(PM9950)                                    *S01486*/
/************CALL       PGM(PM9950) PARM(&RSEQ)            /*S01486*/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************DLTOVR     FILE(*ALL)                                 */ /*CCG009*/
/************CLOF       OPNID(PMPTDVPP)                                *S01486*/
/************CLOF       OPNID(PMPTDVPD)                    /*S01486*/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*CCG009*/
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)          */ /*CCG009*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +   *S01486*/
/************             TOMSGQ(MOPERQ)                               *S01486*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +  /*CCG009*/
/************             TOMSGQ(MOPERQ)                   /*S01486*/ /*CCG009*/
/************GOTO       CMDLBL(ENDPGM)                             */ /*CCG009*/
/************ENDDO                                                 */ /*CCG009*/
/************                                                      */ /*CCG009*/
/**/                                                                  /*053103*/
/* IF EXISTS DIFFERENCES CALL PMC4200                                 /*053103*/
             IF         COND(&WWRRRQ *EQ 'Y') THEN(DO)                /*053103*/
/************* CALL       PGM(PMC4200) PARM(&WWPODF)          *053103* *085853*/
               CALL       PGM(PMC4200) PARM(&WWPODF &RSEQ &RLVL +
                             &RENT)                                   /*085853*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            /*053103*/
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)         /*053103*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +          * *S01486*/
/****************            MSGDTA(&MSG) TOMSGQ(MOPERQ MRUNQ)*053103* *S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&MSG) TOMSGQ(MOPERQ MRUNQ)        /*S01486*/
               GOTO       CMDLBL(ENDPGM)                              /*053103*/
               ENDDO                                                  /*053103*/
             ENDDO                                                    /*053103*/
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/************DLTF       FILE(XPMPORTPP)                                *S01486*/
             DLTF       FILE(XPMPORTPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/************DLTF       FILE(XPMRQXSPP)                                *S01486*/
             DLTF       FILE(XPMRQXSPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XSDPLCSPD)
             MONMSG     MSGID(CPF2105)
             ENDDO
 
/************ENDPGM:        ENDPGM                                     *S01486*/
/**/                                                                  /*CPM005*/
ENDPGM:      DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
