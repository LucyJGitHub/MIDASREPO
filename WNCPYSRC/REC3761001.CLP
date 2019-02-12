/*********************************************************************/             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*       REC3761001 - LUC114 - Switchability   REC3761               */             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*       (c) Misys International Banking Systems Ltd. 2019           */             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*       Last Amend No. LUC114             Date 24Jan19              */             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*-------------------------------------------------------------------*/             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*       LUC114 - Change Layout of Interest Capitalization Report    */             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*********************************************************************/             /*LUC114*/
/* Check if LUC114 is enabled. */                                                   /*LUC114*/
                                                                                    /*LUC114*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                /*LUC114*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                /*LUC114*/
             CHGVAR     VAR(&PSARD) VALUE('LUC114')                                 /*LUC114*/
             CHGVAR     VAR(&LUC114) VALUE('N')                                     /*LUC114*/
                                                                                    /*LUC114*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)            /*LUC114*/
                                                                                    /*LUC114*/
             IF COND(&PRTCD *EQ '       ') THEN(DO)                                 /*LUC114*/
             CHGVAR     VAR(&LUC114) VALUE('Y')                                     /*LUC114*/
             ENDDO                                                                  /*LUC114*/
                                                                                    /*LUC114*/
             IF         COND(&LUC114 *EQ 'Y') THEN(DO)                              /*LUC114*/
             OVRPRTF    FILE(XX3764DR) TOFILE(*LIBL/XX3764DR) +
                          SPLFNAME(RE3764DR)                                        /*LUC114*/
             OVRPRTF    FILE(XX3764CR) TOFILE(*LIBL/XX3764CR) +
                          SPLFNAME(RE3764CR)                                        /*LUC114*/
             CALL       PGM(XX3761) PARM(&BJLANG)                                   /*LUC114*/
             ENDDO                                                                  /*LUC114*/
             ELSE       CMD(DO)                                                     /*LUC114*/
/*********************************************************************/             /*LUC114*/
/* End of hook REC3761001                                            */             /*LUC114*/
/*********************************************************************/             /*LUC114*/
