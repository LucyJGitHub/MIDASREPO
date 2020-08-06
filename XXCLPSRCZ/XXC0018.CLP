/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Check MIMIX DBIC Save')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       XXC0018 - Midas CB Check MIMIX DBIC Save                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2013           */
/*                                                                   */
/*       Last Amend No. ERZ178   *CREATE   Date 15Mar13              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       ERZ178 - COB Save Enhancements + MIMIX                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2013')
 
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5) VALUE(-1)
 
/** Check for switchable feature ERZ178 - COB Save Enhancements **/
 
             CHGVAR     VAR(&PRTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('ERZ178')
             CALL       PGM(AOSARDR0) PARM(&PRTCD &OPTN &SARD)
             IF         COND(&PRTCD *NE '       ') THEN(GOTO +
                          CMDLBL(ENDPGM))
 
             CALL       PGM(QCLRDTAQ) PARM(XXMIMIXRQ *LIBL)
 
/** Send 'XM' entry **/
 
             SNDJRNE    JRN(ICJRN) TYPE('XM') ENTDTA('XXC0018') +
                          FORCE(*YES)
 
/** Check MIMIX Receive Data Queue **/
 
LOOP:
 
             CHGVAR     VAR(&DATA) VALUE('     ')
             CALL       PGM(QRCVDTAQ) PARM('XXMIMIXRQ' '*LIBL   ' +
                          X'00005F' &DATA &WAIT)
 
             IF         COND(&DATA *EQ '*ERR') THEN(DO)
             GOTO ABNOR
             ENDDO
 
             IF         COND(&DATA *EQ '*STOP') THEN(DO)
             GOTO ENDPGM
             ENDDO
 
             IF         COND(&DATA *NE '*OK') THEN(GOTO CMDLBL(LOOP))
 
             GOTO ENDPGM
 
/** Error Processing **/
 
ABNOR:
 
             SNDPGMMSG  MSG('Check MIMIX DBIC Save ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDPGM:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             ENDPGM
