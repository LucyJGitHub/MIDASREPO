/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Show/remove item group on menus')            */
/********************************************************************/
/*                                                                  */
/*       Midas     SECURITY PROFILE FACILITY                    */
/*                                                                  */
/*       SFC0430  - Show/Remove Item Group on Menus                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.   000000           DATE 00/00/00            */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ZIG) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(ZIG) RTNVAR(&ZIG)
/**/
/*  If Item Group not currently being shown, change to show  */
/**/
             IF         COND(%SST(&ZIG 1 1) *EQ ' ') THEN(DO)
                CHGDTAARA  DTAARA(ZIG (1 1)) VALUE('Y')
             ENDDO
/**/
/*  If Item Group currently being shown, change to non-display  */
/**/
             IF         COND(%SST(&ZIG 1 1) *EQ 'Y') THEN(DO)
                CHGDTAARA  DTAARA(ZIG (1 1)) VALUE(' ')
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
