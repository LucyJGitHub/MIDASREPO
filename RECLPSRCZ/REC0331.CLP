/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Sweeps list control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC0331 - Sweeps List Control                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE004  *Create    Date 20Jan97              */
/*       Prev Amend No. 000000             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE004 - Sweep Accounting                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&STATUS &MODE &SEQ &LEVEL &BRANCH)
 
/* Setup Copyright variable */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Declare parameters */
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3)
 
/* Declare variable used in DB error processing */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Declare variable used in Restart processing */
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10) VALUE('REC0331')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0) VALUE(00001)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&STATUS *EQ 'I') THEN(SNDPGMMSG +
                          MSG('REC0331 Sweeps List') TOMSGQ(MRUNQ))
             ELSE       CMD(DO)
 
                SNDPGMMSG  MSG('REC0331 Sweeps List - COB') +
                          TOMSGQ(MRUNQ)
 
/* Get system prefix from data area  */
 
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
 
/* Setup 'To library'  */
                CHGVAR     VAR(&DPLIB) VALUE(&LID *CAT 'DPLIB')
 
/* Get Component Restart Status  */
 
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If Restart Status is 'Y', Restore file from Backup */
/* otherwise Create File Backup */
 
                IF      COND(&STAT *EQ 'Y') THEN(DO)
                  CPYF  FROMFILE(&DPLIB/XRESWEPPD) TOFILE(RESWEPPD) +
                          MBROPT(*REPLACE)
/*/COPY WNCPYSRC,REC0331001                                          */
                ENDDO
                ELSE       CMD(DO)
                   CPYF   FROMFILE(RESWEPPD) TOFILE(&DPLIB/XRESWEPPD) +
                            MBROPT(*ADD) CRTFILE(*YES)
/*/COPY WNCPYSRC,REC0331002                                          */
                   CHGVAR   VAR(&STAT) VALUE('Y')
                   CALL     PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
                ENDDO
 
             ENDDO
 
             CHGJOB     SWS(00000000)
             CALL       PGM(RE0331) PARM(&STATUS &MODE &SEQ &BRANCH)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ELSE       CMD(IF COND(&STATUS *NE 'I') THEN(DO))
               DLTF       FILE(&DPLIB/XRESWEPPD)
/*/COPY WNCPYSRC,REC0331003                                          */
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                         REC0331 ended abnormally - see job log') +
                         TOMSGQ(MOPERQ)
             MONMSG    MSGID(CPF0000 MCH0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
