/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(IFSAUTLC)      VLDCKR(*NONE)      MSGF(QCPFMSG)         */
/*EXI    HLPPNLGRP(IFSAUTLC)     HLPID(*CMD)                         */
/*EXI    TEXT('Midas UT bespoke command BA6032')                     */
/*********************************************************************/
/*                                                                   */
/*       (c) Finastra International Limited 2023                     */
/*                                                                   */
/*       Last Amend No. BA6032 *CREATE     Date 09Jan23              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BA6032 - Invoke In-house Command to Update SAVF Authority   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('IFSAUTLC')

             PARM       KWD(PATH) TYPE(*CHAR) MIN(1) PROMPT('FILE')

