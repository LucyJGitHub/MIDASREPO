/*STD    CLPBASE                                                     */
/*EXI    TEXT('RE Audit Letter Selection (Input Cycle Component')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC7050 - RE Audit Letter Selection (Input Cycle Component) */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      CER041  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       CER041 - Audit Letters Correspondence                       */
/*                (Upgrade of FGE132 and FGE171)                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
/*-------------------------------------------------------------------*/
/* Declare variables                                                 */
/*-------------------------------------------------------------------*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) VALUE('CER041')
/*                                                                   */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDATE) TYPE(*CHAR) LEN(6)
 
/*--------------------------------------------------------------------*/
/* Global Monitor Message                                             */
/*--------------------------------------------------------------------*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/*--------------------------------------------------------------------*/
/* Check if feature CER041 is switched on                             */
/*--------------------------------------------------------------------*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)
/*                                                                    */
/* If found, do                                                       */
             IF         COND(&SRTCD *EQ '        ') THEN(DO)
             CLRPFM     FILE(CGAUHDPD)
/*--------------------------------------------------------------------*/
/* Retrieve Processing Date from data area CGAUDT                    */
/* ...and call LETA screen for selection criteria                     */
/*--------------------------------------------------------------------*/
             RTVDTAARA  DTAARA(CGAUDT (1 6)) RTNVAR(&PDATE)
             CALL       PGM(CG7050) PARM(&RTN_CODE &PDATE)
             CHGDTAARA  DTAARA(CGAUDT (1 6)) VALUE(&PDATE)
             ENDDO
/**/
ABNORMAL:
             ENDPGM
