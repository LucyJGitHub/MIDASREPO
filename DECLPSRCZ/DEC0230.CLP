/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Historic Trns Comparison + Selection Ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0230 - Historic Evnts Comparison and Selection Control   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       208221 - Changes identified during alpha site               */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNAME)
 
/*/COPY WNCPYSRC,DEC0230INT                                          */
 
             DCL        VAR(&MNAME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FHDC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0230 - Historic Evnts Comparison & +
                          Selection Control') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0230MPS                                          */
 
             RTVDTAARA  DTAARA(DEEXTCTL (46 1)) RTNVAR(&FHDC)
 
             CLRPFM     FILE(DENEVNTPD) MBR(&MNAME)
 
             OVRDBF     FILE(DENEVNTPD) MBR(&MNAME) SHARE(*NO)
             OVRDBF     FILE(DEOEVNTL1) MBR(&MNAME) SHARE(*NO)                           /*208221*/
 
             OVRDBF     FILE(DEHEVNTPD) MBR(&MNAME) SHARE(*NO)
                                                                                         /*208221*/
             IF         COND(&MNAME = 'FEES') THEN(DO)                                   /*208221*/
             OVRDBF     FILE(DEOEVNTL2) MBR(&MNAME) SHARE(*NO)                           /*208221*/
             OVRDBF     FILE(DENEVNTL1) MBR(&MNAME) SHARE(*NO)                           /*208221*/
             OVRDBF     FILE(DENPOSNL1) MBR(&MNAME) SHARE(*NO)                           /*208221*/
             OVRDBF     FILE(DEHTRANL1) MBR(&MNAME) SHARE(*NO)                           /*208221*/
             OVRDBF     FILE(DEHEVNTXX) TOFILE(DEHEVNTPD) +
                          MBR(&MNAME) SHARE(*NO)                                         /*208221*/
             ENDDO                                                                       /*208221*/
 
             CALL       PGM(DE0230) PARM(&RTCD &ERMS &MNAME)
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
              IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0230 ended abnormally - see job log') +
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
 
/*/COPY WNCPYSRC,DEC0230MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0230ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0230 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
               GOTO       CMDLBL(END)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0230END                                          */
 
 
             ENDPGM
