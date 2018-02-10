/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Turnover by Country per Department')         */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0520 PM TURNOVER BY COUNTRY PER DEPARTMENT              */
/*                  (On request processing)                         */
/*                                                                  */
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
/*       PREV AMEND NO. S01486  RS        DATE  14OCT94             */
/*                      R00300            DATE  28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01486  -  PORTFOLIO MANAGEMENT UPGRADE TO R10             */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&WWDEPT)                             */  /*S01486*/
/*                                                               */
             PGM      PARM(&RSEQ &RLVL &RENT)                         /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&WWDEPT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*S01486*/
/************DCL        VAR(&RUN) TYPE(*CHAR) LEN(1)               */ /*S01486*/
/**/
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
             IF         COND(&RENT *EQ 'ALL') THEN(DO)
                CHGVAR     VAR(&WWDEPT) VALUE('*ALL')
                ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&WWDEPT) VALUE(&RENT)
                ENDDO
/**/
/**IF*TURNOVER*HAS*NOT*BEEN*RUN*BEFORE*IN*THIS*COB*EXTRACT*TURNOVER*/ /*S01486*/
/**DETAILS**/                                                         /*S01486*/
/************RTVDTAARA  DTAARA(PMSTAT (20 1)) RTNVAR(&RUN)        */  /*S01486*/
/************IF         COND(&RUN *EQ 'N') THEN(DO)               */  /*S01486*/
/************   CALL       PGM(PMC0900)                           */  /*S01486*/
/************   CHGDTAARA  DTAARA(PMSTAT (20 1)) VALUE('Y')       */  /*S01486*/
/**/                                                                  /*S01486*/
/***DATABASE*ERRORS,*IF*U7*+*U8*ON***/                                /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)          */  /*S01486*/
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)     */  /*S01486*/
/*                                                                */  /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
/*                                                       /*R00300*/   /*S01486*/
/************    GOTO     ENDTAG                                   */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
/************OVRDBF     FILE(PMTUR3PO) TOFILE(SDDEPTPD) SHARE(*YES)*/ /*S01486*/
             OVRDBF     FILE(PMTUR3Q0) TOFILE(SDDEPTPD) SHARE(*YES)
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
             IF         COND(&WWDEPT *EQ '*ALL') +
                          THEN(DO)
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCUTVPP)) FORMAT(PMTUR3PO) +              /*S01486*/
/************             KEYFLD((SDDEPTPD/AEPRTL) (SDDEPTPD/AEDPCD) +/*S01486*/
/************             (SDCUSTPD/BBCOLC) (SDACOFPD/AZACOC) +       /*S01486*/
/************             (PMCUTVPP/SBICCY)) +                        /*S01486*/
/************             JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +         /*S01486*/
/************             MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR3Q0) +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (SDCUSTPD/BBCOLC) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +
                          MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             ENDDO
/**/
/*  RUN REPORT SHOWING DETAILS FOR SELECTED DEPARTMENT                        */
             IF         COND((&WWDEPT *NE '*ALL')) +
                          THEN(DO)
/************OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) + /*S01486*/
/************             (PMCUTVPP)) FORMAT(PMTUR3PO) QRYSLT(' +     /*S01486*/
/************             AEDPCD *EQ "' *CAT &WWDEPT *CAT '"') +      /*S01486*/
/************             KEYFLD((SDDEPTPD/AEPRTL) (SDDEPTPD/AEDPCD) +/*S01486*/
/************             (SDCUSTPD/BBCOLC) (SDACOFPD/AZACOC) +       /*S01486*/
/************             (PMCUTVPP/SBICCY)) +                        /*S01486*/
/************             JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +    /*S01486*/
/************             (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +         /*S01486*/
/************             (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +         /*S01486*/
/************             MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             OPNQRYF    FILE((*LIBL/SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMCUTVPD)) FORMAT(PMTUR3Q0) QRYSLT(' +
                          AEDPCD *EQ "' *CAT &WWDEPT *CAT '"') +
                          KEYFLD((SDDEPTPD/AEDPCD) +
                          (SDCUSTPD/BBCOLC) (SDACOFPD/AZACOC) +
                          (PMCUTVPD/SBICCY)) +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST *MAPFLD/BBCNUM)) +
                          MAPFLD((BBCNUM SBCNUM *CHAR 6))             /*S01486*/
             ENDDO
/**/
/** RUN TURNOVER REPORT */
/************CALL       PGM(PM0520) PARM(&WWDEPT)                  */ /*S01486*/
             CALL       PGM(PM0520) PARM(&RSEQ &WWDEPT)               /*S01486*/
             CLOF       OPNID(SDDEPTPD)
/************DLTOVR     FILE(*ALL)                                 */ /*S01486*/
             DLTOVR     FILE(PMTUR3Q0)                                /*S01486*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*S01486*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01486*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
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
