/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                         */
/*                                                                  */
/*    CLP/SCCLRGL - CLEAR GENERAL LEDGER DAILY FILES                */
/*                                                                  */
/*  (c) COPYRIGHT Midas-KAPITI International Ltd. 1998              */
/*                                                                  */
/*       Last Amend No. LUC140 *Create    Date 25Feb21              */
/*       Prev Amend No. MMI013            DATE 30Sep98              */
/*                                                                  */
/********************************************************************/
/*                                                                 */
/*         LUC140 - Upgrade MMI013 to FM2.1                        */
/*         MMI013 - Retail Stamp Duty                              */
/*                                                                 */
/********************************************************************/
/**/                                                                  /*MMI013*/
/* Check to see if MMI013-RE Stamp Duty */                            /*MMI013*/
/* is switched on and clear files.                   */               /*MMI013*/
/**/                                                                  /*MMI013*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'LUC140' &AOFMT) +
                          /*LUC140*/
             IF         COND(&RTCD *EQ ' ') THEN(DO)                  /*MMI013*/
                CLRPFM     FILE(GESDGLPP)                             /*MMI013*/
                CLRPFM     FILE(GESDGLZZ)                             /*MMI013*/
                CLRPFM     FILE(GESDREPP)                             /*MMI013*/
                CLRPFM     FILE(GESDREZZ)                             /*MMI013*/
             ENDDO                                                    /*MMI013*/
/*********************************************************************/
/* End of /COPY SCCLRGL005                                           */
/*********************************************************************/
