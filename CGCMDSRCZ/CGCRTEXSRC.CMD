/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGC4999)                                                */
/*EXI *  TEXT('Midas CG Create new extract from group set')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGCRTEXSRC - Create Template Extract from Group Set              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  Last Amend No. 155016             DATE 07FEB99                   */
/*  Prev Amend No. S01522             DATE 17AUG95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       155016 - Allow lower case                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create UDC Extract Source')
 
/************PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +     */                   /*155016*/
/************             PROMPT('Start from Group Set')             */                   /*155016*/
             PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +
                          CASE(*MIXED) PROMPT('Start from Group Set')                     /*155016*/
 
             PARM       KWD(IN_SRCF) TYPE(FILE) PROMPT('Place in +
                          source file')
 FILE:       QUAL       TYPE(*NAME) LEN(10) DFT(#SRCMBRO)
             QUAL       TYPE(*NAME) LEN(10) DFT(QTEMP) SPCVAL((*LIBL +
                          *LIBL)) PROMPT('Library Name')
 
             PARM       KWD(MBR) TYPE(*NAME) DFT(NEW) PROMPT('Member +
                          Name')
 
             PARM       KWD(MBRNAME) TYPE(*CHAR) LEN(50) DFT('New +
                          Member') PROMPT('Member Text')
