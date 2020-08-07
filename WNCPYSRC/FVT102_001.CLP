/*********************************************************************/
/*                                                                   */
/*       Midas - /COPY Member (CLP)                                  */
/*                                                                   */
/*       FVT102_001 - MCC0540 - Declare variables and file           */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. FVT102CC1          Date 06Jun17              */
/*       Prev Amend No. FVT102   *Create   Date 09May17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       FVT102CC1 - Posting of P/L to Mult. Retained Earnings CC1   */
/*       FVT102 - Posting of P/L to Multiple Retained Earnings       */
/*                                                                   */
/*********************************************************************/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*FVT102*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*FVT102*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*FVT102*/
             DCL        VAR(&FVT102) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*FVT102*/
             DCL        VAR(&MB_FCCY) TYPE(*CHAR) LEN(3)                                  /*FVT102*/
             DCL        VAR(&MB_SPTA) TYPE(*CHAR) LEN(10)                                 /*FVT102*/
             DCL        VAR(&MB_SPAE) TYPE(*CHAR) LEN(10)                                 /*FVT102*/
             DCL        VAR(&MB_SRVL) TYPE(*CHAR) LEN(10)                              /*FVT102CC1*/
             DCL        VAR(&RUNSQL) TYPE(*CHAR) LEN(5000)                             /*FVT102CC1*/
             DCL        VAR(&RUNSQL1) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL1a) TYPE(*CHAR) LEN(500)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL2) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL3) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL4) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL5) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&RUNSQL6) TYPE(*CHAR) LEN(5000)                            /*FVT102CC1*/
             DCL        VAR(&QUOTE) TYPE(*CHAR) LEN(1) VALUE('''')                     /*FVT102CC1*/
             DCL        VAR(&BLANK) TYPE(*CHAR) LEN(1) VALUE(' ')                      /*FVT102CC1*/

/* Declare file.                                                     */                   /*FVT102*/
        /*   DCLF       FILE(XXSRVLL1)       */                             /*FVT102*/ /*FVT102CC1*/
             DCLF       FILE(XXSRVLL7)                                                 /*FVT102CC1*/

/*********************************************************************/
/*      End of /COPY FVT102_001                                      */
/*********************************************************************/
