/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolios Closing Today Report')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0380 PM CHARGES ON PORTFOLIOS CLOSING TODAY              */
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
/*       PREV AMEND NO. 085859             DATE 15MAR95              */
/*                      S01486             DATE 03OCT94              */
/*                      58180              DATE 07JUL93              */
/*                      049421     BZ      DATE 18JAN93              */
/*                      35631      DT      DATE 10FEB92              */
/*                      B8087              DATE 25SEP91              */
/*                      B7915              DATE 05JUN91              */
/*                      B7866              DATE 28MAY91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       085859  -  Wrong file used                                  */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       58180   -  WHEN JOB SUBMITTED TO BATCH CREATE LDA IN QTEMP  */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       35631   -  TWO *AND IN OPNQRY COMMAND                       */
/*       B8087   -  SUBMIT JOBS TO JOBQ/FOJOBQ                       */
/*       B7915   -  ONLY SELESCT PORTFOLIOS WITH BANK CHARGE CCY     */
/*       B7866   -  ALTER PROGRAM TO REPORT ALL PORTFOLIOS           */
/*       R00300  -  Message file changes.                            */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&WWACOF &WWCUST &WWPREF)              */ /*S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT &PARM)                 /*S01486*/
 /**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52) *******/        /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&CLP) TYPE(*CHAR) LEN(7) VALUE(PMC0380)
/*********** DCL        VAR(&WWUSRP)PTYPE(*CHAR)NLEN(10)*****/        /*S01486*/
/*********** DCL        VAR(&WWCYCL)PTYPE(*CHAR)NLEN(1)******/        /*S01486*/
/*********** DCL        VAR(&WWTYPE)PTYPE(*CHAR)NLEN(1)******/        /*S01486*/
             DCL        VAR(&WWACO1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
/**/
             CHGJOB     SWS(00000000)
 
/*  RETRIEVE EVENT CONTROL DATE                                        */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
/*  BUILD PARAMETERS */                                               /*S01486*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 1 6))           /*S01486*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM 11 4))        /*S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(CHGVAR +
                          VAR(&WWACOF) VALUE('*ALL'))                 /*S01486*/
             ELSE       CMD(CHGVAR VAR(&WWACOF) VALUE(&RENT))         /*S01486*/
 
 
/*********** RTVJOBA    TYPE(&WWTYPE) ****************************/   /*S01486*/
/**/                                                                  /*S01486*/
/**PERFORM*BATCH*PROCESSING**/                                        /*S01486*/
/**********  IF  COND(&WWTYPE *EQ '0') THEN(GOTO CMDLBL(BATCH))***/   /*S01486*/
/*********/
/**IF*PROGRAM*OT*UNNING*IN*BATCH*MODE*CALL*INPUT*CYCLE*PROMPTPROGRAM* /*S01486*/
/*********** RTVJOBA    USER(&WWUSRP)******************************/  /*S01486*/
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)**************/  /*S01486*/
 /*PM0800:*****CALL**PGM(PM0800) PARM(&CLP &WWUSRP &WWCYCL &WWACOF */ /*S01486*/
/************************ &WWCUST &WWPREF &WWINBA &WWRTRN)**********/ /*S01486*/
/***********                                                       */ /*S01486*/
/**TERMINATE*PROGRAM*WITH*DATABASE*ERROR****************************/ /*S01486*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) */ /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) */ /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/***********                                                */ /*R00300 S01486*/
/*********** GOTO       CMDLBL(ENDPGM)                             */ /*S01486*/
/*********** ENDDO                                                 */ /*S01486*/
/*********** IF         COND(&WWRTRN *EQ '1') THEN(DO)             */ /*S01486*/
/*********** GOTO       CMDLBL(ENDPGM)                             */ /*S01486*/
/****ENDDO**                                                       */ /*S01486*/
/***********                                                       */ /*S01486*/
/**SUBMIT*REPORT*TO*BE*PRODUCED*IN*BATCH****************************/ /*S01486*/
/*********** IF         COND(&WWINBA *EQ 'B') THEN(DO)             */ /*S01486*/
/*>>B8087>>*/
/************SBMJOB     CMD(CALL PGM(PMC0380) PARM(&WWACOF &WWCUST +
                          &WWPREF)) JOBQ(MJOBQ)*/
