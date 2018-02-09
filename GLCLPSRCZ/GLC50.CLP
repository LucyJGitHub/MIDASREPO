/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Requested GL Balance Extract &Rep')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC50 - REQUESTED GL BALANCE EXTRACT AND REPORT            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01194             DATE  16/03/89           */
/*                      S01098             DATE  27/08/86           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01098  -  BLOCK GLEXGC                                    */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*           Offsets for file indicators in the GLSTAT data area     */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&GLEX) TYPE(*DEC) LEN(3 0) VALUE(041)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
/**/
/**/
             RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)
/**/
             CLRPFM     FILE(EXDAEA)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
             CALL       PGM(GL0705)
/**/
             CLRPFM     FILE(GLEXHH)
             CLRPFM     FILE(GLEXGC)
             CLRPFM     FILE(GLEXZY)
/**/
             OVRDBF     FILE(GLEXGC) SEQONLY(*YES 250)                /*S01098*/
             CALL       PGM(GL0710)
/*********** DLTOVR     FILE(TABLE)*/                                 /*S01194*/
             DLTOVR     FILE(GLEXGC)                                  /*S01098*/
/**/
/*********** IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)*/            /*S01194*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S01194*/
/**/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACCNT') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACCNT') +
                             TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
                CHGVAR     VAR(%SUBSTRING(&GLSTAT &GLEX 1)) VALUE(Y)
                CHGDTAARA  DTAARA(GLSTAT) VALUE(&GLSTAT)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
