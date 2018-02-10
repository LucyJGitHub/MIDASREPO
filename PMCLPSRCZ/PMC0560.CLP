/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Turnover by Industry per Customer')          */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0561 PM TURNOVER BY INDUSTRY PER CUSTOMER               */
/*                  (On request processing)                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 095246            DATE  01NOV95             */
/*                      S01486            DATE  20OCT94             */
/*                      049421            DATE 18JAN93              */
/*                      049467            DATE  18JAN93             */
/*                      R00300            DATE  28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       095246  -  Use correct file in opnqryf command             */
/*       S01486  -  PORTFOLIO MANAGEMENT UPGRADE TO R10             */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWACOF &WWCUST &WWPREF)                 /*S01486*/
/**/
             PGM      PARM(&RSEQ &RLVL &RENT &PARM)                   /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWACF2) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)              * *S01486*/
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(10)              /*S01486*/
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*S01486*/
/************DCL        VAR(&RUN) TYPE(*CHAR) LEN(1)               */ /*S01486*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/***REDEFINE*ACCOUNT*OFFICER*CODE**********************************/  /*S01486*/
/************CHGVAR     VAR(&WWACF2) VALUE(%SST(&WWACOF 1 2))         /*S01486*/
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/************                                                         /*S01486*/
/**IF*TURNOVER*HAS*NOT*BEEN*RUN*BEFORE*IN*THIS*COB*EXTRACT*TURNOVER*/ /*S01486*/
/**DETAILS**********************************************************/ /*S01486*/
/************RTVDTAARA  DTAARA(PMSTAT (20 1)) RTNVAR(&RUN)            /*S01486*/
/************IF         COND(&RUN *EQ 'N') THEN(DO)                   /*S01486*/
/************   CALL       PGM(PMC0900)                               /*S01486*/
/************   CHGDTAARA  DTAARA(PMSTAT (20 1)) VALUE('Y')           /*S01486*/
/************                                                         /*S01486*/
/***DATABASE*ERRORS, IF U7 + U8 ON  */                                /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01486*/
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01486*/
/************                                            /*R00300*/   /*S01486*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/************    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)/+S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/************                                             /*R00300*/  /*S01486*/
/************    GOTO     ENDTAG                                      /*S01486*/
/************ENDDO                                                    /*S01486*/
/************ENDDO                                                    /*S01486*/
/************OVRDBF     FILE(PMTUR2PO) TOFILE(SDPLCSPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMTUR2Q0) TOFILE(SDPLCSPD) SHARE(*YES)
/*  SET PROGRAM VARIABLES */                                          /*S01486*/
                                                                      /*S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
                 CHGVAR     VAR(&WWACOF) VALUE('*ALL')                /*S01486*/
                 ENDDO                                                /*S01486*/
             ELSE       CMD(DO)                                       /*S01486*/
                 CHGVAR     VAR(&WWACOF) VALUE(&RENT)                 /*S01486*/
                 ENDDO                                                /*S01486*/
/************CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM  1 6))  *S01486* *S01486*/
/************CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM  7 4))  *S01486* *S01486*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM  1 10))         /*S01486*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM  11 4))         /*S01486*/
/**/
/*  REDEFINE ACCOUNT OFFICER CODE */
             CHGVAR     VAR(&WWACF2) VALUE(%SST(&WWACOF 1 2))
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
/************IF         COND(&WWACOF *EQ '*ALL' *AND &WWCUST *EQ +   * *S01486*/
/************             '*ALL') THEN(DO)                           * *S01486*/
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWCUST *EQ +
                          '    *ALL  ') THEN(DO)                      /*S01486*/
/************OPNQRYF   FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) + /*S01486*/
/************             FORMAT(PMTUR2PO) KEYFLD((SDACOFPD/AZPRTL) + /*S01486*/
/************             (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +      /*S01486*/
/************             JFLD((SDCUSTPD/BBCUST SDPLCSPD/QBCUST) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC))          /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) + *095246*/
/************             FORMAT(PMTUR2P0) KEYFLD( +                   *095246*/
/************             (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +       *095246*/
/************             JFLD((SDCUSTPD/BBCUST SDPLCSPD/QBCUST) +     *095246*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC))  *S01486* *095246*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMTUR2Q0) KEYFLD( +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDCUSTPD/BBCUST SDPLCSPD/QBCUST) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC))          /*095246*/
             ENDDO
