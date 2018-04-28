/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Turnover by Instrument per Department')      */
/********************************************************************/
/*                                                                  */
/*       Midas     - Portfolio Management Module                    */
/*                                                                  */
/*       PMC0460 PM TURNOVER BY INSTRUMENT PER DEPARTMENT           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 093976             DATE 25OCT95             */
/*       PREV AMEND NO. S01486  JSV        DATE 12OCT94             */
/*                      37830              DATE 01JUL91             */
/*                      R00300             DATE 28AUG90             */
/*                      R10012             DATE 18AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       093976  -  Change PMSTAT to show that PMC0900 is running   */
/*       S01486  -  Private Banking Upgrade to Release 10           */
/*       37830   -  SORT QUERY FILE BY DISPLAY GROUP                */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWDEPT)                                   S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01486*/
/**/
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
/*                                                         /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                        */
/************    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +S01486*/
/************             TOMSGQ(MOPERQ MRUNQ)                          S01486*/
/*                                                         /*R00300*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
                 GOTO     ENDTAG
             ENDDO
             ENDDO
 
/************OVRDBF     FILE(PMTUR1PO) TOFILE(SDDEPTPD) SHARE(*YES)     S01486*/
             OVRDBF     FILE(PMTUR1Q0) TOFILE(SDDEPTPD) SHARE(*YES)   /*S01486*/
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
/************IF         COND(&WWDEPT *EQ '*ALL') THEN(DO)               S01486*/
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPP)) FORMAT(PMTUR1PO) +
                          KEYFLD((SDDEPTPD/AEPRTL) +
                          (SDDEPTPD/AEDPCD) (PMCUTVPP/SBDSPG) +
                          (PMCUTVPP/SBINNR) (SDACOFPD/AZACOC) +
                          (PMCUTVPP/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((BBCNUM SBCNUM +
                          *CHAR 6))                                    S01486*/
             IF         COND(&RENT *EQ 'ALL') THEN(DO)                /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR1Q0) +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBDSPG) (PMCUTVPD/SBINNR) +
                          (SDACOFPD/AZACOC) (PMCUTVPD/SBICCY)) +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +
                          MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             ENDDO
/**/
/*  RUN REPORT SHOWING DETAILS FOR SELECTED DEPARTMENT                        */
/************IF         COND(&WWDEPT *NE '*ALL') THEN(DO)               S01486*/
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPP)) FORMAT(PMTUR1PO) QRYSLT(' +
                          AEDPCD *EQ "' *CAT &WWDEPT *CAT '"') +
                          KEYFLD((SDDEPTPD/AEPRTL) +
                          (SDDEPTPD/AEDPCD) (PMCUTVPP/SBDSPG) +
                          (PMCUTVPP/SBINNR) (SDACOFPD/AZACOC) +
                          (PMCUTVPP/SBICCY)) JFLD((SDDEPTPD/AEDPCD +
                          SDACOFPD/AZDPCD) (SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/BBCNUM)) MAPFLD((BBCNUM SBCNUM +
                          *CHAR 6))                                     S01486*/
             IF         COND(&RENT *NE 'ALL') THEN(DO)                /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR1Q0) +
                          QRYSLT('AEDPCD *EQ "' *CAT &RENT *CAT +
                          '"') KEYFLD((SDDEPTPD/AEDPCD) +
                          (PMCUTVPD/SBDSPG) (PMCUTVPD/SBINNR) +
                          (SDACOFPD/AZACOC) (PMCUTVPD/SBICCY)) +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +
                          MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             ENDDO
/**/
/** RUN TURNOVER REPORT */
/************CALL       PGM(PM0460) PARM(&WWDEPT)                       S01486*/
             CALL       PGM(PM0460) PARM(&RSEQ)                       /*S01486*/
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
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +S01486*/
/****************         TOMSGQ(MOPERQ MRUNQ)                          S01486*/
/*                                                                    /*R00300*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/**/
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
 
/*END:********ENDPGM                                                    S01486*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*S01486*/
             ENDPGM                                                   /*S01486*/
