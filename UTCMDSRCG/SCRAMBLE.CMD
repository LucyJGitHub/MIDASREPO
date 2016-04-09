/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000017)    VLDCKR(*NONE)         MSGF(QCPFMSG)       */
/*EXI    HLPPNLGRP(SCRAMBLE)     HLPID(*CMD )                        */
/*EXI    TEXT('Midas UT Scramble sensitive data')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       SCRAMBLE - Scramble sensitive data                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. BUG27787  *CREATE  Date 19Jul10              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG27787 - New version of the SCRAMBLE utility              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Scramble sensitive data')
 
             PARM       KWD(LAYER) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *GLOB *ZONE) +
                          PROMPT('Layer')
