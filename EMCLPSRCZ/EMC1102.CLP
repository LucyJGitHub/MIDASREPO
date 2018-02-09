/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM Out.loans against security')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Exposure Management Module                */
/*                                                                  */
/*       EMC1102 - OUTSTANDING LOANS AGAINST A SECURITY BY CUSTOMER */
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
/*                      E81174             Date 27/11/86             */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - STANDING DATA CHANGES                             */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/**/
             CHGJOB SWS(00000000)
             CHGDTAARA  DTAARA(LDA)  VALUE(' ')
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABDLI)
/**/
 /*          OVRDBF     FILE(CUSDE) TOFILE(EMDLS)   */                /*E81174*/
/**/
             CALL       PGM(EM1102)
             DLTOVR     FILE(TABLE)
/**/
/*           DLTOVR     FILE(CUSDE)                 */                /*E81174*/
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
              IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44)) */           /*S01194*/
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))              /*S01194*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
              ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
