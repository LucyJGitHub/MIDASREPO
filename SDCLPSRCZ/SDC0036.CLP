/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Set up account narrative')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0036 -Set up Standing Data - Account Narrative           */
/*                switchable feature                                 */
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
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      CSD005             Date 29Mar99              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CSD005 - Created for Standing Data Account Narrative        */
/*                development                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&CO) TYPE(*CHAR) LEN(1)
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/* Ensure that the LDA exists */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
/**/
/* Start commitment control and journalling */
/**/
/***************STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                      /*CPK009*/
                MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                             VALUE('Y'))
 
/**/
             STRJRNPF   FILE(SDACODPD) JRN(ICJRN)
             MONMSG     MSGID(CPF7030) EXEC(CHGVAR VAR(&CO) VALUE('Y'))
 
 
             CALL       PGM(SD0036) PARM(&RTCDE &PMODE)
 
/**/
/* End journalling only for those files that have been started */
/**/
             IF         COND(&CO *NE 'Y') THEN(ENDJRNPF +
                          FILE(SDACODPD))
 
/**/
/* Only end commitment control if started from this program */
/**/
                IF         COND(&CMTCTL *NE 'Y') THEN(ENDCMTCTL)
/**/
/* If the return code is blank then end program normally */
/**/
                IF         COND(&RTCDE *EQ ' ') THEN(DO)
                   GOTO       CMDLBL(END)
                ENDDO
 
/* Abnormal Processing */
 
 ABNOR:      SNDPGMMSG  MSG('Program SDC0036 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
