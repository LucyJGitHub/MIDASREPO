/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Profitability Enq by Bus Gp & Fclty')        */
/********************************************************************/
/*                                                                  */
/*       Midas     - Customer Lending Module                    */
/*                                                                  */
/*       LERC47E - Profitability Enquiry.                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248 *CREATE   Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XXXXXX             Date DDMmmYY              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       XXXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
 
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USAC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ALVL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&LVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
             CHGJOB     SWS(00000000)
 
/* Retrieve job attributes for user A/C Officer & Authority Level */
 
             RTVJOBA    USER(&USER)
             CALL       PGM(LER405) PARM(&RETURNCODE &USER &USAC +
                          &LVL)
 
/* If level is not 0, 1 or 2 then user is not authorised */
/* so move '9' into level to represent no authority. */
 
             IF         COND(&RETURNCODE *NE '       ') THEN(CHGVAR +
                          VAR(&LVL) VALUE('9'))
 
             CHGVAR     VAR(&ALVL) VALUE(&LVL)
 
 
/* Call LER475 for enquiries.     */
 
             CALL       PGM(LER475) PARM(&USAC &ALVL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
