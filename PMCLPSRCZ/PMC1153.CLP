/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Generate Currency Totals Information')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1153 - Setup Currency Totals Information                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPB001             Date 12Jul99              */
/* Midas DBA 3.0 ---------------- Base ------------------------------*/
/*       Prev Amend No. CPM005             DATE 09JUL96              */
/*                      S01124             DATE 06JUN94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPB001 - 'Private Banking' Module                           */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*                VERSION RELEASE III                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/**/                                                                  /*CPM005*/
/* Copyright statement defination  */                                 /*CPM005*/
/**/                                                                  /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*CPM005*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPB001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPB001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPB001*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1153 - PM Generate Portfolio +
                          Currency Totals Information') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
                                                                      /*CPB001*/
/* CHECK IF PB MODULE IS ON */                                        /*CPB001*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPB001*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CPB001*/
 
/* DUPLICATE EVENTS FOR POOL PORTFOLIOS */
/*********** CLRPFM     FILE(PMEVCYP1)                                /*CPM005*/
             CLRPFM     FILE(PMEVCYQ0)                                /*CPM005*/
/*********** OPNQRYF    FILE((PMEVCYPP) (PMPPTMPD)) FORMAT(PMEVCYQQ)+ /*CPM005*/
/************************ QRYSLT('OSRECI *EQ "D"') +                  /*CPM005*/
/************************ JFLD((PMPPTMPD/OSCNUM PMEVCYPP/FGCNUM) +    /*CPM005*/
/************************ (PMPPTMPD/OSPTFR PMEVCYPP/FGPTFR)) +        /*CPM005*/
/************************ MAPFLD((FGCNUM OSPCNU) (FGPTFR OSPPTF))     /*CPM005*/
             OPNQRYF    FILE((PMEVCYPD) (PMPPTMPD)) FORMAT(PMEVCYQ1) +
                          QRYSLT('OSRECI *EQ "D"') +
                          JFLD((PMPPTMPD/OSCNUM PMEVCYPD/FGCNUM) +
                          (PMPPTMPD/OSPTFR PMEVCYPD/FGPTFR)) +
                          MAPFLD((FGCNUM OSPCNU) (FGPTFR OSPPTF))     /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMEVCYPP) TOFILE(PMEVCYP1) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*DROP)                  /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMEVCYPD) TOFILE(PMEVCYQ0) +
                          MBROPT(*ADD) FMTOPT(*DROP)                  /*CPM005*/
             RCLRSC
 
/*********** CPYF       FROMFILE(PMEVCYP1) TOFILE(PMEVCYPP) +         /*CPM005*/
/************************ MBROPT(*ADD)                                /*CPM005*/
             CPYF       FROMFILE(PMEVCYQ0) TOFILE(PMEVCYPD) +
                          MBROPT(*ADD)                                /*CPM005*/
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMNTCMPP)                                /*CPM005*/
             CLRPFM     FILE(PMNTCMPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMTECYPP)                                /*CPM005*/
             CLRPFM     FILE(PMTECYPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMTTCYPP)                                /*CPM005*/
             CLRPFM     FILE(PMTECYQ0)                                /*CPM005*/
 
/* OVERRIDE FILES TO SPEED UP FILE GENERATION */
/*********** OVRDBF     FILE(PMNTCMPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMNTCMPD) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMEVCYPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMEVCYPD) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMTTCYPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMTECYQ0) SEQONLY(*YES 100)              /*CPM005*/
 
/* CREATE TOTAL FILE FOR FORWARD EVENT CCY */
/*********** OPNQRYF    FILE((PMEVCYPP)) FORMAT(PMTECYPP) +           /*CPM005*/
/************************ GRPFLD(FGCNUM FGPTFR FGEVTY FGCURR) +       /*CPM005*/
/************************ MAPFLD((FHCNUM FGCNUM) (FHPTFR FGPTFR) +    /*CPM005*/
/************************ (FHEVDT FGEVTY) (FHCURR FGCURR) (FHRECI +   /*CPM005*/
/************************ '"D"') (FHMNT1 '%SUM(FGMNT1)') (FHMNT2 +    /*CPM005*/
/************************ '%SUM(FGMNT2)'))                            /*CPM005*/
             OPNQRYF    FILE((PMEVCYPD)) FORMAT(PMTECYPD) +
                          GRPFLD(FGCNUM FGPTFR FGEVTY FGCURR) +
                          MAPFLD((FHCNUM FGCNUM) (FHPTFR FGPTFR) +
                          (FHEVTY FGEVTY) (FHCURR FGCURR) (FHRECI +
                          '"D"') (FHMNT1 '%SUM(FGMNT1)') (FHMNT2 +
                          '%SUM(FGMNT2)'))                            /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMEVCYPP) TOFILE(PMTECYPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMEVCYPD) TOFILE(PMTECYPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMEVCYPP)                               /*CPM005*/
             CLOF       OPNID(PMEVCYPD)                               /*CPM005*/
 
