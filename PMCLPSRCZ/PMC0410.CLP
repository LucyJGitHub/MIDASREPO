/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Account Officer Department Cashflow')        */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0410 - PM ACCOUNT OFFICER DEPARTMENT CASHFLOW           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01486  LV        DATE 22SEP94              */
/*                      063367            DATE 16NOV93              */
/*                      58180             DATE 07JUL93              */
/*                      049421            DATE 18JAN93              */
/*                      47905             DATE 30NOV92              */
/*                      45867             DATE 23OCT92              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                             */
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
/************PGM        PARM(&WWDEPT &WWACOF &WWCUST &WWPREF &WW60DD +/*S01486*/
/************             &WWMOTT &WWYETT &GBCH)                      /*S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT &PARM)                 /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*S01486*/
/**/                                                                  /*S01486*/
/************DCL        VAR(&WWCLP) TYPE(*CHAR) LEN(7)                /*S01486*/
/************DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)              /*S01486*/
/************DCL        VAR(&WWCYCL) TYPE(*CHAR) LEN(1)               /*S01486*/
             DCL        VAR(&WWDEPT) TYPE(*CHAR) LEN(4)
/************DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)               /*S01486*/
/************DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)               /*S01486*/
/************DCL        VAR(&WWPREF) TYPE(*CHAR) LEN(4)               /*S01486*/
             DCL        VAR(&WW60DD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMOTT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWYETT) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&WWINBA) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&WWRTRN) TYPE(*CHAR) LEN(1)               /*S01486*/
             DCL        VAR(&DEPT) TYPE(*CHAR) LEN(3)
/************DCL        VAR(&WWTYPE) TYPE(*CHAR) LEN(1)               /*S01486*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)    */           /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/************DCL        VAR(&WWPAR1) TYPE(*CHAR) LEN(10)              /*S01486*/
/************DCL        VAR(&WWPAR2) TYPE(*CHAR) LEN(5)               /*S01486*/
/************DCL        VAR(&GBCH) TYPE(*CHAR) LEN(1)                 /*S01486*/
 
/*  GLOBAL MONITOR MESSAGE:                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ENDTAG))
 
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
 
             CHGJOB     SWS(00000000)
                                                                      /*S01486*/
/*  SET PROGRAM VARIABLES */                                          /*S01486*/
                                                                      /*S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
                 CHGVAR     VAR(&WWDEPT) VALUE('*ALL')                /*S01486*/
                 ENDDO                                                /*S01486*/
             ELSE       CMD(DO)                                       /*S01486*/
                 CHGVAR     VAR(&WWDEPT) VALUE(&RENT)                 /*S01486*/
                 ENDDO                                                /*S01486*/
             CHGVAR     VAR(&WW60DD) VALUE(%SST(&PARM 1 1))           /*S01486*/
             CHGVAR     VAR(&WWMOTT) VALUE(%SST(&PARM 2 1))           /*S01486*/
             CHGVAR     VAR(&WWYETT) VALUE(%SST(&PARM 3 1))           /*S01486*/
                                                                      /*S01486*/
