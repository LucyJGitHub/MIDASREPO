/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Get Next Repair Number')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0215  - Get Next Repair Number                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CAP053  *CREATE    Date 12Mar01              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAP053 - Lending API enhancements                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RPN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RPN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&NRN) TYPE(*CHAR) LEN(5)
 
             RTVDTAARA  DTAARA(LENXRPNO (1 5)) RTNVAR(&NRN)
             CHGVAR     VAR(&RPN) VALUE(&NRN)
             CHGVAR     VAR(&RPN) VALUE(&RPN + 1)
             CHGVAR     VAR(&NRN) VALUE(&RPN)
             CHGDTAARA  DTAARA(LENXRPNO (1 5)) VALUE(&NRN)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
