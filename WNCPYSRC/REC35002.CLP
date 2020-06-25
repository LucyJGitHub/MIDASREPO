/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC35  MIDAS RE CUSTOMER EXCHANGES INPUT TODAY              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/*       Last Amend No. MD52452            Date 12Dec18              */
/*       Prev Amend No. DUG503             Date 04Apr18              */
/*                      DUG431             Date 11Jul05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD52452 - COB Reopen Fails                                  */
/*               - Back up the file CUSEXCE_BK to DPLIB instead of   */
/*                 DMLIB                                             */
/*       DUG431 - Amendments to 'Events by Value Date' Report        */
/*                                                                   */
/*********************************************************************/
/*  Start of DUG431  */                                                                   /*DUG431*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSPRE)                              /*DUG431*/
/*           CHGVAR     VAR(&LIB) VALUE(&SYSPRE *CAT 'DMLIB')                     /*DUG431 MD52452*/
             CHGVAR     VAR(&LIB) VALUE(&SYSPRE *CAT 'DPLIB')                            /*MD52452*/
             DLTF       FILE(CUSEXCE_BK)                                                  /*DUG431*/
             MONMSG     MSGID(CPF0000)                                                    /*DUG431*/
             CPYF       FROMFILE(CUSEXCE) TOFILE(&LIB/CUSEXCE_BK) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*DUG431*/
             MONMSG     MSGID(CPF0000)                                                    /*DUG431*/
/*  End of DUG431  */                                                                     /*DUG431*/