/***RETRIEVE*PHASE OF DAILY PROCESSING                                /*S01486*/
/************                                                         /*S01486*/
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&WWCYCL)                 /*S01486*/
/************                                                         /*S01486*/
/***IF*BATCH*JOB, BYPASS PROMPT PROCESSING:                           /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWTYPE *EQ '0') THEN(DO)                /*S01486*/
/************GOTO       CMDLBL(BATCH)                                 /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***SET*UP*CALLING*PROGRAM*NAME:                                      /*S01486*/
/************                                                         /*S01486*/
/************CHGVAR     VAR(&WWCLP) VALUE('PMC0410')                  /*S01486*/
/************                                                         /*S01486*/
/***RETRIEVE*USER PROFILE OF SIGNED ON USER                           /*S01486*/
/************                                                         /*S01486*/
/************RTVJOBA    USER(&WWUSRP)                                 /*S01486*/
/************                                                         /*S01486*/
/***CALL*PROGRAM TO INPUT REPORT PROMPTS:                             /*S01486*/
/************                                                         /*S01486*/
/*PM0810:****CALL PGM(PM0810) PARM(&WWCLP &WWUSRP &WWCYCL &WWDEPT +   /*S01486*/
/************     &WWACOF &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT +   /*S01486*/
/************           &WWINBA &WWRTRN &GBCH)                        /*S01486*/
/************                                                         /*S01486*/
/***DATABASE*ERRORS, IF U7 + U8 ON:                                   /*S01486*/
/************                                                         /*S01486*/
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
/************                                                         /*S01486*/
/***REPORT*RUN DURING COB; SEND PROGRAM AND PARAMETER TO MSGQ/EODQ:   /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&GBCH *EQ '2') THEN(DO)                  /*S01486*/
/************                                                         /*S01486*/
/***FORMAT*VARIABLE TO BE SENT TO MSGQ/EODQ:                          /*S01486*/
/************                                                         /*S01486*/
/************    CHGVAR    VAR(&WWPAR1) VALUE('PMC0410   ')           /*S01486*/
/************    CHGVAR    VAR(&WWPAR2) VALUE('10001')                /*S01486*/
/************                                                         /*S01486*/
/**UPDATE*WORK FILE                                                   /*S01486*/
/************                                                         /*S01486*/
/************CALL       PGM(PM0410A) PARM(&WWPAR1 &WWPAR2 &WWDEPT +   /*S01486*/
/************       &WWACOF &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT)  /*S01486*/
/*>>>*063367*>>>                                                      /*S01486*/
/************GOTO       CMDLBL(LOIN)                                  /*S01486*/
/*<<<*063367*<<<                                                      /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***REPORT*NOT DURING EOD; SUBMIT JOB TO BATCH TO RUN PROGRAM:        /*S01486*/
/************                                                         /*S01486*/
/************IF         COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'B' +   /*S01486*/
/************                *AND &WWCYCL *NE 'B') THEN(DO)           /*S01486*/
/************SBMJOB     CMD(CALL PGM(PMC0410) PARM(&WWDEPT &WWACOF +  /*S01486*/
/************           &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT)) +   /*S01486*/
/************           JOBQ(MJOBQ)                       /*47905*/   /*S01486*/
/************SBMJOB     CMD(CALL PGM(PMC0410) PARM(&WWDEPT &WWACOF +  /*S01486*/
/************             &WWCUST &WWPREF &WW60DD &WWMOTT &WWYETT +   /*S01486*/
/************             &GBCH)) JOBQ(MJOBQ)              /*47905*/  /*S01486*/
/************ENDDO                                                    /*S01486*/
/************                                                         /*S01486*/
/***REPORT*NOT DURING EOD AND PRODUCED INTERACTIVELY:                 /*S01486*/
/************                                                         /*S01486*/
/*BATCH:******IF    COND(&WWCYCL *NE 'C' *AND &WWINBA *EQ 'I' *OR +   /*S01486*/
/************           &WWTYPE *EQ '0') THEN(DO)                     /*S01486*/
/************                                                         /*S01486*/
/**CREATE*DTAARA/LDA IN QTEMP                                         /*S01486*/
/************CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +      /*S01486*/
/************        TEXT('MIDAS/ABS SD Local Data Area') /*58180 */  /*S01486*/
/************MONMSG MSGID(CPF0000)                        /*58180 */  /*S01486*/
 
/*  CREATE SECOND COPY OF PF/SDDEPTPD TO USE IN QUERY */
 
             CPYF       FROMFILE(SDDEPTPD) TOFILE(QTEMP/SDDEPTPX) +
                        MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817)
 
/*  WHEN DEPARTMENT PARAMETER IS '*ALL':                             */
 
             IF         COND(&WWDEPT *EQ '*ALL') THEN(DO)
 
/*  RUN REPORT SHOWING 60 DAY DETAILS: (U1 ON)                       */
 
                 IF         COND(&WW60DD *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(1XXXXXXX)
/****************OVRDBF   FILE(PMEVN1PO) TOFILE(SDDEPTPD) SHARE(*YES) /*S01486*/
                 OVRDBF   FILE(PMEVN1Q0) TOFILE(SDDEPTPD) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFDYPP)) FORMAT(PMEVN1PO) +              /*S01486*/
