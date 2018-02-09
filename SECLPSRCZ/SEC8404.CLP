/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS SE Daily Exchange Rates Input')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC8404 - Daily Exchange Rates Input                        */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSE108 *CREATE     Date 06Oct17              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE108 - Yearly Profitability Report and Enquiry            */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL       VAR(&LDA)   TYPE(*CHAR)  LEN(256)
 
             CHGJOB SWS(00000000)
 
             OVRDBF   FILE(SEDEXRPX) TOFILE(SEDEXRPD) SHARE(*NO)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Call SE8404 Daily Exchange Rates Maintenance */
             CALL       PGM(SE8404)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
                GOTO ENDPGM
             ENDDO
 
/* For database errors, recover data from LDA */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
ENDPGM:      DLTOVR     *ALL
             ENDPGM
