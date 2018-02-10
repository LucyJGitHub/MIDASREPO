/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Calculate Performance Dataset')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6010 - PM Calculate Performance Dataset                  */
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
/*       Prev Amend No. CPM005             Date 11Jul96              */
/*                      S01124             Date 01Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124 - PBFG/4 - Simple Performance Dataset Save & Query   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*CPM005*/
             PGM        PARM(&RSEQ &RLVL &RENT &PARM)                 /*CPM005*/
/* DECLARE VARIABLES */
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4) VALUE(*ALL)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4) VALUE(*ALL)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1) VALUE('G')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1) VALUE('R')
             DCL        VAR(&WWTNLA) TYPE(*CHAR) LEN(5) VALUE('     ')
/*********** DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)               */ /*CPM005*/
/*********** DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */ /*CPM005*/
/*********** DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)            */ /*CPM005*/
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWCNUM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWRRRQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*CPM005*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*CPM005*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*CPM005*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**/                                                                  /*CPM005*/
/* Global Monitor Message */                                          /*CPM005*/
/**/                                                                  /*CPM005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ENDTAG))                               /*CPM005*/
/**/                                                                  /*CPM005*/
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL PMC1160 WITH PARAMETERS */
/*********** CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +*/ /*CPM005*/
/***********              &WWMODE &WWTNLA &WWCNUM &WWPTFR &WWPFMR) */ /*CPM005*/
             CALL       PGM(PMC1160) PARM(&WWDPCD &WWACOC &WWPMNG +
                          &WWMODE &WWTNLA &WWCNUM &WWPTFR &WWPFMR +
                          &RSEQ)                                      /*CPM005*/
/**/                                                                  /*CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(END)
             ENDDO
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1160 - Calculation of figures required +
                          on Statements Due Today') TOMSGQ(MRUNQ) +
 
/**FORMAT*'TO*LIBRARY*NAME'*FOR*BACKUP*COPIES***********************/ /*CPM005*/
/*********** RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             */ /*CPM005*/
/*********** CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))         */ /*CPM005*/
/*********** CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*CPM005*/
/**/
/**CHECK/CREATE*FILE*PMPTRRPP*IN*LIB/QTEMP**************************/ /*CPM005*/
/*********** CHKOBJ     OBJ(QTEMP/PMPTRRPP) OBJTYPE(*FILE)         */ /*CPM005*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(PMPTRRPP)*/ /*CPM005*/
/***********              TOFILE(QTEMP/PMPTRRPP) MBROPT(*ADD) +    */ /*CPM005*/
/***********              CRTFILE(*YES) NBRRCDS(1))                */ /*CPM005*/
/**/
/**CLEAR*FILE*PMPTRRPP*IN*LIB/QTEMP*********************************/ /*CPM005*/
/*********** CLRPFM     FILE(QTEMP/PMPTRRPP)                       */ /*CPM005*/
/**/
/**OPEN*QRYF*PMPFMRPP***********************************************/ /*CPM005*/
/*********** OVRDBF     FILE(PMPFMRPP) SHARE(*YES)                 */ /*CPM005*/
/*********** OPNQRYF    FILE((PMPFMRPP)) KEYFLD((QRPRRE) (QRPRTL) +*/ /*CPM005*/
/***********              (QRACOC) (QRCNUM) (QRPTFR) (QRPFMP))     */ /*CPM005*/
/**/
/* Clear PMPTRRQ0 file */                                             /*CPM005*/
/**/                                                                  /*CPM005*/
             CLRPFM     FILE(PMPTRRQ0)                                /*CPM005*/
/**/                                                                  /*CPM005*/
/* Copy File PMPFMRPD */                                              /*CPM005*/
/**/                                                                  /*CPM005*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ2) +
                          MBROPT(*REPLACE)                            /*CPM005*/
             MONMSG     MSGID(CPF2817)                                /*CPM005*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ3) +
                          MBROPT(*REPLACE)                            /*CPM005*/
             MONMSG     MSGID(CPF2817)                                /*CPM005*/
