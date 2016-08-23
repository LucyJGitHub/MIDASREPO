/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Alternate Account Check')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       UTCGL022 - Alternate Account Record Update                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 237346             Date 16FEB06              */
/*       PREV Amend No. 230815             Date 06Dec04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       237346 - TO USE UTILITY CREATED FOR 230815                  */
/*       230815 - Utility to check Alternate Account records for     */
/*                discrepancies with other files.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/**/
             DLTF       FILE(REIACD01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(REHISPD01)
             MONMSG     MSGID(CPF0000)
/**/
             SNDPGMMSG  MSG('UTCGL022 - Alternate Account Records +
                          Update') TOMSGQ(MRUNQ MOPERQ)
/**/
/**/
/** Get system prefix                                               **/
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
/**/
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                        *AND (&MODE *NE 'A') *AND (&MODE *NE +
                        'a')) THEN(DO)
                SNDPGMMSG  MSG('Invalid parameter passed - UTCGL022') +
                           TOMSGQ(MOPERQ MRUNQ) TOPGMQ(*EXT)
                GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             ELSE       CMD(DO)
/**/
/** Create back up for file REHISPD & REHISPS if UPDATE mode */
/**/
                IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                           THEN(DO)
                   CRTDUPOBJ  OBJ(REHISPD) FROMLIB(&DMLIB) +
                              OBJTYPE(*FILE) NEWOBJ(REHISPD01) +
                              DATA(*YES)
                   MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 +
                              CPF2116 CPF2122 CPF2151 CPF2162 +
                              CPF2176 CPF2182) EXEC(DO)
                      SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REHISPD by +
                                 PGM : UTCGL022') TOMSGQ(MRUNQ MOPERQ)
                      GOTO       CMDLBL(ABNORMAL)
                   ENDDO
                   CRTDUPOBJ  OBJ(REIACD) FROMLIB(&DMLIB) +
                              OBJTYPE(*FILE) NEWOBJ(REIACD01) +
                              DATA(*YES)
                   MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 +
                              CPF2116 CPF2122 CPF2151 CPF2162 +
                              CPF2176 CPF2182) EXEC(DO)
                      SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REIACD by +
                                 PGM : UTCGL022') TOMSGQ(MRUNQ MOPERQ)
                      GOTO       CMDLBL(ABNORMAL)
                   ENDDO
                ENDDO
/**/
                CHGJOB     SWS(XXXXXX00)
                CALL       PGM(UTGL0022) PARM(&MODE)
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/** Program completed normally */
/**/
                   IF         COND((&MODE *EQ 'U') *OR +
                              (&MODE *EQ 'u')) THEN(DO)
                      DLTF       FILE(REHISPD01)
                      DLTF       FILE(REIACD01)
                      MONMSG     MSGID(CPF0000)
                   ENDDO
                   SNDPGMMSG  MSG('Program UTCGL022 completed +
                              normally') TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ENDCLPGM)
                ENDDO
/**/
/** Copy back if error occurred and in UPDATE mode */
/**/
                IF         COND((&MODE *EQ 'U') *OR +
                           (&MODE *EQ 'u')) THEN(DO)
                   CPYF       FROMFILE(REHISPD01) TOFILE(REHISPD) +
                              MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                      SNDPGMMSG  MSG('Error in RESTART COPY with REHISPD01 +
                                 in UTCGL022') TOMSGQ(MRUNQ MOPERQ)
                   ENDDO
                   CPYF       FROMFILE(REIACD01) TOFILE(REIACD) +
                              MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
                   MONMSG     MSGID(CPF0000) EXEC(DO)
                      SNDPGMMSG  MSG('Error in RESTART COPY with REHISPS01 +
                                 in UTCGL022') TOMSGQ(MRUNQ MOPERQ)
                   ENDDO
                ENDDO
/**/
             ENDDO
/**/
ABNORMAL:
             RCLRSC     LVL(*)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program UTCGL022 ended abnormally') +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                        UTCGL022 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
