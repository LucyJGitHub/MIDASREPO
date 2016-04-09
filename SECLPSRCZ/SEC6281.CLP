/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Missing custody fees report on req.')           */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITIES TRADING MODULE                         */
/*                                                                   */
/*       SEC6281    MISSING CUSTODY FEES REPORT ON REQUEST           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 091522             Date 24Aug95              */
/*                      S01464             Date 04Apr94              */
/*                      R0131             DATE  11FEB91             */
/*                      R00300            DATE  28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*   CLE134 - Past Due Call Loan Processing (Recompile)             */
/*   091522 - Safe Custody Fees - Private Banking (CSE001)          */
/*   S01464 - Safe Custody Fees                                     */
/*   R0131  - Exclude the bank accounts.                            */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWACOF &WWCUST)                         /*S01464*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01464*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01464*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01464*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01464*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01464*/
 
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/**/                                                                  /*S01464*/
             CHGVAR     VAR(&WWACOF) VALUE(%SUBSTRING(&RPARM 1 4))    /*S01464*/
             CHGVAR     VAR(&WWCUST) VALUE(%SUBSTRING(&RPARM 5 6))    /*S01464*/
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/** CLEAR PRECIOUS METAL ACCOUNT BALANCES */
/************CLRPFM     FILE(SCPMABPD)                                /*S01464*/
             CLRPFM     FILE(SEPMABPD)                                /*S01464*/
 
/* OPEN QUERY FILE SELECTING PRECIOUS METAL ACCOUNTS */
/************OVRDBF     FILE(SCACCNLL) TOFILE(SDCURRX0) SHARE(*YES)   /*S01464*/
             OVRDBF     FILE(SEACCNLL) TOFILE(SDCURRL0) SHARE(*YES)   /*S01464*/
/**R0131*****OPNQRYF****FILE((SDCURRX0) (ACCNTAB) (SDSECSPD)) +
                          FORMAT(SCACCNLL SCACCND0) QRYSLT('CYPMRT +
                          *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE +
                          "*"') KEYFLD((CNUM) (PTFR) (CCY)) +
                          JFLD((SDCURRX0/CYCURR ACCNTAB/CCY) +
                          (ACCNTAB/CNUM *MAPFLD/CUST)) +
                          JDFTVAL(*YES) MAPFLD((CUST +
                          'SDSECSPD/BFCUST' *ZONED 6 0))    *****/
/**R0131*****OPNQRYF****FILE((SDCURRX0) (ACCNTAB) (SDSECSPD)) +
                          FORMAT(SCACCNLL SCACCND0) QRYSLT('CYPMRT +
                          *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE +
                          "*" *AND ATYP *EQ "R"') +
                          KEYFLD((CNUM) (PTFR) (CCY)) +
                          JFLD((SDCURRX0/CYCURR ACCNTAB/CCY) +
                          (ACCNTAB/CNUM *MAPFLD/CUST)) +
                          JDFTVAL(*YES) MAPFLD((CUST +
                          'SDSECSPD/BFCUST' *ZONED 6 0))              /*S01464*/
/************OPNQRYF    FILE((SDCURRL0) (ACCNTAB) (SDSECSPD)) +       /*091522*/
/*************            FORMAT(SEACCNLL SEACCND0) QRYSLT('A6PMRT +  /*091522*/
/************             *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE + /*091522*/
/************             "*" *AND ATYP *EQ "R"') +                   /*091522*/
/************             KEYFLD((CNUM) (CCY)) +                      /*091522*/
/************             JFLD((SDCURRL0/A6CYCD ACCNTAB/CCY) +        /*091522*/
/************             (ACCNTAB/CNUM *MAPFLD/CUST)) +              /*091522*/
/************             JDFTVAL(*YES) MAPFLD((CUST +                /*091522*/
/************             'SDSECSPD/BFCUST' *ZONED 6 0)) /* R0131 */  /*091522*/
             OPNQRYF    FILE((SDCURRL0) (ACCNTAB) (SDSECSPD)) +
                          FORMAT(SEACCNLL SEACCND0) QRYSLT('A6PMRT +
                          *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE +
                          "*" *AND ATYP *EQ "R"') +
                          KEYFLD((CNUM) (PTFR) (CCY)) +
                          JFLD((SDCURRL0/A6CYCD ACCNTAB/CCY) +
                          (ACCNTAB/CNUM *MAPFLD/CUST)) +
                          JDFTVAL(*YES) MAPFLD((CUST +
                          'SDSECSPD/BFCUST' *ZONED 6 0)) /* R0131 */  /*091522*/
             CALL       PGM(SE6410)
/************CLOF       OPNID(SDCURRX0)                               /*S01464*/
             CLOF       OPNID(SDCURRL0)
             DLTOVR     FILE(SEACCNLL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/*****************        TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01464*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/*  OPEN QUERY FILE TO SELECT CUSTOMERS AND PORTFOLIOS TO BE REPORTED         */
/************OVRDBF     FILE(SCSECSPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             OVRDBF     FILE(SESECSPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             ENDDO                                                    /*S01464*/
             ELSE       CMD(DO)                                       /*S01464*/
             OVRDBF     FILE(SESECSPP) TOFILE(SDCUSTPD) SHARE(*YES)   /*S01464*/
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*S01464*/
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
/************IF         COND((&WWACOF *EQ '*ALL')) THEN(DO)           /*S01464*/
             IF         COND((&RENT *EQ 'ALL' *AND &WWACOF *EQ +
                          *ALL *AND &WWCUST *EQ *ALL)) THEN(DO)       /*S01464*/
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SCSECSPO) QRYSLT('BFSBJF *EQ "Y"') +
                          KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SDSECSPD)) FORMAT(SESECSPP) +
                          QRYSLT('BFSBJF *EQ "Y"') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDCUSTPD/BBCUST SDSECSPD/BFCUST))     /*S01464*/
             ENDDO
