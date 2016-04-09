/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Journal Files for Generic Updates')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0120 - Journal Files for Generic Updates                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CDE002  *CREATE    Date 05Apr00              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE002 - Data Export - CCRM Revenue Analysis.               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0120INT                                          */
 
             DCL        VAR(&SDSTAT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&PRE)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Determine if COB journalling is On */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CCB009')
 
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CCB009) VALUE('Y'))
 
/* Start journal only if CCB009 is off                               */
 
             IF         COND(&CCB009 *EQ 'N') THEN(DO)
 
             SNDPGMMSG  MSG('DEC0120 - Journal Files for Generic +
                          Updates') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PRE *TCAT 'JLIB')
/**/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0120MPS                                          */
 
/* Ensure that no pending changes exist                              */
 
             RMVJRNCHG  JRN(JDEC0120) FILE((DEPTRANPD) (DEGTRANPD) +
                         (DEGPOSNPD) (DEGEVNTPD) (DEGVALUPD))
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801)
 
/* End journal all files if previous error occurred                  */
 
             ENDJRNPF   FILE(*ALL) JRN(JDEC0120)
             MONMSG MSGID(CPF0000)
 
/* Delete and recreate journal and receivers                         */
 
             DLTJRN     JRN(JDEC0120)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JRDEC0120)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
             CRTJRNRCV  JRNRCV(&JLIB/JRDEC0120)
             CRTJRN     JRN(&JLIB/JDEC0120) JRNRCV(&JLIB/JRDEC0120)
             STRJRNPF   FILE(DEPTRANPD DEGTRANPD DEGPOSNPD DEGEVNTPD +
                          DEGVALUPD) JRN(JDEC0120) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)
 
/*/COPY WNCPYSRC,DEC0120MPE                                          */
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0120ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0120 ended abnormally - see job log') +
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
 
/*/COPY WNCPYSRC,DEC0120END                                          */
 
             ENDPGM
