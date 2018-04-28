/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Update period end dates')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0010 - Update Period End Dates                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002             Date 12Nov99              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CDE001  *CREATE    Date 12Nov99              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0010INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDE002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CDE002*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CDE002*/
             DCL        VAR(&CDE002) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE002*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
 
             CHGJOB SWS(00000000)
 
/* Determine if CCRM Revenue Analysis installed */                    /*CDE002*/
                                                                      /*CDE002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDE002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE002*/
             CHGVAR     VAR(&SARD) VALUE('CDE002')                    /*CDE002*/
                                                                      /*CDE002*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)             /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE002) VALUE('Y'))                    /*CDE002*/
                                                                      /*CDE002*/
/*/COPY WNCPYSRC,DEC0010MPS                                          */
 
             OVRDBF     FILE(DEPERDPD) TOFILE(DEPPERDPD)
             CALL       PGM(DEUPDPERD) PARM('P')
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0010 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
                                                                      /*CDE002*/
/* CDE002 installed */                                                /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&CDE002 *EQ 'Y') THEN(DO)                /*CDE002*/
              OVRDBF     FILE(DEPERDPD) TOFILE(DEHPERDPD)             /*CDE002*/
              CALL       PGM(DEUPDPERD) PARM('H')                     /*CDE002*/
              IF COND(%SWITCH(XXXXXX11)) THEN(DO)                     /*CDE002*/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0010 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)                      /*CDE002*/
               GOTO       CMDLBL(END)                                 /*CDE002*/
              ENDDO                                                   /*CDE002*/
             ENDDO                                                    /*CDE002*/
 
/*/COPY WNCPYSRC,DEC0010MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0010ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0010 ended abnormally - see job log') +
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
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0010END                                          */
 
             DLTOVR     FILE(*ALL)
 
             ENDPGM
