/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Fontis TPP background task')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   MEC2002    Fontis TPP Background Task                           */
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
/*   Prev Amendment No. CGL009 *CREATE   Date 02JUL99                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   CGL009 - Midas-Fontis IAT/TPP Interface                         */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&NBCREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DAFTPP) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTAQN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LNDTA) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WAIT1) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LASTEXT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRIDX) TYPE(*CHAR) LEN(10)
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('MEC2002 - Fontis TPP Background Task') +
                          TOMSGQ(MRUNQ)
 
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
/**/
/* Start TPP Extraction */
             STRTPPEXT:
/*           ---------- */
             RTVDTAARA  DTAARA(MEFTPPDA) RTNVAR(&DAFTPP)
/**/
/* Receive TPP files flag is 'Y' */
             IF COND(%SST(&DAFTPP 27 1) *EQ 'Y') THEN(DO)
/**/
               RTVMBRD  FILE(MGTPPSPD) RTNMBR(&MBRN) NBRCURRCD(&NBCREC)
               MONMSG     MSGID(CPF3019) EXEC(GOTO CMDLBL(CRTMMFILE))
 
/**/
/* For each member of MGTPPSPD retrieved */
               FORMBTPPS:
/*             ---------- */
/**/
               ALCOBJ     OBJ((MGTPPSPD *FILE *EXCL &MBRN)) +
                          WAIT(120)
               MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(NXTMBTPPS))
/**/
/* Number of records null */
               IF         COND(&NBCREC *EQ 0) THEN(DO)
                 DLCOBJ     OBJ((MGTPPSPD *FILE *EXCL &MBRN))
                 RMVM       FILE(MGTPPSPD) MBR(&MBRN)
                 GOTO       CMDLBL(NXTMBTPPS)
               ENDDO
/**/
/* Convert ASCII msg and create Index files */
               OVRDBF  FILE(MGTPPSPD)  MBR(&MBRN)
               CALL       PGM(ME2003) PARM(&MBRN)
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 DLCOBJ     OBJ((MGTPPSPD *FILE *EXCL &MBRN))
                 DMPCLPGM
                 RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&ERRDTA)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO       CMDLBL(ABNOR)
 
               ENDDO
/**/
               COMMIT
               DLCOBJ     OBJ((MGTPPSPD *FILE *EXCL &MBRN))
               RMVM       FILE(MGTPPSPD) MBR(&MBRN)
/**/
/* Retrieve next member of MGTPPSPD */
               NXTMBTPPS:
/*             ---------- */
               CHGVAR     VAR(&MBRIDX) VALUE(&MBRN)
               RTVMBRD    FILE(MGTPPSPD) MBR(&MBRIDX *NEXT) +
                          RTNMBR(&MBRN) NBRCURRCD(&NBCREC)
               MONMSG     MSGID(CPF3049 CPF3019) EXEC(GOTO +
                          CMDLBL(CRTMMFILE))
               GOTO       CMDLBL(FORMBTPPS)
/**/
             ENDDO
/**/
/* Create Message Management files */
/* Retrieve TPP processing time from Fontis ICD */
             CRTMMFILE:
/*           ---------- */
             OVRDBF     FILE(MGTPPMPD) SHARE(*NO)
             CALL       PGM(ME2004) PARM(&WAIT1)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               DLCOBJ     OBJ((MGTPPSPD *FILE *EXCL &MBRN))
               DMPCLPGM
               RTVDTAARA  DTAARA(LDA (134 45)) RTNVAR(&ERRDTA)
               SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&ERRDTA) +
                        TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(ABNOR)
 
             ENDDO
/**/
/* The last extraction has been processed */
             IF         COND(&LASTEXT *EQ 'Y') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* Receive dtaq info */
             CHGVAR     VAR(&DTAQN) VALUE('METPPSA')
             CHGVAR     VAR(&LIBRN) VALUE('*LIBL')
             CHGVAR     VAR(&LNDTA) VALUE(1)
             CHGVAR     VAR(&DATA1) VALUE(' ')
             CALL       PGM(QRCVDTAQ) PARM(&DTAQN &LIBRN &LNDTA +
                          &DATA1 &WAIT1)
/* Continue TPP Extraction */
             IF         COND(&DATA1 *EQ 'C') THEN(DO)
               GOTO       CMDLBL(STRTPPEXT)
             ENDDO
/* End Extraction */
             IF         COND(&DATA1 *EQ 'E') THEN(DO)
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/* Job Termination requested by I/C Termination */
             IF         COND(&DATA1 *EQ 'T') THEN(DO)
/**/
/* Blank Transferred ICT indicator in data area MEFTPPDA */
               CHGDTAARA  DTAARA(MEFTPPDA (28 1)) VALUE(' ')
/**/
/* To indicate we are inside I/C termination and are performing */
/* a last extraction to the programs involved */
               CHGDTAARA  DTAARA(MEFTPPDA (29 1)) VALUE('B')
/* Process now a last extraction */
               CHGVAR     VAR(&LASTEXT) VALUE('Y')
               GOTO       CMDLBL(STRTPPEXT)
             ENDDO
/* By default : continue TPP Extraction */
             GOTO       CMDLBL(STRTPPEXT)
/**/
 ABNOR:      ROLLBACK
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                 ('Program MEC2002 ended abnormally - see job log') +
                 TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDPGM:
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGTPPSPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* Show that the job is finished  */
             CHGDTAARA  DTAARA(MEFTPPDA (1 26)) VALUE(' ')
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
