/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI *  TEXT('Midas UP Copy /COPY sources to specified lib')        */
/*EXI    PGM(UPC00356)   VLDCKR(UPC2035_V6) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CPYCPYSRC)      HLPID(*CMD)                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       CPYCPYSRC6 - Copy /COPYs to specified location              */
/*                                                                   */
/*       Function: This command is similar to CPYCPYSRC with LAYER   */
/*                 as parameter added.                               */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CUP044   *CREATE   Date 22May22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP044 - One Touch Bridge Automation Changes - Release/     */
/*                Patch Upgrade                                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Copy /COPY to Specified locn')

             PARM       KWD(FROMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library to copy from')                                  /*CPK016*/

             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library to copy to')

             PARM       KWD(LAYER) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          VALUES(*GLOBAL *ZONE) MIN(1) PROMPT('Layer')                    /*CPK018*/
