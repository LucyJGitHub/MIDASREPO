/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MG MT970 Generation Batch')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - ME Module                                           */
/*                                                                   */
/*       CLP/MGC0970 - Midas MG MT970 Generation Batch               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6480            Date 25Apr05              */
/*       Prev Amend No. CSW099  *CREATE    Date 28Feb05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6480- Change commitment control                          */
/*       CSW099 - Creation of MT970 Netting Statements               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&WVDTE)
 
/* Declare variables                                                 */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WVDTE) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/* Declare parameters fo access object AOSARDR0                      */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CSW099')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(60)
             DCL        VAR(&CSW099) TYPE(*CHAR) LEN(1) VALUE('N')
 
/* Global monitor message                                            */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas ME MT970 Generation Batch') +
                          TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
/* Check if SAR CSW099 is on                                         */
 
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSFDY)
             IF         COND(&RTCD = '       ') THEN(CHGVAR +
                          VAR(&CSW099) VALUE('Y'))
 
             IF         COND(&CSW099 = 'Y') THEN(DO)
 
/* Start commitment control                                          */
 
/************STRCMTCTL**LCKLVL(*ALL)*NFYOBJ(*NONE)******************* /*BUG6480*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*BUG6480*/
             MONMSG     MSGID(CPF0000)
 
/*********************************************************************/
/* Extraction program                                                */
/*********************************************************************/
 
             CALL       PGM(MG0970) PARM(&WVDTE)
 
/*********************************************************************/
             ENDDO
/*********************************************************************/
 
/*********************************************************************/
/* Database error processing                                         */
/*********************************************************************/
 
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
 
/* Abnormal termination - batch job                                  */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MG0970  ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
