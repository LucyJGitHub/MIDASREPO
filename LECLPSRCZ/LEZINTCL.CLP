/*********************************************************************/
/*STD    CLPBASEBND                                                  */
/*EXI    TEXT('Midas LE Zero Interest Rate Loans Report')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEZINTCL - Zero Interest Rate Loans Report                  */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. CLE170 *CREATE      Date  10Oct19            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE170 - Allow Zero Interest Rates (LE)                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2019')

             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)

             CHGJOB     SWS(00000000)

             CALL       PGM(LEZINTR1)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited.')
ENDPGM:      ENDPGM
