/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Get Next Repair Number')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0215  - Get Next Repair Number                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CAP053  *CREATE    Date 12Mar01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP053 - Lending API enhancements                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RPN)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RPN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&NRN) TYPE(*CHAR) LEN(5)
 
             RTVDTAARA  DTAARA(LENXRPNO (1 5)) RTNVAR(&NRN)
             CHGVAR     VAR(&RPN) VALUE(&NRN)
             CHGVAR     VAR(&RPN) VALUE(&RPN + 1)
             CHGVAR     VAR(&NRN) VALUE(&RPN)
             CHGDTAARA  DTAARA(LENXRPNO (1 5)) VALUE(&NRN)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
