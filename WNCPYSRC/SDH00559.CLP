/*********************************************************************/                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       MIDAS - /COPY Member SDC4710                                */                   /*HUT109*/
/*                                                                   */                   /*HUT109*/
/*       SDH00559 - Midas SD Standing Data Authorisation Summary     */                   /*HUT109*/
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
/** Clear SE Standard Settlement Details Shadow File                                      /*HUT109*/
/**/                                                                                      /*HUT109*/
             IF         COND(&CSD012 *EQ 'Y') THEN(DO)                                    /*HUT109*/
                CLRPFM     FILE(XXXSEDPS)                                                 /*HUT109*/
             ENDDO                                                                        /*HUT109*/
/**/                                                                                      /*HUT109*/
/**********************************************************************/                  /*HUT109*/
/* End of /COPY SDH00559                                             **/                  /*HUT109*/
/**********************************************************************/                  /*HUT109*/
