/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC003004) VLDCKR(UPC3004_VC) MSGF(QCPFMSG)             */
/*EXI *  TEXT('Midas UP Restore global libraries to dummy names')    */
/*********************************************************************/
/*                                                                   */
/*  Midas Plus - Bridge                                              */
/*                                                                   */
/*  RSTGLBLIBS - Restore global libraries to temporary libraries     */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CSC033  *CREATE    Date 01May07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC033 - Include global libraries in backups                */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Restore global libraries')
 
             PARM       KWD(ZONEID) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          DFT(*ALL) MIN(0) FULL(*YES) PROMPT('Zone +
                          prefix')
             PARM       KWD(GLOBID) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          DFT(*ALL) MIN(0) FULL(*YES) +
                          PROMPT('Global prefix')
             PARM       KWD(SAVETYPE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(SAVF) VALUES(SAVF TAPE) MIN(0) +
                          PROMPT('Restore type')
             PARM       KWD(TAPDEV) TYPE(*NAME) LEN(10) RSTD(*NO) +
                          DFT(*FILE) MIN(0) PMTCTL(TAPER) +
                          PROMPT('Tape device')
             PARM       KWD(VOLUME) TYPE(*CHAR) LEN(5) RSTD(*NO) +
                          MIN(0) PMTCTL(TAPER) PROMPT('Tape volume')
             PARM       KWD(GMSAVF) TYPE(FILELIB) MIN(0) +
                          PMTCTL(SAVFR) PROMPT('GMLIB save file')
 FILELIB:    QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL) +
                             (*CURLIB)) PROMPT('Library name')
             PARM       KWD(GTASAVF) TYPE(FILELIB) MIN(0) +
                          PMTCTL(SAVFR) PROMPT('GTALIB save file')
 TAPER:      PMTCTL     CTL(SAVETYPE) COND((*EQ TAPE))
 SAVFR:      PMTCTL     CTL(SAVETYPE) COND((*EQ SAVF))
