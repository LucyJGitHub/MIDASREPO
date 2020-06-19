000100200529/*********************************************************************/
000200200529/*STD    CLPBASE                                                     */
000300200529/*EXI *  TEXT('Midas RE CONSOLIDATED INT. STATEMENT PRINT')          */
000400200529/*********************************************************************/
000500200529/*                                                                   */
000600200529/*       Midas     Retail Module                                 */
000700200529/*                                                                   */
000800200529/*       REC3765 - INTEREST STATEMENT PRINT - CONSOLIDATED           */
000900200529/*                                                                   */
001000200529/*       (c) Finastra International Limited 2001                     */
001100200529/*                                                                   */
001200200604/*       Last Amend No. 253776             Date 22May20              */
001300200529/*       Prev Amend No. MD046248           Date 27Oct17              */
001400200529/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
001500200529/* Midas Plus 1.4 Base 04 -------------------------------------------*/
001600200529/* Midas Plus 1.4 Base ----------------------------------------------*/
001700200529/* Midas Plus 1.3 ---------------- Base -----------------------------*/
001800200529/* Midas Release 4 --------------- Base -----------------------------*/
001900200529/* Midas DBA 3.00 ---------------- Base -----------------------------*/
002000200529/*                      S01413 *CREATE     DATE 13APR93              */
002100200529/*                                                                   */
002200200529/*********************************************************************/
002300200529/*                                                                   */
002400200529/*       253776 - Monitor job switches.                              */
002500200529/*       MD046248 - Finastra Rebranding                              */
002600200529/*       S01413 - Retail 3 Incorporation                             */
002700200529/*                                                                   */
002800200529/*********************************************************************/
002900200529/*                                                                   */
003000200529/*       C R E A T I O N     P A R A M E T E R S                     */
003100200529/*                                                                   */
003200200529/*********************************************************************/
003300200529             PGM
003400200529             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
003500200529                          Finastra International Limited +
003600200529                          2001')
003700200529/**/
003800200529             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
003900200529/**/
004000200529/* declare &BJLANG as a program field as this hasn't been incorp to */
004100200529/*    SDBANKPD yet */
004200200529             DCL        VAR(&BJLANG) TYPE(*CHAR) LEN(2) VALUE('GB')
004300200529/*/COPY WNCPYSRC,REC3765001                                          */
004400200529/**/
004500200529             DCLF       FILE(SDBANKPD)
004600200529/**/
004700200529             SNDPGMMSG  MSG('REC3765 - Consolidated Retail interests +
004800200529                          statements  ') TOMSGQ(MRUNQ)
004900200529/**/
005000200529             RCVF
005100200529             MONMSG     MSGID(CPF0864) EXEC(DO)
005200200529              SNDPGMMSG  MSG('Record not found in file : SDBANKPD by +
005300200529                          PGM : REC3765') TOMSGQ(MOPERQ MRUNQ)
005400200529             CHGVAR     VAR(&BJLANG) VALUE(GB)
005500200529             ENDDO
005600200529/**/
005700200529    CHGVAR         VAR(&MSGF) VALUE(&BJLANG *TCAT 'REPTMSGF')
005800200529/**/
005900200529             OVRMSGF    MSGF(QUSERMSG) TOMSGF(&MSGF)
006000200529             OVRDBF     FILE(ACCRACJ) TOFILE(EACCRACJ)
006100200529             OVRDBF     FILE(ACCNT) TOFILE(EACCNT)
006200200529/*/COPY WNCPYSRC,REC3765002                                          */
006300200529             CALL       PGM(RE3765) PARM(&BJLANG)
006400200529/*/COPY WNCPYSRC,REC3765003                                          */
006500200529   DLTOVR     FILE(*ALL)
006600200529   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR)) /*253776*/
006700200529/**/
006800200529   CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')
006900200529 ABNOR: SNDPGMMSG MSG('REC3765 - Consolidated Retail interestS statements ended +
007000200529                abnormally') TOMSGQ(MOPERQ MRUNQ) /*253776*/
007100200529ENDCL:       ENDPGM
