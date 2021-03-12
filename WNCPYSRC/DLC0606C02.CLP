/********************************************************************/
/*  Start of /COPY DLC0606C02                                       */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *CREATE    Date 17Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
/**/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&LUC110) VALUE('Y'))
/**/
             IF         COND(&LUC110 *EQ 'Y') THEN(DO)
/**/
             IF         COND(&POST *EQ '1') THEN(DO)
             CLRPFM     FILE(XXGEDLX0)
             CLRPFM     FILE(XXGED2X0)
             OVRDBF     FILE(XXGEDLX0) TOFILE(XXGEDLX0) SEQONLY(*YES +
                          250) /*LUC110*/
             ENDDO
/**/
             IF         COND(&POST *EQ '5') THEN(DO)
             CLRPFM     FILE(XXGED2X0)
             OVRDBF     FILE(XXGEDLX0) TOFILE(XXGED2X0) SEQONLY(*YES +
                          250) /*LUC110*/
             CHGJOB     SWS(XX1XXXXX)
             ENDDO
/**/
             ENDDO
/********************************************************************/
/*  End of /COPY DLC0606C02                                         */
/********************************************************************/
