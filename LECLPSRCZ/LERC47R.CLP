/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Profitability Rpt Selection Prompt.')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC47R - Profitability Reports Selection Prompt.           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX             DATE DDMMMYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
 
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &CMD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USAC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ALVL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
 
/* Retrieve job attributes for user A/C Officer & Authority Level */
 
             CHGJOB     SWS(00000000)
             RTVJOBA    USER(&USER)
             CALL       PGM(LER405) PARM(&RETURNCODE &USER &USAC +
                          &LVL)
             IF         COND(&RETURNCODE *NE '       ') THEN(DO)
 
/* If user not authorised put blanks in user account officer  */
/* field to trigger error message in prompt program.          */
 
                  CHGVAR     VAR(&USAC) VALUE('  ')
 
/* Put 9 into access level (9 = No access allowed).           */
 
                  CHGVAR     VAR(&LVL) VALUE(9)
 
             ENDDO
 
             CHGVAR     VAR(&ALVL) VALUE(&LVL)
 
 
/* Call LER471 to prompt for selection required.            */
 
             CALL       PGM(LER471) PARM(&USAC &ALVL &RPARM &RACT &CMD)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
