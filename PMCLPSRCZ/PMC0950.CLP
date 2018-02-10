/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM I/C Valuation Statements')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0950 - I/C CUSTOMER VALUATION STATEMENTS                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CPM005             Date 19Jul96              */
/*                      101266             DATE 07FEB96              */
/*                      094891             DATE 23OCT95              */
/*                      CCG009             DATE 01JUN95              */
/*                      085868             DATE 16MAR95              */
/*                      085853             DATE 14MAR95              */
/*                      082269             DATE 27JAN95              */
/*                      082266             DATE 27JAN95              */
/*                      082265             DATE 27JAN95              */
/*                      S01486             DATE 14SEP94              */
/*                      73300 JSV          DATE 20SEP94              */
/*                      71348 JSV          DATE 20SEP94              */
/*                      53103 JSV          DATE 20SEP94              */
/*                      56460              DATE 11JUN93              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 10JUN92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       101266 - Bank Portfolios                                    */
/*       094891 - Change names of QTEMP files to make them unique    */
/*                and allow QTEMP to appear anywhere in the job's    */
/*                library list                                       */
/*       CCG009 - Private Banking UDC                                */
/*       085868 - ALTERNATE KEY FILES TO BE CREATED IN LIB/QTEMP     */
/*       085853 - Missing parameters                                 */
/*       082269 - Report Sequence corrupted when calling PM1660.     */
/*       082266 - Parameters do not match those required             */
/*       082265 - Open Query File Failure - QRPRRE not found         */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       73300  - ADDITIONAL PARAMETER PERFORMANCE REQUIRED          */
/*       71348  - CORRECT SPOOL FILE NAMES FOR LEUMI                 */
/*       53103  - ADD PARAM. CUSTOMER,PORTFOLIO TO CALLING PMC1160   */
/*                CALLS TO PMC1660 AND PMC4200 ADDED                 */
/*       56460  - RECLAIM RESOURCES AT END OF PROGRAM                */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - REWRITTEN FOR PORTFOLIO PERFORMANCE                */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWTNLA)                                  *S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01486*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(52)
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1) VALUE('I')
             DCL        VAR(&WWTNLA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WWCNUM) TYPE(*DEC) LEN(6 0)              /*053103*/
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)               /*053103*/
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)               /*053103*/
             DCL        VAR(&WWPODF) TYPE(*CHAR) LEN(1) VALUE('Y')    /*053103*/
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)               /*073300*/
/**********  DCL        VAR(&WSEQ) TYPE(*CHAR) LEN(5) ***  /*082269*/ /*CCG009*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*CCG009*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*CCG009*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*CCG009*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CCG009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST') /*CCG009*/
/*/COPY WNCPYSRC,PMC0950001                                          */
                                                                      /*CCG009*/
/* Begin commitment control */                                        /*CCG009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*CCG009 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
             CHGVAR     VAR(&WWTNLA) VALUE(%SUBSTRING(&RPARM 1 5))    /*S01486*/
             SNDPGMMSG  MSG('PMC0950 - PM Valuation Statements') +
                          TOMSGQ(MRUNQ)
 
/* CALL PMC1160 TO CALCULATE SECTOR TOTALS AND PERFORMANCE STATISTICS */
/************CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +    *053103*/
/************             &WWMODE &WWTNLA)                             *053103*/
/************CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +    *073300*/
/************             &WWMODE &WWTNLA &WWCNUM &WWPTFR)    *053103* *073300*/
/************CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +    *S01486*/
/************         &WWMODE &WWTNLA &WWCNUM &WWPTFR &WWPFMR)*073300* *S01486*/
             CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +
                          &WWMODE &WWTNLA &WWCNUM &WWPTFR &WWPFMR +
                          &RSEQ)                                      /*S01486*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
 
/* IF DATABASE ERROR TERMINATE PROGRAM */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ENDPGM))
 
