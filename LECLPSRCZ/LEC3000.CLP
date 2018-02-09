/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE INTEREST ACCRUALS REPORT')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC3000 - CUSTOMER LENDING INTEREST ACCRUALS REPORT        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00     *C *CREATE  Date 00/00/00             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             SNDPGMMSG  MSG('INTEREST ACCRUALS REPORT') +
                        TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(LEACXHH)
             CLRPFM     FILE(LEACXAC)
             CLRPFM     FILE(LEACXZZ)
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABLEEE)
             OVRDBF     FILE(CLOANC) TOFILE(CLOAN) SHARE(*NO)
             CALL       PGM(LE3000)
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CALL       PGM(LE3010)
/**/
                CLRPFM     FILE(LEACXHH)
                CLRPFM     FILE(LEACXAC)
                CLRPFM     FILE(LEACXZZ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
