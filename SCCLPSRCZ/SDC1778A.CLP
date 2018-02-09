/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Rep last sucs. trans on primy m/c')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*       SDC1778A - Check valid CPF name                            */
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
/*                      S01343             Date 15Aug91              */
/*                      E13205             DATE  03/04/89           */
/*                                                                  */
/********************************************************************/
/*       New program overview                                       */
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E29436 - MOVE TO SCCLSRC FROM RR.                          */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                   */
/*                - SCCHKCPF RENAMED FROM SDC1778B                  */
/*                                                                  */
/*       E13205 - Check valid CPF name by calling command           */
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
/*           Call command to check CPF name                          */
/**/
             SCCHKCPF   IN(&IN) OUT(&OUT)
             MONMSG     MSGID(CPF0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
