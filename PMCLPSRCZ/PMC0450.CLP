/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Investment Policies Exception Report')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0450 - Portfolio Exceptions Report                       */
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
/*       Prev Amend No. CPM005             Date 06Aug96              */
/*                      085864             Date 15Mar95              */
/*                      080738             DATE 22DEC94              */
/*                      S01486             DATE 08DEC94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 03AUG92              */
/*                      B08087             DATE 16JUL91              */
/*                      R05826             DATE 14APR91              */
/*                      R05679             DATE 14MAR91              */
/*                      R1063              DATE 10JAN91              */
/*                      R1022              DATE 07DEC90              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET / LIABILITY SPLIT        */
/*                PBFG/6 - ADDITIONAL CUSTOMER DETAILS               */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       085864 - Wrong position on customer parameter               */
/*       080738 - Remove field AZPRTL on OPNQRY                      */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PORTFOLIO PERFORMANCE CHANGES                      */
/*       B08087 - SUBMIT JOBS TO JOBQ/FOJOBQ                         */
/*       R05826 - ONLY REPORT PORTFOLIOS WITH EXCEPTION ERRORS       */
/*       R05679 - PROGRAM DOES NOT RUN CORRECTLY INTERACTIVELY       */
/*       R1063  - Parameters missing in the 'CALL' command.          */
/*       R1022  - Position in parameters in wrong.                   */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&WWACOF &WWCUST &WWPREF)              */ /*S01486*/
             PGM        PARM(&MODE &RSEQ &RLVL &RENT &PARM)           /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)           */ /*S01486*/
/*********** DCL        VAR(&WWCLP) TYPE(*CHAR) LEN(7)             */ /*S01486*/
/*********** DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/*********** DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/*********** DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)            */ /*S01486*/
/*********** DCL        VAR(&WWACO1) TYPE(*CHAR) LEN(2)            */ /*S01486*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(2)               /*S01486*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
/*********** DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/*********** DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)            */ /*S01486*/
/*********** DCL        VAR(&WWPARM) TYPE(*CHAR) LEN(29)           */ /*S01486*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
 
/*  Reset external switches                                                   */
 
             CHGJOB     SWS(00000000)
 
/***Retrieve*type*of*job*-*'1'*=*batch******************************/ /*S01486*/
/************************-*'1'*=*interactive************************/ /*S01486*/
 
/*********** RTVJOBA    TYPE(&WWTYPE)                              */ /*S01486*/
 
/***If*batch*job,*bypass*prompt*processing**************************/ /*S01486*/
 
/*********** IF         COND(&WWTYPE *EQ '0') THEN(GOTO CMDLBL(BAT */ /*S01486*/
 
/***Retrieve*user*profile*of*signed*on*user*************************/ /*S01486*/
 
/*********** RTVJOBA    USER(&WWUSRP)                              */ /*S01486*/
 
/***Retrieve*phase*of*daily*processing******************************/ /*S01486*/
 
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)              */ /*S01486*/
 
/***Set*up*program*name*parameter***********************************/ /*S01486*/
 
/*           CHGVAR     VAR(&WWCLP) VALUE('PMC0450')           R05679*/
/*********** CHGVAR     VAR(&WWCLP) VALUE('PMC0451')        */ /*R05679 S01486*/
 
/***Call*program*to*get*report*parameters*prompts*******************/ /*S01486*/
 
/*********** CALL       PGM(PM0800) PARM(&WWCLP &WWUSRP &WWCYCL &WWACOF +
                          &WWCUST &WWPREF &WWINBA &WWRTRN)         */ /*S01486*/
 
/***Data*base*error*processing**************************************/ /*S01486*/
 
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)       */ /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/*                                                                    /*R00300*/
/***********    GOTO       CMDLBL(ENDPGM)                          */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
 
/***If*F3*pressed*in*prompt*program,**terminate*processing**********/ /*S01486*/
 
/*********** IF         COND(&WWRTRN *EQ '1') THEN(DO)             */ /*S01486*/
/***********    GOTO       CMDLBL(ENDPGM)                          */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
 
/***Format*variable*to*be*sent*to*MSGQ/EODQ*************************/ /*S01486*/
 
/************   CHGVAR     VAR(&WWPARM) VALUE('PMC0450    ' *CAT &WWACOF +
                             *BCAT &WWCUST *BCAT &WWPREF)  ******/    /*R1022*/
 
/*********** IF         COND(&WWCYCL *NE 'A') THEN(DO)      */ /*R05679 S01486*/
/*********** CHGVAR     VAR(&WWPARM) VALUE('PMC0450    ' *CAT +
                          &WWACOF *BCAT &WWCUST *BCAT &WWPR */ /*R1022  S01486*/
 
/***Send*message*to**MSGQ/EODQ**************************************/ /*S01486*/
 
/***********    SNDMSG     MSG(&WWPARM) TOMSGQ(EODQ)               */ /*S01486*/
/***********    GOTO       CMDLBL(PM0800)                          */ /*S01486*/
/*********** ENDDO                                          */ /*R05679 S01486*/
/**/
 
