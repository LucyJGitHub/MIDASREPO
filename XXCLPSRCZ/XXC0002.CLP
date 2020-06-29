/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas XX SE Month End Exchange Rates Input')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       XXC0002 - XX SE Month End Exchange Rate Input               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. DUG504              Date 07Sep17             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG504 - Cost of Funds                                      */
/*                                                                   */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
/**/
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF   FILE(XXMEXRPX) TOFILE(XXMEXRPD) SHARE(*NO)
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CALL       PGM(XX0002)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
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
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
ENDPGM:      DLTOVR     *ALL
             ENDPGM
