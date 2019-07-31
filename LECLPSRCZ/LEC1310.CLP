/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Released transactions control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC1310 - Midas LE Released transactions Control            */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097217          Date 25Mar13              */
/*                      CCB023B            Date 06Aug12              */
/*                      CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE030  *CREATE    Date 20Sep02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097217 - DBICDM in use                                   */
/*       CCB023B - COB Restructure - Input Cycle Termination         */
/*                 Restructuring                                     */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       CLE030 - Customer Lending Enh. - Release Authorisation      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&AUDIT &RSEQ &RLEV &RENT)
 
             DCL        VAR(&AUDIT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ERCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                /*CCB023B*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)                                   /*CCB023B*/
             DCL        VAR(&ZONEID) TYPE(*CHAR) LEN(2)                                  /*CCB023B*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Create a copy of LERELEPD for the Secondary COB                 */                     /*CCB023*/
                                                                                          /*CCB023*/
/**********  RSTOBJ     OBJ(LERELEPD) SAVLIB(PZDMLIB) DEV(*SAVF) +
                          SAVF(DBIC) RSTLIB(QTEMP)                   */           /*CCB023 CCB023B*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                   /*CCB023B*/
             CHGVAR     VAR(&ZONEID) VALUE(%SUBSTRING(&SDSTAT 6 2))                      /*CCB023B*/
             CHGVAR     VAR(&DMLIB) VALUE(&ZONEID *CAT 'DMLIB ')                         /*CCB023B*/
                                                                                         /*CCB023B*/
             RSTOBJ     OBJ(LERELEPD) SAVLIB(&DMLIB) DEV(*SAVF) +
                          SAVF(DBICDM) RSTLIB(QTEMP)                                     /*CCB023B*/
/**********  MONMSG     MSGID(CPF0000)                               */         /*CCB023 AR1097217*/
             MONMSG     MSGID(CPF3812) EXEC(DO)                                        /*AR1097217*/
WAIT:          ALCOBJ     OBJ((DBICDM *FILE *EXCL)) WAIT(3)                            /*AR1097217*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO WAIT)                               /*AR1097217*/
               RSTOBJ     OBJ(LERELEPD) SAVLIB(&DMLIB) DEV(*SAVF) +
                            SAVF(DBICDM) RSTLIB(QTEMP)                                 /*AR1097217*/
               DLCOBJ     OBJ((DBICDM *FILE *EXCL))                                    /*AR1097217*/
             ENDDO                                                                     /*AR1097217*/
             STRJRNPF   FILE(QTEMP/LERELEPD) JRN(ICJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                                  /*CCB023*/
             MONMSG     MSGID(CPF0000)                                                    /*CCB023*/
             OVRDBF     FILE(LERELEPD) TOFILE(QTEMP/LERELEPD)                             /*CCB023*/
 
             CALL       PGM(LE1310) PARM(&AUDIT &RSEQ)
 
/* Error processing */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('FILE CONTROLS OUT OF +
                             BALANCE ')
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             LEC1310 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
