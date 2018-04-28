/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Customer / Portfolio Cashflow (On Req.)')    */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0430 - PM CUSTOMER / PORTFOLIO CASHFLOW                 */
/*                 (On request processing)                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486  LV         DATE 27SEP94             */
/*       PREV AMEND NO. 063367             DATE 16NOV93             */
/*                      58180              DATE 07JUL93             */
/*                      049421             DATE 18JAN93             */
/*                      47905              DATE 30NOV92             */
/*                      45867              DATE 23OCT92             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       S01486  -  PORTFOLIO MANAGEMENT UPGRADE TO R10             */
/*       063367  -  NO JOBS MUST BE SUBMITTED WHEN IT'S CALLED BY   */
/*                  ON REQUEST MENU                                 */
/*       58180   -  WHEN JOB SUBMITTED TO BATCH CREATE LDA IN QTEMP */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       47905   -  CORRECT SUBMIT OF JOB TO BATCH                  */
/*       45867   -  REWRITTEN FOR COB PROCESSING                    */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWACOF &WWCUST &WWPREF &WW60DD &WWMOTT +/*S01486*/
/************                &WWYETT &GBCH)                           /*S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT &PARM)                 /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
/**/                                                                  /*S01486*/
/************DCL        VAR(&WWCLP) TYPE(*CHAR) LEN(7)                /*S01486*/
/************DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)              /*S01486*/
/************DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWDEPT) TYPE(*CHAR) LEN(4)               /*S01486*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WW60DD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMOTT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWYETT) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)                /*S01486*/
/************DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                 /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/************DCL        VAR(&WWPAR1) TYPE(*CHAR) LEN(10)              /*S01486*/
/************DCL        VAR(&WWPAR2) TYPE(*CHAR) LEN(5)               /*S01486*/
/************DCL        VAR(&GBCH) TYPE(*CHAR) LEN(1)                 /*S01486*/
 
/*  GLOBAL MONITOR MESSAGE:                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ENDTAG))
 
/***RETRIEVE*PHASE OF DAILY PROCESSING                                /*S01486*/
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)                 /*S01486*/
/************                                                         /*S01486*/
/***RETRIEVE*PHASE OF DAILY PROCESSING                                /*S01486*/
/************RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)           /*S01486*/
/************                                                         /*S01486*/
/***RETRIEVE*TYPE OF JOB - '0' = BATCH                                /*S01486*/
/************            - '1' = INTERACTIVE                          /*S01486*/
/************                                                         /*S01486*/
/************RTVJOBA    TYPE(&WWTYPE)                                 /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&GBCH *EQ '1') THEN(DO)                  /*S01486*/
/************           CHGVAR VAR(&WWTYPE) VALUE('0')                /*S01486*/
/************ENDDO                                                    /*S01486*/
 
/*  SET OFF SWITCHES:                                                */
/************CHGJOB     SWS(00000000)                                 /*S01486*/
             CHGJOB     SWS(10000000)
                                                                      /*S01486*/
/*  SET PROGRAM VARIABLES */                                          /*S01486*/
                                                                      /*S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
                 CHGVAR     VAR(&WWACOF) VALUE('*ALL')                /*S01486*/
                 ENDDO                                                /*S01486*/
             ELSE       CMD(DO)                                       /*S01486*/
                 CHGVAR     VAR(&WWACOF) VALUE(&RENT)                 /*S01486*/
                 ENDDO                                                /*S01486*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM  1 6))          /*S01486*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM  7 4))          /*S01486*/
             CHGVAR     VAR(&WW60DD) VALUE(%SST(&PARM 11 1))          /*S01486*/
             CHGVAR     VAR(&WWMOTT) VALUE(%SST(&PARM 12 1))          /*S01486*/
             CHGVAR     VAR(&WWYETT) VALUE(%SST(&PARM 13 1))          /*S01486*/
 
