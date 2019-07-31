/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fees Input Repair')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0219  - Fees Input Repair                                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR314017           Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CAP064  *CREATE    Date 07Jun01              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR314017 - PONS/RONS warning if changed with LEACCNPD       */
/*                  records (Child:AR314018)                         */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CAP064 - Lending API enhancements - Fees Input              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             OVRDBF     FILE(LEIFEELX) TOFILE(LEIFEEL2) SHARE(*NO)
             OVRDBF     FILE(CLOANA1)  TOFILE(CLOANL4)  SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(FCLTYA1)  TOFILE(FCLTY)    SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(LEFEEDA1) TOFILE(LEFEED)   SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(LEACCNBB) TOFILE(LEACCNLB) SHARE(*NO)                      /*AR314017*/
 
             CALL       PGM(LE2210) PARM('F' ' ' ' ')
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
