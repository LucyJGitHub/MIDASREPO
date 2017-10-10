/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS SE Daily Exchange Rate Update')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8403 - Daily Exchange Rates update                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2017           */
/*                                                                   */
/*       Last Amend No. CSE108 *CREATE     Date 06Oct17              */
/*       Prev Amend No. nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE108 - Yearly Profitability Report and Enquiry            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
 
             CHGJOB SWS(00000000)
 
             OVRDBF   FILE(SEDEXRPX) TOFILE(SEDEXRPD) SHARE(*NO)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Call SE8403 Daily Exchange Rates Update */
             CALL       PGM(SE8403)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
 
/* For database errors, recover date from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
ENDPGM:      DLTOVR     *ALL
             ENDPGM
