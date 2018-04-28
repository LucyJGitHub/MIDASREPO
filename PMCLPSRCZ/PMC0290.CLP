/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio details prompt and report')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0290 - PM PORTFOLIO DETAILS REPORT                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             Date 03Jul96              */
/*       Prev Amend No. S01486             Date 17Aug94              */
/*                      063196             Date 07Jul93              */
/*                      58180              DATE 07JUL93              */
/*                      049421             DATE 18JAN93              */
/*                      45867              DATE 19OCT92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                Recompiled due to new fields on PF/PMPORTPD        */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       063196 - MISSING PARAMETER ON SUBMITTED  JOB                */
/*       58180  - WHEN JOB SUBMITTED TO BATCH CREATE LDA IN QTEMP    */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       45867  - REWRITTEN FOR COB PROCESSING                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM       PARM(&WWACOF &WWCUST &WWPREF &WWDETT &GBCH) */ /*S01486*/
             PGM      PARM(&MODE &RSEQ &RLVL &RENT &PARM)             /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01486*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/*********** DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)           */ /*S01486*/
/*********** DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1))           */ /*S01486*/
/*********** DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1))           */ /*S01486*/
/*********** DCL        VAR(&MODE) TYPE(*CHAR) LEN(1))             */ /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&RENT2) TYPE(*CHAR) LEN(2)                /*S01486*/
/*********** DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)            */ /*S01486*/
/*********** DCL        VAR(&WWACO1) TYPE(*CHAR) LEN(2)            */ /*S01486*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWDETT) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/************DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/************DCL        VAR(&WWPARX) TYPE(*CHAR) LEN(31)           */ /*S01486*/
/************DCL        VAR(&WWPAR1) TYPE(*CHAR) LEN(10)           */ /*S01486*/
/************DCL        VAR(&WWPAR2) TYPE(*CHAR) LEN(9)            */ /*S01486*/
/************DCL        VAR(&WWPAR3) TYPE(*CHAR) LEN(15)           */ /*S01486*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&GBCH) TYPE(*CHAR) LEN(1)              */ /*S01486*/
 
/* Global monitor message error trap                                 */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/***Retrieve*phase*of*daily*processing******************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)              */ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF         COND(&GBCH *EQ '1') THEN(DO)               */ /*S01486*/
/***********            CHGVAR VAR(&MODE) VALUE('1')               */ /*S01486*/
/***********            CHGVAR VAR(&WWTYPE) VALUE('0')             */ /*S01486*/
/*********** GOTO       CMDLBL(BATCH)                              */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
 
/*  Reset external switches                                                   */
 
             CHGJOB     SWS(00000000)
 
