/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0070)                                                */
/*EXI *  TEXT('Midas UT Update Data Area')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UPDDTAARA - Update data area                                */
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
/*       CREATE - Rewrite of AMDDTAARA                               */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Update Data Area')
 
             PARM       KWD(DTAARA) TYPE(DTAARALIB) PROMPT('Data +
                          Area name')
 
             PARM       KWD(ACTION) TYPE(*CHAR) RSTD(*YES) +
                          DFT(*AMEND) SPCVAL((*AMEND) (*ENQUIRE)) +
                          PMTCTL(*PMTRQS) PROMPT('Action')
 
 DTAARALIB:  QUAL       TYPE(*NAME) SPCVAL((*LDA) (*GDA)) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*CURLIB) +
                          (*LIBL)) PROMPT('Library')
