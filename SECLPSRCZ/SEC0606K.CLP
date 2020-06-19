000100200603/*********************************************************************/
000200200603/*STD    CLPBASE                                                     */
000300200603/*EXI *  TEXT('Midas SE Update Bk Pos with Next Day Trade')          */
000400200603/********************************************************************/
000500200603/*                                                                  */
000600200603/*         Midas - Securities Trading Module                    */
000700200603/*                                                                  */
000800200603/*       SEC0606K - UPDATE BOOK POSITION I/C FIELDS WITH DETAILS    */
000900200603/*                  OF NEXT DAY'S TRADES                            */
001000200603/*                                                                  */
001100200603/*       (c) Finastra International Limited 2001                     */
001200200603/*                                                                   */
001300200604/*       Last Amend No. 255926             Date 22May20              */
001400200603/*       Prev Amend No. MD046248           Date 27Oct17              */
001500200603/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
001600200603/* Midas Plus 1.4 Base 04 -------------------------------------------*/
001700200603/* Midas Plus 1.4 Base ----------------------------------------------*/
001800200603/* Midas Plus 1.3 ---------------- Base -----------------------------*/
001900200603/* Midas Release 4 --------------- Base -----------------------------*/
002000200603/* Midas DBA 3.00 ---------------- Base -----------------------------*/
002100200603/*                      S01408             Date 11May95              */
002200200603/*                      S01117             Date 08Jan91              */
002300200603/*                      S01189                  DATE  08JAN91       */
002400200603/*                      E21114                  DATE  13FEB90       */
002500200603/*                                                                  */
002600200603/*------------------------------------------------------------------*/
002700200603/*                                                                   */
002800200603/*       255926 - Addition of error handling to prevent missing     */
002900200603/*                members in logical files.                         */
003000200603/*       MD046248 - Finastra Rebranding                              */
003100200603/*       S01408 - Addition of core hook SEC0606KMS                  *  *E15549*/
003200200603/*       S01117  -  MULTIBRANCHING                                  */
003300200603/*       S01189  -  CLOSE OF BUSINESS IMPROVEMENTS PHASE 2          */
003400200603/*       E21114  -  NEW PROGRAM.                                    */
003500200603/*                                                                  */
003600200603/********************************************************************/
003700200603/**/
003800200603/*       C R E A T I O N     P A R A M E T E R S                     */
003900200603/*                                                                   */
004000200603/*********************************************************************/
004100200603/************PGM                                                     * *S01189*/
004200200603             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
004300200603
004400200603             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
004500200603                          Finastra International Limited +
004600200603                          2001')
004700200603/**/                                                                  /*S01117*/
004800200603/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
004900200603             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
005000200603             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
005100200603             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
005200200603/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                * *S01189*/
005300200603             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
005400200603             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
005500200603             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
005600200603
005700200603             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
005800200603/************DCL        VAR(&SESTAT)  TYPE(*CHAR)  LEN(128)          * *S01189*/
005900200603             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
006000200603
006100200603/* Catch non-specified error messages and process error routine */                        /*255926*/
006200200603                                                                                          /*255926*/
006300200603             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ERROR)) +
006400200603                          /*255926*/
006500200603
006600200603             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
006700200603             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
006800200603/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')             S01117*/
006900200603             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
007000200603                                                                      /*S01408*/
007100200603/*/COPY WNCPYSRC,SEC0606KMS                                          */
007200200603                                                                      /*S01408*/
007300200603
007400200603/* SEND PGM MESSAGE */
007500200603
007600200603             CHGVAR     VAR(&MEM) VALUE('SEC0606K - Update Book +
007700200603                          Positions I/C fields')
007800200603             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
007900200603
008000200603/* CLEAR SWITCHES */
008100200603
008200200603             CHGJOB     SWS(00000000)
008300200603
008400200603/* CHECK FOR COMPONENT RESTART                                      */
008500200603
008600200603/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)           * *S01189*/
008700200603             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
008800200603             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
008900200603
009000200603/* IF RESTART DISABLE RELATED ACCESS PATHS                          */
009100200603
009200200603/************IF COND(&BUSY = 'NEW') THEN(DO)                         * *S01189*/
009300200603             IF COND(&BUSY = 'Y') THEN(DO)                            /*S01189*/
009400200603
009500200603                RMVM       FILE(BKPHDJF2) MBR(BKPHDJF2)
009600200603                MONMSG MSGID(CPF0000)
009700200603                RMVM       FILE(BKPHJ1) MBR(BKPHJ1)
009800200603                MONMSG MSGID(CPF0000)
009900200603                RMVM       FILE(BKPHJ3V) MBR(BKPHJ3V)
010000200603                MONMSG MSGID(CPF0000)
010100200603                RMVM       FILE(BKPHS) MBR(BKPHS)
010200200603                MONMSG MSGID(CPF0000)
010300200603                RMVM       FILE(BPOHTR) MBR(BPOHTR)
010400200603                MONMSG MSGID(CPF0000)
010500200603                RMVM       FILE(BPOHVL) MBR(BPOHVL)
010600200603                MONMSG MSGID(CPF0000)
010700200603                RMVM       FILE(BKPOSDT) MBR(BKPOSDT)
010800200603                MONMSG MSGID(CPF0000)
010900200603                RMVM       FILE(BKPOSS) MBR(BKPOSS)
011000200603                MONMSG MSGID(CPF0000)
011100200603
011200200603/* OVERRIDE FILES                       */
011300200603
011400200603                OVRDBF FILE(BKPHDD)  SEQONLY(*YES 100)
011500200603                OVRDBF FILE(BKPHDA)  SEQONLY(*YES 1)
011600200603                OVRDBF FILE(XBKPHDD) SEQONLY(*YES 100)
011700200603                OVRDBF FILE(XBKPHDA) SEQONLY(*YES 1)
011800200603                OVRDBF FILE(BKPOSD)  SEQONLY(*YES 100)
011900200603                OVRDBF FILE(BKPOSA)  SEQONLY(*YES 1)
012000200603                OVRDBF FILE(XBKPOSD) SEQONLY(*YES 100)
012100200603                OVRDBF FILE(XBKPOSA) SEQONLY(*YES 1)
012200200603
012300200603/* AND COPY FILES                       */
012400200603
012500200603                CPYF FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
012600200603                MBROPT(*REPLACE) FMTOPT(*NONE)
012700200603                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
012800200603                        EXEC(CLRPFM BKPHDD)
012900200603
013000200603                CPYF FROMFILE(XBKPHDA) TOFILE(BKPHDA) +
013100200603                MBROPT(*REPLACE) FMTOPT(*NONE)
013200200603                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
013300200603                        EXEC(CLRPFM BKPHDA)
013400200603
013500200603                CPYF FROMFILE(XBKPOSD) TOFILE(BKPOSD) +
013600200603                MBROPT(*REPLACE) FMTOPT(*NONE)
013700200603                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
013800200603                        EXEC(CLRPFM BKPOSD)
013900200603
014000200603                CPYF FROMFILE(XBKPOSA) TOFILE(BKPOSA) +
014100200603                MBROPT(*REPLACE) FMTOPT(*NONE)
014200200603                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
014300200603                        EXEC(CLRPFM BKPOSA)
014400200603
014500200603/* CHANGE DATA AREA                     */
014600200603
014700200603/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
014800200603                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
014900200603                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
015000200603
015100200603             ENDDO
015200200603
015300200603/*   OVERRIDE FILES                                                 */
015400200603
015500200603                OVRDBF FILE(BKPHDD)  SEQONLY(*YES 100)
015600200603                OVRDBF FILE(BKPHDA)  SEQONLY(*YES 1)
015700200603                OVRDBF FILE(XBKPHDD) SEQONLY(*YES 100)
015800200603                OVRDBF FILE(XBKPHDA) SEQONLY(*YES 1)
015900200603                OVRDBF FILE(BKPOSD)  SEQONLY(*YES 100)
016000200603                OVRDBF FILE(BKPOSA)  SEQONLY(*YES 1)
016100200603                OVRDBF FILE(XBKPOSD) SEQONLY(*YES 100)
016200200603                OVRDBF FILE(XBKPOSA) SEQONLY(*YES 1)
016300200603
016400200603/* DELETE COPY FILES                               */
016500200603
016600200603                DLTF       FILE(XBKPHDD)
016700200603                   MONMSG MSGID(CPF0000)
016800200603                DLTF       FILE(XBKPHDA)
016900200603                   MONMSG MSGID(CPF0000)
017000200603                DLTF       FILE(XBKPOSD)
017100200603                   MONMSG MSGID(CPF0000)
017200200603                DLTF       FILE(XBKPOSA)
017300200603                   MONMSG MSGID(CPF0000)
017400200603
017500200603             CPYF FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
017600200603             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
017700200603             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
017800200603             EXEC(CLRPFM XBKPHDD)
017900200603
018000200603             CPYF FROMFILE(BKPHDA) TOFILE(&TOLIB/XBKPHDA) +
018100200603             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
018200200603             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
018300200603             EXEC(CLRPFM XBKPHDA)
018400200603
018500200603             CPYF FROMFILE(BKPOSD) TOFILE(&TOLIB/XBKPOSD) +
018600200603             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
018700200603             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
018800200603             EXEC(CLRPFM XBKPOSD)
018900200603
019000200603             CPYF FROMFILE(BKPOSA) TOFILE(&TOLIB/XBKPOSA) +
019100200603             MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
019200200603             MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
019300200603             EXEC(CLRPFM XBKPOSA)
019400200603
019500200603/* CHANGE DATA AREA   TO 'NEW'          */
019600200603
019700200603/************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')             * *S01189*/
019800200603             CHGVAR    VAR(&BUSY) VALUE('Y')                          /*S01189*/
019900200603             CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)                 /*S01189*/
020000200603
020100200603/*   DISABLE ACCESS PATHS FOR LOGICALS NOT REQUIRED BY THIS RPG     */
020200200603
020300200603                RMVM       FILE(BKPHDJF2) MBR(BKPHDJF2)
020400200603                MONMSG MSGID(CPF0000)
020500200603                RMVM       FILE(BKPHJ1) MBR(BKPHJ1)
020600200603                MONMSG MSGID(CPF0000)
020700200603                RMVM       FILE(BKPHJ3V) MBR(BKPHJ3V)
020800200603                MONMSG MSGID(CPF0000)
020900200603                RMVM       FILE(BKPHS) MBR(BKPHS)
021000200603                MONMSG MSGID(CPF0000)
021100200603                RMVM       FILE(BPOHTR) MBR(BPOHTR)
021200200603                MONMSG MSGID(CPF0000)
021300200603                RMVM       FILE(BPOHVL) MBR(BPOHVL)
021400200603                MONMSG MSGID(CPF0000)
021500200603                RMVM       FILE(BKPOSDT) MBR(BKPOSDT)
021600200603                MONMSG MSGID(CPF0000)
021700200603                RMVM       FILE(BKPOSS) MBR(BKPOSS)
021800200603                MONMSG MSGID(CPF0000)
021900200603
022000200603/*  CALL SE2340 (UPDATE) */
022100200603
022200200603             CALL       PGM(SE2340)
022300200603
022400200603
022500200603/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
022600200603
022700200603ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
022800200603                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
022900200603/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
023000200603                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
023100200603             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
023200200603                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
023300200603                CHGVAR    VAR(&MEM) VALUE('SEC0606K - Job Terminated, +
023400200603                          Database in Error')
023500200603             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
023600200603                GOTO ENDPGM
023700200603             ENDDO
023800200603
023900200603
024000200603/* NORMAL COMPLETION - CLEAR OUTPUT FILES */
024100200603
024200200603             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
024300200603/* CHANGE DATA AREA   TO 'NEW'          */
024400200603
024500200603/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')          * *S01189*/
024600200603                CHGVAR    VAR(&BUSY) VALUE('N')                       /*S01189*/
024700200603                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)              /*S01189*/
024800200603
024900200603                DLTF       FILE(XBKPHDD)
025000200603                   MONMSG MSGID(CPF0000)
025100200603                DLTF       FILE(XBKPHDA)
025200200603                   MONMSG MSGID(CPF0000)
025300200603                DLTF       FILE(XBKPOSD)
025400200603                   MONMSG MSGID(CPF0000)
025500200603                DLTF       FILE(XBKOSDA)
025600200603                   MONMSG MSGID(CPF0000)
025700200603
025800200603             ENDDO
025900200603
026000200603/*    ENABLE ACCESS PATHS  */
026100200603
026200200603ENDPGM:         ADDLFM   FILE(BKPHDJF2) MBR(BKPHDJF2)
026300200603                MONMSG MSGID(CPF0000)
026400200603                ADDLFM     FILE(BKPHJ1) MBR(BKPHJ1)
026500200603                MONMSG MSGID(CPF0000)
026600200603                ADDLFM     FILE(BKPHJ3V) MBR(BKPHJ3V)
026700200603                MONMSG MSGID(CPF0000)
026800200603                ADDLFM     FILE(BKPHS) MBR(BKPHS)
026900200603                MONMSG MSGID(CPF0000)
027000200603                ADDLFM     FILE(BPOHTR) MBR(BPOHTR)
027100200603                MONMSG MSGID(CPF0000)
027200200603                ADDLFM     FILE(BPOHVL) MBR(BPOHVL)
027300200603                MONMSG MSGID(CPF0000)
027400200603                ADDLFM     FILE(BKPOSDT) MBR(BKPOSDT)
027500200603                MONMSG MSGID(CPF0000)
027600200603                ADDLFM     FILE(BKPOSS) MBR(BKPOSS)
027700200603                MONMSG MSGID(CPF0000)
027800200603
027900200603             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
028000200603                          Finastra International Limited')
028100200603                ENDPGM