/***Determine*processing*mode***************************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF         COND(&WWCYCL *EQ 'A') THEN(CHGVAR VAR(&MODE) +/*S01486*/
/***********              VALUE('2'))                              */ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF         COND(&WWCYCL *NE 'A') THEN(CHGVAR VAR(&MODE) +/*S01486*/
/***********              VALUE('1'))                              */ /*S01486*/
/***********                                                       */ /*S01486*/
/***Retrieve*type*of*job*-*'0'*=*batch******************************/ /*S01486*/
/************************-*'1'*=*interactive************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** RTVJOBA    TYPE(&WWTYPE)                              */ /*S01486*/
/***********                                                       */ /*S01486*/
/***If*batch*job, bypass*promp* processing**************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF      COND(&WWTYPE *EQ '0') THEN(GOTO CMDLBL(BATCH))*/ /*S01486*/
/***********                                                       */ /*S01486*/
/***Retrieve*user*profile*of*signed*on*user*************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** RTVJOBA    USER(&WWUSRP)                              */ /*S01486*/
/***********                                                       */ /*S01486*/
/***Call*program*to*get*report*parameters*prompts*******************/ /*S01486*/
/***********                                                       */ /*S01486*/
/****PM0830: CALL    PGM(PM0830) PARM(&WWUSRP &WWCYCL &WWACOF +    */ /*S01486*/
/***********           &WWCUST &WWPREF &WWDETT &WWINBA &WWRTRN +   */ /*S01486*/
/***********              &GBCH)                                   */ /*S01486*/
/***Data*base*error*processing**************************************/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)       */ /*S01486*/
/*********SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  */ /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/***********                                                       */ /*S01486*/
/*************  GOTO       CMDLBL(ENDPGM)                          */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
/***********                                                       */ /*S01486*/
/***If*F3*pressed*in*prompt*program,**terminate*processing**********/ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** IF         COND(&WWRTRN *EQ '1') THEN(DO)             */ /*S01486*/
/***********    GOTO       CMDLBL(ENDPGM)                          */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/***********                                                       */ /*S01486*/
/***********                                                       */ /*S01486*/
/***REPORT*RUN*DURING*COB*SEND*PROGRAM*AND*PARAMETER*TO*MSGQ/EODQ***/ /*S01486*/
/*********** IF         COND(&GBCH *EQ '2') THEN(DO)               */ /*S01486*/
/***********                                                       */ /*S01486*/
/***********     CHGVAR    VAR(&WWPAR1) VALUE('PMC0290   ')        */ /*S01486*/
/***********     CHGVAR    VAR(&ERROR) VALUE(' ')                  */ /*S01486*/
/***********     CHGVAR    VAR(&WWPAR2) VALUE('10001')             */ /*S01486*/
/***********     CHGVAR    VAR(&WWPAR3) VALUE('*CAT &WWACOF +      */ /*S01486*/
/***********          *BCAT &WWCUST *BCAT &WWPREF *BCAT &WWDETT')  */ /*S01486*/
/***********     CHGVAR    VAR(&WWPARX) VALUE('*CAT &WWPAR1 +      */ /*S01486*/
/***********                 *CAT &WWPAR2 *CAT &WWPAR3')           */ /*S01486*/
/***********                                                       */ /*S01486*/
/**UPDATE*WORK*FILE*************************************************/ /*S01486*/
/***********    CALL PGM(PM0290A) PARM(&WWPAR1 &WWPAR2 &WWACOF +   */ /*S01486*/
/***********                 &WWCUST &WWPREF &WWDETT)              */ /*S01486*/
/*********** GOTO       CMDLBL(LOIN)                               */ /*S01486*/
/***********                                                       */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/***********                                                       */ /*S01486*/
/*REPORT*RUN*DURINGI/C*OR ON REQ SUBMIT JOB TO BATCH TO RUN PROGRAM*/ /*S01486*/
/*********** IF    COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'B') +    */ /*S01486*/
/*********** IF    COND(&GBCH *NE '2') THEN(DO)                    */ /*063196*/
/*********** IF         COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'B') +  /*S01486*/
/***********              THEN(DO)                          */ /*063196 S01486*/
/*********** SBMJOB CMD(CALL PGM(PMC0290) PARM(&WWACOF &WWCUST +   */ /*063196*/
/***********                 &WWPREF &WWDETT)) JOBQ(FOJOBQ)        */ /*063196*/
/***********    SBMJOB     CMD(CALL PGM(PMC0290) PARM(&WWACOF &/*063196 S01486*/
/***********                 &WWPREF &WWDETT &GBCH)) JOBQ(FOJOB/*063196 S01486*/
/*********** GOTO       CMDLBL(LOIN)                               */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/***********                                                       */ /*S01486*/
/***Extract*account*officer*name************************************/ /*S01486*/
/***BATCH:**    CHGVAR     VAR(&WWACO1) VALUE(%SST(&WWACOF 1 2))   */ /*S01486*/
/***********                                                       */ /*S01486*/
/**CREATE*DTAARA/LDA*IN*QTEMP***************************************/ /*S01486*/
/*********** CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +   */ /*S01486*/
/***********              TEXT('Midas/ABS SD Local Data Area')  /*58180 S01486*/
/*********** MONMSG     MSGID(CPF0000)                       */ /*58180 S01486*/
/***********                                                       */ /*S01486*/
/*REPORT*RUN*DURINGI/C*OR*ON*REQSUBMIT*JOB*TO*BATCH*TO*RUN*PROGRAM */ /*S01486*/
/********IF         COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'I' *OR +*/ /*S01486*/
/***********              &WWTYPE *EQ '0') THEN(DO)                */ /*S01486*/
/**/
/*  OVERRIDE OPEN QUERY FILE                                                  */
/*********** OVRDBF     FILE(PMACCUPO) TOFILE(PMPORTPP) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMACCUQ0) TOFILE(PMPORTPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/**/
/***ACCOUNT*OFFICER,*CUSTOMER*AND*PORTFOLIO*'*ALL'******************/ /*S01486*/
/*********** IF         COND(&WWACOF *EQ '*ALL') THEN(DO)          */ /*S01486*/
/*********** OPNQRYF FILE((*LIBL/PMPORTPP) (SDCUSTPD) (SDACOFPD))  */ /*S01486*/
/***********          FORMAT(PMACCUPO) QRYSLT('PNRECI *EQ "D"') +  */ /*S01486*/
/***********          KEYFLD((AZPRTL) (BBACOC) (PNCNUM) (PNPTFR))  */ /*S01486*/
/***********          JFLD((PMPORTPP/PNCNUM *MAPFLD/BBCUS1 *EQ) +  */ /*S01486*/
/***********          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +         */ /*S01486*/
/***********          MAPFLD((BBCUS1 BBCUST *ZONED 6))             */ /*S01486*/
/***********    CALL       PGM(PM0290) PARM(&MODE &WWACOF &WWDETT) */ /*S01486*/
/***********    CLOF       OPNID(PMPORTPP)                         */ /*S01486*/
/***********    DLTOVR     FILE(PMACCUPO)                          */ /*S01486*/
/*********** ENDDO                                                    /*S01486*/
/**/
/***ACOF*ENTERED;*CUST*&*PORTFOLIO*SET*TO*'*ALL'                  */  /*S01486*/
/************IF         COND((&WWACOF *NE '*ALL') +                   /*S01486*/
/************              *AND (&WWCUST *EQ '*ALL  ')) THEN(DO)      /*S01486*/
/************OPNQRYF    FILE((*LIBL/PMPORTPP) (SDCUSTPD) (SDACOFPD)) +/*S01486*/
/************             FORMAT(PMACCUPO) QRYSLT('"' *CAT &WWACO1 +  /*S01486*/
/************             *CAT '" *EQ BBACOC *AND PNRECI *EQ "D"') +  /*S01486*/
/************             KEYFLD((AZPRTL) (BBACOC) (PNCNUM) (PNPTFR)) /*S01486*/
/************             JFLD((PMPORTPP/PNCNUM *MAPFLD/BBCUS1 *EQ) + /*S01486*/
/************             (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +        /*S01486*/
/************             MAPFLD((BBCUS1 BBCUST *ZONED 6))            /*S01486*/
/************    CALL       PGM(PM0290) PARM(&MODE &WWACOF &WWDETT)   /*S01486*/
/************    CLOF       OPNID(PMPORTPP)                           /*S01486*/
/************    DLTOVR     FILE(PMACCUPO)                            /*S01486*/
/************ ENDDO                                                   /*S01486*/
/**/                                                                  /*S01486*/
/***ACOF*&*CUST*ENTERED;*PORTFOLIO*REFERERENCE*'*ALL'                 /*S01486*/
/***IF******   COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE '*ALL  ') +/*S01486*/
/***********                     *AND (&WWPREF *EQ '*ALL')) THEN(DO)  /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/PMPORTPP) (SDCUSTPD) (SDACOFPD)) +/*S01486*/
/***********              FORMAT(PMACCUPO) QRYSLT('"' *CAT &WWACO1 +  /*S01486*/
/***********              *CAT '" *EQ BBACOC *AND "' *CAT &WWCUST +   /*S01486*/
/***********              *CAT '" *EQ PNCNM1 *AND PNRECI *EQ "D"') +  /*S01486*/
/***********              KEYFLD((AZPRTL) (BBACOC) (PNCNUM) (PNPTFR)) /*S01486*/
/***********              JFLD((PMPORTPP/PNCNUM *MAPFLD/BBCUS1 *EQ) + /*S01486*/
/***********              (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +        /*S01486*/
/***********              MAPFLD((BBCUS1 BBCUST *ZONED 6) (PNCNM1 +   /*S01486*/
/***********              PNCNUM *CHAR 6))                            /*S01486*/
/***********    CALL       PGM(PM0290) PARM(&MODE &WWACOF &WWDETT)    /*S01486*/
/***********    CLOF       OPNID(PMPORTPP)                            /*S01486*/
/***********    DLTOVR     FILE(PMACCUPO)                             /*S01486*/
/***********  ENDDO                                                   /*S01486*/
/**/                                                                  /*S01486*/
/***ACOF,*CUST*&*PORTFOLIO*NOT*'*ALL'                                 /*S01486*/
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE + /*S01486*/
/***********              '*ALL  ') *AND (&WWPREF *NE '*ALL')) THEN(DO/*S01486*/
/*********** OPNQRYF    FILE((*LIBL/PMPORTPP) (SDCUSTPD) (SDACOFPD)) +/*S01486*/
/***********              FORMAT(PMACCUPO) QRYSLT('"' *CAT &WWACO1 +  /*S01486*/
/***********              *CAT '" *EQ BBACOC *AND PNCNM1 *EQ "' *CAT +/*S01486*/
/***********              &WWCUST *CAT '" *AND PNPTFR *eq "' *CAT +   /*S01486*/
/***********              &WWPREF *CAT '"') KEYFLD((AZPRTL) (BBACOC) +/*S01486*/
/***********              (PNCNUM) (PNPTFR)) JFLD((PMPORTPP/PNCNUM +  /*S01486*/
/***********              *MAPFLD/BBCUS1 *EQ) (SDCUSTPD/BBACOC +      /*S01486*/
/***********              SDACOFPD/AZACOC)) MAPFLD((BBCUS1 BBCUST +   /*S01486*/
/***********              *ZONED 6) (PNCNM1 PNCNUM *CHAR 6))          /*S01486*/
/***********    CALL       PGM(PM0290) PARM(&MODE &WWACOF &WWDETT)    /*S01486*/
/***********    CLOF       OPNID(PMPORTPP)                            /*S01486*/
/***********    DLTOVR     FILE(PMACCUPO)                             /*S01486*/
/*********** ENDDO                                                    /*S01486*/
/*********** ENDDO                                                    /*S01486*/
/**/                                                                  /*S01486*/
/* BUILD VARIABLES */                                                 /*S01486*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 1 6))           /*S01486*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM 7 4))           /*S01486*/
             CHGVAR     VAR(&WWDETT) VALUE(%SST(&PARM 11 1))          /*S01486*/
