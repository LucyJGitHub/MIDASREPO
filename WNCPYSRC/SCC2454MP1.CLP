/*********************************************************************/
/*                                                                   */
/*       SCC2454MP1 - LUC109 - Save xxINTFLIB                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
             CHGVAR     VAR(&INTFLIB)  VALUE(&SYSID *CAT 'INTFLIB')   /*LUC109*/
                                                                      /*LUC109*/
/* If this is a test system do not save xxINTFLIB.                    /*LUC109*/
                                                                      /*LUC109*/
/*           IF         COND((&SYSID *NE 'CI') *AND (&SYSID *NE +
                          'LN') *AND (&SYSID *NE 'NY') *AND (&SYSID +
                          *NE 'UL') *AND (&SYSID *NE 'UE') *AND +
                          (&SYSID *NE 'UF') *AND (&SYSID *NE 'SI')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          */ /*LUC109*/
             IF         COND((&SYSID *NE 'LS') *AND (&SYSID *NE +
                          'PS') *AND (&SYSID *NE 'MS') *AND (&SYSID +
                          *NE 'AS')) THEN(CHGVAR VAR(&LUC109) +
                          VALUE(' ')) /* LUC109 */

             IF         COND((&LIVE *NE 'Y')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          /*LUC109*/
                                                                      /*LUC109*/
/* If HOR extraction active wait.                                     /*LUC109*/
                                                                      /*LUC109*/
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                /*LUC109*/
 WAIT:       RTVDTAARA  DTAARA(&INTFLIB/LUC109 (1 1)) +
                          RTNVAR(&STAT43)                             /*LUC109*/
             IF         COND(&STAT43 *EQ 'Y') THEN(DO)                /*LUC109*/
             DLYJOB     DLY(60)                                       /*LUC109*/
             GOTO       CMDLBL(WAIT)                                  /*LUC109*/
             ENDDO       /*LUC109*/
             ENDDO       /*LUC109*/

/*********************************************************************/
/* End of hook SCC2454MP1                                            */
/*********************************************************************/