/*                                                                            */
/*   A/C OFFICER SELECTED                                                     */
/*                                                                            */
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +   * *S01486*/
/************             '*ALL') THEN(DO)                           * *S01486*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *EQ +
                          '    *ALL  ') THEN(DO)                      /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) +/*S01486*/
/************             FORMAT(PMTUR2PO) QRYSLT('AZACOC *EQ "' +    /*S01486*/
/************             *CAT &WWACF2 *CAT '"') +                    /*S01486*/
/************             KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC)+ /*S01486*/
/************             (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +  /*S01486*/
/************             SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +         /*S01486*/
/************             SDCUSTPD/BBACOC))                           /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) + *095246*/
/************             FORMAT(PMTUR2P0) QRYSLT('AZACOC *EQ "' +     *095246*/
/************             *CAT &WWACF2 *CAT '"') +                     *095246*/
/************             KEYFLD((SDACOFPD/AZACOC) +                   *095246*/
/************             (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +   *095246*/
/************             SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +          *095246*/
/************             SDCUSTPD/BBACOC))                   *S01486* *095246*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMTUR2Q0) QRYSLT('AZACOC *EQ "' +
                          *CAT &WWACF2 *CAT '"') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +
                          SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC))                           /*095246*/
             ENDDO
/*                                                                            */
/*   A/C OFFICER AND CUSTOMER SELECTED                                        */
/*                                                                            */
/************IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +   * *S01486*/
/************             '*ALL') THEN(DO)                           * *S01486*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWCUST *NE +
                          '    *ALL  ') THEN(DO)                      /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) +/*S01486*/
/************             FORMAT(PMTUR2PO) QRYSLT('AZACOC *EQ "' +    /*S01486*/
/************             *CAT &WWACF2 *CAT '" *AND BBCUST *EQ "' +   /*S01486*/
/************             *CAT &WWCUST *CAT '"') +                    /*S01486*/
/************             KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) +/*S01486*/
/************             (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +  /*S01486*/
/************             SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +         /*S01486*/
/************             SDCUSTPD/BBACOC))                           /*S01486*/
/************OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) + *095246*/
/************             FORMAT(PMTUR2P0) QRYSLT('AZACOC *EQ "' +     *095246*/
/************             *CAT &WWACF2 *CAT '" *AND BBCUST *EQ "' +    *095246*/
/************             *CAT &WWCUST *CAT '"') +                     *095246*/
/************             KEYFLD((SDACOFPD/AZACOC) +                   *095246*/
/************             (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +   *095246*/
/************             SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +          *095246*/
/************             SDCUSTPD/BBACOC))                   *S01486* *095246*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD) (SDCUSTPD) (SDACOFPD)) +
                          FORMAT(PMTUR2Q0) QRYSLT('AZACOC *EQ "' +
                          *CAT &WWACF2 *CAT '" *AND BBCUST *EQ "' +
                          *CAT &WWCUST *CAT '"') +
                          KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST)) JFLD((SDCUSTPD/BBCUST +
                          SDPLCSPD/QBCUST) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC))                           /*095246*/
             ENDDO
/**/
/** RUN TURNOVER REPORT */
/************CALL       PGM(PM0560) PARM(&WWACOF &WWCUST &WWPREF)     /*S01486*/
             CALL       PGM(PM0560) PARM(&RSEQ &WWACOF &WWCUST +
                        &WWPREF)                                      /*S01486*/
             CLOF       OPNID(SDPLCSPD)
/************DLTOVR     FILE(PMTUR2PO)                                /*S01486*/
             DLTOVR     FILE(PMTUR2Q0)                                /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                    /*R00300*/
             ENDDO
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/**********END:        ENDPGM                                          *S01486*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
         ENDPGM                                                       /*S01486*/
