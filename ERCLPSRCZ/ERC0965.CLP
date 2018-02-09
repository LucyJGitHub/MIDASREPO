/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS ER Guarantee Update For MM Rollovers')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting                                  */
/*                                                                   */
/*       ERC0965 - ER Guarantee Update for MM rollovers              */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX004             Date 26Feb97              */
/*                      XXXXXX             Date ddMmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX004 - Capital Adequacy                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
 
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&BEGIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('ERC0965 - Guarantee update  +
                          for MM Rollovers') TOMSGQ(MRUNQ)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&BEGIN)
 
             CHGVAR     VAR(&DMLIB) VALUE(&BEGIN *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&BEGIN *CAT 'DPLIB')
 
/* CHECK FOR COMPONENT RESTART */
             CHGVAR     VAR(&STAT) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &STAT)
 
/* IF FIRST RUN */
 
             IF         COND(&STAT = 'N') THEN(DO)
             CPYF       FROMFILE(&DMLIB/ERGUARPD) +
                          TOFILE(&DPLIB/XERGUARPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XERGUARPD))
             ENDDO
 
             ELSE  DO
 
             CPYF       FROMFILE(&DPLIB/XERGUARPD) +
                          TOFILE(&DMLIB/ERGUARPD) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DMLIB/ERGUARPD))
             ENDDO
 
                   CHGVAR     VAR(&STAT) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &STAT)
 
             CALL       PGM(ER0965)
 
/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* IF JOB ENDED NORMALLY */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                   CHGVAR     VAR(&STAT) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(XERGUARPD)                               /*S01486*/
             MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          ERC0965 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&MKICPY) VALUE('(c) Finastra International +
                          Limited 2005')
             ENDPGM