/*********** SBMJOB     CMD(CALL PGM(PMC0380) PARM(&WWACOF &WWCUST +  /*S01486*/
/***********              &WWPREF)) JOBQ(FOJOBQ)                   */ /*S01486*/
/*<<B8087<<*/
/*********** GOTO       CMDLBL(PM0800)              **************/   /*S01486*/
/*********** ENDDO   *********************************************/   /*S01486*/
/**/
/* PRODUCE REPORT IN BATCH */
/**BATCH:******CHGVAR*****VAR(&WWACO1) VALUE(%SST(&WWACOF 1 2))***/   /*S01486*/
               CHGVAR     VAR(&WWACO1) VALUE(%SST(&WWACOF 1 2))       /*S01486*/
 
/* CREATE DTAARA/LDA IN QTEMP */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')            /*58180 */
             MONMSG     MSGID(CPF0000)                                /*58180 */
 
/*********** OVRDBF     FILE(PMPORTJF) TOFILE(SDACOFPD) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMPORTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/**/
/* SELECT DETAILS FOR ALL ACCOUNT OFFICERS */
             IF         COND(&WWACOF *EQ '*ALL') THEN(DO)
/*           OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND W1DPCL *GT 0 *AND W2DPCL *LE "' *CAT +
                          &DAECD *CAT '" ') KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6) (W1DPCL PNDPCL *ZONED 5) (W2DPCL +
                          W1DPCL *CHAR 5))                     B7866*/
/*********** OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +      /*S01486*/
/***********              FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +   /*S01486*/
/***********              *AND PNBCGY *NE "   "') +                   /*S01486*/
/***********              KEYFLD((SDACOFPD/AZPRTL) +                  /*S01486*/
/***********              (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +       /*S01486*/
/***********              (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +   /*S01486*/
/***********              SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +         /*S01486*/
/***********              SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +   /*S01486*/
/***********              *CHAR 6))                    */ /*B7915 B7866 S01486*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMPORTQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   "') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST) (PMPORTPD/PNPTFR)) +
                          JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((W1CNUM PNCNUM *CHAR 6))             /*S01486*/
     GOTO CMDLBL(LBLPGM)
     ENDDO
/**/
/* SELECT DETAILS FOR ALL CUSTOMERS */
     IF COND(&WWCUST *EQ '*ALL') THEN(DO)
/*           OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND W1DPCL *GT 0 *AND W2DPCL *LE "' *CAT +
                          &DAECD *CAT '" *AND "' *CAT &WWACO1 *CAT +
                          '" *EQ SDACOFPD/AZACOC') +
                          KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST) (PMPORTPP/PNPTFR)) +
                          JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((W1CNUM PNCNUM *CHAR 6) (W1DPCL +
                          PNDPCL *ZONED 5) (W2DPCL W1DPCL *CHAR 5)) B7866*/
/*********** OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ SDACOFPD/AZACOC') +
                          KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6)) ********************B7915 B7866*/ /*S01486*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMPORTQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ SDACOFPD/AZACOC') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST) (PMPORTPD/PNPTFR)) +
                          JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((W1CNUM PNCNUM *CHAR 6))             /*S01486*/
             GOTO       CMDLBL(LBLPGM)
             ENDDO
/**/
/* SELECT DETAILS FOR ALL PORTFOLIOS */
             IF         COND(&WWPREF *EQ '*ALL') THEN(DO)
/*           OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND W1DPCL *GT 0 *AND W2DPCL *LE "' *CAT +
                          &DAECD *CAT '" *AND "' *CAT &WWACO1 *CAT +
                          '" *EQ AZACOC *AND "' *CAT &WWCUST *CAT '" +
                          *EQ BBCUST') KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6) (W1DPCL PNDPCL *ZONED 5) (W2DPCL +
                          W1DPCL *CHAR 5))                     B7866*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ AZACOC *AND "' *CAT +
                          &WWCUST *CAT '" *EQ BBCUST') +
                          KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6))*********************B7915 B7866*/ /*S01486*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMPORTQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ AZACOC *AND "' *CAT +
                          &WWCUST *CAT '" *EQ BBCUST') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST) (PMPORTPD/PNPTFR)) +
                          JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((W1CNUM PNCNUM *CHAR 6)) /*S01486*/
             GOTO       CMDLBL(LBLPGM)
             ENDDO
