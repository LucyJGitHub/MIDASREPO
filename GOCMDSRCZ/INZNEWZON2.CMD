/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GO000021)  VLDCKR(*NONE)      MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(INZNEWZONE) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas GO Create new zone')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing                                   */
/*                                                                   */
/*       INZNEWZON2 - Create new zone for Global Processing          */
/*                                                                   */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. CUP046   *CREATE   Date 18Jul22              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP046 - One Touch Bridge - migration                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create new zone')

             PARM       KWD(ZONE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Name of zone')

             PARM       KWD(ZONECODE) TYPE(*NAME) LEN(4) MIN(1) +
                          FULL(*YES) PROMPT('Zone shortcode')

             PARM       KWD(ZONEDESC) TYPE(*CHAR) LEN(50) MIN(1) +
                          CASE(*MIXED) PROMPT('Zone description')

             PARM       KWD(ACMVRCVDAY) TYPE(*DEC) LEN(3) MIN(1) +
                          PROMPT('Account movement recovery days')


