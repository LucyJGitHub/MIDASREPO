/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0020)                                                */
/*EXI *  TEXT('Midas UT Write source')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       WRTSRC - Write source                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01516             DATE 18JUL94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/* The Write Source command writes statements to a source member.   */
/*   Either the entire statement can be written or positions can    */
/*   be specified to build up the source statement. The source      */
/*   member must exist.                                             */
/*                                                                  */
/*********************************************************************/
             CMD        PROMPT('Write Source')
             PARM       KWD(SRCFILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('Source File Name')
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Member')
             PARM       KWD(RELRCD) TYPE(*DEC) LEN(3 0) DFT(*NEXT) +
                          SPCVAL((*NEXT 0)) REL(*GT 0) +
                          PROMPT('Relative Record Number')
             PARM       KWD(ACTION) TYPE(*CHAR) LEN(4) DFT(*ADD) +
                          RSTD(*YES) VALUES(*ADD *UPD *RPL *END) +
                          PROMPT('Action')
             PARM       KWD(STMT) TYPE(*CHAR) LEN(80) +
                          PROMPT('Full Source Statement')
             PARM       KWD(POS1) TYPE(*DEC) LEN(2 0) +
                          REL(*GT 0) +
                          PROMPT('Position 1 for Text')
             PARM       KWD(TXT1) TYPE(*CHAR) LEN(25) +
                          PROMPT('Text 1')
             PARM       KWD(POS2) TYPE(*DEC) LEN(2 0) +
                          REL(*GT 0) +
                          PROMPT('Position 2 for text')
             PARM       KWD(TXT2) TYPE(*CHAR) LEN(25) +
                          PROMPT('Text 2')
             PARM       KWD(POS3) TYPE(*DEC) LEN(2 0) +
                          REL(*GT 0) +
                          PROMPT('Position 3 for text')
             PARM       KWD(TXT3) TYPE(*CHAR) LEN(25) +
                          PROMPT('Text 3')
             PARM       KWD(POS4) TYPE(*DEC) LEN(2 0) +
                          REL(*GT 0) +
                          PROMPT('Position 4 for Text')
             PARM       KWD(TXT4) TYPE(*CHAR) LEN(25) +
                          PROMPT('Text 4')
QUAL1:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL(*LIBL) +
                          PROMPT('Library Name')
