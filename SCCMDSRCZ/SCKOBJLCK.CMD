/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCKOBJLCK)  VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI *  TEXT('Midas SC Kill object locks')                          */
/*********************************************************************/
/*                                                                   */
/*  Midas - System Control Module                                    */
/*                                                                   */
/*  SCKOBJLCK - Kill Object Locks                                    */
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
             CMD        PROMPT('Kill object locks')
 
             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*ALL) MIN(0) PROMPT('Object')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*LIBL) MIN(0) PROMPT('Library')
             PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(7) RSTD(*NO) +
                          DFT(*FILE) MIN(0) PROMPT('Object type')
             PARM       KWD(JNAM) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(QZDASOINIT) MIN(0) PROMPT('Job name +
                          (or *ALL)')
             PARM       KWD(JUSR) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(XXOWNER) MIN(0) PROMPT('Job user name +
                          (or *ALL)')
             PARM       KWD(LOCKST) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*SHRUPD) MIN(0) PROMPT('Lock state +
                          (*ALL)')
             PARM       KWD(FIRSTC) TYPE(*CHAR) LEN(1) RSTD(*NO) +
                          DFT(Y) MIN(0) PROMPT('First Call Y or N')
