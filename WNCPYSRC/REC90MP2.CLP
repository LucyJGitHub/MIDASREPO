/********************************************************************/
/*  Start of /COPY REC90MP2                                         */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *CREATE    Date 24Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
             CHGVAR     VAR(&SAR) VALUE('LUC110')                                                   
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                                 
             CHGVAR     VAR(&RTCD) VALUE('       ')                                                 
             CHGVAR     VAR(&LUC110) VALUE('N')                                                     
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                                
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&LUC110) VALUE('Y'))                                                    
/********************************************************************/
/*  End of /COPY REC90MP2                                           */
/********************************************************************/
