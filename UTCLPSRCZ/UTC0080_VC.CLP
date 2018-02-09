/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CVTSRCLEN validity checker')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0080_VC - Validity checker for CVTSRCLEN                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP001 *CREATE     Date 21Dec98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QUALFIL &LENDEC &NEWLIB)
 
             DCL        VAR(&QUALFIL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LENDEC) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&SRCFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Format qualified variables */
             CHGVAR     VAR(&SRCFIL) VALUE(%SST(&QUALFIL 1 10))
             CHGVAR     VAR(&SRCLIB) VALUE(%SST(&QUALFIL 11 10))
 
 
/*  Check source library exists  */
             IF         COND(&SRCLIB *EQ ' ') THEN(DO)
                SNDPGMMSG    MSG('Source Library cannot be blank')
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO ABNOR
             ENDDO
 
             CHKOBJ     OBJ(QSYS/&SRCLIB) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Source library does not exist +
                          or you have insufficient authority') +
                          MSGTYPE(*DIAG) /*CAAA01*/
                CHGVAR     VAR(&ERROR) VALUE('Y')
                GOTO ABNOR
             ENDDO
 
/*  Check source file exists and user has sufficient authority  */
             IF         COND(&SRCFIL *NE '*ALL') THEN(DO)
                CHKOBJ    OBJ(&SRCLIB/&SRCFIL) OBJTYPE(*FILE) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                          MSGDTA('0000Source file does not exist or +
                          you have insufficient authority') +
                          MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                ENDDO
             ENDDO
 
/*  Check new library exists and user has sufficient authority  */
             IF         COND((&NEWLIB *NE &SRCLIB) *AND (&NEWLIB *NE +
                          '*SRCLIB')) THEN(DO)
                CHKOBJ     OBJ(QSYS/&NEWLIB) OBJTYPE(*LIB) AUT(*CHANGE)
                MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                   MSGDTA('0000New library does not exist or you have +
                          insufficient authority') MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                ENDDO
             ENDDO
 ABNOR:
/*  SEND MESSAGE TO CAUSE CPF TO PASS EARLIER MESSAGES BACK         */
            IF  COND(&ERROR *EQ 'Y') THEN(+
            SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
     ENDPGM