/***REPORT*NOT*DURING*EOD*&*JOB*SUBMITTED*TO*BATCH*TO*RUN*PROGRAM:**/ /*S01486*/
/*********** IF         COND(&WWCYCL *EQ 'A' *AND &WWINBA *EQ 'B') +
                          THEN(DO)                          */ /*R05679 S01486*/
/*           SBMJOB     CMD(CALL PGM(PMC0450) PARM(&WWACOF &WWCUST +
                          &WWPREF)) JOBQ(MJOBQ)         B08087 R05679*/
/*********** SBMJOB     CMD(CALL PGM(PMC0450) PARM(&WWACOF &WWCUST +
                          &WWPREF)) JOBQ(FOJOBQ)            */ /*B08087 S01486*/
/*********** GOTO       CMDLBL(PM0800)                      */ /*R05679 S01486*/
/*********** ENDDO                                          */ /*R05679 S01486*/
 
/***Extract*account*officer*name************************************/ /*S01486*/
 
/*********** CHGVAR     VAR(&WWACO1) VALUE(%SST(&WWACOF 1 2))      */ /*S01486*/
/**/                                                                  /*S01486*/
/*********** CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 4 6))   *S01486* *085864*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 5 6))           /*085864*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM 11 4))          /*S01486*/
             CHGVAR     VAR(&WWACOF) VALUE(%SST(&RENT 1 2))           /*S01486*/
 
/*  Override open query file                                                  */
 
/*********** OVRDBF     FILE(PMIVNTPO) TOFILE(*LIBL/SDACOFPD) +
                          SHARE(*YES)                              */ /*S01486*/
             OVRDBF     FILE(PMIVNTQ0) TOFILE(*LIBL/SDACOFPD) +
                          SHARE(*YES)                                 /*S01486*/
             MONMSG     MSGID(CPF0000)
 
/*  Account officer, customer and portfolio '*ALL'                            */
 
/*********** IF         COND(&WWACOF *EQ '*ALL') THEN(DO)          */ /*S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
/*           OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('PNRECI *EQ "D"') +
                          KEYFLD((1/AZPRTL) (1/AZACOC) (3/PNCNUM) +
                          (3/PNPTFR)) JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))                  R05826*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))               */ /*R05826 S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))                  /*S01486 080738*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZACOC) +
                          (3/PNCNUM) (3/PNPTFR)) JFLD((1/AZACOC +
                          2/BBACOC *EQ) (*MAPFLD/BBCUS1 3/PNCNUM)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6 0))          /*080738*/
             ENDDO
 
/*  Account officer entered; customer & portfolio set to '*ALL'           */
 
/*********** IF         COND((&WWACOF *NE '*ALL') +
                           *AND (&WWCUST *EQ '*ALL  ')) THEN(DO)   */ /*S01486*/
             IF         COND((&RENT *NE 'ALL') +
                           *AND (&WWCUST *EQ '*ALL  ')) THEN(DO)      /*S01486*/
/*           OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ BBACOC *AND PNRECI *EQ "D"') +
                          KEYFLD((1/AZPRTL) (1/AZACOC) (3/PNCNUM) +
                          (3/PNPTFR)) JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))                R05826 */
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ BBACOC *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))               */ /*R05826 S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ BBACOC *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0))                  /*S01486 080738*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ BBACOC *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZACOC) +
                          (3/PNCNUM) (3/PNPTFR)) JFLD((1/AZACOC +
                          2/BBACOC *EQ) (*MAPFLD/BBCUS1 3/PNCNUM)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6 0))          /*080738*/
              ENDDO
 
/*  Account officer & customer entered; portolio set to '*ALL'         */
 
/***********  IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE '*ALL  ') +
                                 *AND (&WWPREF *EQ '*ALL')) THEN(D */ /*S01486*/
              IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *NE '*ALL  ') +
                                 *AND (&WWPREF *EQ '*ALL')) THEN(DO)  /*S01486*/
/*           OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ AZACOC *AND "' *CAT &WWCUST +
                          *CAT '" *EQ PNCNM1 *AND PNRECI *EQ "D"') +
                          KEYFLD((1/AZPRTL) (1/AZACOC) (3/PNCNUM) +
                          (3/PNPTFR)) JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0) (PNCNM1 PNCNUM *CHAR 6)) R05826*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ AZACOC *AND "' *CAT &WWCUST +
                          *CAT '" *EQ PNCNM1 *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0) (PNCNM1 PNCNUM */ /*R05826 S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ AZACOC *AND "' *CAT &WWCUST +
                          *CAT '" *EQ PNCNM1 *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                   BBCUST *ZONED 6 0) (PNCNM1 PNCNUM *CHAR 6)) /*S01486 080738*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ AZACOC *AND "' *CAT &WWCUST +
                          *CAT '" *EQ PNCNM1 *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZACOC) +
                          (3/PNCNUM) (3/PNPTFR)) JFLD((1/AZACOC +
                          2/BBACOC *EQ) (*MAPFLD/BBCUS1 3/PNCNUM)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6 0) (PNCNM1 +
                          PNCNUM *CHAR 6))                            /*080738*/
              ENDDO
 