/************             QRYSLT('QKPTFR *NE "9997" *AND QKPTFR *NE + /*S01486*/
/************             "9998" *AND QKPTFR *NE "9999"') +           /*S01486*/
/************             KEYFLD((SDDEPTPD/AEPRTL) (SDACOFPD/AZDPCD) +/*S01486*/
/************             (PMCFDYPP/QKDYNO) (SDACOFPD/AZACOC) +       /*S01486*/
/************             (PMCFDYPP/QKCCY)) JFLD((SDDEPTPD/AEDPCD +   /*S01486*/
/************             SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +         /*S01486*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01486*/
/************             *MAPFLD/QKCNU1)) MAPFLD((QKCNU1 QKCNUM +    /*S01486*/
/************             *CHAR 6))  */                               /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCFDYPD)) FORMAT(PMEVN1Q0) +
                          QRYSLT('QKPTFR *NE "9997" *AND QKPTFR *NE +
                          "9998" *AND QKPTFR *NE "9999"') +
                          KEYFLD((SDACOFPD/AZDPCD) +
                          (PMCFDYPD/QKDYNO) (SDACOFPD/AZACOC) +
                          (PMCFDYPD/QKCCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/QKCNU1)) MAPFLD((QKCNU1 QKCNUM +
                          *CHAR 6))                                   /*S01486*/
             ENDDO
 
/*  RUN REPORT SHOWING MONTHLY DETAILS: (U2 ON)                      */
 
                 IF         COND(&WWMOTT *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(X1XXXXXX)
/****************OVRDBF   FILE(PMEVN2PO) TOFILE(SDDEPTL0) SHARE(*YES) /*S01486*/
                 OVRDBF   FILE(PMEVN2Q0) TOFILE(SDDEPTL1) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTL0) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFMYPP)) FORMAT(PMEVN2PO) +              /*S01486*/
/************             QRYSLT('QLMYIN *EQ "M" *AND QLPTFR *NE +    /*S01486*/
/************             "9997" *AND QLPTFR *NE "9998" *AND QLPTFR + /*S01486*/
/************             *NE "9999"') KEYFLD((SDDEPTL0/AEPRTL) +     /*S01486*/
/************             (SDACOFPD/AZDPCD) (PMCFMYPP/QLMYNO) +       /*S01486*/
/************             (SDACOFPD/AZACOC) (PMCFMYPP/QLCCY)) +       /*S01486*/
/************             JFLD((SDDEPTL0/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +         /*S01486*/
/************             MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTL1) (SDACOFPD) (SDCUSTPD) +
                          (PMCFMYPD)) FORMAT(PMEVN2Q0) +
                          QRYSLT('QLMYIN *EQ "M" *AND QLPTFR *NE +
                          "9997" *AND QLPTFR *NE "9998" *AND QLPTFR +
                          *NE "9999"') KEYFLD( +
                          (SDACOFPD/AZDPCD) (PMCFMYPD/QLMYNO) +
                          (SDACOFPD/AZACOC) (PMCFMYPD/QLCCY)) +
                          JFLD((SDDEPTL1/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +
                          MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             ENDDO
 
/*  RUN REPORT SHOWING YEARLY DETAILS: (U3 ON)                       */
 
                 IF         COND(&WWYETT *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(XX1XXXXX)
/****************OVRDBF   FILE(PMEVN3PO) TOFILE(SDDEPTPX) SHARE(*YES) /*S01386*/
                 OVRDBF   FILE(PMEVN3Q0) TOFILE(SDDEPTPX) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTPX) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFMYPP)) FORMAT(PMEVN3PO) +              /*S01486*/
/************             QRYSLT('QLMYIN *EQ "Y" *AND QLPTFR *NE +    /*S01486*/
/************             "9997" *AND QLPTFR *NE "9998" *AND QLPTFR + /*S01486*/
/************             *NE "9999"') KEYFLD((SDDEPTPX/AEPRTL) +     /*S01486*/
/************             (SDACOFPD/AZDPCD) (PMCFMYPP/QLMYNO) +       /*S01486*/
/************             (SDACOFPD/AZACOC) (PMCFMYPP/QLCCY)) +       /*S01486*/
/************             JFLD((SDDEPTPX/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +         /*S01486*/
/************             MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPX) (SDACOFPD) (SDCUSTPD) +
                          (PMCFMYPD)) FORMAT(PMEVN3Q0) +
                          QRYSLT('QLMYIN *EQ "Y" *AND QLPTFR *NE +
                          "9997" *AND QLPTFR *NE "9998" *AND QLPTFR +
                          *NE "9999"') KEYFLD( +
                          (SDACOFPD/AZDPCD) (PMCFMYPD/QLMYNO) +
                          (SDACOFPD/AZACOC) (PMCFMYPD/QLCCY)) +
                          JFLD((SDDEPTPX/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +
                          MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             ENDDO
 
             ENDDO
 
/*  WHEN DEPARTMENT PARAMETER IS NOT '*ALL':                         */
 
             IF         COND(&WWDEPT *NE '*ALL') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE(%SST(&WWDEPT 1 3))
 
