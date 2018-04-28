/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Restore save files in Input Cycle')                   */
/*********************************************************************/
/*                                                                   */
/*        Midas - Standing Data Module                               */
/*                                                                   */
/*       SCC5140  - RESTORE SAVE FILES IN INPUT CYCLE                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. 249135             Date 13Jul07              */
/*       Prev Amend No. CSC032  *Created   Date 03Apr07              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     249135 - Program Crashing during COB                          */
/*     CSC032 - Exit programs for Midas save and restore.            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*   Initial Processing                                             */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')
 
/*  Define, retrieve and update temporary dataarea to indicate restore is complete */
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RSTCMPL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                     /*249135*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                                    /*249135*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                   /*249135*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYS)
 
             CHGVAR     VAR(&DLIB) VALUE(&SYS *CAT 'DPLIB')
 
             RTVJOBA    TYPE(&JOBTYPE)
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNBR)                                /*249135*/
             CHGDTAARA  DTAARA(&DLIB/SCC5140DA (2 26)) VALUE(&JOB +
                          *CAT &USER *CAT &JOBNBR)                                        /*249135*/
             CHGJOB     SWS(XXXXXX00)
 
/* ********** INSERT TATRA PROCESSING HERE ***************************** */
 
             CHGVAR     VAR(&RSTCMPL) VALUE('Y')
 
             CHGDTAARA  DTAARA(&DLIB/SCC5140DA (1 1)) VALUE(&RSTCMPL)
 
             GOTO       CMDLBL(END)                                                       /*249135*/
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SCC5140 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDDO
END:                                                                                      /*249135*/
             ENDPGM
