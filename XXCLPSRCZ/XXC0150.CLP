/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX SE Cost of Funds Maintenance')               */
/*********************************************************************/
/*                                                                   */
/*       Midas   Securities Trading Module                           */
/*                                                                   */
/*       XXC0150 - XX Cost of Funds Maintenance                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*         Last Amend No. DUG504            Date 06Sep17             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG504 - Cost of Funds                                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
/**/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
/**/
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
/**/
             CHGJOB SWS(00000000)
/**/
             IF COND(&PARM = 'S') THEN(DO)
                DLTOVR     *ALL
                OVRDBF     FILE(FUND1) TOFILE(FUNDS) SHARE(*NO)
                OVRDBF     FILE(FUNDS) TOFILE(FUNDS) SHARE(*NO)
             ENDDO
/**/
             IF COND(&PARM = 'T') THEN(DO)
                DLTOVR     *ALL
             OVRDBF     FILE(FUND1) TOFILE(XXFUNTV0) SHARE(*NO)
             OVRDBF     FILE(FUNDS) TOFILE(XXFUNTV0) SHARE(*NO)
             ENDDO
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CALL       PGM(XX0150) PARM(&PARM)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA                      */
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
ENDPGM:      DLTOVR     *ALL
             ENDPGM
