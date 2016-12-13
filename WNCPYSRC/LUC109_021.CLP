/*********************************************************************/
/*                                                                   */
/*       LUC109_021 - LUC109 - Save HOR library                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2016           */
/*                                                                   */
/*       Last Amend No. LUC109             Date 21Sep16              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       LUC109 - HO Reporting (Upgrade to FBM 2.1)                  */
/*                                                                   */
/*********************************************************************/
/*                                                                    /*LUC109*/
/** Check for Switchable Feature LUC109.                              /*LUC109*/
/*                                                                    /*LUC109*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*LUC109*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*LUC109*/
             CHGVAR     VAR(&SARD) VALUE('LUC109')                    /*LUC109*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*LUC109*/
             IF         COND((&RTN *EQ ' ') *AND (&MODE *EQ 'DM')) +
                          THEN(DO) /*LUC109*/
/* Define HOR Library                                                 /*LUC109*/
               CHGVAR     VAR(%SUBSTRING(&LIBI 1 2)) +
                          VALUE(%SUBSTRING(&SDSTAT 6 2))              /*LUC109*/
/* Save HOR library                                                   /*LUC109*/
               SAVLIB     LIB(&LIBI) DEV(*SAVF) SAVF(&DILIB/DBIF) +
                            USEOPTBLK(*NO) CLEAR(*ALL) +
                            ACCPTH(&ACPTH) OUTPUT(*PRINT)             /*LUC109*/
             ENDDO       /*LUC109*/
/*********************************************************************/
/* End of hook LUC109_021                                            */
/*********************************************************************/
