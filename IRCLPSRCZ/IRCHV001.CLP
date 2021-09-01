/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Amend FT Extension')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Italian Returns Module                              */
/*                                                                   */
/*       IRCHV001 - Amend FT Extension                               */
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

             UPDDTA     FILE(&ERDLIB/FTPAYMV0)

             ENDPGM
