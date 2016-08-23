/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Turnover by Industry per Department')        */
/********************************************************************/
/*                                                                  */
/*       Midas     - Portfolio Management Module                    */
/*                                                                  */
/*       PMC0540 PM TURNOVER BY INDUSTRY PER DEPARTMENT             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*                                                                  */
/*       Last Amend No. CER059             Date 19Jul10              */
/*       Prev Amend No. BUG23967           Date 15May09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      093976             Date 25Oct95              */
/*                      S01486  JSV       DATE  18OCT94             */
/*                      R00300            DATE  28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23967 - Add Local Industry Code Field.                  */
/*       093976  -  Change PMSTAT to show that PMC0900 is running   */
/*       S01486  -  Private Banking Upgrade to Release 10           */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWDEPT)                                   S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01486*/
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
/************DCL        VAR(&WWDEPT) TYPE(*CHAR) LEN(4)                 S01486*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                   S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1)
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
/**/
/* IF TURNOVER HAS NOT BEEN RUN BEFORE IN THIS COB EXTRACT TURNOVER  */
/* DETAILS */
DATAAREA:                                                             /*093976*/
             RTVDTAARA  DTAARA(PMSTAT (20 1)) RTNVAR(&RUN)
             IF         COND(&RUN *EQ 'R') THEN(DO)                   /*093976*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*093976*/
             GOTO       CMDLBL(DATAAREA)                              /*093976*/
             ENDDO                                                    /*093976*/
             IF         COND(&RUN *EQ 'N') THEN(DO)
             CHGDTAARA  DTAARA(PMSTAT (20 1)) VALUE('R')              /*093976*/
                CALL       PGM(PMC0900)
                CHGDTAARA  DTAARA(PMSTAT (20 1)) VALUE('Y')
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)   */    /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/************    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                          S01486*/
/*                                                                    /*R00300*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
                 GOTO     ENDTAG
             ENDDO
             ENDDO
/************OVRDBF     FILE(PMTUR4PO) TOFILE(SDDEPTPD) SHARE(*YES)     S01486*/
             OVRDBF     FILE(PMTUR4Q0) TOFILE(SDDEPTPD) SHARE(*YES)   /*S01486*/
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
/************IF         COND(&WWDEPT *EQ '*ALL') +
                          THEN(DO)                                      S01486*/
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPP)) FORMAT(PMTUR4PO) +
                          QRYSLT('W1LIND *NE "000"') +
                          KEYFLD((SDDEPTPD/AEPRTL) (SDDEPTPD/AEDPCD) +
                          (PMCUTVPP/SBLIND) (SDACOFPD/AZACOC) +
                          (PMCUTVPP/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((W1LIND SBLIND +
                          *CHAR 3) (BBCNUM SBCNUM *CHAR 6))            S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
/**********  OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR4Q0) +
                          QRYSLT('W1LIND *NE "000"') +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBLIND) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((W1LIND SBLIND +
                          *CHAR 3) (BBCNUM SBCNUM *CHAR 6))                  /*S01486*/ /*BUG23967*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR4Q0) +
                          QRYSLT('W1LOIC *NE "000" *AND W1LOIC *NE "   "') +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBLOIC) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((W1LOIC SBLOIC +
                          *CHAR 3) (BBCNUM SBCNUM *CHAR 6))                             /*BUG23967*/
             ENDDO
/**/
/*  RUN REPORT SHOWING DETAILS FOR SELECTED DEPARTMENT                        */
/************IF         COND((&WWDEPT *NE '*ALL')) +
                          THEN(DO)                                      S01486*/
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPP)) FORMAT(PMTUR4PO) QRYSLT(' +
                          AEDPCD *EQ "' *CAT &WWDEPT *CAT '" *AND +
                          W1LIND *NE "000"') +
                          KEYFLD((SDDEPTPD/AEPRTL) (SDDEPTPD/AEDPCD) +
                          (PMCUTVPP/SBLIND) (SDACOFPD/AZACOC) +
                          (PMCUTVPP/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((BBCNUM SBCNUM +
                          *CHAR 6) (W1LIND SBLIND *CHAR 3))             S01486*/
             IF         COND(&RENT *NE 'ALL') THEN(DO)                /*S01486*/
/**********  OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR4Q0) QRYSLT(' +
                          AEDPCD *EQ "' *CAT &RENT *CAT '" *AND +
                          W1LIND *NE "000"') +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBLIND) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((W1LIND SBLIND +
                          *CHAR 3) (BBCNUM SBCNUM *CHAR 6))                  /*S01486*/ /*BUG23967*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR4Q0) QRYSLT(' +
                          AEDPCD *EQ "' *CAT &RENT *CAT '" *AND +
                          W1LOIC *NE "000" *AND W1LOIC *NE "   "') +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBLOIC) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((W1LOIC SBLOIC +
                          *CHAR 3) (BBCNUM SBCNUM *CHAR 6))                             /*BUG23967*/
             ENDDO
/**/
/** RUN TURNOVER REPORT */
/************CALL       PGM(PM0540) PARM(&WWDEPT)                       S01486*/
             CALL       PGM(PM0540) PARM(&RSEQ)                       /*S01486*/
             CLOF       OPNID(SDDEPTPD)
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)   */    /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)/+S01486*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/*                                                                    /*R00300*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
             ENDDO
             GOTO       CMDLBL(END)
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/*END:********ENDPGM                                                    S01486*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*S01486*/
             ENDPGM                                                   /*S01486*/