/***IF*BATCH*JOB, BYPASS PROMPT PROCESSING:                           /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************GOTO       CMDLBL(BATCH)                                 /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***SET*UP*CALLING PROGRAM NAME:                                      /*S01486*/
/************                                                         /*S01486*/
/************CHGVAR     VAR(&WWCLP) VALUE('PMC0430')                  /*S01486*/
/************                                                         /*S01486*/
/***RETRIEVE*USER PROFILE OF SIGNED ON USER                           /*S01486*/
/************RTVJOBA    USER(&WWUSRP)                                 /*S01486*/
/************                                                         /*S01486*/
/***CALL*PROGRAM TO INPUT REPORT PROMPTS:                             /*S01486*/
/*PM0810:*****CALL   PGM(PM0810) PARM(&WWCLP &WWUSRP &WWCYCL &WWDEPT  /*S01486*/
/************       &WWACOF &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT   /*S01486*/
/************           &WWINBA &WWRTRN &GBCH)                        /*S01486*/
/************                                                         /*S01486*/
/***DATABASE*ERRORS, IF U7 + U8 ON:                                   /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01486*/
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)             /*S01486*/
/************                                                         /*S01486*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/************           TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
/************                                                         /*S01486*/
/************GOTO       CMDLBL(ENDPGM)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***IF*F3*TAKEN IN PROMPT PROGRAM, TERMINATE PROCESSING:              /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWRTRN *EQ '1') THEN(DO)                /*S01486*/
/************GOTO       CMDLBL(ENDPGM)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
/**/                                                                  /*S01486*/
/***REPORT*RUN DURING COB; SEND PROGRAM AND PARAMETER TO MSGQ/EODQ:   /*S01486*/
/************IF         COND(&GBCH *EQ '2') THEN(DO)                  /*S01486*/
/**/                                                                  /*S01486*/
/***FORMAT*VARIABLE TO BE SENT TO MSGQ/EODQ:                          /*S01486*/
/************                                                         /*S01486*/
/************    CHGVAR    VAR(&WWPAR1) VALUE('PMC0430   ')           /*S01486*/
/************    CHGVAR    VAR(&WWPAR2) VALUE('10001')                /*S01486*/
/************                                                         /*S01486*/
/**UPDATE*WORK FILE                                                   /*S01486*/
/************                                                         /*S01486*/
/************CALL       PGM(PM0430A) PARM(&WWPAR1 &WWPAR2 &WWACOF +   /*S01486*/
/************             &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT)    /*S01486*/
/*>>>*063367*>>>                                                      /*S01486*/
/************GOTO       CMDLBL(LOIN)                                  /*S01486*/
/*<<<*063367*<<<                                                      /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'B' +   /*S01486*/
/************                *AND &WWCYCL *NE 'B') THEN(DO)           /*S01486*/
/************SBMJOB     CMD(CALL PGM(PMC0430) PARM(&WWACOF +          /*S01486*/
/************           &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT)) +   /*S01486*/
/************           JOBQ(FOJOBQ)                        /*47905*/ /*S01486*/
/************SBMJOB     CMD(CALL PGM(PMC0430) PARM(&WWACOF &WWCUST +/ /*S01486*/
/************             &WWPREF &WW60DD &WWMOTT &WWYETT &GBCH)) +*/ /*S01486*/
/************             JOBQ(FOJOBQ)                     /*47905*/  /*S01486*/
/************GOTO       CMDLBL(DATA)                                  /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***REPORT*DURING EOD OR ON REQ                                       /*S01486*/
/**BATCH:****CHGJOB     SWS(1XXXXXXX)                                 /*S01486*/
/************                                                         /*S01486*/
/**CREATE*DTAARA/LDA IN QTEMP                                         /*S01486*/
/************CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +      /*S01486*/
/************             TEXT('MIDAS/ABS SD Local Data Area')        /*581806*/
/************MONMSG     MSGID(CPF0000)                                /*581806*/
 
/*  RUN REPORT FOR INPUT QRYF PMCUSTPO:                              */
/***A**-**A/C*OFFICER*=**ALL*;*CUSTOMER*=**ALL*;*PORTFOLIO*=*9999     /*S01486*/
/***B**-**A/C*OFFICER*=**ALL*;*CUSTOMER*=**ALL*;*PORTFOLIO*=*9998     /*S01486*/
/***C**-**A/C*OFFICER*=**ALL*;*CUSTOMER*=**ALL*;*PORTFOLIO*=**ALL     /*S01486*/
/*  A  -  A/C OFFICER = *ALL                                         */
 