/*  RUN REPORT SHOWING 60 DAY DETAILS: (U1 ON)                       */
 
                 IF         COND(&WW60DD *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(1XXXXXXX)
/****************OVRDBF   FILE(PMEVN1PO) TOFILE(SDDEPTPD) SHARE(*YES) /*S01486*/
                 OVRDBF   FILE(PMEVN1Q0) TOFILE(SDDEPTPD) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFDYPP)) FORMAT(PMEVN1PO) +              /*S01486*/
/************             QRYSLT('QKPTFR *NE "9997" *AND QKPTFR *NE + /*S01486*/
/************             "9998" *AND QKPTFR *NE "9999" *AND AZDPCD + /*S01486*/
/************             *EQ "' *CAT &DEPT *CAT '"') +               /*S01486*/
/************             KEYFLD((SDDEPTPD/AEPRTL) (SDACOFPD/AZDPCD) +/*S01486*/
/************             (PMCFDYPP/QKDYNO) (SDACOFPD/AZACOC) +       /*S01486*/
/************             (PMCFDYPP/QKCCY)) JFLD((SDDEPTPD/AEDPCD +   /*S01486*/
/************             SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +         /*S01486*/
/************             SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01486*/
/************             *MAPFLD/QKCNU1)) MAPFLD((QKCNU1 QKCNUM +    /*S01486*/
/************             *CHAR 6))                                   /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCFDYPD)) FORMAT(PMEVN1Q0) +
                          QRYSLT('QKPTFR *NE "9997" *AND QKPTFR *NE +
                          "9998" *AND QKPTFR *NE "9999" *AND AZDPCD +
                          *EQ "' *CAT &DEPT *CAT '"') +
                          KEYFLD((SDACOFPD/AZDPCD) +
                          (PMCFDYPD/QKDYNO) (SDACOFPD/AZACOC) +
                          (PMCFDYPD/QKCCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/QKCNU1)) MAPFLD((QKCNU1 QKCNUM +
                          *CHAR 6))                                   /*S01486*/
                 ENDDO
 
/*  RUN REPORT SHOWING MONTHLY DETAILS: (U2 ON)                      */
 
                 IF         COND(&WWMOTT *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(X1XXXXXX)
/****************OVRDBF   FILE(PMEVN2PO) TOFILE(SDDEPTL0) SHARE(*YES) /*S01486*/
                 OVRDBF   FILE(PMEVN2Q0) TOFILE(SDDEPTL1) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTL0) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFMYPP)) FORMAT(PMEVN2PO) +              /*S01486*/
/************             QRYSLT('QLMYIN *EQ "M" *AND QLPTFR *NE +    /*S01486*/
/************             "9997" *AND QLPTFR *NE "9998" *AND QLPTFR + /*S01486*/
/************             *NE "9999" *AND AZDPCD *EQ "' *CAT &DEPT +  /*S01486*/
/************             *CAT '"') KEYFLD((SDDEPTL0/AEPRTL) +        /*S01486*/
/************             (SDACOFPD/AZDPCD) (PMCFMYPP/QLMYNO) +       /*S01486*/
/************             (SDACOFPD/AZACOC) (PMCFMYPP/QLCCY)) +       /*S01486*/
/************             JFLD((SDDEPTL0/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +         /*S01486*/
/************             MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTL1) (SDACOFPD) (SDCUSTPD) +
                          (PMCFMYPD)) FORMAT(PMEVN2Q0) +
                          QRYSLT('QLMYIN *EQ "M" *AND QLPTFR *NE +
                          "9997" *AND QLPTFR *NE "9998" *AND QLPTFR +
                          *NE "9999" *AND AZDPCD *EQ "' *CAT &DEPT +
                          *CAT '"') KEYFLD( +
                          (SDACOFPD/AZDPCD) (PMCFMYPD/QLMYNO) +
                          (SDACOFPD/AZACOC) (PMCFMYPD/QLCCY)) +
                          JFLD((SDDEPTL1/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +
                          MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
                 ENDDO
 
/*  RUN REPORT SHOWING YEARLY DETAILS: (U3 ON)                       */
 
                 IF         COND(&WWYETT *EQ 'Y') THEN(DO)
                 CHGJOB     SWS(XX1XXXXX)
