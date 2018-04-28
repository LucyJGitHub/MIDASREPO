/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000030) VLDCKR(UTC000034V) MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(UTWRKVLDL)    HLPID(*CMD )                        */
/*EXI *  TEXT('Midas UT Work with validation lists')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTWRKVLDL - Work with Validation Lists                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. BUG27989A*CREATE   Date 12Aug10              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG27989A - HATS should run with/without LDAP (Reopen)      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Work with validation lists')
 
             PARM       KWD(VLDL) TYPE(QUAL01) MIN(1) +
                          PROMPT('Validation list')
 
QUAL01:      QUAL       TYPE(*NAME) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*USRLIBL) +
                          SPCVAL((*LIBL) (*CURLIB) (*USRLIBL)) +
                          MIN(0) PROMPT('Library')
