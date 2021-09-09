/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTCP950  - FX Preferential rate update and Currency Update  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. PNL011             Date 12Aug2005            */
/*       Last Amend No. ESL038             Date 04Oct2004            */
/*       Prev Amend No. EEE058             Date 06Feb2003            */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       PNL011 - Changes to dealing rates upload                    */
/*       ESL038 - ING STP Development                                */
/*       EEE058 - FX Preferential rates                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INPEOD &RTN_CODE)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&INPEOD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEY_INFO) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,FTCP950INT                                          */
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
/*-----------------------------------------------------------------------*/
/* Lock Data Area.                                                       */

             RCLRSC
             DLCOBJ     OBJ((SDCYU *DTAARA *EXCL))
             CHGVAR     VAR(&RTN_CODE) VALUE('CPF0000')
             ALCOBJ     OBJ((SDCYU *DTAARA *EXCL)) WAIT(10)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(REPTERR))
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/*/COPY WNCPYSRC,FTCP950MPS                                          */
/*-----------------------------------------------------------------------*/
/* Perform Automatic Currency Update.                                    */

             CALL       PGM(SDP046) PARM(&RTN_CODE &INPEOD)
/*/COPY WNCPYSRC,FTCP950001                                          */

/*=======================================================================*/
/* Display Message & Exit Program.                                       */

             /* Report error */
 REPTERR:    IF         COND(&RTN_CODE *NE ' ') THEN(DO)
             SNDPGMMSG  MSGID(&RTN_CODE) MSGF(XXUSRMSG) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             ENDDO

/*-----------------------------------------------------------------------*/
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/*-----------------------------------------------------------------------*/
/* */
/* Run FTP950 - FX Rate Spread update */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(FTP950) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Run FTP955 - Commission rate update */
/* */
             CALL       PGM(FTP955) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FTCP950 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTCP950 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
/* */
             DLCOBJ     OBJ((SDCYU *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
