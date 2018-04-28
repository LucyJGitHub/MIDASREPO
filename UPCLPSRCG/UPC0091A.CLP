/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP UPDDLVLST validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UTC0091A - UPDDLVLST Validity Checker                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     Date 15Jul96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DLVLIB)
 
/* Command parameters */
 
             DCL        VAR(&DLVLIB) TYPE(*CHAR) LEN(10)
 
/* Work variables */
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(508)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Check delivery library */
DLVLIB:
             CHKOBJ     OBJ(&DLVLIB) OBJTYPE(*LIB) AUT(*CHANGE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
                CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
 
/* Check for deliverables list */
DLVLST:
             IF         COND(&ERROR *NE 'Y') THEN(DO)
                CHKOBJ  OBJ(&DLVLIB/UPDLVCPD) OBJTYPE(*FILE) AUT(*UPD)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                   RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSG(&MSG)
                   CHGVAR     VAR(&MSGDTA) VALUE('0000' *CAT &MSG)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                             MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                ENDDO
             ENDDO
 
/* Send message to pass earlier messages back */
 
ERRORS:
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
/* Normal end of program */
 
             RETURN
 
ABNOR:
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