/**/                                                                  /*CPM005*/
/* SET PARAMETERS WWMODE, WWRRRQ                                  */
             CHGVAR     VAR(&WWRRRQ) VALUE(' ')
/**/
/* CALL PM1660 TO REPORT PORTFOLIO PERFORMANCE RECONCILIATION    */
/*********** CALL       PGM(PM1660) PARM('1' &WWRRRQ &WWACOC)      */ /*CPM005*/
             CALL       PGM(PM1660) PARM('1' &WWRRRQ &RSEQ +
                          &RLVL &RENT)                                /*CPM005*/
/**/
/**CLOSE*AND*DLTOVR*OF*FILE*PMPFMRPP********************************/ /*CPM005*/
/*********** CLOF       OPNID(PMPFMRPP)                            */ /*CPM005*/
/*********** DLTOVR     FILE(PMPFMRPP)                             */ /*CPM005*/
/**/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)       */ /*CPM005*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG)  +        */ /*CPM005*/
/***********                 MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)     */ /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
             GOTO       CMDLBL(END)
             ENDDO
 
/**CREATE*WORKFILE*PF/PMPFDSQQ*IN*QTEMP*****************************/ /*CPM005*/
/*********** CPYF       FROMFILE(&FMLIB/PMPFMRQQ) +                */ /*CPM005*/
/***********              TOFILE(QTEMP/PMPFMRQQ) MBROPT(*REPLACE) +*/ /*CPM005*/
/***********              CRTFILE(*YES)                            */ /*CPM005*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPFMRQQ)) */ /*CPM005*/
 
/**COPY*RECORDS*TO*PF/PMPFDSQQ**************************************/ /*CPM005*/
/*********** CPYF       FROMFILE(PMPFMRPP) TOFILE(PMPFMRQQ) +      */ /*CPM005*/
/***********              MBROPT(*ADD)                             */ /*CPM005*/
/***********                                                       */ /*CPM005*/
/*********** CLRPFM     FILE(PMPFDSPP)                             */ /*CPM005*/
/**/                                                                  /*CPM005*/
/* COPY RECORDS TO PF/PMPFDSQ0 */                                     /*CPM005*/
/**/                                                                  /*CPM005*/
             CPYF       FROMFILE(PMPFMRPD) TOFILE(PMPFMRQ0) +
                          MBROPT(*REPLACE)                            /*CPM005*/
/**/                                                                  /*CPM005*/
             CLRPFM     FILE(PMPFDSPD)                                /*CPM005*/
 
/* CALL PM6010 TO PRODUCE REPORT */
/*********** CALL       PGM(PM6010) PARM(&WWDPCD &WWACOC)          */ /*CPM005*/
             CALL       PGM(PM6010) PARM(&WWDPCD &WWACOC &RSEQ)       /*CPM005*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********              MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* IF EXISTS DIFFERENCES CALL PMC4200                               */
             IF         COND(&WWRRRQ *EQ 'Y') THEN(DO)
/***********   CALL       PGM(PMC4200) PARM('Y')                   */ /*CPM005*/
               CALL       PGM(PMC4200) PARM('Y' &RSEQ &RLVL &RENT)    /*CPM005*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)      */ /*CPM005*/
/***********     SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +        */ /*CPM005*/
/***********                 MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)     */ /*CPM005*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM005*/
                 SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        /*CPM005*/
               ENDDO
             ENDDO
 
/***END:****    DLTF       FILE(QTEMP/PMPORTPP)                    */ /*CPM005*/
/*********** MONMSG     MSGID(CPF2105)                             */ /*CPM005*/
/**/                                                                  /*CPM005*/
             DLTOVR     FILE(*ALL)                                    /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             GOTO       CMDLBL(END)                                   /*CPM005*/
/**/                                                                  /*CPM005*/
/* Error in CL Program */                                             /*CPM005*/
/**/                                                                  /*CPM005*/
 ENDTAG:     DMPCLPGM
/**/                                                                  /*CPM005*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
