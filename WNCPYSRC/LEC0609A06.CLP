/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module.                            */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139             Date 22Apr21              */
/*                      UIT021             Date 28feb97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD058100 - Rollup of additional BoI onsite fixes at FbMidas     */
/*   LUC139   - Upgrade UCI Italian Returns                          */
/*   UIT021   - BOI Monthly Reporting (Italy)                        */
/*                                                                   */
/*********************************************************************/
                                                                      /*UIT021*/
/***  Check if feature UIT021 is installed.  ***/                     /*UIT021*/
                                                                      /*UIT021*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*UIT021*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPT &SAR)           /*UIT021*/
             IF         COND(&RTCD *EQ '       ')  +
                   THEN(CHGVAR VAR(&UIT021) VALUE('Y'))               /*UIT021*/
                                                                      /*UIT021*/
