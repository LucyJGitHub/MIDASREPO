/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Check program is on stack')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC9001 - Check whether program is on stack                 */
/*                                                                   */
/*       This program receives parameters of a program name and a    */
/*       numeric (1,0) returncode.  It checks whether the program    */
/*       is in the current call stack.  It returns a value of 0 if   */
/*       it is not, and 1 if it is.                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 089864 *CREATE     Date 07AUG96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       089864 - Fix is to prevent recursive call of programs       */
/*                through the attention key Instruction Manual       */
/*                menu (SF0600), but this program can be used        */
/*                whenever it is necessary to determine whether a    */
/*                particular program is on the call stack.           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROGRAM &RETURNCODE)
 
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10) /* Program +
                          to check */
             DCL        VAR(&RETURNCODE) TYPE(*DEC) LEN(1 0) /* +
                          Return code: 1 if found, 0 if not found */
             DCL        VAR(&BLKMSGID) TYPE(*CHAR) LEN(7) /* Blank +
                          message ID field */
             DCL        VAR(&BLKMSGF) TYPE(*CHAR) LEN(20) /* Blank +
                          message file and library field */
             DCL        VAR(&MSGLEN) TYPE(*CHAR) LEN(4) /* Message +
                          length */
             DCL        VAR(&MSGTYPE) TYPE(*CHAR) LEN(10) +
                          VALUE('*INFO') /* Message type */
             DCL        VAR(&STACKPOS) TYPE(*CHAR) LEN(4) /* +
                          Position in the stack */
             DCL        VAR(&MSGKEY) TYPE(*CHAR) LEN(4) /* Message +
                          key */
             DCL        VAR(&ERRCDE) TYPE(*CHAR) LEN(4) +
                          VALUE(X'00000000') /* Error code for API; +
                          the value of zero forces an escape +
                          message to be sent. */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*/COPY UTCPYSRC,STDERR_DCL                                          */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
 
/** +
    Set up initial data +
    =================== +
    The message length is a binary field  It is set to 5 because the +
    dummy message used is that length. +
    The stack position will be determined by the program name, so +
    the field for that purpose is set to binary zero. +
**/
             CHGVAR     VAR(%BIN(&MSGLEN)) VALUE(5)
             CHGVAR     VAR(%BIN(&STACKPOS)) VALUE(0)
 
/** +
    Determine whether the program is on the stack +
    ============================================= +
    The API attempts to send a program message to the specified +
    program.  If the program is on the stack no message will be +
    sent.  If it is not, one of the monitored messages will be sent. +
    Return code is set to 1 (program found on stack) initially; if +
    the program is not found it will be set to 0. +
**/
             CHGVAR     VAR(&RETURNCODE) VALUE(1)
 
             CALL       PGM(QMHSNDPM) PARM(&BLKMSGID &BLKMSGF +
                          'DUMMY' &MSGLEN &MSGTYPE &PROGRAM +
                          &STACKPOS &MSGKEY &ERRCDE)
 
             MONMSG     MSGID(CPF247A CPF2479) EXEC(DO)
 
                CHGVAR     VAR(&RETURNCODE) VALUE(0)
 
             ENDDO
 
/*/COPY WNCPYSRC,UTC9001MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/*/COPY WNCPYSRC,UTC9001ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&MSGDTA) VALUE('UTC9001')
 
/*/COPY UTCPYSRC,STDERR                                              */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,UTC9001END                                          */
 
             ENDPGM
