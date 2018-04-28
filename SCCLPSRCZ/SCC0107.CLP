/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas default routing entry program')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0107 - Midas Default Routing Entry Program.              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 111958             Date 06Dec96              */
/*       Prev Amend No. 099150  *CREATE    Date 26JAN96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       111958 - Create data area in the system                     */
/*       099150 - New program introduced to standardise entry        */
/*                to the Midas system.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)
 
/*/COPY WNCPYSRC,SCC0107INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ALLPARM) TYPE(*CHAR) LEN(1000)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/* Create LDA */                                                      /*111958*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD AS400 LOCAL DATA AREA +
                          EQUIVALENT')
             MONMSG     MSGID(CPF0000)                                /*111958*/
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             CHGVAR     VAR(&PROGRAM) VALUE(%SST(&PARM1 1 10))
 
/*/COPY WNCPYSRC,SCC0107MPS                                          */
 
/* Run pre-formatted command string passed in as a parameter */
 
             IF         COND(%SST(&PARM1 1 4) *EQ 'CALL') THEN(DO)
               CHGVAR     VAR(&ALLPARM) VALUE(&PARM1 *CAT &PARM2 *CAT +
                            &PARM3 *CAT &PARM4 *CAT &PARM5)
               CALL       PGM(QCMDEXEC) PARM(&ALLPARM 1000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* General default - run program passed in as a parameter */
 
             CALL       PGM(&PROGRAM)
 
/*/COPY WNCPYSRC,SCC0107MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
 
/*/COPY WNCPYSRC,SCC0107ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0107 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0107END                                          */
 
             ENDPGM
