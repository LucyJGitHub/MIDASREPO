/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Clear export files')                         */
/*OVR  : OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                        :*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC9999 - Clear Export Files                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CDE002             Date 12Nov99              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 12Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       208221 - If Revenue Analysis is on, only clear file         */
/*                DEELOGPD in the first run of the Close of Business */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *208221*/
             PGM        PARM(&MOD)                                    /*208221*/
 
/*/COPY WNCPYSRC,DEC9999INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CDE002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CDE002*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CDE002*/
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(1)                  /*208221*/
             DCL        VAR(&CDE002) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE002*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QTEMP/FDMBR)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC9999 - Clear Export Files') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
                                                                      /*CDE002*/
/* Determine if CCRM Revenue Analysis installed */                    /*CDE002*/
                                                                      /*CDE002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDE002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE002*/
             CHGVAR     VAR(&SARD) VALUE('CDE002')                    /*CDE002*/
                                                                      /*CDE002*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)             /*CDE002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE002) VALUE('Y'))                    /*CDE002*/
 
/*/COPY WNCPYSRC,DEC9999MPS                                          */
 
             DSPFD      FILE(DEPTRANPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
 
             CLRPFM     FILE(DEPTRANPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPPOSNPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPEVNTPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPCASHPD) MBR(&MLNAME)
 
/* CDE002 installed */                                                /*CDE002*/
                                                                      /*CDE002*/
             IF         COND(&CDE002 *EQ 'Y') THEN(DO)                /*CDE002*/
             CLRPFM     FILE(DEHTRANPD) MBR(&MLNAME)                  /*CDE002*/
             CLRPFM     FILE(DEHPOSNPD) MBR(&MLNAME)                  /*CDE002*/
             CLRPFM     FILE(DEHEVNTPD) MBR(&MLNAME)                  /*CDE002*/
             CLRPFM     FILE(DEHCASHPD) MBR(&MLNAME)                  /*CDE002*/
             ENDDO                                                    /*CDE002*/
                                                                      /*CDE002*/
             GOTO       CMDLBL(LOOP)
 
FINISH:
 
             CLRPFM     FILE(DETRIGPD)
 
             IF         COND((&CDE002 *EQ 'Y') *AND (&MOD *EQ '2') +
                          *OR (&CDE002 *NE 'Y')) THEN(DO)             /*208221*/
             CLRPFM     FILE(DEELOGPD)
             ENDDO                                                    /*208221*/
 
/*/COPY WNCPYSRC,DEC9999MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC9999ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC9999 ended abnormally - see job log') +
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
 
/*/COPY WNCPYSRC,DEC9999END                                          */
 
             ENDPGM
