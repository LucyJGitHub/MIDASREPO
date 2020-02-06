/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC000123)  VLDCKR(SMC000123V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(BFCMPUSR)   HLPID(*CMD)                           */
/*EXI    TEXT('Midas SM Compare user access for BF migration')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       BFCMPUSR - Compare user access for BF migration             */
/*                                                                   */
/*       (c) Finastra International Limited 2011                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CBF005  *CREATE    Date 04Jul11              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CBF005 - BF Infrastructure: Single Security User Maintenance*/
/*                Profile                                            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare user access for BF mig')
 
             PARM       KWD(USR1) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('User 01')
 
             PARM       KWD(USR2) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('User 02')
 
             PARM       KWD(MBROPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*ADD) VALUES(*ADD *REPLACE) MIN(0) +
                          PROMPT('Replace or add records')
 
             PARM       KWD(DTL) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*SUM) VALUES(*SUM *DTL) MIN(0) +
                          PROMPT('Level of detail')
 
