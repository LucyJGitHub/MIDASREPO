/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Historic Posn Comparison + Selection Ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0220 - Historic Posn Comparison and Selection Control    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002  *CREATE    Date 16May00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNAME)
 
/*/COPY WNCPYSRC,DEC0220INT                                          */
 
             DCL        VAR(&MNAME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0220 - Historic Posn Comparison & +
                          Selection Control') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0220MPS                                          */
 
             CLRPFM     FILE(DENPOSNPD) MBR(&MNAME)
 
             OVRDBF     FILE(DEHPOSNPD) MBR(&MNAME) SHARE(*NO)
             OVRDBF     FILE(DEOPOSNL1) MBR(&MNAME) SHARE(*NO)
             OVRDBF     FILE(DENPOSNPD) MBR(&MNAME) SHARE(*NO)
 
             CALL       PGM(DE0220) PARM(&RTCD &ERMS &MNAME)
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
              IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0220 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
              ENDDO
 
              IF         COND(&JOBTYPE = '1') THEN(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DEC0220MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0220ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0220 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0220END                                          */
 
 
             ENDPGM
