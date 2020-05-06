/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC DBCS initialisation')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0108 - DBCS Initialisation                               */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. AR934370           Date 10Mar20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014  *CREATE    Date 11Apr02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR934370 - Some reports have European-formatted amounts     */
/*                  while others are American-formatted. Override    */
/*                  decimal format according to new system value     */
/*                  DecimalSeparator. Value 'D' if to use dot as     */
/*                  decimal or 'C' if comma. (Child: AR934371)       */
/*                - Applied for MD-55379.                            */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC014 - Allow double byte character set support            */
/*                                                                   */
/*********************************************************************/
             PGM

/*/COPY WNCPYSRC,SCC0108INT                                          */

             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
                                                                                        /*AR934370*/
/* Define parameters used in AOSVALR0 to retrieve system value */                       /*AR934370*/
/* General error return code */                                                         /*AR934370*/
             DCL        VAR(&RSVALRTNC) TYPE(*CHAR) LEN(7)                              /*AR934370*/
/* System value variables */                                                            /*AR934370*/
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                /*AR934370*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                /*AR934370*/
             DCL        VAR(&SVALK10) TYPE(*CHAR) LEN(20)                               /*AR934370*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                               /*AR934370*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')

             DCLF       FILE(SCDBCSPD)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             RTVJOBA    TYPE(&JOBTYPE)
                                                                                        /*AR934370*/
/* Call AOSVALR0 to get system value for 'DecimalSeparator' */                          /*AR934370*/
                                                                                        /*AR934370*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC  +
                          'DecimalSeparator' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                             /*AR934370*/
                                                                                        /*AR934370*/
/* If there is an error finding any system value then end abnormally */                 /*AR934370*/
                                                                                        /*AR934370*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*AR934370*/
             IF         COND(&SVAL1 *EQ 'D') THEN(DO)                                   /*AR934370*/
                CHGJOB  DECFMT(*BLANK)                                                  /*AR934370*/
             ENDDO                                                                      /*AR934370*/
             ELSE       CMD(DO)                                                         /*AR934370*/
                CHGJOB  DECFMT(*SYSVAL)                                                 /*AR934370*/
             ENDDO                                                                      /*AR934370*/

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
                          Finastra International Limited')

/*/COPY WNCPYSRC,SCC0108END                                          */

             ENDPGM
