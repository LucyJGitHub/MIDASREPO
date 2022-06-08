/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member SCC07                                  */
/*                                                                   */
/*       HUT104_001 - Midas SD Call UBSREOPEN1                       */
/*                                                                   */
/*       Last Ament No. HUT104  *CREATE    DATE 27APR20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT104 - Call In-House program on Input Cycle Re-open       */
/*                (Upgrade to FM2.1 SP22)                            */
/*                                                                   */
/*********************************************************************/
                                                                                      /*HUT104*/
/**/                                                                                  /*HUT104*/
/* Check if Switchable Feature HUT104 is on */                                        /*HUT104*/
/**/                                                                                  /*HUT104*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                   /*HUT104*/
             CHGVAR     VAR(&SARD) VALUE('HUT104')                                    /*HUT104*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                   /*HUT104*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SFMT)                   /*HUT104*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                    CHGVAR     VAR(&HUT104) VALUE('Y')                                /*HUT104*/
                    CALL  PGM(UBSREOPEN1)                                             /*HUT104*/
/* */                                                                                 /*HUT104*/
/* If Switches U7 AND U8 is On, Exit with error*/                                     /*HUT104*/
/* */                                                                                 /*HUT104*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*HUT104*/
             GOTO       CMDLBL(ABNOR)                                                 /*HUT104*/
             ENDDO                                                                    /*HUT104*/

                    ENDDO                                                             /*HUT104*/
/**********************************************************************/
/* End of /COPY HUT104_001                                           **/
/**********************************************************************/
