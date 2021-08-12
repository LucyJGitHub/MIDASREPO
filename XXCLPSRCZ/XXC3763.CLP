/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Scalare')                                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       RECM3763*-*Scalare                                          */
/*       XXC3763  - Scalare                                          */
/*                                                                   */
/*       (C) Finastra International Systems Ltd. 2021                */
/*                                                                   */
/*       Last Amend No. LUC141  *Create    Date 23Feb21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC141 - Scalare (MMI036)                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Finastra International Systems Ltd. 2021')
             DCL        VAR(&MPROG) TYPE(*CHAR) LEN(10) +
                          VALUE(XX3764DCXX)
             DCL        VAR(&WPROG) TYPE(*CHAR) LEN(8) +
                          VALUE(XX3764DC)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) +
                          VALUE(XXREPTMSGF)
             DCL        VAR(&WCUNT) TYPE(*CHAR) LEN(2) VALUE(GB)
/**/
             DCLF       FILE(SDLANGPD)
/**/
/*           SNDPGMMSG  MSG('RECM3763 - Summary retail interest +
                          statements') TOMSGQ(MRUNQ)         */   /*LUC141*/
             SNDPGMMSG  MSG('XXC3763 - Summary retail interest statements') +
                          TOMSGQ(MRUNQ) /*LUC141*/
/**/
       /*    CALL       PGM(REM010)        */      /*LUC141*/
             CALL       PGM(XX0010)                /*LUC141*/
/**/
             OVRDBF     FILE(ACCRACJ) TOFILE(EACCRACJ)
             OVRDBF     FILE(ACCNT) TOFILE(EACCNT)
/**/
             CHGVAR     VAR(&SCUNT) VALUE('  ')
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(%SST(&MPROG 9 2)) VALUE(&SCUNT)
             IF         COND(&MPROG *EQ 'XX3764DCGB') THEN(DO)
             CHKOBJ     OBJ(&WPROG) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(POS1))
             OVRPRTF    FILE(XX3764DC) TOFILE(&WPROG)
             ENDDO
             ELSE       CMD(DO)
             CHKOBJ     OBJ(&MPROG) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(POS1))
             OVRPRTF    FILE(XX3764DC) TOFILE(&MPROG)
             ENDDO
             CHGVAR     VAR(&WCUNT) VALUE(&SCUNT)
/**/
 POS1:       CHGVAR     VAR(%SST(&MSGF 1 2)) VALUE(&SCUNT)
             CHKOBJ     OBJ(&MSGF) OBJTYPE(*MSGF)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(POS2))
             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)
/**/
 POS2:       CALL       PGM(XX3763) PARM(&WCUNT)
             GOTO       CMDLBL(LOOP)
/**/
  END:       DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
/**/
             ENDPGM
/**/
