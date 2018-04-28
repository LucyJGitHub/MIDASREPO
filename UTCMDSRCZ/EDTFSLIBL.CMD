/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0014)                                                */
/*EXI *  TEXT('Midas UT Edit FETCH search library list')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       EDTFSLIBS - Edit FETCH search library list                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01516             DATE 02NOV94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Edit FETCH Search Library List')
 
             PARM       KWD(DEVSUPP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(S) VALUES(D S) +
                          PROMPT('Development/Support Libraries')