/*                **/                                                 /*S01486*/
/* LEVEL = SYSTEM, OR =ACCOUNT OFFICER +ENTITY ALL                    /*S01486*/
/* OR  =DEPARTMENT +ENTITY ALL                                        /*S01486*/
             IF         COND((&RLVL *EQ 'S') *OR ((&RLVL *EQ 'A') +
                          *AND (&RENT *EQ 'ALL')) +
                          *OR ((&RLVL *EQ 'D') *AND (&RENT *EQ 'ALL'))) +
                          THEN(DO)                                    /*S01486*/
/* ALL CUSTOMERS SELECTED WITH ALL PORTFOLIOS */                      /*S01486*/
             IF         COND((&WWCUST *EQ '*ALL  ') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('PNRECI *EQ "D"') +
                          KEYFLD((BBACOC) (PNCNUM) (PNPTFR)) +
                          JFLD((PMPORTPD/PNCNUM *MAPFLD/BBCUS1) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6 +
                          0))                                         /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH ALL PORTFOLIOS **/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND PNRECI *EQ "D"') +
                          KEYFLD((BBACOC) (PNCNUM) (PNPTFR)) +
                          JFLD((PMPORTPD/PNCNUM *MAPFLD/BBCUS1 *EQ) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6) (WWCUS1 +
                          &WWCUST *ZONED 6))                          /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH SPECIFIC PORTFOLIO **/             /*S01486*/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *NE +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND "' *CAT &WWPREF +
                          *CAT '" *EQ PNPTFR *AND PNRECI *EQ "D"') +
                          KEYFLD((BBACOC) (PNCNUM) (PNPTFR)) +
                          JFLD((PMPORTPD/PNCNUM *MAPFLD/BBCUS1 *EQ) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6) (WWCUS1 +
                          &WWCUST *ZONED 6))                          /*S01486*/
             ENDDO                                                    /*S01486*/
             ENDDO                                                    /*S01486*/
