/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member SCC0204                                */
/*                                                                   */
/*       SCC0204MPE - MIDAS SD call UBSSUBMIT                        */
/*                                                                   */
/*       Last Ament No. HUT104  *CREATE    DATE 27APR20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT104   - UPGRADE HUT104 TO FBM 2.1 SP 22                  */
/*                - Call In-House Program on Input Cycle Re-open     */
/*                                                                   */
/*********************************************************************/
                                                                                          /*HUT104*/
/**/                                                                                      /*HUT104*/
/* Check if Switchable Feature HUT104 is on */                                            /*HUT104*/
/**/                                                                                      /*HUT104*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*HUT104*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*HUT104*/
             CHGVAR     VAR(&SAR) VALUE('HUT104')                                         /*HUT104*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*HUT104*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(UBSSUBMIT))                                                 /*HUT104*/

/**********************************************************************/
/* End of /COPY SCC0204MPE                                           **/
/**********************************************************************/
