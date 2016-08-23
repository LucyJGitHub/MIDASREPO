/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facilities details enquiry')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*                LEC0302-FACILITY DETAILS ENQUIRY                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. BUG22126                Date  23Jan09       */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 204670                  Date  08Apr02       */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      120184                  Date  10Jul97       */
/*                      S01194                  Date  08Feb90       */
/*                                                                  */
/********************************************************************/
/*       BUG22126 - Override FCLTY file to include Aggregate        */
/*                  facilities in the Details Enquiry               */
/*       204670 - Pass a parameter when calling LE0170.               */
/*                Applied fix 194860.                                 */
/*       120184 - OVERRIDE TO FACILITY FILE                         */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
/**********  OVRDBF     FILE(FCLTY) SHARE(*NO)                                   /*120184 BUG22126*/
             OVRDBF     FILE(FCLTY) TOFILE(FCLTY4) SHARE(*NO)                           /*BUG22126*/
/**********  CALL       PGM(LE0170)                                                       /*204670*/
             CALL       PGM(LE0170) PARM('H')                                             /*204670*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             DLTOVR     FILE(*ALL)                                    /*120184*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
