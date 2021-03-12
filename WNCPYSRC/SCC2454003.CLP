/*********************************************************************/
/*                                                                   */
/*       SCC2454003 - LUC109 - Call AOSARDR0                         */
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
/** Check if Unicredito Head Office Reporting is on */                
                                                                      
             CHGVAR     VAR(&RTNC) VALUE('       ')                   
             CHGVAR     VAR(&SARD) VALUE('LUC109')                    
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SARD &SFMT)   
             IF         COND(&RTNC *EQ '       ') THEN(DO)            
                        CHGVAR VAR(&LUC109) VALUE('Y')                
             CALL       PGM(AOSVALR0) +
                          PARM(&RTCD 'TestSystemIndicator' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)            
             IF         COND(%SST(&SVAL1 1 4) *EQ 'LIVE') THEN(DO)    
                        CHGVAR VAR(&LIVE) VALUE('Y')                  
 
             ENDDO       
             ENDDO       
/*********************************************************************/
/* End of hook SCC2454003                                            */
/*********************************************************************/