/*  Account officer, customer & portfolio entered                             */
 
/*********** IF         COND((&WWACOF *NE '*ALL') *AND (&WWCUST *NE +
                          '*ALL  ') *AND (&WWPREF *NE '*ALL')) THE */ /*S01486*/
             IF         COND((&RENT *NE 'ALL') *AND (&WWCUST *NE '*ALL  ') +
                          *AND (&WWPREF *NE '*ALL')) THEN(DO)         /*S01486*/
/*           OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ BBACOC *AND PNCNM1 *EQ "' *CAT +
                          &WWCUST *CAT '" *AND PNPTFR *eq "' *CAT +
                          &WWPREF *CAT '"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0) (PNCNM1 PNCNUM *CHAR 6)) R05826*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMIVNTPO) QRYSLT('"' *CAT &WWACO1 +
                          *CAT '" *EQ BBACOC *AND PNCNM1 *EQ "' +
                          *CAT &WWCUST *CAT '" *AND PNPTFR *EQ "' +
                          *CAT &WWPREF *CAT '" *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                          BBCUST *ZONED 6 0) (PNCNM1 PNCNUM */ /*R05826 S01486*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ BBACOC *AND PNCNM1 *EQ "' +
                          *CAT &WWCUST *CAT '" *AND PNPTFR *EQ "' +
                          *CAT &WWPREF *CAT '" *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZPRTL) +
                          (1/AZACOC) (3/PNCNUM) (3/PNPTFR)) +
                          JFLD((1/AZACOC 2/BBACOC *EQ) +
                          (*MAPFLD/BBCUS1 3/PNCNUM)) MAPFLD((BBCUS1 +
                   BBCUST *ZONED 6 0) (PNCNM1 PNCNUM *CHAR 6)) /*S01486 080738*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMIVNTQ0) QRYSLT('"' *CAT &WWACOF +
                          *CAT '" *EQ BBACOC *AND PNCNM1 *EQ "' +
                          *CAT &WWCUST *CAT '" *AND PNPTFR *EQ "' +
                          *CAT &WWPREF *CAT '" *AND PNXPTN *EQ "Y" +
                          *AND PNRECI *EQ "D"') KEYFLD((1/AZACOC) +
                          (3/PNCNUM) (3/PNPTFR)) JFLD((1/AZACOC +
                          2/BBACOC *EQ) (*MAPFLD/BBCUS1 3/PNCNUM)) +
                          MAPFLD((BBCUS1 BBCUST *ZONED 6 0) (PNCNM1 +
                          PNCNUM *CHAR 6))                            /*080738*/
             ENDDO
 
 /***R1063***   CALL       PGM(PM0450) PARM(&WWACOF)     ****/
 /********** CALL       PGM(PM0450) PARM(&WWACOF &WWCUST &W  */ /*R1063 S01486*/
             CALL       PGM(PM0450) PARM(&RENT &WWCUST &WWPREF &RSEQ) /*S01486*/
                CLOF       OPNID(SDACOFPD)
/***********    DLTOVR     FILE(PMIVNTPO)                          */ /*S01486*/
                DLTOVR     FILE(PMIVNTQ0)                             /*S01486*/
 
/*  Database error processing                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  File out of balance processing      */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/***********     SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                 SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*********** IF         COND(&WWINBA *EQ 'I') THEN(DO)      */ /*R05679 S01486*/
/*********** GOTO       CMDLBL(PM0800)                      */ /*R05679 S01486*/
/*********** ENDDO                                          */ /*R05679 S01486*/
 
/*********** IF         COND(&WWINBA *NE 'I') THEN(DO)      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMCCYTPP)                      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMCCYTX0)                      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMCNTTPP)                      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMCNTTX0)                      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMINDTPP)                      */ /*S01313 S01486*/
/*********** CLRPFM     FILE(PMINDTX0)                      */ /*S01313 S01486*/
             IF         COND(&MODE *EQ '1') THEN(DO)                  /*S01486*/
/*********** CLRPFM     FILE(PMCCYTPD)                         /*S01486 CPM005*/
             CLRPFM     FILE(PMCCYWPD)                                /*S01486*/
             CLRPFM     FILE(PMCNTTPD)                                /*S01486*/
             CLRPFM     FILE(PMCNTWPD)                                /*S01486*/
             CLRPFM     FILE(PMINDTPD)                                /*S01486*/
             CLRPFM     FILE(PMINDWPD)                                /*S01486*/
             ENDDO                                           /*S01313*/
/*               GOTO       CMDLBL(ENDPGM)                     R05679*/
 
/*ENDTAG:     DMPCLPGM                                         R05679*/
 
/*ENDPGM:     RCLRSC                                           R05679*/
/*           ENDPGM                                            R05679*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                          /*R05679*/
