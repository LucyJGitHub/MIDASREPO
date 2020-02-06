/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Blocked Positions Audit/Full List')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6820 - SE ER Blocked Positions List/Audit                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 085081             Date 05Sep95              */
/*                      S01496             Date 12Oct94              */
/*                      S10978             DATE 30MAR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       085081 - Checking for input cycle request should be using   */
/*                an indicator not if the report is running in batch */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01496*/
/*********** PGM        PARM(&RSEQ &RLEV &RENT)               *S01496* *085081*/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                 /*085081*/
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01496*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01496*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01496*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&FEA) TYPE(*CHAR) LEN(1)               */ /*S01496*/
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/**Retrieve*Job*attributes******************************************** *085081*/
/**********  RTVJOBA    TYPE(&TYPE) JOB(&JOB) USER(&USER) NBR(&JOBNO)* *085081*/
 
/* If COB, it is an Audit List, select all records changed today, */
/*         or matured today or before next working day            */
             IF COND(&TYPE = '0') THEN(DO)
 
             SNDPGMMSG  MSG('SE6820 - Early Redemptions Blocked +
                          Positions Audit Report') TOMSGQ(MRUNQ)
 
/* Override the File on itself */
             OVRDBF     FILE(SEBLKPL1) SHARE(*YES)
 
/* Process an Open Query File to Select the Records of Today */
             OPNQRYF    FILE((SEBLKPL1) (SDBANKPD)) FORMAT(SEBLKPL1 +
                          SEBLKPD0) QRYSLT('(VDLCD *EQ BJRDNB) *OR +
                          ((BJRDNB *LE VDBEDT) *AND (VDBEDT *LT +
                          BJDNWD))') KEYFLD((1/VDBRCD *ASCEND) +
                          (1/VDCNUM) (1/VDPTFR) (1/VDBLTY) +
                          (1/VDSESN) (1/VDBEDT) (1/VDSEQN)) +
                          JFLD(*NONE) MAPFLD(*NONE)
             ENDDO
 
/* If IC, it is a Full List, select all live records */
             IF COND(&TYPE = '1') THEN(DO)
 
/*********** RTVDTAARA  DTAARA(LZSTAT (49 1)) RTNVAR(&FEA)         */ /*S01496*/
/*********** IF         COND(&FEA *NE 'Y') THEN(DO)                */ /*S01496*/
/*********** SNDPGMMSG  MSG('Option not allowed, Early Redemptions +  /*S01496*/
/***********              Feature not installed.') TOPGMQ(*EXT)    */ /*S01496*/
/***********   GOTO       CMDLBL(ENDCLPGM)                         */ /*S01496*/
/*********** ENDDO                                                 */ /*S01496*/
 
             SNDPGMMSG  MSG('SE6820 - Early Redemptions Blocked +
                          Positions Full List') TOMSGQ(MRUNQ)
 
/* Override the File on itself */
             OVRDBF     FILE(SEBLKPL1)
 
/* Process an Open Query File to Select the Records of Today */
             OPNQRYF    FILE((SEBLKPL1) (SDBANKPD)) FORMAT(SEBLKPL1 +
                          SEBLKPD0) QRYSLT('BJRDNB *LE VDBEDT') +
                          KEYFLD((1/VDBRCD *ASCEND) (1/VDCNUM) +
                          (1/VDPTFR) (1/VDBLTY) (1/VDSESN) +
                          (1/VDBEDT) (1/VDSEQN)) JFLD(*NONE) +
                          MAPFLD(*NONE)
             ENDDO
 
/* Call RPG Pgm */
/*********** CALL       PGM(SE6820) PARM(&TYPE)                    */ /*S01496*/
             CALL       PGM(SE6820) PARM(&TYPE &RSEQ &RLEV &RENT)     /*S01496*/
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +          */ /*S01496*/
/***********              MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6820 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)
               GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
/***********                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6820 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
 ERROR:      CLOF       OPNID(SEBLKPL1)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             RETURN
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
