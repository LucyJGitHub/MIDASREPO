/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SETCOBJAUT)    VLDCKR(*NONE)      MSGF(QCPFMSG)         */
/*EXI    HLPPNLGRP(SETOBJAUT)     HLPID(*CMD)                        */
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
             CMD        PROMPT('SETCOBJAUT')

             PARM       KWD(LIB) TYPE(*CHAR) MIN(1) PROMPT('LIB')

             PARM       KWD(OBJECT) TYPE(*CHAR) MIN(1) +
                          PROMPT('OBJECT')

             PARM       KWD(TYPE) TYPE(*CHAR) MIN(1) +
                          PROMPT('TYPE')

