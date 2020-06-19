000100200529/*********************************************************************/
000200200529/*STD    CLPBASE                                                     */
000300200529/*EXI *  TEXT('Midas PM Save Start of Period Details')               */
000400200529/*********************************************************************/
000500200529/*                                                                   */
000600200529/*       Midas - Portfolio Management Module                         */
000700200529/*                                                                   */
000800200529/*       PMC6430 - SAVE START OF PERIOD DETAILS                      */
000900200529/*                                                                   */
001000200529/*       (c) Finastra International Limited 2001                     */
001100200529/*                                                                   */
001200200604/*       Last Amend No. 250228             Date 22May20              */
001300200529/*       Prev Amend No. MD046248           Date 27Oct17              */
001400200529/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
001500200529/* Midas Plus 1.4 Base 04 -------------------------------------------*/
001600200529/* Midas Plus 1.4 Base ----------------------------------------------*/
001700200529/* Midas Plus 1.3 ---------------- Base -----------------------------*/
001800200529/* Midas Release 4 --------------- Base -----------------------------*/
001900200529/* Midas DBA 3.00 ---------------- Base -----------------------------*/
002000200529/*                      CPM005             Date 24Jun96              */
002100200529/*                      S01124             Date 22Jun94              */
002200200529/*                                                                   */
002300200529/*-------------------------------------------------------------------*/
002400200529/*                                                                   */
002500200529/*       250228 - Error on OPNQRYF for PMPSTCPD.                     */
002600200529/*       MD046248 - Finastra Rebranding                              */
002700200529/*       CPM005 - Private Banking Phase 2                            */
002800200529/*                Focus Group Changes upgraded to DBA                */
002900200529/*       S01124 - PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
003000200529/*                  VERSION RELEASE III                              */
003100200529/*                                                                   */
003200200529/*********************************************************************/
003300200529             PGM        PARM(&CNAM &CSEQ)
003400200529
003500200529             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
003600200529                          Finastra International Limited +
003700200529                          2001')
003800200529             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
003900200529             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
004000200529/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                * *CPM005*/
004100200529             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
004200200529             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
004300200529             DCL        VAR(&DARUN) TYPE(*CHAR) LEN(5)
004400200529             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)
004500200529/**********  DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                * *CPM005*/
004600200529/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)               * *CPM005*/
004700200529/**********  DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)               * *CPM005*/
004800200529/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)              * *CPM005*/
004900200529/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)               * *CPM005*/
005000200529             DCL        VAR(&EOM)  TYPE(*CHAR) LEN(1)
005100200529             DCL        VAR(&EOY)  TYPE(*CHAR) LEN(1)
005200200529             DCL        VAR(&ERR)  TYPE(*CHAR) LEN(1)                 /*CPM005*/
005300200529
005400200529/**Retrieve*Job*attributes******************************************** *CPM005*/
005500200529/**********  RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)            * *CPM005*/
005600200529
005700200529/* Global Monitor Message */
005800200529             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
005900200529                          CMDLBL(ENDTAG))
006000200529
006100200529/**Get*system*ID*to*build*DLIB*name*********************************** *CPM005*/
006200200529/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)         * *CPM005*/
006300200529/**********  CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')       * *CPM005*/
006400200529
006500200529/* Set OFF Switches */
006600200529             CHGJOB     SWS(00000000)
006700200529
006800200529/* Send Program Message */
006900200529             SNDPGMMSG  MSG('PMC6430 - Save Start of Period +
007000200529                          Details') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
007100200529
007200200529/* End of month and end of year check */
007300200529/**********  CALL PGM(SD2000) PARM(&EOM &EOY)                          *CPM005*/
007400200529             CALL PGM(SD2000) PARM(&EOM &EOY &ERR)                    /*CPM005*/
007500200529
007600200529/* If not End of month */
007700200529             IF         COND(&EOM *EQ 'N') THEN(DO)
007800200529
007900200529/**********  CPYF  FROMFILE(&DLIB/PMPSTCPP) TOFILE(QTEMP/PMPSTCPP) + * *CPM005*/
008000200529/**********             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) * *CPM005*/
008100200529/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPP))   * *CPM005*/
008200200529             CLRPFM     FILE(PMPSTCPD)                                /*CPM005*/
008300200529
008400200529/* Save Event Control Date as Date Extract Last Run */
008500200529             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
008600200529             RTVDTAARA  DTAARA(PMSTAT (6 5)) RTNVAR(&DARUN)
008700200529
008800200529/**********  DLTF       FILE(QTEMP/PMPORTPP)                         * *CPM005*/
008900200529/**********  MONMSG MSGID(CPF0000)                                   * *CPM005*/
009000200529/**********                                                          * *CPM005*/
009100200529/**********  CPYF       FROMFILE(PMPORTPP) TOFILE(QTEMP/PMPORTPP) +  * *CPM005*/
009200200529/**********              MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)* *CPM005*/
009300200529/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)               * *CPM005*/
009400200529/**********                                                          * *CPM005*/
009500200529/**********  CPYF       FROMFILE(PMCNSDPP) TOFILE(QTEMP/PMPORTPP) +  * *CPM005*/
009600200529/**********               MBROPT(*ADD) FMTOPT(*MAP *DROP)            * *CPM005*/
009700200529/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)               * *CPM005*/
009800200529             CPYF       FROMFILE(PMPORTPD) TOFILE(PMMERGPD) +
009900200529                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*CPM005*/
010000200529             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
010100200529                                                                      /*CPM005*/
010200200529             CPYF       FROMFILE(PMCNSDPD) TOFILE(PMMERGPD) +
010300200529                          MBROPT(*ADD) FMTOPT(*MAP *DROP)             /*CPM005*/
010400200529             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
010500200529
010600200529/*  Open Query File to Select Record with Performance Start Date less */
010700200529/*  or equal than Event Control Date                                  */
010800200529/**********  OVRDBF     FILE(PMPORTPP) SHARE(*YES)                   * *CPM005*/
010900200529/**********  OPNQRYF    FILE((QTEMP/PMPORTPP)) +                     * *CPM005*/
011000200529/**********               FORMAT(QTEMP/PMPORTPP) QRYSLT('(PNPSDA +   * *CPM005*/
011100200529/**********               *LE "' *CAT &DAECD *CAT '") & (PNPSDA *GE +* *CPM005*/
011200200529/**********               "' *CAT &DARUN *CAT '") & (PNRECI *EQ +    * *CPM005*/
011300200529/**********               "D")') KEYFLD((PNCNUM *ASCEND) (PNPTFR +   * *CPM005*/
011400200529/**********               *ASCEND)) MAPFLD((PNPSD1 PNPSDT *ZONED 5 + * *CPM005*/
011500200529/**********               0) (PNPSDA PNPSD1 *CHAR 5))                * *CPM005*/
011600200529             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD) SHARE(*YES)   /*CPM005*/
011700200529             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
011800200529             OPNQRYF    FILE((PMPORTPD)) QRYSLT('(PNPSDA *LE "' *CAT +
011900200529                          &DAECD *CAT '") & (PNPSDA *GE "' *CAT +
012000200529                          &DARUN *CAT '") & (PNRECI *EQ "D")') +
012100200529                          KEYFLD((PNCNUM *ASCEND) (PNPTFR *ASCEND)) +
012200200529                          MAPFLD((PNPSD1 PNPSDT *ZONED 5 0) (PNPSDA +
012300200529                          PNPSD1 *CHAR 5))                            /*CPM005*/
012400200529             CALL       PGM(PM6430)
012500200529/*********** DLTOVR     FILE(PMPORTPP)                               * *CPM005*/
012600200529/*********** CLOF       OPNID(PMPORTPP)                              * *CPM005*/
012700200529             CLOF       OPNID(PMPORTPD)                               /*CPM005*/
012800200529             DLTOVR     FILE(*ALL)                                    /*CPM005*/
012900200529
013000200529/* For Database Errors Recover Data from LDA */
013100200529 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
013200200529/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         * *CPM005*/
013300200529/**********     SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG)             + *CPM005*/
013400200529/**********                MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    *CPM005*/
013500200529/**********     SNDMSG   MSG('PMC6430 ENDED ABNORMALLY FOR JOB ' *CAT +*CPM005*/
013600200529/**********                 &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' + * *CPM005*/
013700200529/**********                 *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)     * *CPM005*/
013800200529                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
013900200529                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
014000200529                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
014100200529                GOTO       CMDLBL(ENDPGM)
014200200529             ENDDO
014300200529
014400200529/* For File in Balance Error */
014500200529             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
014600200529/**********     CHGVAR VAR(&MEM) VALUE('PMC6430 - FILE CONTROLS OUT +* *CPM005*/
014700200529/**********               OF BALANCE')                               * *CPM005*/
014800200529/**********     SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)* *CPM005*/
014900200529                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
015000200529                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
015100200529                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
015200200529                GOTO       CMDLBL(ENDPGM)
015300200529             ENDDO
015400200529
015500200529/* Copy extracted data from workfile to master file */
015600200529/**********  CPYF       FROMFILE(PMPSTCPP) TOFILE(PMPSTMPP) +        * *CPM005*/
015700200529/**********               MBROPT(*ADD) FMTOPT(*MAP *DROP)            * *CPM005*/
015800200529/* Copy extracted data from workfile to master file */
015900200529/**********  CPYF       FROMFILE(PMPSTCPP) TOFILE(PMPSTMPP) +        * *CPM005*/
016000200529/**********               MBROPT(*ADD) FMTOPT(*MAP *DROP)            * *CPM005*/
016100200529 /********** OPNQRYF    FILE((PMPSTCPD)) FORMAT(PMPSTMQ0) +
016200200529 /**********              MAPFLD((QFCNUM GFCNUM) (QFPTFR GFPTFR) +
016300200529 /**********              (QFINNR GFINNR) (QFVALG GFVALG) (QFCCY1 +
016400200529 /**********              GFCCY1) (QFCDP1 GFCDP1) (QFCNTR GFCNTR) +
016500200529 /**********              (QFLIND GFLIND) (QFTDSS GFTDSS) (QFAMT1 +
016600200529 /**********              GFAMT1) (QFACIS GFACIS) (QFPLFX GFPLFX) +
016700200529 /**********              (QFMFXR GFMFXR) (QFMFMD GFMFMD) (QFMPRC +
016800200529 /**********              GFMPRC) (QFTRNB GFTRNB) (QFMODI GFMODI) +
016900200529 /**********              (QFBYSF GFBYSF) (QFFOIS GFFOIS) (QFTXT2 +
017000200529 /**********              GFTXT2) (QFSTMN GFSTMN) (QFPPRC GFPPRC) +
017100200529 /**********              (QFMFXD GFMFXD) (QFNMDP GFNMDP) (QFSPBS +
017200200529 /**********              GFSPBS) (QFTKDM GFTKDM) (QFMNPF GFMNPF) +
017300200529 /**********              (QFTKVL GFTKVL) (QFFPSI GFRESH) (QFVDAT +
017400200529 /**********              GFVDAT) (QFMVPC GFMVPC))                                 /*CPM005 250228*/
017500200529             OPNQRYF    FILE((PMPSTCPD)) FORMAT(PMPSTMQ0) MAPFLD((QFCNUM GFCNUM) +
017600200529                          (QFPTFR GFPTFR) (QFINNR GFINNR) (QFVALG GFVALG) (QFCCY1 +
017700200529                          GFCCY1) (QFCDP1 GFCDP1) (QFCNTR GFCNTR) (QFLIND GFLIND) +
017800200529                          (QFTDSS GFTDSS) (QFAMT1 GFAMT1) (QFACIS GFACIS) (QFPLFX +
017900200529                          GFPLFX) (QFMFXR GFMFXR) (QFMFMD GFMFMD) (QFMPRC GFMPRC) +
018000200529                          (QFTRNB GFTRNB) (QFMODI GFMODI) (QFBYSF GFBYSF) (QFFOIS +
018100200529                          GFFOIS) (QQTXT2 GFTXT2) (QFSTMN GFSTMN) (QFPPRC GFPPRC) +
018200200529                          (QFMFXD GFMFXD) (QFNMDP GFNMDP) (QFSPBS GFSPBS) (QFTKDM +
018300200529                          GFTKDM) (QFMNPF GFMNPF) (QFTKVL GFTKVL) (QFFPSI GFRESH) +
018400200529                          (QFVDAT GFVDAT) (QFMVPC GFMVPC)) /*250228*/
018500200529             CPYFRMQRYF FROMOPNID(PMPSTCPD) TOFILE(PMPSTMQ0) +
018600200529                          MBROPT(*ADD)  FMTOPT(*NOCHK)                /*CPM005*/
018700200529             CLOF       OPNID(PMPSTCPD)                               /*CPM005*/
018800200529                                                                      /*CPM005*/
018900200529             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
019000200529             ENDDO
019100200529
019200200529             GOTO       CMDLBL(ENDPGM)
019300200529
019400200529ENDTAG:      DMPCLPGM
019500200529/***ENDPGM:**    ENDPGM                                              * *CPM005*/
019600200529ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
019700200529                          Finastra International Limited')
019800200529             ENDPGM                                                   /*CPM005*/
