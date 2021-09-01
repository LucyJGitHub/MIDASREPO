/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Amend IRPUMAPD - STEP 2')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Italian Returns Module                              */
/*                                                                   */
/*       IRCHV005 - Amend IRPUMAPD - STEP 2                          */
/*                                                                   */
/*       (C) Copyright Misys 2002                                    */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. MBV002 *Create     Date 18Apr02              */
/*                                                                   */
/********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MBV002 - Created for HVB Milan                              */
/*                                                                   */
/********************************************************************/
             PGM

             DCL        VAR(&XXLIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)

/* Get the library prefix */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&XXLIB)
             CHGVAR     VAR(&ERDLIB) VALUE(&XXLIB *CAT 'ERDLIB')

             STRDFU     OPTION(1 1) DFUPGM(&ERDLIB/IRPUMAPDD) +
                          FILE(&ERDLIB/IRPUMAL1)

/* Recreate output files for Minerva */

             ADDLIBLE   LIB(&ERDLIB)
             CALL       PGM(ERC4110)
             CALL       PGM(ERC4130)
             RMVLIBLE   LIB(&ERDLIB)

             ENDPGM
