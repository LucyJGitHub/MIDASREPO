/*********************************************************************/
/*                                                                   */
/*  Midas -  Italian Returns                                         */
/*                                                                   */
/*  ERCOMP - Compare any two files given a common key                */
/*                                                                   */
/*  (C) COPYRIGHT Midas/Kapiti International 2001                    */
/*                                                                   */
/*     Last Amend No. MD058100           Date 20May21               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     MD058100 - Rollup of additional BoI onsite fixes at FbMidas   */
/*     MMI100   - Created for PUMA                                   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*CRT  : CRTCMD                                                     :*/
/*CRT  : CMD(BISBISBISB/BISBISBISB) SRCFILE(BISBISBISB/BISBISBISB)  :*/
/*CRT  : PGM(ERC4900)  SRCMBR(*CMD)                                 :*/
/*CRT  : VLDCKR(*NONE) MODE(*ALL)                                   :*/
/*CRT  : ALLOW(*ALL)                                                :*/
/*CRT  : MAXPOS(*NOMAX) PMTFILE(*NONE) MSGF(QCPFMSG)                :*/
/*CRT  : AUT(*USE) TEXT(*SRCMBRTXT)                                 :*/
/*********************************************************************/
             CMD        PROMPT('Compare two files by key')
             PARM       KWD(FILE1) TYPE(*CHAR) LEN(10) MIN(1) +
                          FILE(*IN) CHOICE('File Name') +
                          PROMPT('Master File ' 1)
             PARM       KWD(FILE2) TYPE(*CHAR) LEN(10) MIN(1) +
                          FILE(*IN) CHOICE('File name') +
                          PROMPT('Target File ' 3)
             PARM       KWD(KEY) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Field common to the files') +
                          PROMPT('Common Field ' 7)
             PARM       KWD(FILE3) TYPE(*CHAR) LEN(10) MIN(1) +
                          FILE(*IN) CHOICE('File name') +
                          PROMPT('Output File ' 5)
             PARM       KWD(LIB3) TYPE(*CHAR) LEN(10) MIN(1) +
                          FILE(*IN) CHOICE('Library ') +
                          PROMPT('  Library ' 6)
             PARM       KWD(LIB1) TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          CHOICE('Library, *LIBL') PROMPT('  +
                          Library ' 2)
             PARM       KWD(LIB2) TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          CHOICE('Library, *LIBL') PROMPT('  +
                          Library ' 4)