/************IF        COND(&WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL'/*S01486*/
/************           *AND &WWPREF *EQ '9999' *OR +                 /*S01486*/
/************           &WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +/*S01486*/
/************           *AND &WWPREF *EQ '9998' *OR +                 /*S01486*/
/************           &WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +/*S01486*/
/************           *AND &WWPREF *EQ '*ALL') THEN(DO)             /*S01486*/
             IF         COND(&WWACOF *EQ '*ALL' *OR &WWACOF *EQ  +
                        '    ') THEN(DO)                              /*S01486*/
/************OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +/*S01486*/
/************           FORMAT(PMCUSTPO) QRYSLT('QBRECI *EQ "D" +     /*S01486*/
/************           *AND QBPCUS *EQ "Y"') +                       /*S01486*/
/************           KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) +  /*S01486*/
/************           (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +    /*S01486*/
/************           SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +           /*S01486*/
/************           SDPLCSPD/QBCUST))                             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*S01486*/
 
/************CALL       PGM(PM0430) PARM(&WWACOF &WWCUST &WWPREF +    /*S01486*/
/************           &WW60DD &WWMOTT &WWYETT)                      /*S01486*/
             CALL       PGM(PM0430) PARM(&RSEQ &WWACOF &WWCUST +
                          &WWPREF &WW60DD &WWMOTT &WWYETT)            /*S01486*/
 
             CLOF       OPNID(SDACOFPD)
             DLTOVR     FILE(*ALL)
 
/***     IN CASE OF DATABASE ERROR:                                  */
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO       CMDLBL(DATA)
                        ENDDO
 
/***     IN CASE OF FILE ERROR:                                      */
                        IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                        GOTO       CMDLBL(FILE)
                        ENDDO
 
             ENDDO
 
/***D**-**A/C*OFFICER*=*DEF.*;*CUSTOMER*=*DEF.*;*PORTFOLIO*=**ALL     /*S01486*/
/***F**-**A/C*OFFICER*=*DEF.*;*CUSTOMER*=*DEF.*;*PORTFOLIO*=*DEF.     /*S01486*/
/*  B  -  A/C OFFICER = DEF. ; CUSTOMER = DEF.                       */
 
/*           IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK +
                        *AND &WWPREF *EQ '*ALL' *OR +
                        &WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK +
                        *AND &WWPREF *NE '9999' *AND &WWPREF *NE '9998' +
                        *AND &WWPREF *NE '*ALL' *AND &WWPREF *NE *BLANK) +
                        THEN(DO)                               B07929*/
/************IF    COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK+   /*S01486*/
/************      *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK0 /*S01486*/
/************      *AND &WWPREF *EQ '*ALL' *OR +                      /*S01486*/
/************      &WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +       /*S01486*/
/************      *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK  /*S01486*/
/************      *AND &WWPREF *NE '*ALL' *AND &WWPREF *NE *BLANK)   /*S01486*/
/************         THEN(DO)  */                        /*B07929*/  /*S01486*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK) +
                        THEN(DO)                                      /*S01486*/
/************OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +/*S01486*/
/************           FORMAT(PMCUSTPO) QRYSLT('QBRECI *EQ "D" +     /*S01486*/
/************           *AND QBPCUS *EQ "Y" *AND AZACOC *EQ "' *CAT + /*S01486*/
/************           &WWACOF *CAT '" *AND BBCUST *EQ "' *CAT +     /*S01486*/
/************           &WWCUST *CAT '"') +                           /*S01486*/
/************           KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) +  /*S01486*/
/************           (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +    /*S01486*/
/************           SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +           /*S01486*/
/************           SDPLCSPD/QBCUST))                             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D" +
                        *AND AZACOC *EQ "' *CAT +
                        &WWACOF *CAT '" *AND BBCUST *EQ "' *CAT +
                        &WWCUST *CAT '"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*S01486*/
 
