/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Set on mandatory switchable features')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3012 - Set On Mandatory Switchable Features              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014  *CREATE    Date 31Oct01              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK014 - New program created to switch on the mandatory     */
/*                LE switchable features.                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&GROUP)
 
/*/COPY WNCPYSRC,SCC3012INT                                          */
 
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SARSFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SARSDESC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SARNAM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             OVRMSGF    MSGF(CBUSRMSG) TOMSGF(GBCBUSRMSG)
 
/*/COPY WNCPYSRC,SCC3012MPS                                          */
 
/* If this is called when setting the LE module on */
 
             IF         COND(&GROUP *EQ 'LENDING MODULE') THEN(DO)
 
/* Seton CLE002 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE002')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE003 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE003')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE004 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE004')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE005 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE005')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE007 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE007')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE009 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE009')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
/* Seton CLE105 */
             CHGVAR     VAR(&SARNAM) VALUE('CLE105')
                CALL       PGM(AOSARSR0) PARM(&RTNCODE '*KEY' +
                             &SARNAM &SARSFMT)
                CHGVAR     VAR(&SARSDESC) VALUE(%SST(&SARSFMT 7 50))
                CALL       PGM(SC3011X) PARM(&RTNCODE 'I' &SARNAM +
                             &SARSDESC &WRTNCODE)
 
             ENDDO
 
/*/COPY WNCPYSRC,SCC3012MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC3012ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC3012 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             SCC3012 ended abnormally - see job log') +
                             TOPGMQ(*EXT)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC3012END                                          */
 
             ENDPGM
