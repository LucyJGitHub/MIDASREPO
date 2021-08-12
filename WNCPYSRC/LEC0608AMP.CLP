/*********************************************************************/
/*                                                                   */
/*       Midas - Customer lending Module                             */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139             Date 22Apr21              */
/*                      UIT021             Date 26feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting (Italy)                      */
/*                                                                   */
/*********************************************************************/
                                                                      /*UIT021*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*UIT021*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)               /*UIT021*/
                                                                      /*UIT021*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('UIT021')  /*UIT021*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*UIT021*/
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY') /*UIT021*/
             DCL        VAR(&UIT021) TYPE(*CHAR) LEN(1) VALUE('N')    /*UIT021*/
                                                                      /*UIT021*/
