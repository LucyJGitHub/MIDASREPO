/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member SCC0700                                */
/*                                                                   */
/*       HUT104_004 - MIDAS SD call UBSREOPEN1                       */
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
/*    Call In-House program if HUT104 is activated  */                                /*HUT104*/
/**/                                                                                  /*HUT104*/
             IF         COND(&HUT104 *EQ 'Y') THEN(DO)
                    CALL  PGM(UBSREOPEN2)                                             /*HUT104*/
/* */                                                                                 /*HUT104*/
/* If Switches U7 AND U8 is On, Exit with error*/                                     /*HUT104*/
/* */                                                                                 /*HUT104*/
             IF         COND(%SWITCH(XXXXXX11)) +
                          THEN(DO)                                                    /*HUT104*/
             GOTO       CMDLBL(ABNOR)                                                 /*HUT104*/
             ENDDO                                                                    /*HUT104*/

                    ENDDO                                                             /*HUT104*/
/**********************************************************************/
/* End of /COPY HUT104_004                                           **/
/**********************************************************************/
