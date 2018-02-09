/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE FACILITY AVAILABILITY ENQUIRY')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*            LEC0307-FACILITY AVAILABILITY ENQUIRY                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. BUG22126           Date 23Jan09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01194             Date 08Feb90              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       BUG22126 - Override file FCLTY to include Aggregate        */
/*                  facilities in the Availability Enquiry          */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEIC)                  * *S01194*/
             OVRDBF     FILE(FCLTY) TOFILE(FCLTY4)  SHARE(*NO)                          /*BUG22126*/
             CALL       PGM(LE0220)
             DLTOVR     FILE(FCLTY)                                                     /*BUG22126*/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
