/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Counterparty Exposure Rpt Prompt')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0705P  COUNTERPARTY EXPOSURE REPORT PROMPT               */
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
/*                      048405             Date 04Feb93              */
/*                      S01117             Date 16Jan91             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard code.                         */
/*       048405 - Set on appropriate indicators to display error    */
/*                message when fields are not filled on screen.     */
/*       S01117 - MULTIBRANCHING NEW PROGRAM REPLACING SEC070R      */
/*                   AND SEC0705L                                   */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(SEC0705DF)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(19)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&IN02) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN04) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN06) TYPE(*LGL) LEN(1)                  /*048405*/
 
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*S01117*/
             CHGVAR     VAR(&CUST) VALUE(%SST(&RPARM 1 1))            /*S01117*/
             CHGVAR     VAR(&BYBOOK) VALUE(%SST(&RPARM 2 1))          /*S01117*/
             CHGVAR     VAR(&EXCEPT) VALUE(%SST(&RPARM 3 1))          /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))                                 /*S01117*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))                                 /*S01117*/
 
/* DISPLAY PROMPT SCREEN */
 
 PROMPT:     SNDRCVF    RCDFMT(SEC0705F1)
 
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
 
/************IF         COND((&CUST *EQ ' ') *OR (&BYBOOK *EQ ' ') */ /*048405*/
/************             *OR (&EXCEPT *EQ ' ')) THEN(GOTO + */       /*048405*/
/************             CMDLBL(PROMPT)) */               /*S01117*/ /*048405*/
/* */                                                                 /*048405*/
/* CLEAR ERROR INDICATORS */                                          /*048405*/
             CHGVAR     VAR(&IN02) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN04) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN06) VALUE('0')                         /*048405*/
/* */                                                                 /*048405*/
             IF         COND(&CUST *EQ ' ')  THEN(DO)                 /*048405*/
             CHGVAR     VAR(&IN02) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&BYBOOK *EQ ' ')  THEN(DO)               /*048405*/
             CHGVAR     VAR(&IN04) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&EXCEPT *EQ ' ')  THEN(DO)               /*048405*/
             CHGVAR     VAR(&IN06) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
 
/**SET*UP*MSG*&*SEND*TO*EODQ**/                                       /*S01117*/
 
 
 
/**********  CHGVAR     VAR(&RPARM) VALUE(&CUST ** &BYBOOK ** +                */ /*S01117 BG18886*/
/**********               &EXCEPT)                                             */ /*S01117 BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&CUST *CAT &BYBOOK *CAT +
                          &EXCEPT)                                              /* S01117 BG18886 */
             ENDDO                                                    /*S01117*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
