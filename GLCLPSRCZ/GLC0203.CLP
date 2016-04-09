/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('WHT history update - COB')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0203 - WHT History Update (COB)                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/*       Last Amend No. AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL013  *CREATE    Date 08Jun06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,GLH00310                                */
/*                  WNCPYSRC,GLH00311                                */
/*       CDL013 - Tiered Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,GLH00310                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2006')
/**/
             SNDMSG     MSG('GLC0203 - WHT History Update') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*/COPY WNCPYSRC,GLH00311                                            */
             CALL       PGM(GL0203)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