/**/
/*  RUN REPORT SHOWING DETAILS OF SELECTED ACCOUNT OFFICER     */
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +    /*S01464*/
/************             '*ALL') THEN(DO)                            /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &RENT *EQ 'ALL') THEN(DO)       /*S01464*/
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SCSECSPO) QRYSLT(' AZACOC *EQ "' +
                          *CAT &WWACOF *CAT '" *AND BFSBJF *EQ +
                          "Y"') KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SESECSPO) QRYSLT(' AZACOC *EQ "' +
                          *CAT &WWACOF *CAT '" *AND BFSBJF *EQ +
                          "Y"') KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             ENDDO
/**/
/*  RUN REPORT SHOWING DETAILS OF SELECTED ACCOUNT OFFICER AND CUSTOMER */
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +    /*S01464*/
/************             '*ALL') THEN(DO)                            /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &RENT *EQ 'ALL') THEN(DO)       /*S01464*/
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SCSECSPO) QRYSLT(' BBCUST *EQ "' +
                          *CAT &WWCUST *CAT '" *AND BFSBJF *EQ +
                          "Y"') KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SESECSPO) QRYSLT(' BBCUST *EQ "' +
                          *CAT &WWCUST *CAT '" *AND BFSBJF *EQ "Y" +
                          *AND AZACOC *EQ "' *CAT &WWACOF *CAT '"') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             ENDDO
/**/
/*  RUN REPORT SHOWING ALL DETAILS OF A SELECTED BRANCH                       */
             IF         COND((&RENT *NE 'ALL' *AND &WWACOF *EQ +
                          *ALL *AND &WWCUST *EQ *ALL)) THEN(DO)       /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SDSECSPD)) FORMAT(SESECSPP) +
                          QRYSLT('BFSBJF *EQ "Y" *AND BBBRCD *EQ "' +
                          *CAT &RENT *CAT '"') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDCUSTPD/BBCUST SDSECSPD/BFCUST))     /*S01464*/
             ENDDO                                                    /*S01464*/
/**/
/*  RUN REPORT SHOWING DETAILS OF SELECTED ACCOUNT OFFICER AND BRANCH*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &RENT *NE 'ALL') THEN(DO)       /*S01464*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SESECSPO) QRYSLT(' AZACOC *EQ "' +
                          *CAT &WWACOF *CAT '" *AND BFSBJF *EQ "Y" +
                          *AND BBBRCD *EQ "' *CAT &RENT *CAT '" ') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             ENDDO                                                    /*S01464*/
/**/
/*  RUN REPORT SHOWING DETAILS OF SELECTED ACCOUNT OFFICER AND CUSTOMER */
/*  AND BRANCH                                                          */
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &RENT *NE 'ALL') THEN(DO)       /*S01464*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SESECSPO) QRYSLT(' BBCUST *EQ "' +
                          *CAT &WWCUST *CAT '" *AND BFSBJF *EQ "Y" +
                          *AND AZACOC *EQ "' *CAT &WWACOF *CAT '" +
                          *AND BBBRCD *EQ "' *CAT &RENT *CAT '"') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             ENDDO                                                    /*S01464*/
/**/
/** RUN MISSING CUSTODY FEE CODES REPORT */
/************CALL       PGM(SE6280) PARM(&WWACOF &WWCUST)             /*S01464*/
             CALL       PGM(SE6280) PARM(&WWACOF &WWCUST &RSEQ &RENT) /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             CLOF       OPNID(SDACOFPD)
             ENDDO                                                    /*S01464*/
             ELSE       CMD(CLOF       OPNID(SDCUSTPD))               /*S01464*/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/***END:********ENDPGM                                                /*S01464*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM                                                                /*S01464*/
