/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Holdings Exposure Report Prompt')            */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0801P  HOLDINGS EXPOSURE REPORT PROMPT                  */
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
/*                      S01502             Date 08Jul94              */
/*                      048405             Date 04Feb93              */
/*                      S01117             Date 16Jan91              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       048405 - Set on appropriate indicators to display error    */
/*                message when fields are not filled on screen.     */
/*       S01117 - MULTIBRANCHING - NEW PGM TO REPLACE SEC0801L      */
/*                    AND SEC0801R                                  *  *S01219*/
/*                                                                  */
/********************************************************************/
 
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)    /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCLF       FILE(SEC0801DF)
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/   /*S01219 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)            /*S01502*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&IN04) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN05) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN06) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN07) TYPE(*LGL) LEN(1)                  /*048405*/
             DCL        VAR(&IN08) TYPE(*LGL) LEN(1)                  /*048405*/
/*                                                                           */
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)               /*S01219*/
             CHGVAR     VAR(&IN64) VALUE('0')                        /*S01219*/
             IF         COND(%SST(&SESTAT 64 1) *EQ 'Y') THEN(CHGVAR +
                          VAR(&IN64) VALUE('1'))                     /*S01219*/
 
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*S01117*/
             CHGVAR     VAR(&BYBOOK) VALUE(%SST(&RPARM 1 1))          /*S01117*/
             CHGVAR     VAR(&CAT) VALUE(%SST(&RPARM 2 1))             /*S01117*/
             CHGVAR     VAR(&HOLD) VALUE(%SST(&RPARM 3 1))            /*S01117*/
             CHGVAR     VAR(&EXCEPT) VALUE(%SST(&RPARM 4 1))          /*S01117*/
             CHGVAR     VAR(&FACTORED) VALUE(%SST(&RPARM 5 1))        /*S01117*/
             ENDDO                                                    /*S01117*/
             IF         COND(&RACT *EQ 'E') THEN(CHGVAR VAR(&IN13) +
                          VALUE('1'))                                 /*S01117*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN11) +
                          VALUE('1'))                                 /*S01117*/
/*                                                                           */
 
/* DISPLAY PROMPT SCREEN */
 
 PROMPT:     SNDRCVF    RCDFMT(SEC0801F1)
 
 
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
/*                                                                           */
             IF         COND(&IN64 *NE '1') THEN(CHGVAR VAR(&HOLD) +
                          VALUE('O'))                                /*S01219*/
/*                                                                           */
 
/************IF         COND((&BYBOOK *EQ ' ') *OR (&CAT *EQ ' ') */  /*048405*/
/************             *OR (&HOLD *EQ ' ') *OR (&EXCEPT *EQ ' ')*/ /*048405*/
/************             *OR (&FACTORED *EQ ' ')) THEN(GOTO + */     /*048405*/
/************             CMDLBL(PROMPT)) */               /*S01117*/ /*048405*/
                                                                      /*E13805*/
/* CLEAR ERROR INDICATORS */
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN05) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN06) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN07) VALUE('0')                         /*048405*/
             CHGVAR     VAR(&IN08) VALUE('0')                         /*048405*/
/* */                                                                 /*048405*/
             IF         COND(&CAT *EQ ' ')  THEN(DO)                  /*048405*/
             CHGVAR     VAR(&IN04) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&BYBOOK *EQ ' ')  THEN(DO)               /*048405*/
             CHGVAR     VAR(&IN05) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&HOLD *EQ ' ')  THEN(DO)                 /*048405*/
             CHGVAR     VAR(&IN06) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&FACTORED *EQ ' ')  THEN(DO)             /*048405*/
             CHGVAR     VAR(&IN07) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
             IF         COND(&EXCEPT *EQ ' ')  THEN(DO)               /*048405*/
             CHGVAR     VAR(&IN08) VALUE('1')                         /*048405*/
             GOTO       CMDLBL(PROMPT)                                /*048405*/
             ENDDO                                                    /*048405*/
 
/* PERFORM EXTRA VALIDATION -              */
/* 1. IF CAT=6 OR 7 - FACTORED MUST BE U   */
             IF        COND((&CAT *EQ '6') *OR (&CAT *EQ '7')) THEN(DO)
                IF         COND(&FACTORED *NE 'U') THEN(DO)
                CHGVAR     VAR(&IN02) VALUE('1')
                GOTO PROMPT
                ENDDO
             ENDDO
 
/* 2. IF HOLD=D,S,OR A -BYBOOK MUST BE N   */
             IF        COND((&HOLD *EQ 'D') *OR (&HOLD *EQ 'S') *OR +
                            (&HOLD *EQ 'A')) THEN(DO)
             IF         COND(&BYBOOK *NE 'N') THEN(DO)
                CHGVAR     VAR(&IN03) VALUE('1')
                GOTO PROMPT
                ENDDO
             ENDDO
 
/* SET UP MSG & SEND TO EODQ */
 
/**********  CHGVAR     VAR(&RPARM) VALUE(&BYBOOK ** &CAT ** &HOLD +           */ /*S01117 BG18886*/
/**********               ** &EXCEPT ** &FACTORED)                             */ /*S01117 BG18886*/
             CHGVAR     VAR(&RPARM) VALUE(&BYBOOK *CAT &CAT *CAT &HOLD +
                          *CAT &EXCEPT *CAT &FACTORED)                           /*S01117 BG18886 */
             ENDDO                                                    /*S01117*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
 
