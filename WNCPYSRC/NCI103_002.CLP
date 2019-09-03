/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Midas - /COPY NCI103_002                                    */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       RPC0015 - Call AOSARDR0                                     */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       Last Amend No. NCI103  *Create    Date 18Jul19              */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*       NCI103 - Replication enhancements (MD-25711)                */                   /*NCI103*/
/*                                                                   */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
                                                                                        /*MD025711*/
/* Check if NCI103 is enabled. */                                                       /*MD025711*/
                                                                                        /*MD025711*/
             CHGVAR     VAR(&RTCD) VALUE('       ') /*MD025711*/
             CHGVAR     VAR(&SAR)  VALUE('NCI103') /*MD025711*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY') /*MD025711*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*MD025711*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE '*NRF   ') +
                          THEN(DO) /*MD025711*/
                GOTO       CMDLBL(TAG998) /*MD025711*/
             ENDDO      /*MD025711*/
             IF         COND(&RTCD *EQ '       ') THEN(DO) /*MD025711*/
                CHGVAR     VAR(&NCI103) VALUE('Y') /*MD025711*/
             ENDDO      /*MD025711*/
/*********************************************************************/                   /*NCI103*/
/*  End of /COPY NCI103_002                                          */                   /*NCI103*/
/*********************************************************************/                   /*NCI103*/
