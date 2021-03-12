/*********************************************************************/
/*                                                                   */
/*       LUC109_021 - LUC109 - Save HOR library                      */
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
/*                                                                    
/** Check for Switchable Feature LUC109.                              
/*                                                                    
             CHGVAR     VAR(&RTN) VALUE('       ')                    
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    
             CHGVAR     VAR(&SARD) VALUE('LUC109')                    
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     
             IF         COND((&RTN *EQ ' ') *AND (&MODE *EQ 'DM')) +
                          THEN(DO) 
/* Define HOR Library                                                 
               CHGVAR     VAR(%SUBSTRING(&LIBI 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))              
/* Save HOR library                                                   
               SAVLIB     LIB(&LIBI) DEV(*SAVF) SAVF(&DILIB/DBIF) +
                            USEOPTBLK(*NO) CLEAR(*ALL) +
                            ACCPTH(&ACPTH) OUTPUT(*PRINT)             
             ENDDO       
/*********************************************************************/
/* End of hook LUC109_021                                            */
/*********************************************************************/
