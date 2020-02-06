/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facilities Repair')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0209R - Facilities Repair                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CAP065  *CREATE    Date 19Jun01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP065 - Lending API enhancements - Facility Details        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             OVRDBF     FILE(LEIFACLX) TOFILE(LEIFACL2) SHARE(*NO)
             CALL       PGM(LE2020) PARM('F' ' ' ' ')
             DLTOVR     FILE(*ALL)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
