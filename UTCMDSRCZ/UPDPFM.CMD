/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0075)                                                */
/*EXI *  TEXT('Midas UT View Physical file records')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UPDPFM - Update physical file member                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CREATE             Date 05MAR96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CREATE - Rewrite of UPDPF                                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('View Physical File Records')
 
             PARM       KWD(FILE) TYPE(FILELIB) PROMPT('File name')
 
             PARM       KWD(MBR) TYPE(*NAME) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PMTCTL(*PMTRQS) +
                          PROMPT('Member name')
 
 FILELIB:    QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*CURLIB) +
                          (*LIBL)) PROMPT('Library')
