/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RE001511)   VLDCKR(REC001513)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(SNDABCDTA)  HLPID(*CMD)                           */
/*EXI    TEXT('Midas RE Send ABC message to CREABCQ')                */
/*********************************************************************/
/*                                                                   */
/*       Midas RE Utilities Menu Command                             */
/*                                                                   */
/*       SNDABCDTA - Midas RE Send ABC message to CREABCQ            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2013           */
/*                                                                   */
/*       Last Amend No. AR1089591 *CREATE  Date 05Apr13              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1089591 - ABC Data Queue Recovery Process                 */
/*                   (Child:AR1089593)                               */
/*                 - Applied for MD-19899                            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Send ABC Msg To CREABCQ DTAQ')
             PARM       KWD(MODE) TYPE(*CHAR) LEN(10) +
                          CONSTANT('SendMsg   ') MIN(1) CASE(*MIXED)
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Midas Zone System Prefix')
             PARM       KWD(JOBDTL) TYPE(*CHAR) LEN(28) CONSTANT(' +
                          ') MIN(1)
             PARM       KWD(DTQMSG) TYPE(*CHAR) LEN(4021) CONSTANT(' +
                          ') MIN(1)
/*********************************************************************/