/*/COPY WNCPYSRC,PMC0950002                                          */
/* */                                                                 /*CCG009*/
/* User Defined Correspondence processing  */                         /*CCG009*/
/* */                                                                 /*CCG009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCG009*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CCG009*/
/* */                                                                 /*CCG009*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*CCG009*/
/* */                                                                 /*CCG009*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CCG009*/
/* */                                                                 /*CCG009*/
/** Database error handling                                           /*CCG009*/
/* */                                                                 /*CCG009*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CCG009*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*CCG009*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)       +
                          MSGTYPE(*INFO)                              /*CCG009*/
             GOTO       CMDLBL(ENDPGM)                                /*CCG009*/
             ENDDO                                                    /*CCG009*/
                                                                      /*CCG009*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CCG009*/
                                                                      /*CCG009*/
             OVRDBF     FILE(PMPTDVXX) TOFILE(PMPTDVPD) SHARE(*NO)    /*CCG009*/
                                                                      /*CCG009*/
             CALL       PGM(CG4150) PARM(&W0RTN &W0CMT)               /*CCG009*/
                                                                      /*CCG009*/
             RCLRSC                                                   /*CCG009*/
                                                                      /*CCG009*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*CCG009*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*CCG009*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ)       +
                          MSGTYPE(*INFO)                              /*CCG009*/
             ROLLBACK                                                 /*CCG009*/
             GOTO       CMDLBL(ENDPGM)                                /*CCG009*/
             ENDDO                                                    /*CCG009*/
                                                                      /*CCG009*/
/* Prompt for immediate print */                                      /*CCG009*/
             CALL       PGM(CGC5217) PARM(' ')                        /*CCG009*/
                                                                      /*CCG009*/
             ENDDO                                                    /*CCG009*/
