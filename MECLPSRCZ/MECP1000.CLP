/*********************************************************************/
/*STD    CLPBASE                                                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECP1000 - Control call to selection processing             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD31937            Date 13Jan15              */
/*       Last Amend No. AR856737           Date 13Sep11              */
/*       Last Amend No. EEE065             Date 07Sep04              */
/*       Prev Amend No. ESL038             Date 01Oct2004            */
/*                      EEE058             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD31937  - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       EEE065 - FT Payment Routing                                 */
/*       ESL038 - Incoming STP                                       */
/*       EEE058 - Incoming STP                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &BRANCH &FT_PROC)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRANCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FT_PROC) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCLF       FILE(SDFTFRPD)                               /*140636*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1000 - ME Selection processing') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* If allocation of MEINMRPD allowed then clear */
/* */
             ALCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(MISS_CLEAR)
             ENDDO
             CLRPFM     FILE(MEINMRPD)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
 MISS_CLEAR:
             ALCOBJ     OBJ((MEINMRPD *FILE *SHRUPD)) WAIT(600)
/* */
/* Set up overrides            */
/* */
             OVRDBF     FILE(MEINCRN1) TOFILE(MEINCRJ1Q)
             OVRDBF     FILE(MEINFTK2) TOFILE(MEINFTJ2Q)
             OVRDBF     FILE(MEINFTN3) TOFILE(MEINFTJ3Q)
             OVRDBF     FILE(MEINFTN2) TOFILE(MEINFTL2Q)
             OVRDBF     FILE(MEINMPN2) TOFILE(MEINMPJ2Q)
             OVRDSPF    FILE(MEP1240D) TOFILE(MEP1240DF)
             OVRDSPF    FILE(MEP1060D) TOFILE(MEP1060DF)
             OVRDSPF    FILE(MEP1010D) TOFILE(MEP1010DF)
             OVRDSPF    FILE(MEP1020D) TOFILE(MEP1020DF)
             OVRDSPF    FILE(MEP1000D) TOFILE(MEP1000DF)                                  /*EEE065*/
             OVRDBF     FILE(FTMESQV0) SHARE(*NO)
/* */
/* Run ME1000 - Imm Selection  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
             CALL       PGM(MEP1000) PARM(&RTN_CODE &ACTION &BRANCH +
                          &FT_PROC)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* Automatic call of Pay/Receive Indicator - */                      /*140636*/
/**/                                                                 /*140636*/
             RCVF       RCDFMT(SDFTFRD0)                             /*140636*/
             IF         COND((&BTAFTM = 'Y')) THEN(DO)               /*140636*/
/**/                                                                 /*140636*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                 /*140636*/
/**/                                                                 /*140636*/
/************SBMJOB     JOB(FTC0630) JOBD(MBATCH) RTGDTA(*JOBD) +                         /*CPK014*/
/************             RQSDTA('CALL PGM(FTC0630) PARM('''' '''' +                      /*CPK014*/
/************             '''' )') INLLIBL(*JOBD)                    /*140636*/           /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +                           /*CPK014*/
/************             JOBD(MBATCH) RTGDTA(*JOBD) INLLIBL(*JOBD)  /*140636*/           /*CPK014*/
             SBMJOB     JOB(FTC0630) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(FTC0630) +
                          PARM('''' '''' '''' )') INLLIBL(*JOBD)                          /*CPK014*/
             SBMJOB     CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) +
                          JOBD(MBATCH) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
             ENDDO                                                   /*140636*/
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
             SNDPGMMSG  MSG('Program MECP1000 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECP1000 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* */
/* CALL ME1070 to remove any remaining reserved electronic msgs*/
/* */
 ENDCLPGM:   ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CALL       PGM(ME1070) PARM('*END    ' X'000000000F' +
                          X'000F' ' ' ' ' ' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             COMMIT
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *SHRUPD))
             MONMSG     MSGID(CPF0000)
/* */
             ENDPGM