/* LEVEL = ACCOUNT OFFICER */                                         /*S01486*/
             IF         COND((&RLVL *EQ 'A') *AND (&RENT *NE 'ALL')) +
                          THEN(DO)                                    /*S01486*/
             CHGVAR     VAR(&RENT2) VALUE(%SST(&RENT 1 2))            /*S01486*/
/* ALL CUSTOMERS SELECTED WITH ALL PORTFOLIOS */                      /*S01486*/
             IF         COND((&WWCUST *EQ '*ALL  ') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND BBACOC = "' *CAT &RENT2 *CAT '"') +
                          KEYFLD((BBACOC) (PNCNUM) (PNPTFR)) +
                          JFLD((PMPORTPD/PNCNUM *MAPFLD/BBCUS1 *EQ) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6))            /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH ALL PORTFOLIOS **/                 /*S01486*/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND PNRECI *EQ "D" +
                          *AND BBACOC = "' *CAT &RENT2 *CAT '"') +
                          KEYFLD((BBACOC) +
                          (PNCNUM) (PNPTFR)) JFLD((PMPORTPD/PNCNUM +
                          *MAPFLD/BBCUS1 *EQ) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((BBCUS1 BBCUST +
                          *ZONED 6) (WWCUS1 &WWCUST *ZONED 6))        /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH SPECIFIC PORTFOLIO **/             /*S01486*/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *NE +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND "' *CAT &WWPREF *CAT '" +
                          *EQ PNPTFR *AND PNRECI *EQ "D" +
                          *AND BBACOC = "' *CAT &RENT2 *CAT '"') +
                          KEYFLD((BBACOC) (PNCNUM) +
                          (PNPTFR)) JFLD((PMPORTPD/PNCNUM +
                          *MAPFLD/BBCUS1 *EQ) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((BBCUS1 BBCUST +
                          *ZONED 6) (WWCUS1 &WWCUST *ZONED 6))        /*S01486*/
             ENDDO                                                    /*S01486*/
             ENDDO                                                    /*S01486*/
/* LEVEL = DEPARTMENT      */                                         /*S01486*/
             IF         COND((&RLVL *EQ 'D') *AND (&RENT *NE 'ALL')) +
                          THEN(DO)                                    /*S01486*/
/* ALL CUSTOMERS SELECTED WITH ALL PORTFOLIOS */                      /*S01486*/
             IF         COND((&WWCUST *EQ '*ALL  ') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND AZDPCD = "' *CAT &RENT *CAT '"') +
                          KEYFLD((BBACOC) (PNCNUM) (PNPTFR)) +
                          JFLD((PMPORTPD/PNCNUM *MAPFLD/BBCUS1 *EQ) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6))            /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH ALL PORTFOLIOS **/                 /*S01486*/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *EQ +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND PNRECI *EQ "D" +
                          *AND AZDPCD = "' *CAT &RENT *CAT '"') +
                          KEYFLD((BBACOC) +
                          (PNCNUM) (PNPTFR)) JFLD((PMPORTPD/PNCNUM +
                          *MAPFLD/BBCUS1 *EQ) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((BBCUS1 BBCUST +
                          *ZONED 6) (WWCUS1 &WWCUST *ZONED 6))        /*S01486*/
             ENDDO                                                    /*S01486*/
/* SPECIFIC CUSTOMER SELECTED WITH SPECIFIC PORTFOLIO **/             /*S01486*/
             IF         COND((&WWCUST *NE '*ALL') *AND (&WWPREF *NE +
                          '*ALL')) THEN(DO)                           /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMACCUQ0) QRYSLT('*MAPFLD/WWCUS1 +
                          *EQ PNCNUM *AND "' *CAT &WWPREF *CAT '" +
                          *EQ PNPTFR *AND PNRECI *EQ "D" +
                          *AND AZDPCD = "' *CAT &RENT *CAT '"') +
                          KEYFLD((BBACOC) (PNCNUM) +
                          (PNPTFR)) JFLD((PMPORTPD/PNCNUM +
                          *MAPFLD/BBCUS1 *EQ) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((BBCUS1 BBCUST +
                          *ZONED 6) (WWCUS1 &WWCUST *ZONED 6))        /*S01486*/
             ENDDO                                                    /*S01486*/
             ENDDO                                                    /*S01486*/
 /* */                                                                /*S01486*/
 /* CALL REPORT PROGRAM WITH DETAIL PARAMETER TO SHOW OR NOT */       /*S01486*/
 /*  THE INVESTMENT POLICIES ATTACHED ON THE PORTFOLIO */             /*S01486*/
 /* */                                                                /*S01486*/
             CALL PM0290 (&MODE &WWDETT &RLVL &RSEQ)                  /*S01486*/
                CLOF       OPNID(PMPORTPD)                            /*S01486*/
                DLTOVR     FILE(PMACCUQ0)                             /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01486*/
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
 
/************    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)/*S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
 
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*  FILE OUT OF BALANCE ERROR IF U8 ON  */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
 
/*************   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) +           /*S01486*/
/*************            TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
                 SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
 
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*****LOIN:**                                                         /*S01486*/
/************                                                         /*S01486*/
/**If*batch*job,*terminate*processing */                              /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************   GOTO       CMDLBL(ENDPGM)                             /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/**Return*to*prompt*screen */                                         /*S01486*/
/************                                                         /*S01486*/
/************GOTO       CMDLBL(PM0830)                                /*S01486*/
/************                                                         /*S01486*/
             GOTO       CMDLBL(ENDPGM)                                /*S01486*/
 ENDTAG:     DMPCLPGM
 
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
