/*********************************************************************/                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       MIDAS - /COPY Member SDC4710                                */                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       SDH00558 - Midas SD Standing Data Authorisation Summary     */                   /*HUT109*/
/*                    Report                                         */                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       Last Ament No. HUT109  *CREATE    DATE 15Apr20              */                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*********************************************************************/                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       HUT109 - Partial upgrade of HUT020 to FB 2.1 SP22           */                   /*HUT109*/
/*                Additional Authorisation Steps in SE Module        */                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*********************************************************************/                   /*HUT109*/
                                                                                          /*HUT109*/
/**/                                                                                      /*HUT109*/
/** Check if CSD012 is installed */                                                       /*HUT109*/
/**/                                                                                      /*HUT109*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*HUT109*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*HUT109*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN 'CSD012' +
                           &DSSDY)                                                        /*HUT109*/
             IF         COND(&PRTCD *EQ '       ') +
                           THEN(CHGVAR VAR(&CSD012) VALUE('Y'))                           /*HUT109*/
/**/                                                                                      /*HUT109*/
/**********************************************************************/                  /*HUT109*/
/* End of /COPY SDH00558                                             **/                  /*HUT109*/
/**********************************************************************/                  /*HUT109*/
