/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Exposure by Country by Book Brch')           */
/*                                                                  */
/* Midas - Dealing Module                                   */
/*                                                                  */
/* DLC806BB - COUNTRY DEALING EXPOSURE BY BOOKING BRANCH            */
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
/* PREV AMEND NO. CDL002               DATE  22SEP97                */
/*                064998               DATE  23DEC93                */
/*                E27942               DATE  03SEP91                */
/*                E195                 DATE  19DEC89                */
/*                E26                  DATE  02NOV89                *  E26   */
/*                E17                  DATE  30OCT89                *  E17   */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/* CDL002  - FX Netting. Override net event file to correct logical */
/*           based on entity of the report.                         */
/* 064998  - If called twice through the same job the program leaves*/
/*         - on U1 which will then always produce exception reports */
/*   E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A          */
/*            LEVEL OF BLANKS                                       */
/*   E195 -  ENSURE THAT IF MESSAGE QUEUE IS FULL PROGRAM DOES      */
/*           NOT LOOP                                               */
/*   E17  -  CORRECTED USE OF SUBSTRING FUNCTION                    *  E17   */
/*                                                                  */
/*   E26  -  FIELD &EXR DEFINED WRONGLY IN SUBSTRING FUNCTION       *  E26   */
/********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PROD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CTRY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&EXR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PROPNR) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)                 /*CDL002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDL002*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CDL002*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1)               /*CDL002*/
/**/
/*   MONITOR FOR ANY ERRORS AND SEND APPROPRIATE MESSAGE */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   GET INPUT PARMS SENT IN &PARM - */
/*   - PROD. OPTION, COUNTRY AND LIMITS IN EXCESS ONLY INDICATOR */
/************CHGVAR     VAR(&PROD) VALUE(%SST(&PARM 1 1))               E17   */
             CHGVAR     VAR(&PROD) VALUE(%SST(&PARM 1 1))          /*   E17   */
/************CHGVAR     VAR(&CTRY) VALUE(%SST(&PARM 2 3))               E17   */
             CHGVAR     VAR(&CTRY) VALUE(%SST(&PARM 2 2))          /*   E17   */
/************CHGVAR     VAR(&EXR) VALUE(%SST(&PARM 4 5))                E17   */
/************CHGVAR     VAR(&EXR) VALUE(%SST(&PARM 4 2))          E17   E26   */
             CHGVAR     VAR(&EXR) VALUE(%SST(&PARM 4 1))           /*   E26   */
/**/
/*   SET &OB TO 'B' FOR BOOKING BRANCH */
             CHGVAR     VAR(&OB) VALUE('B')
/**/                                                                  /*CDL002*/
/* CHECK IF FX NETTING IS ON                                         * *CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002' +
                          &FMT)                                       /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CDL002*/
             CHGVAR     VAR(&CDL002) VALUE('Y')                       /*CDL002*/
             ENDDO                                                    /*CDL002*/
/**/
/*   IF 'LIMITS IN EXCESS ONLY' REQUESTED THEN SET ON SWITCH 1 */
             IF         COND(&EXR = 'Y') THEN(CHGJOB SWS(1XXXXXXX))
/*   IF NOT 'LIMITS IN EXCESS ONLY' REQUESTED THEN SET OFF SWITCH 1 /*064998*/
             IF         COND(&EXR = 'N') THEN(CHGJOB SWS(0XXXXXXX)) /*064998*/
/**/
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
               OVRDBF     FILE(EVLA) TOFILE(EVLBBA)
             IF         COND(&CDL002 *EQ 'Y') THEN(OVRDBF +
                          FILE(FXNEVTC) TOFILE(FXNEVTL7))             /*CDL002*/
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
               OVRDBF     FILE(EVLA) TOFILE(EVLCBA)
             IF         COND(&CDL002 *EQ 'Y') THEN(OVRDBF +
                          FILE(FXNEVTC) TOFILE(FXNEVTL8))             /*CDL002*/
             ENDDO
/**/
/*  SYSTEM LEVEL SELECTED - SET UP MESSAGE AND OVERRIDE TO FILE */
/************IF         COND(&RLEV = 'S') THEN(DO)                   * *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(DO)                                    /*E27942*/
               IF         COND(&PROD *EQ '1') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against system limits')
                 OVRDBF     FILE(EVLA) TOFILE(EVLACB)
                 /* DO NOT WANT TO SPECIFY ORIGINATING OR BOOKING */
                 /* BRANCH - THIS OPTION ASSUMES BOOKING BRANCH   */
                 CHGVAR     VAR(&OB) VALUE(' ')
               ENDDO
               IF         COND(&PROD *EQ '2') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against all limits +
                            (by country)')
                 OVRDBF     FILE(EVLA) TOFILE(EVLACB)
               ENDDO
               IF         COND(&PROD *EQ '3') THEN(DO)
                 CHGVAR     VAR(&PROPNR) VALUE('Against all limits +
                            (one country)')
                 OVRDBF     FILE(EVLA) TOFILE(EVLACB)
               ENDDO
             ENDDO
/**/
/*  SEND MESSAGE TO MRUNQ */
             SNDPGMMSG  MSG('Country Dealing Exposure - ' *CAT +
                          &PROPNR) TOMSGQ(MRUNQ)
/* */
/*  CALL DL0781 IF BRANCH OR COMPANY LEVEL; DL0782 IF SYSTEM LEVEL */
             IF         COND((&RLEV = 'B') *OR (&RLEV = 'C')) THEN(DO)
               CALL       PGM(DL0781) PARM(&RSEQ &RLEV &RENT &OB)
             ENDDO
             ELSE       CMD(DO)
               CALL       PGM(DL0782) PARM(&RSEQ &PROD &CTRY &OB)
             ENDDO
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             SNDPGMMSG  MSG('Country Dealing Exposure - ' *CAT +
                          &PROPNR *TCAT '  ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                  */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)               /*E195  */
/****END:        CHGVAR     VAR(&BISCPY) VALUE('COPYRIGHT MKI')      /*E195  */
/************ENDPGM                                                  /*E195  */
 END:        ENDPGM                                                  /*E195  */
