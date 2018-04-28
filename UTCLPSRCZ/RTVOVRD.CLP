/*STD    CLPBASE                                                     */
/*EXI    TEXT('Retrieve Override Description')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities                                             */
/*                                                                   */
/*       RTVOVRD - Retrieve Override Description                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CLE134  *CREATE    Date 01Aug12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing                      */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&FMFL &TOFL &TOLB &TOMB &OVRT &STS)
 
             DCL        VAR(&FMFL)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOFL)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOMB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OVRT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&STS)     TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000)
 
/** Initialisation */
 
             CHGVAR     VAR(&TOFL)  VALUE(' ')
             CHGVAR     VAR(&TOLB)  VALUE(' ')
             CHGVAR     VAR(&TOMB)  VALUE(' ')
             CHGVAR     VAR(&OVRT)  VALUE(' ')
             CHGVAR     VAR(&STS)   VALUE(' ')
 
/** Validate From File */
 
             CHKOBJ     OBJ(&FMFL) OBJTYPE(*FILE)
 
             MONMSG     MSGID(CPF0000) EXEC(DO)
               SNDPGMMSG MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                  File does not exist.') MSGTYPE(*DIAG)
               GOTO      CMDLBL(ERR010)
             ENDDO
 
/** Validation Successful */
 
             CALL       PGM(RTVOVRDSC) PARM(&FMFL &TOFL &TOLB &TOMB +
                          &OVRT &STS)
 
             GOTO       CMDLBL(ENDPGM)
 
/** Exit Program */
 
ERR010:
             SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
 
ENDPGM:
            ENDPGM
/*********************************************************************/
