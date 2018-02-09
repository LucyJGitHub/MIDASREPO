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
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             Date 02Nov94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Edit FETCH Search Library List')
 
             PARM       KWD(DEVSUPP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(S) VALUES(D S) +
                          PROMPT('Development/Support Libraries')
