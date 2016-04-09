/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Forward commitments reversals (UP/UL)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC4400 - Forward Commitments Revaluation (UP/UL) Reversal  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 226165             Date 31Mar04              */
/*       Prev Amend No. CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       226165 - Limit UP/UL Generation in DL COB Prompt            */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FREVLP) TYPE(*CHAR) LEN(1)                                   /*226165*/
             DCL        VAR(&FREVAL) TYPE(*CHAR) LEN(1)                                   /*226165*/
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)                                 /*226165*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
                                                                                          /*226165*/
/* Check to see if Forward Revals are to be posted from DLSTAT */                         /*226165*/
                                                                                          /*226165*/
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                                    /*226165*/
             CHGVAR     VAR(&FREVAL) VALUE(%SUBSTRING(&DLSTAT 16 1))                      /*226165*/
             CHGVAR     VAR(&FREVLP) VALUE(%SUBSTRING(&DLSTAT 23 1))                      /*226165*/
             IF         COND(&FREVLP *EQ 'Y' *OR &FREVAL *NE 'Y') +
                          THEN(GOTO CMDLBL(END))                                          /*226165*/
                                                                                          /*226165*/
             SNDPGMMSG  MSG('DLC4400 - Forward Commitments +
                          Revaluation UP/UL Reversals A/C Key +
                          Generation') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Setup system prefix variable from SDSTAT data area */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
 
/* Call program CB0160 to get value of restart indicator */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If it is NOT a restart */
 
             IF         COND(&STAT *NE 'Y') THEN(DO)
               DLTF       FILE(XDKEYSDP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSZZ)
               MONMSG     MSGID(CPF2105)
 
               CPYF       FROMFILE(DKEYSDP) TOFILE(&DPLIB/XDKEYSDP) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(DKEYSZZ) TOFILE(&DPLIB/XDKEYSZZ) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* If it is a restart */
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XDKEYSDP) TOFILE(DKEYSDP) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817 CPF2869) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(XDKEYSZZ) TOFILE(DKEYSZZ) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817 CPF2869) CMPDTA(CPF2869)
             ENDDO
 
             CHGVAR     VAR(&STAT) VALUE('Y')
 
/* Call CB0150 to update restart indicator */
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Call DL Forward Commitments Revaluation UP/UL A/c generation report */
 
             CALL       PGM(DL4400)
 
/* If no error occured in the program */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Call CB0150 to update restart indicator */
 
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XDKEYSDP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSZZ)
               MONMSG     MSGID(CPF2105)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC4400 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