/****************OVRDBF   FILE(PMEVN3PO) TOFILE(SDDEPTPX) SHARE(*YES) /*S01486*/
                 OVRDBF   FILE(PMEVN3Q0) TOFILE(SDDEPTPX) SHARE(*YES) /*S01486*/
                 MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDDEPTPX) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCFMYPP)) FORMAT(PMEVN3PO) +              /*S01486*/
/************             QRYSLT('QLMYIN *EQ "Y" *AND QLPTFR *NE +    /*S01486*/
/************             "9997" *AND QLPTFR *NE "9998" *AND QLPTFR + /*S01486*/
/************             *NE "9999" *AND AZDPCD *EQ "' *CAT &DEPT +  /*S01486*/
/************             *CAT '"') KEYFLD((SDDEPTPX/AEPRTL) +        /*S01486*/
/************             (SDACOFPD/AZDPCD) (PMCFMYPP/QLMYNO) +       /*S01486*/
/************             (SDACOFPD/AZACOC) (PMCFMYPP/QLCCY)) +       /*S01486*/
/************             JFLD((SDDEPTPX/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +         /*S01486*/
/************             MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPX) (SDACOFPD) (SDCUSTPD) +
                          (PMCFMYPD)) FORMAT(PMEVN3Q0) +
                          QRYSLT('QLMYIN *EQ "Y" *AND QLPTFR *NE +
                          "9997" *AND QLPTFR *NE "9998" *AND QLPTFR +
                          *NE "9999" *AND AZDPCD *EQ "' *CAT &DEPT +
                          *CAT '"') KEYFLD( +
                          (SDACOFPD/AZDPCD) (PMCFMYPD/QLMYNO) +
                          (SDACOFPD/AZACOC) (PMCFMYPD/QLCCY)) +
                          JFLD((SDDEPTPX/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/QLCUST)) +
                          MAPFLD((QLCUST QLCNUM *CHAR 6))             /*S01486*/
                 ENDDO
                 ENDDO
 
/****************CALL       PGM(PM0410) PARM(&WWDEPT)                 /*S01486*/
                 CALL       PGM(PM0410) PARM(&RSEQ &WWDEPT)           /*S01486*/
 
             IF         COND(&WW60DD *EQ 'Y') THEN(DO)
             CLOF       OPNID(SDDEPTPD)
             ENDDO
 
             IF         COND(&WWMOTT *EQ 'Y') THEN(DO)
/************CLOF       OPNID(SDDEPTL0)                               /*S01486*/
             CLOF       OPNID(SDDEPTL1)                               /*S01486*/
             ENDDO
 
             IF         COND(&WWYETT *EQ 'Y') THEN(DO)
             CLOF       OPNID(SDDEPTPX)
             ENDDO
 
/*  IN CASE OF DATABASE ERROR:                                       */
 
                 IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 GOTO       CMDLBL(DATA)
                 ENDDO
 
/*  IN CASE OF FILE ERROR:                                           */
 
                 IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                 GOTO       CMDLBL(FILE)
                 ENDDO
 
                 CHGJOB     SWS(00000000)
 
/************ENDDO                                                    /*S01486*/
 
/*  DATABASE ERROR, IF U7 + U8 ON:                                   */
 
 DATA:           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
 
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01486*/
/***************            TOMSGQ(MOPERQ MRUNQ)                      /*S01486*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                            MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)         /*S01486*/
 
                 GOTO       CMDLBL(ENDPGM)
                 ENDDO
 
/*  FILE OUT OF BALANCE ERROR, IF U8 ON:                             */
 
 FILE:           IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
 
/****************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) +           /*S01486*/
/****************           TOMSGQ(MOPERQ MRUNQ)                      /*S01486*/
                 SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                            TOMSGQ(MOPERQ MRUNQ)                      /*S01486*/
 
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
/************CHGJOB     SWS(000XXXXX)                                 /*S01486*/
/************GOTO       CMDLBL(PM0810)                                /*S01486*/
/************ENDDO                                                    /*S01486*/
 
             GOTO       CMDLBL(ENDPGM)
 
/*>>> 063367 >>> */
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
/*<<< 063367 <<< */
/*  ERROR IN CL PROGRAM:                                             */
 
 ENDTAG:     DMPCLPGM
/**********ENDPGM:     RCLRSC                                          *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
         ENDPGM                                                       /*S01486*/