/**/
/* SELECT DETAILS FOR SPECIFIC PORTFOLIO */
/*           OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND W1DPCL *GT 0 *AND W2DPCL *LE "' *CAT +
                          &DAECD *CAT '" *AND "' *CAT &WWACO1 *CAT +
                          '" *EQ AZACOC *AND "' *CAT &WWCUST *CAT '" +
                          *EQ BBCUST *AND "' *CAT &WWPREF *CAT '" +
                          *EQ PNPTFR') KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6) (W1DPCL PNDPCL *ZONED 5) (W2DPCL +
                          W1DPCL *CHAR 5))                     B7866*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ AZACOC *AND "' *CAT +
                          &WWCUST *CAT '" *EQ BBCUST *AND "' *CAT +
                          &WWPREF *CAT '" *EQ PNPTFR') +
                          KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST) +
                          (PMPORTPP/PNPTFR)) JFLD((*MAPFLD/W1CNUM +
                          SDCUSTPD/BBCUST) (SDCUSTPD/BBACOC +
                          SDACOFPD/AZACOC)) MAPFLD((W1CNUM PNCNUM +
                          *CHAR 6))  *******************B7915 B7866*/ /*S01486*/
/*********** OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +     * *085859*/
/***********              FORMAT(PMPORTJF) QRYSLT('PNRECI *EQ "D" +  * *085859*/
/***********              *AND PNBCGY *NE "   " *AND "' *CAT +       * *085859*/
/***********              &WWACO1 *CAT '" *EQ AZACOC *AND "' *CAT +  * *085859*/
/***********              &WWCUST *CAT '" *EQ BBCUST *AND "' *CAT +  * *085859*/
/***********              &WWPREF *CAT '" *EQ PNPTFR') +             * *085859*/
/***********              KEYFLD((SDACOFPD/AZACOC) +                 * *085859*/
/***********              (SDCUSTPD/BBCUST) (PMPORTPD/PNPTFR)) +     * *085859*/
/***********              JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +    * *085859*/
/***********              (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +       * *085859*/
/***********              MAPFLD((W1CNUM PNCNUM *CHAR 6))     *S01486* *085859*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMPORTQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND PNBCGY *NE "   " *AND "' *CAT +
                          &WWACO1 *CAT '" *EQ AZACOC *AND "' *CAT +
                          &WWCUST *CAT '" *EQ BBCUST *AND "' *CAT +
                          &WWPREF *CAT '" *EQ PNPTFR') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST) (PMPORTPD/PNPTFR)) +
                          JFLD((*MAPFLD/W1CNUM SDCUSTPD/BBCUST) +
                          (SDCUSTPD/BBACOC SDACOFPD/AZACOC)) +
                          MAPFLD((W1CNUM PNCNUM *CHAR 6))             /*085859*/
/**/
/* REDISPLAY PROMPT SCREEN TO ALLOW USER TO INPUT NEW SET OF PARAMETERS */
/**LBLPGM:******CALL    PGM(PM0380) PARM(&WWACOF &WWCUST &WWPREF)***/ /*S01486*/
LBLPGM:      CALL     PGM(PM0380) PARM(&WWACOF &WWCUST &WWPREF &RSEQ) /*S01486*/
             CLOF       OPNID(SDACOFPD)
/*********** DLTOVR     FILE(PMPORTJF)******************************/ /*S01486*/
             DLTOVR     FILE(PMPORTQ0)                                /*S01486*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)  *********/ /*S01486*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(MEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/************SNDPGMMSG  MSGID(MEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)    *****************/  /*S01486*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/*********** IF         COND(&WWTYPE *EQ '0') THEN(DO)  ************/ /*S01486*/
/*********** GOTO       CMDLBL(ENDPGM)  ****************************/ /*S01486*/
/*********** ENDDO      ********************************************/ /*S01486*/
/*********** GOTO       CMDLBL(PM0800)  ****************************/ /*S01486*/
             GOTO       CMDLBL(ENDPGM)                                /*S01486*/
 ENDTAG:     DMPCLPGM
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
