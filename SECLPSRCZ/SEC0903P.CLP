/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Monthly Profitability Rpt Prompt')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0903P  MONTHLY PROFITABILITY REPORT PROMPT              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01117                  DATE  17JAN91       */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  * *E16600*/
/*       S01117 - MULTIBRANCHING - NEW PROGRAM TO REPLACE SEC0903L  */
/*                AND SEC0903R                                      * *E16600*/
/*                                                                  * *E16600*/
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(SEC0903DF)
             DCL        &WSID10 *CHAR 10
             DCL        &MSGDTA *CHAR 14
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
 
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*S01117*/
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))          /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))                                 /*S01117*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))                                 /*S01117*/
/**/
/* Get screen variables and display prompt screen */
/**/
             RTVJOBA  JOB(&WSID10)
             CHGVAR   &WSID %SST(&WSID10 1 3)
             CHGVAR   &UPBS  ' '
             CALL     SECTAB36 PARM(&UPBS &RPBS)
 
 PROMPT:     SNDRCVF    RCDFMT(SEC0903D1)
 
/**/
/* IF F3, RETURN TO RCF WITH ACTION CODE = END                       * *S01117*/
/**/
             IF         COND(&IN01 *EQ '1') THEN(DO)                  /*S01117*/
             CHGVAR     VAR(&RCMD) VALUE('E')                         /*S01117*/
             GOTO       CMDLBL(ENDPGM)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/* IF F12, RETURN TO RCF WITH ACTION CODE = FIRST SCREEN             * *S01117*/
             IF         COND(&IN12 *EQ '1') THEN(DO)                  /*S01117*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*S01117*/
             GOTO       CMDLBL(ENDPGM)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/* IF F10, RETURN TO RCF WITH ACTION CODE = DELETE                   * *S01117*/
             IF         COND(*IN10 *EQ '1') THEN(DO)                  /*S01117*/
             CHGVAR     VAR(&RCMD) VALUE('D')                         /*S01117*/
             GOTO       CMDLBL(ENDPGM)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/* CHECK VALIDATION ONLY WHEN NOT ENQUIRY OR DELETE */
             IF         COND(&IN11 *EQ '0' *AND &IN13 *EQ '0') THEN(DO)
 
/**/
/* Clear error conditioning */
/**/
             CHGVAR     VAR(&IN97) VALUE('0')
 
/**/
/* If the option is not T,V or B, error it and re-display the screen */
/**/
             IF   ((&OPTION *NE 'T') *AND +
                   (&OPTION *NE 'V') *AND +
                   (&OPTION *NE 'B')) THEN(DO)
                CHGVAR &IN97 '1'
                GOTO   PROMPT
             ENDDO
 
/**/                                                                  /*S01117*/
 
             CHGVAR     VAR(&RPARM) VALUE(&OPTION)                    /*S01117*/
             ENDDO                                                    /*S01117*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
 
