/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Exposure by Customer by Book Brch')          */
/*********************************************************************/
/*                                                                   */
/* Midas - Dealing Module                                            */
/*                                                                   */
/* DLC806BA - CUSTOMER DEALING EXPOSURE BY BOOKING BRANCH            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/* LAST AMEND NO. CDL002               DATE  22SEP97                 */
/* PREV AMEND NO. 064998               DATE  23DEC93                 */
/*                S01433               DATE  04OCT93                 */
/*                E27942               DATE  03SEP91                 */
/*                E195                 DATE  19DEC89                 */
/*                E17                  DATE  30OCT89                 */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/* CDL002 - FX Netting.                                             */
/* 064998  - If called twice through the same job the program leaves*/
/*         - on U1 which will then always produce exception reports */
/* S01433  -  ENHANCED DEALING LIMITS                               */
/*            (NB. This function is to remain switchable until      */
/*            after Alpha-site testing, when it will become         */
/*            mandatory.)                                           */
/* E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A            */
/*          LEVEL OF BLANKS                                         */
/* E195- ENSURE THAT IF MESSAGE QUEUE IS FULL PROGRAM DOES NOT LOOP */
/* E17 - CORRECTED USE OF SUBSTRING FUNCTION                        */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PROD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PROPNR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01433*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*S01433*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01433*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CDL002*/
             DCL        VAR(&BNNTCE) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
/**/
/*   MONITOR FOR ANY ERRORS AND SEND APPROPRIATE MESSAGE */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   GET INPUT PARMS SENT IN &PARM - */
/*   - PROD OPT, CUSTOMER, PARENT AND LIMITS IN EXCESS ONLY IND */
             CHGVAR     VAR(&PROD) VALUE(%SST(&PARM 1 1))
/*********** CHGVAR     VAR(&CUNO) VALUE(%SST(&PARM 2 7))              E17   */
             CHGVAR     VAR(&CUNO) VALUE(%SST(&PARM 2 6))            /*E17   */
/*********** CHGVAR     VAR(&PTNO) VALUE(%SST(&PARM 8 13))             E17   */
             CHGVAR     VAR(&PTNO) VALUE(%SST(&PARM 8 6))            /*E17   */
/*********** CHGVAR     VAR(&EXR) VALUE(%SST(&PARM 14 14))             E17   */
             CHGVAR     VAR(&EXR) VALUE(%SST(&PARM 14 1))            /*E17   */
                                                                      /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002')  /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL002) VALUE('Y'))                    /*CDL002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL002*/
             CALL       PGM(AODEALR0) PARM(&RTCD '*FIRST' &DSFDY)     /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BNNTCE) VALUE(%SST(&DSFDY 94 +
                          94)))                                       /*CDL002*/
                                                                      /*CDL002*/
                                                                      /*CDL002*/
/**                                                                          */
/**/
/*   SET &OB TO 'B' FOR BOOKING BRANCH */
             CHGVAR     VAR(&OB) VALUE('B')
/**/
/*   IF 'LIMITS IN EXCESS ONLY' REQUESTED THEN SET ON SWITCH 1 */
             IF         COND(&EXR = 'Y') THEN(CHGJOB SWS(1XXXXXXX))
/*   IF NOT 'LIMITS IN EXCESS ONLY' REQUESTED THEN SET OFF SWITCH 1 /*064998*/
             IF         COND(&EXR = 'N') THEN(CHGJOB SWS(0XXXXXXX)) /*064998*/
/*   BRANCH LEVEL SELECTED - SET UP MESSAGE AND OVERRIDE TO FILE */
             IF         COND(&RLEV = 'B') THEN(DO)
               IF         COND(&RENT *EQ 'ALL') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against branch limits +
                            (by branch)')
               ENDDO
               ELSE       CMD(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against branch limits +
                            (one branch)')
               ENDDO
               OVRDBF     FILE(EVLN) TOFILE(EVLBBN)
               OVRDBF     FILE(EVLP) TOFILE(EVLBBP)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL1)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL2)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
             ENDDO
/**/
/*  COMPANY LEVEL SELECTED - SET UP MESSAGE AND OVERRIDE TO FILE */
             IF         COND(&RLEV = 'C') THEN(DO)
               IF         COND(&RENT *EQ 'ALL') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against company +
                            limits (by company)')
               ENDDO
               ELSE       CMD(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against company +
                            limits (one company)')
               ENDDO
               OVRDBF     FILE(EVLN) TOFILE(EVLCBN)
               OVRDBF     FILE(EVLP) TOFILE(EVLCBP)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL3)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL4)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
             ENDDO
