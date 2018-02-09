/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000006)    VLDCKR(UTC000006V)    MSGF(QCPFMSG)       */
/*EXI    HLPPNLGRP(CMPFMNT)      HLPID(*CMD )                        */
/*EXI *  TEXT('Midas UT Maintain template file for CMPF')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       CMPFMNT - Maintain template file for CMPFMNT                */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27790 *CREATE   Date 22Jun10              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27790 - New utility                                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Maint. template file for CMPF')
 
             PARM       KWD(TFILE) TYPE(Q1) MIN(1) PROMPT('File name +
                          for field template' 1)
 
             PARM       KWD(MBROVR) TYPE(*NAME) LEN(10) DFT(*CURUSR) +
                          SPCVAL((*CURUSR)) PROMPT('Member name +
                          used for override' 2)
 
 Q1:         QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
