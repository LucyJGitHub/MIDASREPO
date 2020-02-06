/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Margin accruals report')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LER340P - Margin accruals report                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      118282             Date 27Jan98              */
/*                      MOF60              DATE 24Mar92              */
/*                                         DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       118282 - Apply fix 085314.                                  */
/*                Override CLOAN to PETEMPLN before call to LER340   */
/*                to get details of reversed loan.                   */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('MARGIN ACCRUALS REPORT ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
                OVRDBF     FILE(INACS) TOFILE(MGACS)
                OVRDBF     FILE(CLOAN) TOFILE(PETEMPLN)               /*118282*/
/**/
/* MARGIN ACCRUALS REPORT                                           */
                CALL PGM(LER340)
/**/
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
