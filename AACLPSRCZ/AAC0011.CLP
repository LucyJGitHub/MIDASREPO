/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA SE Database Files Book Conversion')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting module                        */
/*                                                                   */
/*       AAC0011 - Call SE Database Files Book Conversion            */
/*                 For Switchable Feature Initialisation.            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CAC005  *CREATE    Date 13Apr99              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CAC005 - Profit Centre Accounting - SE Enhancement.         */
/*                - CAC005 initialisation control program.           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
/*/COPY WNCPYSRC,AAC0011INT                                          */
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,AAC0011MPS                                          */
 
/* Mode 1 - First call */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
 
                STRJRNPF   FILE(TRADSD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BULKTD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(HSTTRD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(DPTMVD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(PRICED) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BKMTHD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BKPHDD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BKPHHD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BKRVLD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(MATEXD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BKPOSD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(BPACHD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(UPLEXD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(UDEPPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(TREVED) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SEERALPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SECOALPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SECOAPPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SECOREPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SECORHPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(SECOSIPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
                STRJRNPF   FILE(PMPLTRPD) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
 
/**********     STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                         /*CPK009*/
                MONMSG     MSGID(CPF8351)
                CALL       PGM(AA0015) PARM(&RTCDE &PMODE)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSG('Program AA0015 ended abnormally') +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ABNOR)
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
 
/*/COPY WNCPYSRC,AAC0011MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,AAC0011ERR                                          */
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program AAC0011 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,AAC0011END                                          */
 
             ENDPGM
