/********************************************************************/
/*  Start of /COPY REC90MP2                                         */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *Create    Date 24Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
             CHGVAR     VAR(&SAR) VALUE('LUC110')                                         /*LUC110*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*LUC110*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*LUC110*/
             CHGVAR     VAR(&LUC110) VALUE('N')                                           /*LUC110*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*LUC110*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&LUC110) VALUE('Y'))                                          /*LUC110*/
/********************************************************************/
/*  End of /COPY REC90MP2                                           */
/********************************************************************/
