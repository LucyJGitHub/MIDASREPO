/********************************************************************/
/*  Start of /COPY REC99001                                         */
/********************************************************************/
/*                                                                  */
/*  Last Amend No. LUC110  *Create    Date 24Jan19                  */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)        */
/*                                                                  */
/********************************************************************/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*LUC110*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*LUC110*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*LUC110*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*LUC110*/
             DCL        VAR(&LUC110) TYPE(*CHAR) LEN(1) VALUE('N')    /*LUC110*/

             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*LUC110*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*LUC110*/
             CHGVAR     VAR(&SAR) VALUE('LUC110')                     /*LUC110*/
/**/                                                                  /*LUC110*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &FMT)     /*LUC110*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&LUC110) VALUE('Y'))                      /*LUC110*/
/********************************************************************/
/*  End of /COPY REC99001                                           */
/********************************************************************/