/* */                                                                 /*CCG009*/
/**OPEN*QRYF*SELECTING STATEMENTS TO BE PRINTED USING STANDARD ACT */ /*CCG009*/
/**FORMAT*AND*CALL PM0950 TO PRINT STATEMENTS                      */ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OVRDBF     FILE(PMPTDVPP) SHARE(*YES)                     *S01486*/
/************OVRDBF     FILE(PMPTDVPD) SHARE(*YES)         /*S01486*/ /*CCG009*/
/************                                                      */ /*CCG009*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *071348*/
/************             QNHLDM *EQ "S" *AND QNVLNT *EQ "A" *OR +     *071348*/
/************             QNVLSR *EQ "Y" *AND QNHLDM *EQ "S" *AND +    *071348*/
/************             QNVLNT *EQ "L"') KEYFLD((QNHLDM) (QNVLNT) +  *071348*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +        *071348*/
/************             (QNADCD) (QNPTFR))                           *071348*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *S01486*/
/************             QNFRMT *EQ "S"') KEYFLD((QNHLDM) +           *S01486*/
/************             (QNVLNT) (QNPRTL) (QNLANG) (QNCNUM) +        *S01486*/
/************             (QNRQNO) (QNADCD) (QNPTFR))         *071348* *S01486*/
/************OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +/*CCG009*/
/************             QNFRMT *EQ "S" ') KEYFLD((QNHLDM) +         /*CCG009*/
/************             (QNVLNT) (QNACOC) (QNLANG) (QNCNUM) +       /*CCG009*/
/************             (QNRQNO) (QNADCD) (QNPTFR))     /*S01486*/  /*CCG009*/
/**/                                                                  /*053103*/
/**CHECK/CREATE*FILE*PMPTRRPP*IN*LIB/QTEMP*********************053103* *S01486*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRPP) OBJTYPE(*FILE)    *053103* *S01486*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRPP) +  *S01486*/
/************             TOFILE(QTEMP/PMPTRRPP) MBROPT(*ADD) +        *S01486*/
/************             CRTFILE(*YES) NBRRCDS(1))           *053103* *S01486*/
/**CHECK/CREATE*FILE*PMPTRRQ0*IN*LIB/QTEMP******************* *S01486* *094891*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRQ0) OBJTYPE(*FILE)    *S01486* *094891*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) +  *094891*/
/************             TOFILE(QTEMP/PMPTRRQ0) MBROPT(*ADD) +        *094891*/
/************             CRTFILE(*YES) NBRRCDS(1))           *S01486* *094891*/
/**CHECK/CREATE FILE PMPTRRT0 IN LIB/QTEMP                   *094891* /*101266*/
/************CHKOBJ     OBJ(QTEMP/PMPTRRT0) OBJTYPE(*FILE)   *094891* /*101266*/
/************MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRQ0) + /*101266*/
/************             TOFILE(QTEMP/PMPTRRT0) MBROPT(*ADD) +       /*101266*/
/************             CRTFILE(*YES) NBRRCDS(1))          *094891* /*101266*/
/**/                                                                  /*053103*/
/**CLEAR*FILE*PMPTRRPP*IN*LIB/QTEMP****************************053103* *S01486*/
/************CLRPFM     FILE(QTEMP/PMPTRRPP)                  *053103* *S01486*/
/**CLEAR*FILE*PMPTRRQ0*IN*LIB/QTEMP************************** *S01486* *094891*/
/************CLRPFM     FILE(QTEMP/PMPTRRQ0)                  *S01486* *094891*/
/**CLEAR*FILE PMPTRRT0 IN LIB/QTEMP                          *094891* /*101266*/
/************CLRPFM     FILE(QTEMP/PMPTRRT0)                 *094891* /*101266*/
/**/                                                                  /*053103*/
/**OPEN*QRYF*PMPFMRPP******************************************053103* *S01486*/
/************OVRDBF     FILE(PMPFMRPP) SHARE(*YES)            *053103* *S01486*/
/************OPNQRYF    FILE((PMPFMRPP)) KEYFLD((QRPRRE) (QRPRTL) +    *S01486*/
/************             (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))*053103* *S01486*/
/* OPEN QRYF PMPFMRPD                                                * *S01486*/
/*********** OVRDBF     FILE(PMPFMRPD) SHARE(*YES)            *S01486* *085868*/
/*********** OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRPRRE) (QRPRTL) +    *082265*/
/***********              (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))*S01486* *082265*/
/*********** OPNQRYF    FILE((PMPFMRPD)) KEYFLD((QRACOC) (QRCNUM) +  * *085868*/
/***********              (QRPTFR) (QRPFMP))                  *082265* *085868*/
/**/                                                                  /*053103*/
/* SET PARAMETERS WWMODE, WWRRRQ                                     * *053103*/
                                                                      /*053103*/
             CHGVAR     VAR(&WWMODE) VALUE('1')                       /*053103*/
             CHGVAR     VAR(&WWRRRQ) VALUE(' ')                       /*053103*/
                                                                      /*085868*/
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
/**/                                                                  /*053103*/
/* CALL PM1660 TO REPORT PORTFOLIO PERFORMANCE RECONCILIATION    */   /*053103*/
/*********** CHGVAR     VAR(&WSEQ) VALUE(&RSEQ)            /*082269*/ /*CCG009*/
/*********** CHGVAR     VAR(&RSEQ) VALUE('     ')          /*082269*/ /*CCG009*/
/************CALL    PGM(PM1660) PARM(&WWMODE &WWRRRQ &WWACOC)*053103* *S01486*/
/*********** CALL       PGM(PM1660) PARM(&WWMODE &WWRRRQ &WWACOC +     *082266*/
/***********              &RSEQ)                              *S01486* *082266*/
/* */                                                                 /*101266*/
/* CLEAR/SET WORKFILES */                                             /*101266*/
/* */                                                                 /*101266*/
             CLRPFM     FILE(PMPTRRQ0)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ2) +
                          MBROPT(*REPLACE)                            /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ3) +
                          MBROPT(*REPLACE)                            /*101266*/
             MONMSG     MSGID(CPF2817)                                /*101266*/
/* */                                                                 /*101266*/
             OVRDBF     FILE(PMPFMRT2) TOFILE(PMPFMRQ2)               /*101266*/
             OVRDBF     FILE(PMPFMRT3) TOFILE(PMPFMRQ3)               /*101266*/
             OVRDBF     FILE(PMPTRRT0) TOFILE(PMPTRRQ0)               /*101266*/
             CALL       PGM(PM1660) PARM(&WWMODE &WWRRRQ &RSEQ +
                          &RLVL &RENT)                                /*082266*/
