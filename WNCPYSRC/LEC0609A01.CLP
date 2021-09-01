/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*  (C) COPYRIGHT ACT INTERNATIONAL LIMITED 1984, 1994               */
/*                                                                   */
/*       Last Amend No. MD058100    Date 20May21                     */
/*       Prev Amend No. LUC139      Date 22Apr21                     */
/*                      MMI001      Date 24Sep98                     */
/*                      UIT021      DATE 28feb97                     */
/*                      PR_R10      DATE 25JUL95                     */
/*                      56749  SL   DATE 01JUL93                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD058100 - Rollup of additional BoI onsite fixes at FbMidas     */
/*   LUC139 -   Upgrade UCI Italian Returns                          */
/*   MMI001  -  Upgrade Midas Italy DB2                              */
/*   UIT021  -  BOI Monthly Reporting                                */
/*   PR_R10  -  R10 : EXTERNALISE IML/IBLC                           */
/*    56749  -  ADD DROP FCLTYMX4/FCLTYMX6                           */
/*                                                                   */
/*********************************************************************/
                                                                      /*UIT021*/
/***  Clear Italian Extended facility details if UIT021 is installed.   UIT021*/
                                                                      /*UIT021*/
             IF         COND(&UIT021 *EQ 'Y') THEN(DO)                /*UIT021*/
                CPYF       FROMFILE(LEFCT1PD) TOFILE(LEFCT1XP) +
                           MBROPT(*REPLACE)                           /*UIT021*/
                MONMSG     MSGID(CPF2817)                             /*UIT021*/
             ENDDO                                                    /*UIT021*/
                                                                      /*UIT021*/
