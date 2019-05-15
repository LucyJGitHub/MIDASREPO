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
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27787 *CREATE   Date 19Jul10              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27787 - New version of the SCRAMBLE utility              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Scramble sensitive data')
 
             PARM       KWD(LAYER) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *GLOB *ZONE) +
                          PROMPT('Layer')
