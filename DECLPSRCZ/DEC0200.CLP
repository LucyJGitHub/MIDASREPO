/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Fiduciary Accrual A/c Keys Extract Ctl')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0200 - Fiduciary Accrual A/c Keys Extract Control        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002  *CREATE    Date 29Mar00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,DEC0200INT                                          */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDL006) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0200 - Fiduciary Accrual Account Keys +
                          Extract') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0200MPS                                          */
 
/* Set up susbsytem data */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYST)
             CHGVAR     VAR(&DPLIB) VALUE(&SYST *CAT 'DPLIB')
 
/* Determine if Fiduciary Dealing is installed */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CDL006')
 
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL006) VALUE('Y'))
             IF         COND(&CDL006 *EQ 'Y') THEN(DO)
 
/* Check for component restart                */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If Restart copy file to back up copy    */
 
 
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/XDEFAAKPD) +
                          TOFILE(&DPLIB/DEFAAKPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEFAAKPD))
 
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(&DPLIB/DEFAAKPD) +
                          TOFILE(&DPLIB/XDEFAAKPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDEFAAKPD))
 
                CHGVAR     VAR(&BUSY) VALUE('Y')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
                ENDDO
 
/* Call the program                               */
 
             CALL       PGM(DE0200) PARM(&RTCD &ERMS)
 
/* If program called successfully                 */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             ELSE       DLTF FILE(XDEFAAKPD)
 
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
                ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0200ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0200 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0200END                                          */
 
ENDPGM
