/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Validate CoB files')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0020 - Validation of CoB files.                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CUP014 *CREATE     Date 17Apr01              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP014 - Create shell for CoB files validation.             */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&LIB)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&NOTVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Copy CoB files for checking purposes. */
             CPYF       FROMFILE(&LIB/CBCMPNPD) TOFILE(CHKCMPPD) +
                          MBROPT(*REPLACE)
             CPYF       FROMFILE(&LIB/CBDPRLPD) TOFILE(CHKDPRPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Validation of CoB Component and +
                          Dependency files in' *BCAT &LIB *BCAT +
                          'taking place') TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CALL       PGM(CHKCOBRPG) PARM(&NOTVAL &LIB)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&NOTVAL *EQ 'Y') THEN(DO)
                              SNDPGMMSG  MSGID(CPF9898) +
                              MSGF(QCPFMSG) MSGDTA('A +
                              Dependency Loop conflict has +
                              occurred. See report CB9010P1') +
                              TOPGMQ(*EXT)
                ENDDO
                IF         COND(&NOTVAL *NE 'Y') THEN(DO)
                           SNDPGMMSG  MSGID(CPF9898) +
                           MSGF(QCPFMSG) MSGDTA('A Database +
                           error has occurred. See report +
                           CHKCOBP1') TOPGMQ(*EXT)
                ENDDO
 
                GOTO       CMDLBL(END)
 
             ENDDO
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Validation of COB files complete. +
                          The files are correct') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             DLYJOB     DLY(10)
             GOTO       CMDLBL(END)
 
 ABNOR:
             SNDPGMMSG  MSG('A database error has occurred during +
                          the CoB file validation processing - Job +
                          terminated.') TOPGMQ(*EXT) MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
