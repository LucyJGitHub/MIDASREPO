/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000082)  VLDCKR(SMC000082V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CFGIASP)    HLPID(*CMD)                           */
/*EXI    TEXT('Midas SM Configure IASP System Values set up')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation                                      */
/*                                                                   */
/*       CFGIASP - Configure IASP System Values set up               */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG28037 *CREATE   Date 17Aug10              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG28037 - New command to set up IASP System Values.        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Configure IASP System Values')
 
             PARM       KWD(ASPGRP) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('IASP group')
             PARM       KWD(ASPRDB) TYPE(*NAME) LEN(18) DFT(*ASPGRP) +
                          SPCVAL((*ASPGRP)) MIN(0) PROMPT('IASP +
                          relational database')
