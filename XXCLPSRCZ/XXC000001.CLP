/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Update XXACODPD')                               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing data Module                                */
/*                                                                   */
/*       XXC000001 - Midas XX SD Upddta Linkage Acod                 */
/*                                                                   */
/*      (c) Finastra International Banking Systems Ltd. 2017         */
/*                                                                   */
/*       Last Amend No. DUG501  *CREATE    Date 23Aug17              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG501 - Accounts split for Realised P&L and Account Seq    */
/*                by Book                                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Banking Systems Ltd. 2017')
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
             DCL        (&DUG501) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        (&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             MONMSG     MSGID(CPF2817)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DMLIB')
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('XXC000001 - Midas XX SD Upddta Linkage Acod') +
                          TOMSGQ(MRUNQ)
 
/***  Access Switchable Features file to see if IFL007  present  ***/
 
             CALL       (AOSARDR0) PARM(&PRTCD '*VERIFY' 'DUG501')
             IF         (&PRTCD *EQ ' ') (CHGVAR (&DUG501) VALUE('Y'))
 
/***  If the DUG501 Feature is present                   ***/
 
             IF         (&DUG501 *EQ 'Y') THEN(DO)
 
/**/
                UPDDTA     FILE(&TOLIB/XXACODPD)
/**/
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC000001 +
                          ended abnormally - see job log') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Banking +
                          Systems Ltd. 2017')
 
             ENDPGM