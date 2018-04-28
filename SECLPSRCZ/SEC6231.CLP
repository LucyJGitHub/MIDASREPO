/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Custody fees accrued to date report')           */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITIES TRADING MODULE                         */
/*                                                                   */
/*       SEC6231    CUSTODY FEES ACCRUED TO DATE REPORT             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01464            DATE  04APR94             */
/*       PREV AMEND NO. R00300            DATE  28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01464  -  Safe Custody Fees.                              */
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
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01464*/
 
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
/**/                                                                  /*S01464*/
             CHGVAR     VAR(&WWACOF) VALUE(%SUBSTRING(&RPARM 1 4))    /*S01464*/
             CHGVAR     VAR(&WWCUST) VALUE(%SUBSTRING(&RPARM 5 6))    /*S01464*/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)           /*S01464*/
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
 
/*  Override open query file                                                  */
 
/************OVRDBF     FILE(SCSCFAQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             OVRDBF     FILE(SESCFAQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*S01464*/
             ELSE       CMD(DO)                                       /*S01464*/
             OVRDBF     FILE(SESCFAQ2) TOFILE(SDCUSTPD) SHARE(*YES)   /*S01464*/
             MONMSG     MSGID(CPF0000)
             ENDDO                                                    /*S01464*/
 
/*  Run report showing all details                                            */
 
/************IF         COND(&WWACOF *EQ '*ALL') THEN(DO)             /*S01464*/
             IF         COND(&RENT *EQ 'ALL' *AND &WWACOF *EQ +
                          *ALL *AND &WWCUST *EQ *ALL) THEN(DO)        /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCSCFAPD)) +      /*S01464*/
