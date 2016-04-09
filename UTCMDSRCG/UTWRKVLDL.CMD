/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000030) VLDCKR(UTC000030V) MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(UTWRKVLDL)    HLPID(*CMD )                        */
/*EXI    TEXT('Midas UT Work with validation lists')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTWRKVLDL - Work with Validation Lists                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2010           */
/*                                                                   */
/*       Last Amend No. CUT007  *REWRITE   Date 15Dec10              */
/*       Prev Amend No. BUG27989A*CREATE   Date 12Aug10              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUT007 - Rewrite of utility to make it more generic.        */
/*       BUG27989A - HATS should run with/without LDAP (Reopen)      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Work with validation lists')
 
             PARM       KWD(VLDL) TYPE(QUAL01) PROMPT('Validation +
                          list')
 
 QUAL01:     QUAL       TYPE(*NAME) LEN(10) DFT(*ALL) SPCVAL((*ALL))
             QUAL       TYPE(*CHAR) LEN(10) DFT(*USRLIBL) +
                          SPCVAL((*LIBL) (*CURLIB) (*USRLIBL)) +
                          MIN(0) PROMPT('Library')
