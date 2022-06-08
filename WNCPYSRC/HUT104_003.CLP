/*********************************************************************/
/*                                                                   */
/*       MIDAS - /COPY Member SCC0700                                */
/*                                                                   */
/*       HUT104_003 - MIDAS SD call UBSREOPEN1                       */
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
/**/                                                                                  /*HUT104*/
/* Check if Switchable Feature HUT104 is on */                                        /*HUT104*/
/**/                                                                                  /*HUT104*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                    /*HUT104*/
             CHGVAR     VAR(&SARD) VALUE('HUT104')                                    /*HUT104*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                    /*HUT104*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                     /*HUT104*/
             IF         COND(&RTN *EQ '       ') THEN(DO)
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
/* End of /COPY HUT104_003                                           **/
/**********************************************************************/
