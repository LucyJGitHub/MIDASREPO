/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Update Generic Transaction details')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0020 - Update Generic Transaction Details                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002  *CREATE    Date 05Apr00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis.               */
/*                                                                   */
/*********************************************************************/
             PGM   PARM(&TTYP)
 
/*/COPY WNCPYSRC,DEC0020INT                                          */
 
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0020 - Update Generic Transactions +
                          for Revenue') TOMSGQ(MRUNQ)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
/**/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0001MPS                                          */
 
             OVRDBF     FILE(DEPTRANL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEPPOSNL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEPEVNTL1) MBR(&TTYP) SHARE(*NO)
 
             OVRDBF     FILE(DEGTRANL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGPOSNL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGEVNTL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGVALUL1) MBR(&TTYP) SHARE(*NO)
 
             CALL       PGM(DEUPDGETR) PARM(&TTYP)
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0020 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                 ROLLBACK
                 ENDCMTCTL
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,DEC0020MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0020ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0020 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
             ROLLBACK
             MONMSG     MSGID(CPF0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0020END                                          */
 
             ENDPGM
