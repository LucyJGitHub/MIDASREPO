/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Manual Repayments Repair')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0218  - Manual Repayments Repair                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CAP063  *CREATE    Date 06Jun01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP063 - Lending API enhancements - Manual Repayment        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)
             OVRDBF     FILE(LEIMRPLX) TOFILE(LEIMRPL2) SHARE(*NO)
 
             CALL       PGM(LE2110) PARM('F' 'LAMR' ' ')
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
