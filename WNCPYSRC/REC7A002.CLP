/********************************************************************/
/*  Start of /COPY REC7A002                                         */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *CREATE    Date 24Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                           
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                          
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                           
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                            
             DCL        VAR(&LUC110) TYPE(*CHAR) LEN(1) VALUE('N')              

             CHGVAR     VAR(&RTCD) VALUE('       ')                             
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                             
             CHGVAR     VAR(&SAR) VALUE('LUC110')                               
/**/                                                                            
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &FMT)               
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&LUC110) VALUE('Y'))                                
/********************************************************************/
/*  End of /COPY REC7A002                                           */
/********************************************************************/
