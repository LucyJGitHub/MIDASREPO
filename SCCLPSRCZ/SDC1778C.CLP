/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDC1778C - Check valid CPF name                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E29436             Date 11Oct91              */
/*                      E13205             Date 03/04/89             */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
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
                          Finastra International Limited +
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
                          Finastra International Limited')
             ENDPGM
