/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC DBCS initialisation')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0108 - DBCS Initialisation                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSC014  *CREATE    Date 11Apr02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC014 - Allow double byte character set support            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC0108INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
             DCLF       FILE(SCDBCSPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Check whether DBCS is switched on                                 */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSC014' +
                          &FMT)
             IF         COND(&RTCD *NE '       ') THEN(GOTO +
                          CMDLBL(END))
 
/* Apply printer/diaplay file overrides as appropriate              */
DBCSLoop:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND(&HFOVRD *NE 'Y') THEN(DO)
                GOTO       CMDLBL(DBCSLOOP)
             ENDDO
 
             IF         COND(&HFTYPE *EQ DSPF) THEN(DO)
                OVRDSPF    FILE(&HFFILE) OVRSCOPE(*JOB) IGCDTA(*YES)
             ENDDO
 
             IF         COND(&HFTYPE *EQ PRTF) THEN(DO)
                OVRPRTF    FILE(&HFFILE) OVRSCOPE(*JOB) IGCDTA(*YES)
             ENDDO
 
             GOTO       CMDLBL(DBCSLOOP)
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC0108ERR                                          */
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC0108 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
/*  Call SCC0010 to Display 'DBCS Initialisation failed' message */
 
                RTVMSG     MSGID(SCM0184) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000)
                CALL       PGM(SCC0010) PARM('SCC0108' 'ENTER ' ' ')
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0108END                                          */
 
             ENDPGM
