/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Customer Trading Statement Prompt')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       SEC0905P  CUSTOMER TRADING STATEMENT PROMPT                 */
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
/*       Prev Amend No. E40270             Date 27May92              */
/*                      S01117             Date 17Jan91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       E40270 - '?' should be allowed for customer on prompt.      */
/*       S01117 - Multibranching - New Program to replace SEC0905L   */
/*                and SEC0905R.                                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(SEC0905DF) RCDFMT(SEC0905F2)
             DCL        VAR(&CUSTNO) TYPE(*CHAR) LEN(6)               /*E13576*/
             DCL        VAR(&CUSTN1) TYPE(*CHAR) LEN(1)               /*E13576*/
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(19)
             DCL        VAR(&IND ) TYPE(*CHAR) LEN(10)                /*E13576*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
 
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*S01117*/
             CHGVAR     VAR(&CUSTMR) VALUE(%SST(&RPARM 1 6))          /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))                                 /*S01117*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))                                 /*S01117*/
 
/* GET WSID              */
 
             RTVJOBA    JOB(&JOB )
             CHGVAR     VAR(&WSID) VALUE(%SST(&JOB 1 3))
 
/* DISPLAY PROMPT SCREEN */
 
 PROMPT:     SNDRCVF    RCDFMT(SEC0905F2)
 
/* IF F3, RETURN TO RCF WITH ACTION CODE = END                       * *S01117*/
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
 
/* VALIDATE CUSTOMER NUMBER ENTERED */                                /*E13576*/
             CHGVAR     VAR(&IND) VALUE(' ')                          /*E13576*/
             IF         COND(&CUSTMR *EQ ' ') THEN(DO)                /*E13576*/
             ENDDO                                                    /*E13576*/
             ELSE       CMD(DO)                                       /*E13576*/
             CHGVAR     VAR(&CUSTNO) VALUE(&CUSTMR)                   /*E13576*/
             ENDDO                                                    /*E13576*/
             CALL       PGM(SE0941) PARM(&CUSTNO &IND &ERRMSG)        /*E13576*/
 
/* IF '?' USED */                                                     /*E40270*/
                                                                      /*E40270*/
             CHGVAR     VAR(&CUSTN1) VALUE(%SST(&CUSTMR 1 1))         /*S01117*/
             IF         COND(&CUSTN1 *EQ '?') THEN(DO)                /*E40270*/
             CHGVAR     VAR(&CUSTMR) VALUE(&CUSTNO)                   /*E40270*/
             CHGVAR     VAR(&IND) VALUE(' ')                          /*E40270*/
             CHGVAR     VAR(&IN51) VALUE('0')                         /*E40270*/
             CHGVAR     VAR(&IN52) VALUE('0')                         /*E40270*/
             CHGVAR     VAR(&IN53) VALUE('0')                         /*E40270*/
             GOTO       CMDLBL(PROMPT)                                /*E40270*/
             ENDDO                                                    /*E40270*/
/* ANY ERRORS */                                                      /*E13576*/
             IF         COND(&IND *EQ '1') THEN(CHGVAR VAR(&IN51) +
                          VALUE('1'))                                 /*E13576*/
             IF         COND(&IND *EQ '2') THEN(CHGVAR VAR(&IN52) +
                          VALUE('1'))                                 /*E13576*/
             IF         COND(&IND *EQ '3') THEN(CHGVAR VAR(&IN53) +
                          VALUE('1'))                                 /*E13576*/
 
             CHGVAR     VAR(&CUSTNO) VALUE('      ')                  /*E13576*/
 
             IF         COND(&IND *NE ' ') THEN(GOTO CMDLBL(PROMPT))  /*E13576*/
 
 
             CHGVAR     VAR(&RPARM) VALUE(&CUSTMR)                    /*S01117*/
             ENDDO                                                    /*S01117*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
