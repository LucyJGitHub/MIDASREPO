/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Currency Commitment Rpt (On request)')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6041 - PM Net Currency Commitment Report Selection       */
/*                 (On Request Processing)                           */
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
/*       Prev Amend No. CPM005             Date 21Jun96              */
/*                      S01124             Date 13Jun94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124 - PBFG/1 - Change Customer/Portfolio Base Currency   */
/*                PBFG/8 - Display Positions Split By Currency       */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&WWACOF &WWCUST &WWPREF)              */ /*CPM005*/
             PGM        PARM(&RSEQ &RLVL &RENT &PARM)                 /*CPM005*/
 
/*********** DCL        VAR(&WWCLP) TYPE(*CHAR) LEN(7)             */ /*CPM005*/
/*********** DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)           */ /*CPM005*/
/*********** DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1)            */ /*CPM005*/
/*********** DCL        VAR(&WWDEPT) TYPE(*CHAR) LEN(4)            */ /*CPM005*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)
/*********** DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)            */ /*CPM005*/
/*********** DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)            */ /*CPM005*/
/*********** DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)             */ /*CPM005*/
 
/*********** DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1)            */ /*CPM005*/
/*********** DCL        VAR(&DAT) TYPE(*CHAR) LEN(5)               */ /*CPM005*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
/*********** DCL        VAR(&WWPARM) TYPE(*CHAR) LEN(60)           */ /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*CPM005*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*  GLOBAL MONITOR MESSAGE:                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ENDTAG))
 
/*  SET OFF SWITCHES:                                                */
             CHGJOB     SWS(00000000)
 
/***RETRIEVE*PHASE*OF*DAILY*PROCESSING******************************/ /*CPM005*/
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)              */ /*CPM005*/
 
/***RETRIEVE*PHASE*OF*DAILY*PROCESSING******************************/ /*CPM005*/
/*********** RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)        */ /*CPM005*/
 
/***RETRIEVE*TYPE*OF*JOB*-*'0'*=*BATCH******************************/ /*CPM005*/
/************************-*'1'*=*INTERACTIVE************************/ /*CPM005*/
/*********** RTVJOBA    TYPE(&WWTYPE)                              */ /*CPM005*/
 
/***IF*BATCH*JOB,*BYPASS*PROMPT*PROCESSING:*************************/ /*CPM005*/
/*********** IF         COND(&WWTYPE *EQ '0') THEN(DO)             */ /*CPM005*/
/*********** GOTO       CMDLBL(BATCH)                              */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
 
/***SET*UP*CALLING*PROGRAM*NAME:************************************/ /*CPM005*/
/*********** CHGVAR     VAR(&WWCLP) VALUE('PMC6041')               */ /*CPM005*/
 
/***RETRIEVE*USER*PROFILE*OF*SIGNED*ON*USER*************************/ /*CPM005*/
/*********** RTVJOBA    USER(&WWUSRP)                              */ /*CPM005*/
 
/***CALL*PROGRAM*TO*INPUT*REPORT*PROMPTS:***************************/ /*CPM005*/
/*PM6041:*** CALL       PGM(PM6041) PARM(&WWCLP &WWUSRP &WWCYCL +  */ /*CPM005*/
/***********            &WWDEPT &WWACOF &WWCUST &WWPREF &WWINBA +  */ /*CPM005*/
/***********            &WWRTRN)                                   */ /*CPM005*/
 
/***DATABASE*ERRORS,*IF*U7*+*U8*ON:*********************************/ /*CPM005*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*CPM005*/
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +            */ /*CPM005*/
/***********            MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)          */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** GOTO       CMDLBL(ENDPGM)                             */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
 
