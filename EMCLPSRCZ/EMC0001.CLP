/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Set-up EM/TI interface feature')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       EMC0001 - Set up Exposure Management -> Trade Innovation    */
/*                 switchable feature                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK009             Date 09Aug99              */
/*       Prev Amend No. CTI002             DATE 23Feb99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CTI002 - Created for Exposure Management Development        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&D4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&D5) TYPE(*CHAR) LEN(1)
             DCL        VAR(&D6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&C1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&C2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&C3) TYPE(*CHAR) LEN(1)
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Ensure that the LDA exists */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
/**********     STRCMTCTL  LCKLVL(*CHG)                                 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                             VALUE('Y'))
 
                STRJRNPF   FILE(EMTFCBPD) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&CB) VALUE('Y'))
 
                STRJRNPF   FILE(EMTFSAPD) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&SA) VALUE('Y'))
 
                STRJRNPF   FILE(EMTFSLPD) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&SL) VALUE('Y'))
 
                STRJRNPF   FILE(EMDEXX4) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&D4) VALUE('Y'))
 
                STRJRNPF   FILE(EMDEXX5) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&D5) VALUE('Y'))
 
                STRJRNPF   FILE(EMDEXX6) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&D6) VALUE('Y'))
 
                STRJRNPF   FILE(EMCEXX1) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&C1) VALUE('Y'))
 
                STRJRNPF   FILE(EMCEXX2) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&C2) VALUE('Y'))
 
                STRJRNPF   FILE(EMCEXX3) JRN(ICJRN)
                MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&C3) VALUE('Y'))
 
                CALL       PGM(EM0001) PARM(&RTCDE)
 
/* End journalling only for those files that have been started */
 
                IF         COND(&CB *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMTFCBPD))
                IF         COND(&SA *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMTFSAPD))
                IF         COND(&SL *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMTFSLPD))
                IF         COND(&D4 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMDEXX4))
                IF         COND(&D5 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMDEXX5))
                IF         COND(&D6 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMDEXX6))
                IF         COND(&C1 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMCEXX1))
                IF         COND(&C2 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMCEXX2))
                IF         COND(&C3 *NE 'Y') THEN(ENDJRNPF +
                             FILE(EMCEXX3))
 
/* Only end commitment control if started from this program */
 
                IF         COND(&CMTCTL *NE 'Y') THEN(DO)
                   COMMIT
                   ENDCMTCTL
                ENDDO
 
/* If the return code is blank then end program normally */
 
                IF         COND(&RTCDE *EQ ' ') THEN(DO)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
/* Mode 2 - Second call */
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal Processing */
 
 ABNOR:      SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program EMC0001 +
                          ended abnormally')
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
