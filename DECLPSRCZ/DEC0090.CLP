/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Send Revenue extract data message')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0090 - Send Revenue extract data available message       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002  *CREATE    Date 06Apr00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0090INT                                          */
 
             DCL        VAR(&DS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&SDTR) TYPE(*CHAR) LEN(2) VALUE('RV')
             DCL        VAR(&MQMQ) TYPE(*CHAR) LEN(48)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0090MPS                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)
 
/* If called interactively from I/C menu, call prompt program for    */
/* departmental server Id and apply this to extract data area.       */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
               CALL       PGM(DEBLKPRMT) PARM(&DS &SDTR)
 
/*    Error processing                                               */
 
               IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
               ENDDO
 
               IF         COND(&DS *NE '  ') THEN(DO)
 
                CHGDTAARA  DTAARA(DEEXTCTL (21 2)) VALUE(&DS)
                CHGVAR     VAR(&MQMQ) VALUE('CW_CHANNEL.' *TCAT +
                           &LIBR *TCAT '1.' *TCAT &DS)
 
                CALL       PGM(DEPUTMSGC) PARM(&RTCD &ERMS &SDTR &MQMQ)
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
               ENDDO
 
             ENDDO
 
/* If called in batch as part of COB, retrieve departmental server   */
/* from dataarea.                                                    */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
 
               RTVDTAARA  DTAARA(DEEXTCTL (21 2)) RTNVAR(&DS)
 
               IF         COND(&DS *NE '  ') THEN(DO)
 
                CHGVAR     VAR(&MQMQ) VALUE('CW_CHANNEL.' *TCAT +
                           &LIBR *TCAT '1.' *TCAT &DS)
 
                CALL       PGM(DEPUTMSGC) PARM(&RTCD &ERMS &SDTR &MQMQ)
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0090 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
               ENDDO
 
             ENDDO
 
/*/COPY WNCPYSRC,DEC0090MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0090ERR                                          */
 
/* Abnormal termination */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0090 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0090END                                          */
 
ENDPGM
