/*********************************************************************/
/*                                                                   */
/*       SCC2455010 - LUC109 - HOR processing                        */
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
/* */                                                                 
             CHGVAR     VAR(&RTN) VALUE('       ')                    
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    
             CHGVAR     VAR(&SARD) VALUE('LUC109')                    
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     
             IF         COND(&RTN *EQ '       ') THEN(DO)             
             CHGVAR     VAR(&LUC109) VALUE('Y')                       
             CALL       PGM(AOSVALR0) +
                          PARM(&RTCD 'TestSystemIndicator' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)            
             IF         COND(%SST(&SVAL1 1 4) *EQ 'LIVE') THEN(DO)    
                        CHGVAR VAR(&LIVE) VALUE('Y')                  
/* */                                                                 
/* Retrieve System Id */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           
                                                                      
             CHGVAR     VAR(&INTFLIB)  VALUE(&SYSID *CAT 'INTFLIB')   
/* If HOR extraction active wait.                                     
                                                                      
 WAIT:       RTVDTAARA  DTAARA(&INTFLIB/LUC109 (1 1)) +
                          RTNVAR(&STAT43)                             
             IF         COND(&STAT43 *EQ 'Y') THEN(DO)                
             DLYJOB     DLY(60)                                       
             GOTO       CMDLBL(WAIT)                                  
             ENDDO       
             ENDDO       
             ENDDO       
                                                                      
/*********************************************************************/
/* End of hook SCC2455010                                            */
/*********************************************************************/