/*********** CHGVAR     VAR(&RSEQ) VALUE(&WSEQ)            /*082269*/ /*CCG009*/
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
/* */                                                                 /*CCG009*/
/* OPEN QRYF SELECTING STATEMENTS TO BE PRINTED USING STANDARD     */ /*CCG009*/
/* FORMAT AND CALL PM0950 TO PRINT STATEMENTS                      */ /*CCG009*/
                                                                      /*CCG009*/
             OVRDBF     FILE(PMPTDVPD) SHARE(*YES)                    /*CCG009*/
                                                                      /*CCG009*/
             OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +
                          QNEUDC *NE "Y" *AND QNFRMT *EQ "S" ') +
                          KEYFLD((QNHLDM) (QNVLNT) (QNACOC) +
                          (QNLANG) (QNCNUM) (QNRQNO) (QNADCD) +
                          (QNPTFR))                                   /*CCG009*/
 
/************CALL       PGM(PM0950)                                    *S01486*/
             CALL       PGM(PM0950) PARM(&RSEQ)                       /*S01486*/
 
             DLTOVR     FILE(*ALL)
/************CLOF       OPNID(PMPTDVPP)                                *S01486*/
             CLOF       OPNID(PMPTDVPD)                               /*S01486*/
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
 
/* OPEN QRYF SELECTING STATEMENTS TO BE PRINTED USING SPECIAL BANK   */
/* FORMAT AND CALL PM9950 TO PRINT STATEMENTS                        */
 
/************OVRDBF     FILE(PMPTDVPP) SHARE(*YES)                     *S01486*/
             OVRDBF     FILE(PMPTDVPD) SHARE(*YES)                    /*S01486*/
 
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *071348*/
/************             QNHLDM *EQ "B" *OR QNVLSR *EQ "Y" *AND +     *071348*/
/************             QNVLNT *EQ "C"') KEYFLD((QNHLDM) (QNVLNT) +  *071348*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +        *071348*/
/************             (QNADCD) (QNPTFR))                           *071348*/
/************OPNQRYF    FILE((PMPTDVPP)) QRYSLT('QNVLSR *EQ "Y" *AND + *S01486*/
/************             QNFRMT *EQ "B"') KEYFLD((QNHLDM) (QNVLNT) +  *S01486*/
/************             (QNPRTL) (QNLANG) (QNCNUM) (QNRQNO) +        *S01486*/
/************             (QNADCD) (QNPTFR))                  *071348* *S01486*/
/************OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +/*CCG009*/
/************             QNFRMT *EQ "B"') KEYFLD((QNHLDM) (QNVLNT) + /*CCG009*/
/************             (QNACOC) (QNLANG) (QNCNUM) (QNRQNO) +       /*CCG009*/
/************             (QNADCD) (QNPTFR))              /*S01486*/  /*CCG009*/
                                                                      /*CCG009*/
             OPNQRYF    FILE((PMPTDVPD)) QRYSLT('QNVLSR *EQ "Y" *AND +
                          QNEUDC *NE "Y" *AND QNFRMT *EQ "B"') +
                          KEYFLD((QNHLDM) (QNVLNT) (QNACOC) +
                          (QNLANG) (QNCNUM) (QNRQNO) (QNADCD) +
                          (QNPTFR))                                   /*CCG009*/
 
/************CALL       PGM(PM9950)                                    *S01486*/
             CALL       PGM(PM9950) PARM(&RSEQ)                       /*S01486*/
 
             DLTOVR     FILE(*ALL)
/************CLOF       OPNID(PMPTDVPP)                                *S01486*/
             CLOF       OPNID(PMPTDVPD)                               /*S01486*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
 
             RCLRSC                                         /*56460 */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MSG)
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MSG) +   *S01486*/
/************             TOMSGQ(MOPERQ)                               *S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MSG) +
                          TOMSGQ(MOPERQ)                              /*S01486*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*/COPY WNCPYSRC,PMC0950003                                          */
/**/                                                                  /*053103*/
/* IF EXISTS DIFFERENCES CALL PMC4200                                * *053103*/
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
               ENDDO                                                  /*053103*/
             ENDDO                                                    /*053103*/
/***********ENDPGM:        ENDPGM                                      *S01486*/
/**/                                                                  /*CPM005*/
ENDPGM:      DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
