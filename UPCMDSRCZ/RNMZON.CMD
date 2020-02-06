/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000013)  VLDCKR(UPC000013V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RNMZON)     HLPID(*CMD)                           */
/*EXI    TEXT('Midas UP Rename zone')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       RNMZON - Rename zone                                        */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP002  *CREATE    Date 12Aug10              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP002 - Rename zone.                                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Rename zone')
 
             PARM       KWD(ZPFX) TYPE(*NAME) LEN(2) MIN(1) +
                          PROMPT('Zone prefix')
             PARM       KWD(NEWZ) TYPE(NEWZONE) MIN(1) PROMPT('New +
                          zone data')
 
 NEWZONE:    ELEM       TYPE(*NAME) LEN(10) MIN(1) PROMPT('New zone +
                          name')
             ELEM       TYPE(*NAME) LEN(4) MIN(1) FULL(*YES) +
                          PROMPT('New zone shortcode')
             ELEM       TYPE(*CHAR) LEN(50) MIN(1) CASE(*MIXED) +
                          PROMPT('New zone description')
 
