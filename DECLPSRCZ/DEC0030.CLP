/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Report transaction details')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0030 - Report Transaction Details                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CDE002             Date 12Nov99              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 12Nov99              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PH &TTYP &DTSM &RSEQ &RLEV &RENT)
 
/*/COPY WNCPYSRC,DEC0030INT                                          */
 
             DCL        VAR(&PH)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DTSM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0030 - Report Transaction Details') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,DEC0030MPS                                          */
 
             IF         COND(&PH *EQ 'P' *AND &TTYP *EQ '    ') +
                          THEN(DO)
             OVRDBF     FILE(DETRANL2) TOFILE(DEPTRANL2) SHARE(*NO)
             OVRDBF     FILE(DEPOSNL0) TOFILE(DEPPOSNL0) SHARE(*NO)
             OVRDBF     FILE(DEEVNTL0) TOFILE(DEPEVNTL0) SHARE(*NO)
             OVRDBF     FILE(DECASHL0) TOFILE(DEPCASHL0) SHARE(*NO)
             CHGJOB SWS(XXXX0XXX)                                     /*CDE002*/
             ENDDO
 
             IF         COND(&PH *NE 'P' *AND &TTYP *EQ '    ') +
                          THEN(DO)                                    /*CDE002*/
             OVRDBF     FILE(DETRANL2) TOFILE(DEHTRANL2) SHARE(*NO)   /*CDE002*/
             OVRDBF     FILE(DEPOSNL0) TOFILE(DEHPOSNL0) SHARE(*NO)   /*CDE002*/
             OVRDBF     FILE(DEEVNTL0) TOFILE(DEHEVNTL0) SHARE(*NO)   /*CDE002*/
             OVRDBF     FILE(DECASHL0) TOFILE(DEHCASHL0) SHARE(*NO)   /*CDE002*/
             CHGJOB SWS(XXXX1XXX)                                     /*CDE002*/
             ENDDO                                                    /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&PH *EQ 'P' *AND &TTYP *NE '    ') +
                          THEN(DO)
             OVRDBF     FILE(DETRANL2) TOFILE(DEPTRANL3) MBR(&TTYP) +
                          SHARE(*NO)
             OVRDBF     FILE(DEPOSNL0) TOFILE(DEPPOSNL0) SHARE(*NO)
             OVRDBF     FILE(DEEVNTL0) TOFILE(DEPEVNTL0) SHARE(*NO)
             OVRDBF     FILE(DECASHL0) TOFILE(DEPCASHL0) SHARE(*NO)
             CHGJOB SWS(XXXX0XXX)                                     /*CDE002*/
             ENDDO
 
             IF         COND(&PH *NE 'P' *AND &TTYP *NE '    ') +
                          THEN(DO)                                    /*CDE002*/
             OVRDBF     FILE(DETRANL2) TOFILE(DEHTRANL3) MBR(&TTYP) +
                          SHARE(*NO)                                  /*CDE002*/
             OVRDBF     FILE(DEPOSNL0) TOFILE(DEHPOSNL0) SHARE(*NO)   /*CDE002*/
             OVRDBF     FILE(DEEVNTL0) TOFILE(DEHEVNTL0) SHARE(*NO)   /*CDE002*/
             OVRDBF     FILE(DECASHL0) TOFILE(DEHCASHL0) SHARE(*NO)   /*CDE002*/
             CHGJOB SWS(XXXX1XXX)                                     /*CDE002*/
             ENDDO                                                    /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&DTSM *EQ 'D') THEN(DO)
              CALL       PGM(DEREPTRND) PARM(&TTYP &RSEQ &RENT)
              IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
             IF         COND(&DTSM *NE 'D') THEN(DO)
              CALL       PGM(DEREPTRNS) PARM(&TTYP &RSEQ &RENT)
              IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DEC0030MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0030ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0030 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0030END                                          */
 
ENDPGM
