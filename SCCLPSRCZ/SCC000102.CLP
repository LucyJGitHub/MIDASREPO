/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Check/start subsystem')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC000102 - Check /Start subsystems                         */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAAA02  *CREATE    Date 06Sep03              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAAA02 - Webfacing Enhancement                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
/*/COPY SDCPYSRC,SDSVALDCL                                           */
             DCL        VAR(&MID24X7) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SUPPXLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SBSSTR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/* Start up Midas related subsystems if required */
 
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'SysStrMainSysSignon' &SVAL1 +
                          'SysStrSuppSysSignon' &SVAL2 +
                          'SysStrRepSysSignon' &SVAL3 +
                          'SysStrWaitTime' &SVAL4 +
                          'SysStrTISysSignon' &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 +
                          &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)
 
/* If there was an error on System Value retrieval end abnormally */
 
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Check 24x7 status */
 
             RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&MID24X7)
 
/* Main Midas subsystem startup */
 
             IF         COND((%SST(&SVAL1 1 10) *NE '          ') +
                          *AND (&MID24X7 *EQ ' ')) THEN(DO)
                STRSBS     SBSD(%SST(&SVAL1 1 10))
                MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(SUPPORT))
                CHGVAR     VAR(&SBSSTR) VALUE('Y')
             ENDDO
 
 SUPPORT:
/* Support Midas subsystem startup */
 
             IF         COND(%SST(&SVAL2 1 10) *NE '          ') +
                          THEN(DO)
                CHGVAR     VAR(&SUPPXLIB) VALUE(%SST(&SVAL2 2 2) *CAT +
                             'XLIB')
                STRSBS     SBSD(&SUPPXLIB/%SST(&SVAL2 1 10))
                MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(REPLIC))
                CHGVAR     VAR(&SBSSTR) VALUE('Y')
             ENDDO
 
 REPLIC:
/* Replication subsystem startup */
 
             IF         COND((%SST(&SVAL3 1 10) *NE '          ') +
                          *AND (&MID24X7 *EQ ' ')) THEN(DO)
                STRSBS     SBSD(%SST(&SVAL3 1 10))
                MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(TICSCS))
                CHGVAR     VAR(&SBSSTR) VALUE('Y')
             ENDDO
 
 TICSCS:
/* Trade Innovation Client-Server Control subsystem startup */
 
             IF         COND((%SST(&SVAL5 1 10) *NE '          ') +
                          *AND (&MID24X7 *EQ ' ')) THEN(DO)
                STRSBS     SBSD(%SST(&SVAL5 1 10))
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC000102 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
