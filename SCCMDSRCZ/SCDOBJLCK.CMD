/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCDOBJLCK)  VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI *  TEXT('Midas SC Display objects locked')                     */
/*********************************************************************/
/*                                                                   */
/*  Midas - System Control Module                                    */
/*                                                                   */
/*  SCDOBJLCK - Display Object Locks                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3834  *CREATE   Date 18Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG3834 - New programs created to deal with object locks    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Display objects locked')
 
             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*ALL) MIN(0) PROMPT('Object')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*LIBL) MIN(0) PROMPT('Library')
             PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(7) RSTD(*NO) +
                          DFT(*FILE) MIN(0) PROMPT('Object type')
             PARM       KWD(PRINT) TYPE(*CHAR) LEN(8) RSTD(*NO) +
                          DFT(*) MIN(0) PROMPT('* or *PRINT')
