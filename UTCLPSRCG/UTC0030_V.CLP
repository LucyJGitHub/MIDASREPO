/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CLRDBLIB validity checker')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0030_V - CLRDBLIB validity checker                       */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CSM002             Date 22Nov02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Move to global layer.        */
/*       CSM002 - Refresh options from the Bridge.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&LIB)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Check whether the library exists. */
             CHKOBJ     OBJ(&LIB) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000 +
                             Library' *BCAT &LIB *BCAT 'does not +
                             exist.') MSGTYPE(*DIAG)
                CHGVAR     VAR(&ERROR) VALUE('Y')
             ENDDO
 
/* Send message to cause CPF to pass earlier messages back */
             IF         COND(&ERROR *EQ 'Y') THEN(SNDPGMMSG +
                          MSGID(CPF0002) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