/************CALL       PGM(PM0430) PARM(&WWACOF &WWCUST &WWPREF +    /*S01486*/
/************           &WW60DD &WWMOTT &WWYETT)                      /*S01486*/
             CALL       PGM(PM0430) PARM(&RSEQ &WWACOF &WWCUST +
                          &WWPREF &WW60DD &WWMOTT &WWYETT)            /*S01486*/
 
             CLOF       OPNID(SDACOFPD)
             DLTOVR     FILE(*ALL)
 
/***     IN CASE OF DATABASE ERROR:                                  */
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO       CMDLBL(DATA)
                        ENDDO
 
/***     IN CASE OF FILE ERROR:                                      */
                        IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                        GOTO       CMDLBL(FILE)
                        ENDDO
 
             ENDDO
 
/***E**-**A/C*OFFICER*=*DEF.*;*CUSTOMER*=**ALL*;*PORTFOLIO*=**ALL     /*S01486*/
/*  C  -  A/C OFFICER = DEF. ; CUSTOMER = *ALL                     */ /*S01486*/
 
/*           IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *EQ '*ALL  ' *AND &WWPREF *EQ '*ALL') +
                        THEN(DO)                                      B07929*/
             IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *EQ '*ALL  ') THEN(DO)         /*B07929*/
/************OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +/*S01486*/
/************           FORMAT(PMCUSTPO) QRYSLT('QBRECI *EQ "D" +     /*S01486*/
/************           *AND QBPCUS *EQ "Y" *AND AZACOC *EQ "' *CAT + /*S01486*/
/************           &WWACOF *CAT '"') +                           /*S01486*/
/************           KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) +  /*S01486*/
/************           (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +    /*S01486*/
/************           SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +           /*S01486*/
/************           SDPLCSPD/QBCUST))                             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D" +
                        *AND AZACOC *EQ "' *CAT +
                        &WWACOF *CAT '"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*S01486*/
 
/************CALL       PGM(PM0430) PARM(&WWACOF &WWCUST &WWPREF +    /*S01486*/
/************           &WW60DD &WWMOTT &WWYETT)                      /*S01486*/
             CALL       PGM(PM0430) PARM(&RSEQ &WWACOF &WWCUST +
                          &WWPREF &WW60DD &WWMOTT &WWYETT) /*S01486*/
 
             CLOF       OPNID(SDACOFPD)
             DLTOVR     FILE(*ALL)
 
/***     IN CASE OF DATABASE ERROR:                                  */
                        IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO       CMDLBL(DATA)
                        ENDDO
 
/***     IN CASE OF FILE ERROR:                                      */
                        IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                        GOTO       CMDLBL(FILE)
                        ENDDO
 
             ENDDO
 
/*  DATABASE ERROR, IF U7 + U8 ON:                                   */
 DATA:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)             /*S01486*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01486*/
 
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/************           TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  FILE OUT OF BALANCE ERROR, IF U8 ON:                             */
 FILE:       IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
 
/************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) TOMSGQ(MOPERQ + /*S01486*/
/************             MRUNQ)                                      /*S01486*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*S01486*/
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/***IF*BATCH*JOB, TERMINATE PROCESSING:                               /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************GOTO       CMDLBL(ENDPGM)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***IF*F3*NOT TAKEN IN PM0810, GO TO PROGRAM:                         /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWRTRN *NE '1') THEN(DO)                /*S01486*/
/************GOTO       CMDLBL(PM0810)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
 
             GOTO       CMDLBL(ENDPGM)
 
/*>>>*063367*>>>                                                      /*S01486*/
/*LOIN:********                                                       /*S01486*/
/************                                                         /*S01486*/
/**If*batch*job, terminate processing                                 /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************   GOTO       CMDLBL(ENDPGM)                             /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/**Return*to*prompt screen                                            /*S01486*/
/************                                                         /*S01486*/
/************GOTO       CMDLBL(PM0810)                                /*S01486*/
/*<<<*063367*<<<                                                      /*S01486*/
/*  ERROR IN CL PROGRAM:                                             */
 
 ENDTAG:     DMPCLPGM
 
/**********ENDPGM:     RCLRSC                                          *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
         ENDPGM                                                       /*S01486*/
