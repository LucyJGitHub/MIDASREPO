/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Produce Prof Format X-ref File')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC415 - Profitability format X-reference file creation    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. MOF60              DATE 23MAR92              */
/*       PREV AMEND NO.                    DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             ALCOBJ     OBJ((PEFMTD *FILE *EXCL) (PEXREF *FILE *EXCL))
             CLRPFM     FILE(PEXREF)
             CALL       PGM(LER415)
             DLCOBJ     OBJ((PEFMTD *FILE *EXCL) (PEXREF *FILE *EXCL))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
