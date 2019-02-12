/********************************************************************/
/*  Start of /COPY DLC0606C02                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *Create    Date 17Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
/**/                                                                  /*LUC110*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*LUC110*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&LUC110) VALUE('Y'))                 /*LUC110*/
/**/                                                                  /*LUC110*/
             IF         COND(&LUC110 *EQ 'Y') THEN(DO)                /*LUC110*/
/**/                                                                  /*LUC110*/
             IF         COND(&POST *EQ '1') THEN(DO)                  /*LUC110*/
             CLRPFM     FILE(XXGEDLX0)                                /*LUC110*/
             CLRPFM     FILE(XXGED2X0)                                /*LUC110*/
             OVRDBF     FILE(XXGEDLX0) TOFILE(XXGEDLX0) SEQONLY(*YES +
                          250) /*LUC110*/
             ENDDO       /*LUC110*/
/**/                                                                  /*LUC110*/
             IF         COND(&POST *EQ '5') THEN(DO)                  /*LUC110*/
             CLRPFM     FILE(XXGED2X0)                                /*LUC110*/
             OVRDBF     FILE(XXGEDLX0) TOFILE(XXGED2X0) SEQONLY(*YES +
                          250) /*LUC110*/
             CHGJOB     SWS(XX1XXXXX)                                 /*LUC110*/
             ENDDO       /*LUC110*/
/**/                                                                  /*LUC110*/
             ENDDO       /*LUC110*/
/********************************************************************/
/*  End of /COPY DLC0606C02                                         */
/********************************************************************/