/* CREATE TOTALS FILE FOR 9998 AND 9999 PORTFOLIOS WHERE THE */
/*********** OPNQRYF    FILE((PMTECYPP)) FORMAT(PMTTCYPP) +           /*CPM005*/
/************************ QRYSLT('FHPTFR *NE "9997"') GRPFLD(FHCNUM + /*CPM005*/
/************************ FHPTFR FHEVDT FHCURR) MAPFLD((FTCNUM +      /*CPM005*/
/************************ FHCNUM) (FTPTFR "9998") (FTCURR FHCURR) +   /*CPM005*/
/************************ (FTRECI '"D"') (FTEVDT FHEVDT) (FTMNT1 +    /*CPM005*/
/************************ '%SUM(FHMNT1)') (FTMNT2 '%SUM(FHMNT2)'))    /*CPM005*/
             OPNQRYF    FILE((PMTECYPD)) FORMAT(PMTECYQ0) +
                          QRYSLT('FHPTFR *NE "9997"') GRPFLD(FHCNUM +
                          FHPTFR FHEVTY FHCURR) MAPFLD((FTCNUM +
                          FHCNUM) (FTPTFR "9998") (FTCURR FHCURR) +
                          (FTRECI '"D"') (FTEVTY FHEVTY) (FTMNT1 +
                          '%SUM(FHMNT1)') (FTMNT2 '%SUM(FHMNT2)'))    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMTECYPP) TOFILE(PMTTCYPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTECYPD) TOFILE(PMTECYQ0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMTECYPP)                               /*CPM005*/
             CLOF       OPNID(PMTECYPD)                               /*CPM005*/
 
/*********** OPNQRYF    FILE((PMTECYPP)) FORMAT(PMTTCYPP) +           /*CPM005*/
/************************ GRPFLD(FHCNUM FHPTFR FHEVDT FHCURR) +       /*CPM005*/
/************************ MAPFLD((FTCNUM FHCNUM) (FTPTFR "9999") +    /*CPM005*/
/************************ (FTCURR FHCURR) (FTRECI '"D"') (FTEVDT +    /*CPM005*/
/************************ FHEVDT) (FTMNT1 '%SUM(FHMNT1)') (FTMNT2 +   /*CPM005*/
/************************ '%SUM(FHMNT2)'))                            /*CPM005*/
             IF         COND(%SST(&FMT 104 1) *NE 'Y') THEN(DO)       /*CPB001*/
             OPNQRYF    FILE((PMTECYPD)) FORMAT(PMTECYQ0) +
                          GRPFLD(FHCNUM FHPTFR FHEVTY FHCURR) +
                          MAPFLD((FTCNUM FHCNUM) (FTPTFR "9999") +
                          (FTCURR FHCURR) (FTRECI '"D"') (FTEVTY +
                          FHEVTY) (FTMNT1 '%SUM(FHMNT1)') (FTMNT2 +
                          '%SUM(FHMNT2)'))                            /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMTECYPP) TOFILE(PMTTCYPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTECYPD) TOFILE(PMTECYQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMTECYPP)                               /*CPM005*/
             CLOF       OPNID(PMTECYPD)                               /*CPM005*/
             ENDDO                                                    /*CPB001*/
 
/**COPY*TOTALS*FROM*PMTTCYPP*TO*TOTAL*EVENTS*BY*CURRENCY**/           /*CPM005*/
/* COPY TOTALS FROM PMTECYQ0 TO TOTAL EVENTS BY CURRENCY */           /*CPM005*/
/*********** CPYF       FROMFILE(PMTTCYPP) TOFILE(PMTECYPP) +         /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYF       FROMFILE(PMTECYQ0) TOFILE(PMTECYPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             MONMSG     MSGID(CPF2817)
 
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "A" FOR NET COMMITMENT BY CCY */
/*********** OPNQRYF    FILE((PMCIALPP)) FORMAT(PMNTCMPP) +           /*CPM005*/
/************************ QRYSLT('FIPOTY *EQ "C " *AND FITOTT *EQ +   /*CPM005*/
/************************ "B"') MAPFLD((FJCNUM FICNUM) (FJPTFR +      /*CPM005*/
/************************ FIPTFR) (FJCURR FICURR) (FJRECI '"D"') +    /*CPM005*/
/************************ (FJCVAL 'FIASVL-FILIVL') (FJCAPC +          /*CPM005*/
/************************ '000000000000000') (FJFFOR +                /*CPM005*/
/************************ '000000000000000') (FJFORX +                /*CPM005*/
/************************ '000000000000000'))                         /*CPM005*/
             OPNQRYF    FILE((PMCIALPD)) FORMAT(PMNTCMPD) +
                          QRYSLT('FIPOTY *EQ "C " *AND FITOTT *EQ +
                          "B"') MAPFLD((FJCNUM FICNUM) (FJPTFR +
                          FIPTFR) (FJCURR FICURR) (FJRECI '"D"') +
                          (FJCVAL 'FIASVL-FILIVL') (FJCAPC +
                          '000000000000000') (FJFFOR +
                          '000000000000000') (FJFORX +
                          '000000000000000'))                         /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMCIALPP) TOFILE(PMNTCMPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALPD) TOFILE(PMNTCMPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMCIALPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALPD)                               /*CPM005*/
 
/* CALL PGM PM6340 CURRENCY TOTAL INFORMATION */
             CALL       PGM(PM6340)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +            /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             DLTOVR     FILE(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ABNOR:       ENDPGM
