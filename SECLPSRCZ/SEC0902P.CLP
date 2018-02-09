/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Unrealized P&L Analysis Rpt Prmpt')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0902P  UNREALISED P & L ANALYSIS RPT PROMPT             */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 20May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 17Jan91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  *  *E16600*/
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       S01117 - MULTIBRANCHING - NEW PGM TO REPLACE SEC0902L      */
/*                 AND SEC0902R                                     *  *E16600*/
/*                                                                  *  *E16600*/
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(SEC0902DF)
             DCL        &WSID   *CHAR 10
             DCL        &MSGDTA *CHAR 14                              /*E23248*/
             DCL        &IGNORE *CHAR 1
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
 
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*S01117*/
             CHGVAR     VAR(&OPTION) VALUE(%SST(&RPARM 1 1))          /*S01117*/
             CHGVAR     VAR(&PRTYPE) VALUE(%SST(&RPARM 2 1))          /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))                                 /*S01117*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))                                 /*S01117*/
/**/
/* Get screen variables and display prompt screen */
/**/
             RTVJOBA  JOB(&WSID)
             CHGVAR   &WSIDL %SST(&WSID 1 3)
             CHGVAR   &UPBS  ' '
             CALL     SECTAB36 PARM(&UPBS &IGNORE)
 
 PROMPT:     SNDRCVF    RCDFMT(SEC0902D1)
 
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
             CHGVAR     VAR(&IN96) VALUE('0')                         /*E23248*/
 
/**/
/* If the option is not T,V or B, error it and re-display the screen */
/**/
             IF   ((&OPTION *NE 'T') *AND +
                   (&OPTION *NE 'V') *AND +
                   (&OPTION *NE 'B')) THEN(DO)
                CHGVAR &IN97 '1'
                GOTO   PROMPT
             ENDDO
 
/* If price format is not Y or P, error; re-display the screen */     /*E23248*/
/**/                                                                  /*E23248*/
             IF   ((&PRTYPE *NE 'Y') *AND +
                   (&PRTYPE *NE 'P')) THEN(DO)                        /*E23248*/
                CHGVAR &IN96 '1'                                      /*E23248*/
                GOTO   PROMPT                                         /*E23248*/
             ENDDO                                                    /*E23248*/
                                                                      /*E23248*/
/**/                                                                  /*S01117*/
 
/**********  CHGVAR     VAR(&RPARM) VALUE(&OPTION ** &PRTYPE)                 */ /*S01117 BG18886 */
             CHGVAR     VAR(&RPARM) VALUE(&OPTION *CAT &PRTYPE)                   /*S01117 BG18886*/
             ENDDO                                                    /*S01117*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
