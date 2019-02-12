/*********************************************************************/             /*LUC114*/
/*                                                                   */             /*LUC114*/
/*       LUC114_002 - LUC114 - Switchability   REC3762               */             /*LUC114*/
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
             IF         COND(&LUC114 *EQ 'Y') THEN(DO)
             OVRPRTF    FILE(XX3764DC) TOFILE(*LIBL/XX3764DC) +
                          SPLFNAME(RE3764DC)                                        /*LUC114*/
             CALL       PGM(XX3762) PARM(&BJLANG)                                   /*LUC114*/
             ENDDO                                                                  /*LUC114*/
             ELSE       CMD(DO)                                                     /*LUC114*/
/*********************************************************************/             /*LUC114*/
/* End of hook LUC114_002                                            */             /*LUC114*/
/*********************************************************************/             /*LUC114*/
