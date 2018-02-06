/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Retrieve name of the *LOCAL database')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondent Module                   */
/*                                                                   */
/*       CGC3600 - Retrieve a data base according to its remote      */
/*                 location                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD024871           Date 11Feb14              */
/*                      AR659584           Date 06Dec10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    Date 05Nov01              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD024871 - CM Custom-Defined Data Extract terminated        */
/*                  abnormally due to graphic field &DBXRDBT2        */
/*                  in file QADBXRDBD.                               */
/*       AR659584 - IASP enablement.                                 */
/*       CCG015 - Correspondence Manager                             */
/*                                                                   */
/*********************************************************************/
             PGM (&RMTL &DBNAME &RTNCOD)
 
/*/COPY WNCPYSRC,mmCnnnnINT                                          */
/* Remote location */
             DCL        VAR(&RMTL) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTNCOD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBNAME) TYPE(*CHAR) LEN(18)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                /*AR659584*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                 /*AR659584*/
 
/* File that stores the RDB entries */
/**********  DCLF       FILE(QADBXRDBD) ALWVARLEN(*YES) */                              /*MD024871*/
             DCLF       FILE(QADBXRDBD) ALWVARLEN(*YES) +
                          ALWGRAPHIC(*YES)                                              /*MD024871*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
/**/                                                                                    /*AR659584*/
/* Get the global IASP system values */                                                 /*AR659584*/
/**/                                                                                    /*AR659584*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                           'IASPinstallation' &SVAL1 +
                           'IASPdatabase' &SVAL2 &SVALK3 +
                           &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                           &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                           &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                      /*AR659584*/
/**/                                                                                    /*AR659584*/
/* Check whether system is in IASP environment. */                                      /*AR659584*/
/**/                                                                                    /*AR659584*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                           /*AR659584*/
/**/                                                                                    /*AR659584*/
/* If IASP environment, */                                                              /*AR659584*/
/**/                                                                                    /*AR659584*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                 /*AR659584*/
/**/                                                                                    /*AR659584*/
/* Get name of IASP. */                                                                 /*AR659584*/
/**/                                                                                    /*AR659584*/
               CHGVAR     VAR(&DBNAME) VALUE(%SST(&SVAL2 1 18))                         /*AR659584*/
               GOTO       CMDLBL(END)                                                   /*AR659584*/
/**/                                                                                    /*AR659584*/
             ENDDO                                                                      /*AR659584*/
/**/                                                                                    /*AR659584*/
 
/*/COPY WNCPYSRC,mmCnnnnMPS                                          */
 
RTVRDBDIR:
             RCVF       DEV(*FILE)
             MONMSG     MSGID(CPF0864) EXEC(DO)
               CHGVAR     VAR(&RTNCOD) VALUE('*NOTFOUND')
               GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SST(&DBTXRLC 3 254) *EQ &RMTL) THEN(DO)
               CHGVAR     VAR(&DBNAME) VALUE(&DBXRDBN)
               GOTO       CMDLBL(END)
             ENDDO
             GOTO       CMDLBL(RTVRDBDIR)
 
 
/*/COPY WNCPYSRC,mmCnnnnMPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,mmCnnnnERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&RTNCOD) VALUE('*ERROR')
             DMPCLPGM
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC3600 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,mmCnnnnEND                                          */
 
/* (Add any specific end processing here) */
 
             ENDPGM
