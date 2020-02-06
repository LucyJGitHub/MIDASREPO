/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Re-Generation of Position Sett for Wtax')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       CLP/SEC7602 - Midas SE Re-Generation of Position            */
/*                     Settlement for Withholding Tax                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CSE023  *CREATE    Date 12Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE023 - Treaty Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSSHT &RDDTE &REVTP)
 
/* Declare variables */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSSHT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RDDTE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&REVTP) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Declare parameters fo access object AOSARDR0 */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CSE023')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(60)
             DCL        VAR(&CSE023) TYPE(*CHAR) LEN(1) VALUE('N')
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas SE Allocations per Dividend +
                          Payment Summary Report') TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
/* Check if SAR CSE023 is on */
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)
             IF         COND(&RTCD = '       ') THEN(CHGVAR +
                          VAR(&CSE023) VALUE('Y'))
 
             IF         COND(&CSE023 = 'Y') THEN(DO)
 
/* Start commitment control for batch jobs with file updates */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))
             ENDDO
 
                CALL       PGM(SE7608UPD) PARM(&RSSHT &RDDTE &REVTP)
 
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                COMMIT
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SE7608UPD ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
