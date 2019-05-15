/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('WHT deductions by customer report - COB')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0202 - WHT Deductions by Customer Report (COB)           */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR787620           Date 10Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL013  *CREATE    Date 08Jun06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,GLH00308                                */
/*                  WNCPYSRC,GLH00309                                */
/*                  WNCPYSRC,GLH00312                                */
/*       CDL013 - Tiered Withholding Tax                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) VALUE('B')
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
/*/COPY WNCPYSRC,GLH00308                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2006')
/**/
             SNDMSG     MSG('GLC0202 - WHT Deductions by Customer +
                          Report') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,GLH00309                                            */
/**/
             CALL       PGM(GL0202) PARM(&RSEQ &RLEV &RENT)
/*/COPY WNCPYSRC,GLH00312                                            */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
ENDPGM:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
