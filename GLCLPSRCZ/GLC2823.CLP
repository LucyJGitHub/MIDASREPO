/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis IAT background task')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC2823 - Midas-Fontis IAT Background Task                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. CGL009  *CREATE    Date 18May99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&RECIAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTCD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PWAIT)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&DATA)   TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GLC2823 - Midas-Fontis IAT Background +
                          Task') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
 
             CHGDTAARA  DTAARA(GLFIATDA (1 26)) VALUE(&JOB *CAT +
                          &USER *CAT &NBR)
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
 PROCESS:
             CHGVAR     VAR(&PRTCD) VALUE(' ')
             CALL       PGM(GLC2824) PARM(&PRTCD)
             IF         COND(&PRTCD *EQ 'Y') THEN(GOTO CMDLBL(ABNOR))
 
/* Convert GLIATXPD and GLIATJPD records into corresponding record */
/* files GLJEIHPD and GLJEIPPD */
 
             CALL       PGM(GL2825) PARM(&PWAIT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&DATA *EQ 'T') THEN(GOTO CMDLBL(END))
 
 
             CALL       PGM(QRCVDTAQ) PARM(GLIATSA *LIBL X'00001F' +
                          &DATA &PWAIT)
             DLTOVR     FILE(*ALL)
 
             IF         COND((&DATA *EQ ' ') *OR (&DATA *EQ 'C')) +
                          THEN(GOTO CMDLBL(PROCESS))
             ELSE       CMD(IF COND(&DATA *EQ 'E') THEN(GOTO +
                          CMDLBL(END)))
             ELSE       CMD(IF COND(&DATA *EQ 'T') THEN(DO))
/* Blank Transferred ICT indicator in data area GLFIATDA */
             CHGDTAARA  DTAARA(GLFIATDA (28 1)) VALUE(' ')
/* To indicate we are inside I/C termination and are performing */
/* a last extraction to the programs involved */
             CHGDTAARA  DTAARA(GLFIATDA (29 1)) VALUE('B')
             GOTO       CMDLBL(PROCESS)
             ENDDO
 
 ABNOR:
             ROLLBACK
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC2823 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
/**/
/* We no longer need to indicate we are processing a last */
/* extraction */
             CHGDTAARA  DTAARA(GLFIATDA (29 1)) VALUE(' ')
/* Show that the job is finished  */
             CHGDTAARA  DTAARA(GLFIATDA (1 26)) VALUE(' ')
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
 