/***IF*F3*TAKEN*IN*PROMPT*PROGRAM,*TERMINATE*PROCESSING:************/ /*CPM005*/
/*********** IF         COND(&WWRTRN *EQ '1') THEN(DO)             */ /*CPM005*/
/*********** GOTO       CMDLBL(ENDPGM)                             */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
/**/
/***REPORT*RUN*DURING*COB;*SEND*PROGRAM*AND*PARAMETER*TO*MSGQ/EODQ:*/ /*CPM005*/
/*********** IF         COND(&WWCYCL *EQ 'C') THEN(DO)             */ /*CPM005*/
/**/
/***FORMAT*VARIABLE*TO*BE*SENT*TO*MSGQ/EODQ:************************/ /*CPM005*/
/*********** CHGVAR     VAR(&WWPARM) VALUE('PMC6041    ' *CAT +    */ /*CPM005*/
/***********              '''' *CAT &WWACOF *CAT '''' *CAT ' ' +   */ /*CPM005*/
/***********              *CAT '''' *CAT &WWCUST *CAT '''' *CAT +  */ /*CPM005*/
/***********              ' ' *CAT '''' *CAT &WWPREF *CAT '''')    */ /*CPM005*/
/**/
/***SEND*MESSAGE*TO*MSGQ/EODQ:**************************************/ /*CPM005*/
/*********** SNDMSG     MSG(&WWPARM) TOMSGQ(EODQ)                  */ /*CPM005*/
/*********** GOTO       CMDLBL(DATA)                               */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
/**/
 
 
/*********** IF         COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ +    */ /*CPM005*/
/***********            'B') THEN(DO)                              */ /*CPM005*/
/*********** SBMJOB     CMD(CALL PGM(PMC6041) PARM(&WWACOF +       */ /*CPM005*/
/***********            &WWCUST &WWPREF)) +                        */ /*CPM005*/
/***********            JOBQ(MJOBQ)                                */ /*CPM005*/
/*********** GOTO       CMDLBL(DATA)                               */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
 
/***REPORT*DURING*EOD*OR*ON*REQ*************************************/ /*CPM005*/
/**BATCH:*** CHGJOB     SWS(1XXXXXXX)                              */ /*CPM005*/
 
/* CREATE DTAARA/LDA IN QTEMP */
/*********** CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +   */ /*CPM005*/
/***********              TEXT('MIDAS/ABS SD Local Data Area')     */ /*CPM005*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')            /*CPM005*/
             MONMSG     MSGID(CPF0000)
/**/                                                                  /*CPM005*/
/* Set Program Variables */                                           /*CPM005*/
/**/                                                                  /*CPM005*/
             IF         COND(&RENT *EQ 'ALL') THEN(+
               CHGVAR     VAR(&WWACOF) VALUE('*ALL'))                 /*CPM005*/
             ELSE       CMD(CHGVAR VAR(&WWACOF) VALUE(&RENT))         /*CPM005*/
/**/                                                                  /*CPM005*/
             CHGVAR     VAR(&WWCUST) VALUE(%SST(&PARM 1 6))           /*CPM005*/
             CHGVAR     VAR(&WWPREF) VALUE(%SST(&PARM 7 4))           /*CPM005*/
 
/***RUN*REPORT*FOR*INPUT*QRYF*PMCUSTPO:*****************************/ /*CPM005*/
/*  RUN REPORT FOR INPUT QRYF PMCUSTQ0:                            */ /*CPM005*/
/*  A  -  A/C OFFICER = *ALL ; CUSTOMER = *ALL ; PORTFOLIO = 9997    */
/*  B  -  A/C OFFICER = *ALL ; CUSTOMER = *ALL ; PORTFOLIO = 9999    */
/*  C  -  A/C OFFICER = *ALL ; CUSTOMER = *ALL ; PORTFOLIO = 9998    */
/*  D  -  A/C OFFICER = *ALL ; CUSTOMER = *ALL ; PORTFOLIO = *ALL    */
 
             IF         COND(&WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +
                        *AND &WWPREF *EQ '9999' *OR +
                        &WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +
                        *AND &WWPREF *EQ '9998' *OR +
                        &WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +
                        *AND &WWPREF *EQ '9997' *OR +
                        &WWACOF *EQ '*ALL' *AND &WWCUST *EQ '*ALL  ' +
                        *AND &WWPREF *EQ '*ALL') THEN(DO)
