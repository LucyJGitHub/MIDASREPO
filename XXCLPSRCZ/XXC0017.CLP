/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Retrieve component status in COB')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       XXC0017 - Retrieve component status in COB                  */
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
 
             PGM        PARM(&CMPNAM &CMPSEQ &CMPRQD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2013')
 
             DCL        VAR(&CMPNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMPSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CMPRQD) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CMPKEY) TYPE(*CHAR) LEN(16)
 
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(512)
 
/** File **/
 
             DCLF       FILE(CBCOMSL0)
 
             CHGVAR     VAR(&CMPRQD) VALUE(' ')
             CHGVAR     VAR(&CMPKEY) VALUE(&CMPNAM *CAT &CMPSEQ *CAT +
                          '1')
 
             OVRDBF     FILE(CBCOMSL0) POSITION(*KEY 2 @DHREGG +
                          &CMPKEY) SECURE(*YES) OVRSCOPE(*CALLLVL) +
                          SHARE(*NO)
 
/** Search for record **/
 
RCVKEY:
             RCVF
             MONMSG     MSGID(CPF4128) EXEC(DO)
             DLYJOB     DLY(5)
             GOTO       CMDLBL(RCVKEY)
             ENDDO
             MONMSG     MSGID(CPF4137 CPF0864) EXEC(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('Component' *BCAT &CMPNAM +
                          *BCAT &CMPSEQ *BCAT 'not found in CBCOMSL0')
             GOTO       CMDLBL(EXIT)
             ENDDO
 
             IF         COND((&DHCOTT = &CMPNAM) *AND (&DHCSEQ = +
                          &CMPSEQ)) THEN(DO)
             CHGVAR     VAR(&CMPRQD) VALUE(&DHCRQD)
             CHGVAR     VAR(&MSGTXT) VALUE('Status of component' +
                          *BCAT &CMPNAM *BCAT &CMPSEQ *BCAT 'in +
                          current COB is' *BCAT &CMPRQD)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('Can not retrieve status +
                          of component' *BCAT &CMPNAM *BCAT &CMPSEQ +
                          *BCAT 'from CBCOMSL0')
             ENDDO
 
EXIT:
             DLTOVR     FILE(CBCOMSL0) LVL(*)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGTXT *NE ' ') THEN(DO)
 
/** Send message to job log **/
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGTXT) +
                          TOPGMQ(*EXT) MSGTYPE(*COMP)
 
             ENDDO
 
             ENDPGM
