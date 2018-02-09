/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Outstanding Loans by Facility Enquiry')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0303A - Outstanding Loans by Facility Enquiry            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      136625             Date 16Jun98              */
/*                      CLE004             Date 02Dec96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       136625 - Loans by Facility Enquiry and Loans by Participant */
/*                Facility looks identical.                          */
/*       CLE004 - Customer Lending Enhancements - Syndications.      */
/*                                                                   */
/*********************************************************************/
             PGM
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             OVRDBF     FILE(FCLTY) TOFILE(LEFCLTL3) MBR(*ALL) +
                          SHARE(*NO)
             OVRDBF     FILE(CLOAN) TOFILE(LELOANL6) MBR(*ALL) +
                          SHARE(*NO)
/*********** CALL       PGM(LE0181)                                   /*136625*/
             CALL       PGM(LE0181) PARM('OSLP')                      /*136625*/
             DLTOVR     FILE(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
