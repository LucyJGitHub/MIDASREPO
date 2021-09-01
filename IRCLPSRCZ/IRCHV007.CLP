/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR QUERIES FOR RISERVA OBBLIGATORIA')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Italian Returns Module                              */
/*                                                                   */
/*       IRCHV007 - QUERIES FOR RISERVA OBBLIGATORIA                 */
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

             RUNQRY     QRY(&ERDLIB/RIS03)
             RUNQRY     QRY(&ERDLIB/RIS04)
             RUNQRY     QRY(&ERDLIB/RIS05)
             RUNQRY     QRY(&ERDLIB/RIS06)
             RUNQRY     QRY(&ERDLIB/RIS07)

             ENDPGM
