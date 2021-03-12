/*********************************************************************/
/*                                                                   */
/*       SCC2454MP1 - LUC109 - Save xxINTFLIB                        */
/*                                                                   */
/*       (c) Finastra International Banking Systems Ltd. 2016        */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
             CHGVAR     VAR(&INTFLIB)  VALUE(&SYSID *CAT 'INTFLIB')   
                                                                      
/* If this is a test system do not save xxINTFLIB.                    
                                                                      
/*           IF         COND((&SYSID *NE 'CI') *AND (&SYSID *NE +
                          'LN') *AND (&SYSID *NE 'NY') *AND (&SYSID +
                          *NE 'UL') *AND (&SYSID *NE 'UE') *AND +
                          (&SYSID *NE 'UF') *AND (&SYSID *NE 'SI')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          */ 
             IF         COND((&SYSID *NE 'LS') *AND (&SYSID *NE +
                          'PS') *AND (&SYSID *NE 'MS') *AND (&SYSID +
                          *NE 'AS')) THEN(CHGVAR VAR(&LUC109) +
                          VALUE(' ')) 

             IF         COND((&LIVE *NE 'Y')) +
                          THEN(CHGVAR VAR(&LUC109) VALUE(' ')) +
                          
                                                                      
/* If HOR extraction active wait.                                     
                                                                      
             IF         COND(&LUC109 *EQ 'Y') THEN(DO)                
 WAIT:       RTVDTAARA  DTAARA(&INTFLIB/LUC109 (1 1)) +
                          RTNVAR(&STAT43)                             
             IF         COND(&STAT43 *EQ 'Y') THEN(DO)                
             DLYJOB     DLY(60)                                       
             GOTO       CMDLBL(WAIT)                                  
             ENDDO       
             ENDDO       

/*********************************************************************/
/* End of hook SCC2454MP1                                            */
/*********************************************************************/
