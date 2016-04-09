/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDC1778C - Check valid CPF name                            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E29436             DATE  11OCT91            */
/*       PREV AMEND NO. E13205             DATE  03/04/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       E29436 - Move to SCCLSRC from RR.                          */
/*       E13205 - Pass back name                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&IN &OUT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&IN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUT) TYPE(*CHAR) LEN(10)
/**/
             CHGVAR     VAR(&OUT) VALUE(&IN)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
