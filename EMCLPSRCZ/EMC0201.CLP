/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LIMITS MAINTENANCE')                         */
/********************************************************************/
/*                                                                  */
/*        Midas     - Exposure Management Module                */
/*                                                                  */
/*       EMC0201 - EXPOSURE MANAGEMENT LIMITS MAINTENANCE           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194             Date 13Dec89              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
     PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
     DCL VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
     CHGJOB SWS(00000000)
     OVRDBF FILE(TABLE) TOFILE(TABEM)
     CHGDTAARA DTAARA(LDA) VALUE(' ')
/**/
     CALL PGM(EM0020)
     MONMSG  MSGID(RPG0000  CPF0000  MCH0000) EXEC(DO)
         ROLLBACK
         SNDPGMMSG MSG('Transaction failed. Re-input necessary. +
                       Enter to continue.') TOPGMQ(*EXT)
         GOTO END
     ENDDO
/**/
     IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))           */ /*S01194*/
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))              /*S01194*/
       ROLLBACK
       SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) TOPGMQ(*EXT) -
TOMSGQ(MOPERQ)
     ENDDO
/**/
END: DLTOVR FILE(TABLE)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
     ENDPGM