/**/
/*  SYSTEM LEVEL SELECTED - SET UP MESSAGE AND OVERRIDE TO FILE */
/************IF         COND(&RLEV = 'S') THEN(DO)                   * *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E27942*/
               IF         COND(&PROD *EQ '1') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against system limits')
                 CHGVAR     VAR(&NUMB) VALUE(' ')
                 OVRDBF     FILE(EVLN) TOFILE(EVLNCB)
                 OVRDBF     FILE(EVLP) TOFILE(EVLPCB)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL5)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL6)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
                 /* DO NOT WANT TO SPECIFY ORIGINATING OR BOOKING */
                 /* BRANCH - THIS OPTION ASSUMES BOOKING BRANCH   */
                 CHGVAR     VAR(&OB) VALUE(' ')
               ENDDO
               IF         COND(&PROD *EQ '2') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against all limits +
                            (by customer)')
                 CHGVAR     VAR(&NUMB) VALUE(' ')
                 OVRDBF     FILE(EVLN) TOFILE(EVLNCB)
                 OVRDBF     FILE(EVLP) TOFILE(EVLPCB)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL5)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL6)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
               ENDDO
               IF         COND(&PROD *EQ '3') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against all limits +
                            (one customer)')
                 CHGVAR     VAR(&NUMB) VALUE(&CUNO)
                 OVRDBF     FILE(EVLN) TOFILE(EVLNCB)
                 OVRDBF     FILE(EVLP) TOFILE(EVLPCB)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL5)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL6)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
               ENDDO
               IF         COND(&PROD *EQ '4') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against all limits +
                            (one parent plus children)')
                 CHGVAR     VAR(&NUMB) VALUE(&PTNO)
                 OVRDBF     FILE(EVLN) TOFILE(EVLNCB)
                 OVRDBF     FILE(EVLP) TOFILE(EVLPCB)
                                                                      /*CDL002*/
               IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
               OVRDBF     FILE(FXNEVTP) TOFILE(FXNEVTL5)              /*CDL002*/
               OVRDBF     FILE(FXNEVTN) TOFILE(FXNEVTL6)              /*CDL002*/
               ENDDO                                                  /*CDL002*/
                                                                      /*CDL002*/
               ENDDO
             ENDDO
/**/
/*  SEND MESSAGE TO MRUNQ */
             SNDPGMMSG  MSG('Customer Dealing Exposure - ' *CAT +
                          &PROPNR) TOMSGQ(MRUNQ)
/**/                                                                  /*S01433*/
/* DETERMINE IF SAR INSTALLED */                                      /*S01433*/
/**/                                                                  /*S01433*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01433*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01433*/
             CHGVAR     VAR(&SARD) VALUE('S01433')                    /*S01433*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)         /*S01433*/
/**/                                                                  /*S01433*/
/* ERROR */                                                           /*S01433*/
/**/                                                                  /*S01433*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                         /*S01433*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*S01433*/
             CHGJOB (XXXXXX11)                                        /*S01433*/
             GOTO       CMDLBL(END)                                   /*S01433*/
             ENDDO                                                    /*S01433*/
/* */
/*  CALL DL0761 IF BRANCH OR COMPANY LEVEL; DL0762 IF SYSTEM LEVEL */
             IF         COND((&RLEV = 'B') *OR (&RLEV = 'C')) THEN(DO)
/*******       CALL       PGM(DL0761) PARM(&RSEQ &RLEV &RENT &OB)     /*S01433*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0761A) PARM(&RSEQ &RLEV &RENT &OB))     /*S01433*/
             ELSE       CMD(CALL PGM(DL0761) PARM(&RSEQ &RLEV &RENT +
                        &OB))                                         /*S01433*/
             ENDDO
             ELSE       CMD(DO)
/*********     CALL       PGM(DL0762) PARM(&RSEQ &PROD &NUMB &OB)     /*S01433*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0762A) PARM(&RSEQ &PROD &NUMB &OB))     /*S01433*/
             ELSE       CMD(CALL PGM(DL0762) PARM(&RSEQ &PROD &NUMB +
                        &OB))                                         /*S01433*/
             ENDDO
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             SNDPGMMSG  MSG('Customer Dealing Exposure - ' *CAT +
                          &PROPNR *TCAT '  ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)               /*E195  */
/****END:        CHGVAR     VAR(&BISCPY) VALUE('COPYRIGHT MKI')      /*E195  */
/************ENDPGM                                                  /*E195  */
 END:        ENDPGM                                                  /*E195  */
