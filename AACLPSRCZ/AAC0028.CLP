/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Futures and options PRFC defaults')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       AAC0028 - Futures and Options PRFC defaults                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. 184967  *CREATE    Date 12Sep00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       184967 - PCA Implementation Utilities                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,AAC0028INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,AAC0028MPS                                          */
 
/* Start commitment control for batch jobs with file updates */
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                             VALUE('Y'))
 
             OVRDBF     FILE(TRANSD) TOFILE(TRANSD) MBR(*ALL)
 
             CALL       PGM(AA0028)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Only end commitment control if started from this program */
/**/
                IF         COND(&CMTCTL *NE 'Y') THEN(ENDCMTCTL)
 
                GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,AAC0028ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
 
/* Abnormal termination                   */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            AAC0028 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,AAC0028END                                          */
 
             ENDPGM
