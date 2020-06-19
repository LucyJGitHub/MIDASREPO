000100200603/*********************************************************************/
000200200603/*STD    CLPBASE                                                     */
000300200603/*EXI *  TEXT('Midas SE CO Automatic Allocation Processing')         */
000400200603/*********************************************************************/
000500200603/*                                                                   */
000600200603/*       Midas - Securities Trading Module                           */
000700200603/*                                                                   */
000800200603/*       SEC7550 - SE CO Automatic Allocation Processing             */
000900200603/*                                                                   */
001000200603/*       (c) Finastra International Limited 2001                     */
001100200603/*                                                                   */
001300200619/*       LAST Amend No. MD046248           Date 27Oct17              */
001400200603/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
001500200603/* Midas Plus 1.4 Base 04 -------------------------------------------*/
001600200603/* Midas Plus 1.4 Base ----------------------------------------------*/
001700200603/* Midas Plus 1.3 ---------------- Base -----------------------------*/
001800200603/* Midas Release 4 --------------- Base -----------------------------*/
001900200603/* Midas DBA 3.00 ---------------- Base -----------------------------*/
002000200619/*       Prev Amend No. CPK009             Date 09Aug99              */
002100200603/*                      149378             Date 03Dec98              */
002200200603/*                      CSE007  *CREATE    Date 12Jan98              */
002300200603/*                                                                   */
002400200603/*********************************************************************/
002500200603/*                                                                   */
003100200603/*       MD046248 - Finastra Rebranding                              */
003200200603/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
003300200603/*                to CMTSCOPE(*JOB).                                 */
003400200603/*       149378 - Allocation problems: allow restart in case of lock */
003500200603/*       CSE007 - Corporate Actions                                  */
003600200603/*                                                                   */
003700200603/*********************************************************************/
003800200619             PGM        PARM(&PCORF &PBRCD &PDDPT &POPTN &PNSEC +
003900200619                          &PBOOK &PCNUM &PPTFR)
004200200603
004300200603/* Declare PGM Variables */
004400200603
004500200603             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
004600200603                          Finastra International Limited +
004700200603                          2001')
004800200603             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
004900200603             DCL        VAR(&PCORF)  TYPE(*CHAR) LEN(6)   /* CO Refernce */
005000200603             DCL        VAR(&PBRCD)  TYPE(*CHAR) LEN(3)   /* Branch Code */
005100200603             DCL        VAR(&PDDPT)  TYPE(*CHAR) LEN(6)   /* Depot */
005200200603             DCL        VAR(&POPTN)  TYPE(*CHAR) LEN(2)   /* Option Number */
005300200603             DCL        VAR(&PNSEC)  TYPE(*CHAR) LEN(10)  /* New Security */
005400200603             DCL        VAR(&PBOOK)  TYPE(*CHAR) LEN(2)   /* Book Code */
005500200603             DCL        VAR(&PCNUM)  TYPE(*CHAR) LEN(6)   /* Customer Number */
005600200603             DCL        VAR(&PPTFR)  TYPE(*CHAR) LEN(4) /* Portfolio Ref. */
005800200603/***         DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)              /*149378*/
005900200603/***         DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)             /*149378*/
006000200603
006100200603/* Global monitor message */
006200200603
006300200603 /********** MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
006400200603 /**********              CMDLBL(ABNOR))                             /*149378*/
006500200603
006600200603             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
006700200603                          AUT(*USE)
006800200603             MONMSG     MSGID(CPF0000)
006900200603             CHGDTAARA  DTAARA(QTEMP/LDA) VALUE(' ')
007000200603
007100200603/* Reset Switches */
007200200603
007300200603             CHGJOB     SWS(XXXXXX00)
007400200603
007500200603/* Start commitment control */
007600200603
007700200603/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE)                        /*CPK009*/
007800200603             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE) CMTSCOPE(*JOB)         /*CPK009*/
007900200603
008000200603             SNDPGMMSG  MSG('SEC7550 - SE CO Automatic Allocation +
008100200603                          Processing') TOMSGQ(MRUNQ)
008200200603
008300200603/* Do Security Copies of updated files */
008400200603
008500200603/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)         /*149378*/
008600200603/**********  CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *TCAT 'DMLIB')     /*149378*/
008700200603
008800200603/**********  CPYF       FROMFILE(&DMLIB/SECOALPD) +
008900200603/**********               TOFILE(QTEMP/SECOALPD) CRTFILE(*YES)    +  /*149378*/
009000200603/**********               /* CO Allocation file */                   /*149378*/
009100200603
009200200603/**********  CPYF       FROMFILE(&DMLIB/SECODPPD) +
009300200603/**********               TOFILE(QTEMP/SECODPPD) CRTFILE(*YES)    +  /*149378*/
009400200603/**********               /* CO Depots file */                       /*149378*/
009500200603
009600200603/**********  CPYF       FROMFILE(&DMLIB/SECODRPD) +
009700200603/**********               TOFILE(QTEMP/SECODRPD) CRTFILE(*YES)    +  /*149378*/
009800200603/**********               /* CO Depots Reference file */             /*149378*/
009900200603
010000200603/* Call RPG/SE7550 - SE CO Automatic Allocation Processing */
010100200603
010200200619             CALL       PGM(SE7550) PARM(&PCORF &PBRCD &PDDPT &POPTN +
010400200619                          &PNSEC &PBOOK &PCNUM &PPTFR)
010700200603
010800200603/* Database error processing */
010900200603
011000200603             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
011100200603                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
011200200603                ROLLBACK
011300200603                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
011400200603                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
011500200603                CHGVAR VAR(&MEM) VALUE('SEC7550 - JOB TERMINATED, +
011600200603                                        DATABASE IN ERROR')
011700200603                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
011800200603                GOTO       CMDLBL(END)
011900200603             ENDDO
012000200603
012100200603             GOTO       CMDLBL(END)
012200200603
012300200603 ABNOR:
012400200603
012500200603             CHGJOB     SWS(XXXXXX11)
012600200603
012700200603/* Abnormal termination */
012800200603
012900200603             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
013000200603                          SEC7550 - SE CO Automatic Allocation +
013100200603                          Processing ended abnormally - see job +
013200200603                          log') TOMSGQ(MRUNQ MOPERQ)
013300200603             MONMSG     MSGID(CPF0000 MCH0000)
013400200603
013500200603END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
013600200603                          Finastra International Limited')
013700200603
013800200603             ENDPGM