/*********** OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)*/ /*CPM005*/
/*********** MONMSG     MSGID(CPF0000)                             */ /*CPM005*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) +         */ /*CPM005*/
/***********            (SDPLCSPD)) FORMAT(PMCUSTPO) QRYSLT(+      */ /*CPM005*/
/***********            'QBRECI *EQ "D" *AND QBPCUS *EQ "Y"') +    */ /*CPM005*/
/***********            KEYFLD((SDACOFPD/AZPRTL) +                 */ /*CPM005*/
/***********            (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) JFLD(+*/ /*CPM005*/
/***********            (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +        */ /*CPM005*/
/***********            SDCUSTPD/BBCUST SDPLCSPD/QBCUST))          */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** CALL       PGM(PM6040) PARM(&WWACOF &WWCUST &WWPREF)  */ /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*CPM005*/
             MONMSG     MSGID(CPF0000)                                /*CPM005*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*CPM005*/
/**/                                                                  /*CPM005*/
             CALL       PGM(PM6040) PARM(&RSEQ &RENT &WWCUST &WWPREF) /*CPM005*/
 
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
 
/*  D  -  A/C OFFICER = DEF. ; CUSTOMER = DEF. ; PORTFOLIO = *ALL    */
/*  F  -  A/C OFFICER = DEF. ; CUSTOMER = DEF. ; PORTFOLIO = DEF.    */
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK +
                        *AND &WWPREF *EQ '*ALL' *OR +
                        &WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *NE '*ALL  ' *AND &WWCUST *NE *BLANK +
                        *AND &WWPREF *NE '*ALL' *AND &WWPREF *NE *BLANK) +
                        THEN(DO)
/*********** OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)*/ /*CPM005*/
/*********** MONMSG     MSGID(CPF0000)                             */ /*CPM005*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) +         */ /*CPM005*/
/***********            (SDPLCSPD)) FORMAT(PMCUSTPO) QRYSLT(+      */ /*CPM005*/
/***********            'QBRECI *EQ "D" *AND QBPCUS *EQ "Y" *AND + */ /*CPM005*/
/***********            AZACOC *EQ "' *CAT &WWACOF *CAT '" *AND +  */ /*CPM005*/
/***********            BBCUST *EQ "' *CAT &WWCUST *CAT '"') +     */ /*CPM005*/
/***********            KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) */ /*CPM005*/
/***********            (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC + */ /*CPM005*/
/***********            SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +        */ /*CPM005*/
/***********            SDPLCSPD/QBCUST))                          */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** CALL       PGM(PM6040) PARM(&WWACOF &WWCUST &WWPREF)  */ /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*CPM005*/
             MONMSG     MSGID(CPF0000)                                /*CPM005*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D" +
                        *AND AZACOC *EQ "' *CAT +
                        &WWACOF *CAT '" *AND BBCUST *EQ "' *CAT +
                        &WWCUST *CAT '"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*CPM005*/
 
             CALL       PGM(PM6040) PARM(&RSEQ &RENT &WWCUST &WWPREF) /*CPM005*/
 
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
 
/*  E  -  A/C OFFICER = DEF. ; CUSTOMER = *ALL ; PORTFOLIO = *ALL    */
 
             IF         COND(&WWACOF *NE '*ALL' *AND &WWACOF *NE *BLANK +
                        *AND &WWCUST *EQ '*ALL  ') THEN(DO)