/************             FORMAT(SCSCFAQ1 SCSCFAQ0)  +                /*S01464*/
/************             KEYFLD((AZPRTL) (AZACOC) (SDCNUM) (SDPTFR))+/*S01464*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +    /*S01464*/
/************             (SDCUSTPD/BBCUST *MAPFLD/CNUM)) +           /*S01464*/
/************             JDFTVAL(*NO) +                              /*S01464*/
/************             MAPFLD((CNUM 'SCSCFAPD/SDCNUM' *CHAR 6))    /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SESCFAPD)) FORMAT(SESCFAQ2 +
                          SESCFAQ1) KEYFLD((BBBRCD) (BBACOC) +
                          (SDCNUM) (SDPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO
 
/***Run*report*showing*details*for*selected*printer*location*and***** /*S01464*/
/***account*officer************************************************** /*S01464*/
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +    /*S01464*/
/************             '*ALL') THEN(DO)                            /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCSCFAPD)) +      /*S01464*/
/************             FORMAT(SCSCFAQ1 SCSCFAQ0) QRYSLT('AZACOC +  /*S01464*/
/************             *EQ "' *CAT &WWACOF *CAT '"') +             /*S01464*/
/************             KEYFLD((AZPRTL) (AZACOC) (SDCNUM) +         /*S01464*/
/************             (SDPTFR)) JFLD((SDACOFPD/AZACOC +           /*S01464*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01464*/
/************             *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +  /*S01464*/
/************             'SCSCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
/*  Run report showing details for selected account officer           /*S01464*/
/*  for all branches.                                                 /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &RENT *EQ 'ALL') THEN(DO)       /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '"') +
                          KEYFLD((BBBRCD) (AZACOC) (SDCNUM) +
                          (SDPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO
 
/***Run*report*showing*details*for*selected*printer*location,******** /*S01464*/
/***account*officer*and*customer*number****************************** /*S01464*/
 
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +    /*S01464*/
/************             '*ALL') THEN(DO)                            /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCSCFAPD)) +      /*S01464*/
/************             FORMAT(SCSCFAQ1 SCSCFAQ0)  +                /*S01464*/
/************             QRYSLT(' BBCUST *EQ "' +                    /*S01464*/
/************             *CAT &WWCUST *CAT '"') +                    /*S01464*/
/************             KEYFLD((AZPRTL) (AZACOC) (SDCNUM) (SDPTFR))+/*S01464*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +    /*S01464*/
/************             (SDCUSTPD/BBCUST *MAPFLD/CNUM)) +           /*S01464*/
/************             JDFTVAL(*NO) +                              /*S01464*/
/************             MAPFLD((CNUM 'SCSCFAPD/SDCNUM' *CHAR 6))    /*S01464*/
/*  Run report showing details for selected account officer and       /*S01464*/
/*  customer number for all branches.                                 /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &RENT *EQ 'ALL') THEN(DO)       /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '"') +
                          KEYFLD((BBBRCD) (AZACOC) (SDCNUM) +
                          (SDPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO
/**/                                                                  /*S01464*/
/*  Run report showing all details of a selected branch.              /*S01464*/
             IF         COND(&RENT *NE 'ALL' *AND &WWACOF *EQ +
                          *ALL *AND &WWCUST *EQ *ALL +
                          *AND &MBIN *EQ 'Y') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SESCFAPD)) FORMAT(SESCFAQ2 +
                          SESCFAQ1) QRYSLT(' BBBRCD *EQ "' *CAT +
                          &RENT *CAT '"') KEYFLD((BBBRCD) (BBACOC) +
                          (SDCNUM) (SDPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO
/**/
/*  Run report showing details of selected account officer and branch.        */
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &RENT *NE 'ALL' +
                          *AND &MBIN *EQ 'Y') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '" *AND BBBRCD +
                          *EQ "' *CAT &RENT *CAT '"') +
                          KEYFLD((BBBRCD) (AZACOC) (SDCNUM) +
                          (SDPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO                                                    /*S01464*/
/**/                                                                  /*S01464*/
/*  Run report showing details for selected account officer and       /*S01464*/
/*  customer and branch.                                              /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &RENT *NE 'ALL' +
                          *AND &MBIN *EQ 'Y') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND BBBRCD +
                          *EQ "' *CAT &RENT *CAT '" *AND AZACOC *EQ +
                          "' *CAT &WWACOF *CAT '"') KEYFLD((BBBRCD) +
                          (AZACOC) (SDCNUM)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO                                                    /*S01464*/
/**/                                                                  /*S01464*/
/*  Run report showing all details of in a single branch              /*S01464*/
/*  environment.                                                      /*S01464*/
             IF         COND(&RENT *NE 'ALL' *AND &WWACOF *EQ +
                          *ALL *AND &WWCUST *EQ *ALL +
                          *AND &MBIN *EQ 'N') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SESCFAPD)) FORMAT(SESCFAQ2 +
                          SESCFAQ1) KEYFLD((BBBRCD) (BBACOC) +
                          (SDCNUM) (SDPTFR)) JFLD((SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO
/**/
/*  Run report showing details of selected account officer in a               */
/*  single branch environment.                                        /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '*ALL' *AND &RENT *NE 'ALL' +
                          *AND &MBIN *EQ 'N') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT('AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '"') +
                          KEYFLD((BBBRCD) (AZACOC) (SDCNUM) +
                          (SDPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO                                                    /*S01464*/
/**/                                                                  /*S01464*/
/*  Run report showing details for selected account officer and       /*S01464*/
/*  customer in a single branch environment.                          /*S01464*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '*ALL' *AND &RENT *NE 'ALL' +
                          *AND &MBIN *EQ 'N') THEN(DO)                /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SESCFAPD)) +
                          FORMAT(SESCFAQ1 SESCFAQ0) QRYSLT(' BBCUST +
                          *EQ "' *CAT &WWCUST *CAT '" *AND AZACOC +
                          *EQ "' *CAT &WWACOF *CAT '"') +
                          KEYFLD((BBBRCD) (AZACOC) (SDCNUM) +
                          (SDPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) JDFTVAL(*NO) MAPFLD((CNUM +
                          'SESCFAPD/SDCNUM' *CHAR 6))                 /*S01464*/
             ENDDO                                                    /*S01464*/
/**/
/** RUN MISSING CUSTODY FEE CODES REPORT */
/************CALL       PGM(SE6230) PARM(&WWACOF &WWCUST)             /*S01464*/
             CALL       PGM(SE6230) PARM(&WWACOF &WWCUST +
                                &RSEQ &RENT)                          /*S01464*/
             IF         COND(&WWACOF *NE '*ALL') THEN(DO)             /*S01464*/
             CLOF       OPNID(SDACOFPD)
             ENDDO                                                    /*S01464*/
             ELSE       CMD(CLOF       OPNID(SDCUSTPD))               /*S01464*/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/****************                                          /*R00300*/ /*S01464*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG)MSGDTA(&MEM)+/*S01464*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
 
/***END:********ENDPGM                                                /*S01464*/
                                                                      /*S01464*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*S01464*/
ENDPGM                                                                /*S01464*/
