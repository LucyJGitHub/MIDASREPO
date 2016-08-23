/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas NX Input Cycle Drip-feed Extract')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0610 - Input Cycle Drip-Feed Extract                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CMX001  *CREATE    Data 01Jan00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0610INT                                          */
 
             DCL        VAR(&TEMPENTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JSEQN) TYPE(*DEC)  LEN(10)
             DCL        VAR(&JSEQA) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(MXOLEJPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             ALCOBJ     OBJ((MXOLEJPD *FILE *EXCLRD)) WAIT(30)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             SNDPGMMSG  MSG('Attempt to start Midas Export Drip-Feed +
                          Extract has failed. Probable cause: +
                          process is active already.') +
                          TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0610MPS                                          */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF0000)
 
             OVRDBF     FILE(MXOLEJPD) SHARE(*NO)
 
             RCVF
 
             OVRDBF     FILE(MXMQDLPD) MBR(IDRIP) SHARE(*NO)
 
 
             CHGVAR     VAR(&JSEQN) VALUE(&I#LASTSEQ)
 
/* Check if journal sequence exists. */
/* If journal sequence does not exist, set to restart at first entry */
 
             RTVJRNE    JRN(ICJRN) FROMENT(&JSEQN) TOENT(&JSEQN) +
                          RTNENTTYP(&TEMPENTYP)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   CHGVAR     VAR(&JSEQN) VALUE(0)
                   RTVJRNE    JRN(ICJRN) FROMENT(*FIRST) +
                                TOENT(*FIRST) RTNSEQNBR(&JSEQN)
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
             CHGVAR     VAR(&JSEQN) VALUE(&JSEQN + 1)
 
 
/* Receive journal entries*/
 
             CHGVAR     VAR(&JSEQA) VALUE(&JSEQN)
             CALL       PGM(MXDRIPEXC) PARM(&RTCD &ERMS &JSEQA)
 
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               ROLLBACK
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0610 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,MXC0610MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0610ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0610 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,MXC0610END                                          */
 
             DLCOBJ     OBJ((MXOLEJPD *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