/*********** OVRDBF     FILE(PMCUSTPO) TOFILE(SDACOFPD) SHARE(*YES)*/ /*CPM005*/
/*********** MONMSG     MSGID(CPF0000)                             */ /*CPM005*/
/*********** OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) +         */ /*CPM005*/
/***********            (SDPLCSPD) FORMAT(PMCUSTPO) QRYSLT(+       */ /*CPM005*/
/***********            'QBRECI *EQ "D" *AND QBPCUS *EQ "Y" *AND + */ /*CPM005*/
/***********            AZACOC *EQ "' *CAT &WWACOF *CAT '"') +     */ /*CPM005*/
/***********            KEYFLD((SDACOFPD/AZPRTL) (SDACOFPD/AZACOC) */ /*CPM005*/
/***********            (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC + */ /*CPM005*/
/***********            SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +        */ /*CPM005*/
/***********            SDPLCSPD/QBCUST))                          */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** CALL       PGM(PM6040) PARM(&WWACOF &WWCUST &WWPREF)  */ /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*CPM005*/
             MONMSG     MSGID(CPF0000)                                /*CPM005*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDPLCSPD)) +
                        FORMAT(PMCUSTQ0) QRYSLT('QBRECI *EQ "D" +
                        *AND AZACOC *EQ "' *CAT +
                        &WWACOF *CAT '"') +
                        KEYFLD((SDACOFPD/AZACOC) +
                        (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                        SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                        SDPLCSPD/QBCUST))                             /*CPM005*/
                                                                      /*CPM005*/
             CALL       PGM(PM6040) PARM(&RSEQ &RENT &WWCUST &WWPREF) /*CPM005*/
 
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
/**/                                                                  /*CPM005*/
/*  G  -  A/C OFFICER = *ALL ; CUSTOMER = DEF. ; PORTFOLIO = *ALL */  /*CPM005*/
/**/                                                                  /*CPM005*/
             IF         COND(&WWACOF *EQ '*ALL' *AND (&WWCUST +
                          *NE '*ALL' *AND &WWCUST *NE +
                          *BLANKS)) THEN(DO)                          /*CPM005*/
               OVRDBF     FILE(PMCUSTQ0) TOFILE(SDACOFPD) SHARE(*YES) /*CPM005*/
               MONMSG     MSGID(CPF0000)                              /*CPM005*/
               OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) +
                            (SDPLCSPD)) FORMAT(PMCUSTQ0) QRYSLT(+
                            'QBRECI *EQ "D" *AND +
                            BBCUST *EQ "' *CAT &WWCUST *CAT '"') +
                            KEYFLD((SDACOFPD/AZACOC) +
                            (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                            SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                            SDPLCSPD/QBCUST))                         /*CPM005*/
                                                                      /*CPM005*/
               CALL       PGM(PM6040) PARM(&RSEQ &RENT &WWCUST +
                            &WWPREF)                                  /*CPM005*/
                                                                      /*CPM005*/
               CLOF       OPNID(SDACOFPD)                             /*CPM005*/
               DLTOVR     FILE(*ALL)                                  /*CPM005*/
/**/                                                                  /*CPM005*/
/* In case of DATABASE ERROR: */                                      /*CPM005*/
/**/                                                                  /*CPM005*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            /*CPM005*/
                 GOTO       CMDLBL(DATA)                              /*CPM005*/
               ENDDO                                                  /*CPM005*/
/**/                                                                  /*CPM005*/
/* In case of FILE ERROR: */                                          /*CPM005*/
/**/                                                                  /*CPM005*/
               IF         COND(%SWITCH(XXXXXX01)) THEN(DO)            /*CPM005*/
                 GOTO       CMDLBL(FILE)                              /*CPM005*/
               ENDDO                                                  /*CPM005*/
             ENDDO                                                    /*CPM005*/
 
/*  DATABASE ERROR, IF U7 + U8 ON:                                   */
 DATA:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          */ /*CPM005*/
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +            */ /*CPM005*/
/***********            MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)          */ /*CPM005*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*CPM005*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*CPM005*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  FILE OUT OF BALANCE ERROR, IF U8 ON:                             */
 FILE:       IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/*********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) TOMSGQ(+     */ /*CPM005*/
/***********              MOPERQ MRUNQ)                            */ /*CPM005*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*CPM005*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  IF BATCH JOB, TERMINATE PROCESSING:                              */
/*********** IF         COND(&WWTYPE *EQ '0') THEN(DO)             */ /*CPM005*/
/*********** GOTO       CMDLBL(ENDPGM)                             */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
 
/*  IF F3 NOT TAKEN IN PM6041, GO TO PROGRAM:                        */
/*********** IF         COND(&WWRTRN *NE '1') THEN(DO)             */ /*CPM005*/
/*********** GOTO       CMDLBL(PM6041)                             */ /*CPM005*/
/*********** ENDDO                                                 */ /*CPM005*/
 
             GOTO       CMDLBL(ENDPGM)
 
/*  ERROR IN CL PROGRAM:                                             */
 ENDTAG:     DMPCLPGM
 
/*ENDPGM:*** RCLRSC                                                */ /*CPM005*/
/*********** ENDPGM                                                */ /*CPM005*/
 ENDPGM:     RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
