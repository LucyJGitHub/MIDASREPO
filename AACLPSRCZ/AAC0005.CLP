/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Match off and update balancing postings')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       AAC0005 - Match Off and Update Balancing Postings           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
             /* Bank Fusion Midas 1.4 Base ---------------------------------------*/
             TEST       /* Bank Fusion Midas 1.4 Base +
                          ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CL program.                                    */
/*                                                                   */
/*********************************************************************/
PGM
/*/COPY WNCPYSRC,AAC0005001                                          */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             OVRDBF     FILE(AAACPT) TOFILE(GLPOSTL) SHARE(*YES)

             CLRPFM     FILE(AAPSTC)
/*/COPY WNCPYSRC,AAC0005002                                          */

             OPNQRYF    FILE((GLPOSTL *FIRST APOSTPDF)) +
                          FORMAT(AAACPT) QRYSLT('OTTP *NE +
                          "          " *AND OTST *NE "          "') +
                          KEYFLD((BRCA) (CCY) (CNUM) (ACOD) (ACSQ) +
                          (SPOS) (OTTP) (OTST) (OTRF) (DRCR))

             CALL AA0005A
/*/COPY WNCPYSRC,AAC0005003                                          */

             CLOF GLPOSTL
             DLTOVR AAACPT

             CALL AA0005B

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

ENDPGM
