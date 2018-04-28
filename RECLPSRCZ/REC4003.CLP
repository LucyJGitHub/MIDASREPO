/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Term & Notice Periods & Penalites Input')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail T&N Accounts                             */
/*                                                                   */
/*       CLP/REC4003 - Period and Penalty Maintenance                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CRE015 *Create     Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
/**/
             DCL     VAR(&MODE) TYPE(*CHAR) LEN(7)
/**/
             DCL     VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL     VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL     VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL     VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             OVRDBF     FILE(REPRPNPD) TOFILE(REPRPNPD) SHARE(*NO)
             OVRDBF     FILE(ACCNT) TOFILE(ACCNT) SHARE(*NO)
             OVRDBF     FILE(ACNUM) TOFILE(ACNUM) SHARE(*NO)
             CALL       PGM(RE4003) PARM(&MODE)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
             SNDPGMMSG  MSG('Error in REC4003') TOPGMQ(*EXT)
             ENDDO
/**/
                RTVJOBA    JOB(&JOB) SWS(&SWS)
/**/
                 IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                    CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                    ROLLBACK
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                    SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT)
                 ENDDO
 ENDPGM:
       /* Remove Overrides */
                    DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd. 2009')
               ENDPGM
