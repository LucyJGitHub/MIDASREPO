/*********************************************************************/
/*                                                                   */
/*       HUT121_062 -  Midas /COPY for GOC0100                       */
/*                                                                   */
/*       Last Amend No. HUT121  *CREATE    Date 07Feb22              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       HUT121 -  Allow SE Price Input for Non-working day.         */
/*                                                                   */
/*********************************************************************/
                                                                                          /*HUT121*/
             CHGVAR     VAR(&PSAR) VALUE('HUT121')                                        /*HUT121*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*HUT121*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSAR &SCSARD)                   /*HUT121*/
             IF         COND(&PRTCD *EQ '       ')  THEN(DO)                              /*HUT121*/
             CHGVAR     VAR(&HUT121) VALUE('Y')                                           /*HUT121*/
             ENDDO                                                                        /*HUT121*/
                                                                                          /*HUT121*/
             IF         COND((&HUT121 *EQ 'Y') *AND +
                        (&GPF = 'GZPRICED'))  THEN(DO)                                    /*HUT121*/
             CHGVAR     VAR(&PGM) VALUE('XGO' *CAT %SST(&GPF 3 8))                        /*HUT121*/
             ENDDO                                                                        /*HUT121*/
             ELSE       (DO)                                                              /*HUT121*/
                                                                                          /*HUT121*/
/*********************************************************************/
/*      End of /COPY HUT121_062                                      */
/*********************************************************************/
