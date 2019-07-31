/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Early Redemption Summary List')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6810 - SE Early Redemption Summary List                  */
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
/*       Prev Amend No. S01496             Date 12Oct94              */
/*                      S10978             Date 07Apr93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978  -  JYSZRH: EARLY REDEMPTIONS                        */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&STATUS &LSTIND &RTCD)                */ /*S01496*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01496*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01496*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01496*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01496*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01496*/
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LSTIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
 
             DCLF       FILE(SEERRFL1)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/**/                                                                  /*S01496*/
/**  Get status and last allocation indicator from RPARM */           /*S01496*/
/**/                                                                  /*S01496*/
             CHGVAR     VAR(&STATUS) VALUE(%SST(&RPARM 1 1))          /*S01496*/
             CHGVAR     VAR(&LSTIND) VALUE(%SST(&RPARM 2 1))          /*S01496*/
/**/                                                                  /*S01496*/
 
             IF COND(&STATUS *NE '*' *AND &LSTIND *EQ '*') THEN(DO)
/***********     OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAERST *EQ "' *TCAT +
/***********                &STATUS *TCAT '"')                     */ /*S01496*/
             OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAERST *EQ "' *TCAT +
                          &STATUS *TCAT '"') KEYFLD((VAERRF))         /*S01496*/
             ENDDO
 
             ELSE       CMD(IF COND(&STATUS *EQ '*' *AND &LSTIND *NE +
                          '*') THEN(DO))
/*********** OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAFAID *EQ "' *TCAT +/*S01496*/
/***********              &LSTIND *TCAT '"')                       */ /*S01496*/
             OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAFAID *EQ "' *TCAT +
                          &LSTIND *TCAT '"') KEYFLD((VAERRF))         /*S01496*/
             ENDDO
 
             ELSE       CMD(IF COND(&STATUS *NE '*' *AND &LSTIND *NE +
                          '*') THEN(DO))
/*********** OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAERST *EQ "' *TCAT +/*S01496*/
/***********              &STATUS *TCAT '"' *BCAT '*AND VAFAID *EQ +  /*S01496*/
/***********              "' *TCAT &LSTIND *TCAT '"')              */ /*S01496*/
             OPNQRYF    FILE((SEERRFL1)) QRYSLT('VAERST *EQ "' *TCAT +
                          &STATUS *TCAT '"' *BCAT '*AND VAFAID *EQ +
                          "' *TCAT &LSTIND *TCAT '"') +
                          KEYFLD((VAERRF))                            /*S01496*/
             ENDDO
 
             ELSE       CMD(IF COND(&STATUS *EQ '*' *AND &LSTIND *EQ +
                          '*') THEN(DO))
/*********** OPNQRYF    FILE((SEERRFL1))                           */ /*S01496*/
             OPNQRYF    FILE((SEERRFL1)) KEYFLD((VAERRF))             /*S01496*/
             ENDDO
 
/*********** CALL       PGM(SE6810) PARM(&RTCD &STATUS &LSTIND)    */ /*S01496*/
             CALL       PGM(SE6810) PARM(&RTCD &STATUS &LSTIND &RSEQ) /*S01496*/
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
/***********                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6810 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             CLOF       OPNID(SEERRFL1)
             RETURN
 
 ERROR:      RCVMSG     MSGTYPE(*LAST) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          MSGTYPE(*ESCAPE)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
