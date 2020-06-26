/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE CO Automatic Allocation Processing')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC7550 - SE CO Automatic Allocation Processing             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       LAST Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      149378             Date 03Dec98              */
/*                      CSE007  *CREATE    Date 12Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       149378 - Allocation problems: allow restart in case of lock */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PCORF &PBRCD &PDDPT &POPTN &PNSEC +
                          &PBOOK &PCNUM &PPTFR)

/* Declare PGM Variables */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PCORF)  TYPE(*CHAR) LEN(6)   /* CO Refernce */
             DCL        VAR(&PBRCD)  TYPE(*CHAR) LEN(3)   /* Branch Code */
             DCL        VAR(&PDDPT)  TYPE(*CHAR) LEN(6)   /* Depot */
             DCL        VAR(&POPTN)  TYPE(*CHAR) LEN(2)   /* Option Number */
             DCL        VAR(&PNSEC)  TYPE(*CHAR) LEN(10)  /* New Security */
             DCL        VAR(&PBOOK)  TYPE(*CHAR) LEN(2)   /* Book Code */
             DCL        VAR(&PCNUM)  TYPE(*CHAR) LEN(6)   /* Customer Number */
             DCL        VAR(&PPTFR)  TYPE(*CHAR) LEN(4) /* Portfolio Ref. */
/***         DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)              /*149378*/
/***         DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(10)             /*149378*/

/* Global monitor message */

 /********** MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
 /**********              CMDLBL(ABNOR))                             /*149378*/

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*USE)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(QTEMP/LDA) VALUE(' ')

/* Reset Switches */

             CHGJOB     SWS(XXXXXX00)

/* Start commitment control */

/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE)                        /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*NONE) CMTSCOPE(*JOB)         /*CPK009*/

             SNDPGMMSG  MSG('SEC7550 - SE CO Automatic Allocation +
                          Processing') TOMSGQ(MRUNQ)

/* Do Security Copies of updated files */

/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)         /*149378*/
/**********  CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *TCAT 'DMLIB')     /*149378*/

/**********  CPYF       FROMFILE(&DMLIB/SECOALPD) +
/**********               TOFILE(QTEMP/SECOALPD) CRTFILE(*YES)    +  /*149378*/
/**********               /* CO Allocation file */                   /*149378*/

/**********  CPYF       FROMFILE(&DMLIB/SECODPPD) +
/**********               TOFILE(QTEMP/SECODPPD) CRTFILE(*YES)    +  /*149378*/
/**********               /* CO Depots file */                       /*149378*/

/**********  CPYF       FROMFILE(&DMLIB/SECODRPD) +
/**********               TOFILE(QTEMP/SECODRPD) CRTFILE(*YES)    +  /*149378*/
/**********               /* CO Depots Reference file */             /*149378*/

/* Call RPG/SE7550 - SE CO Automatic Allocation Processing */

             CALL       PGM(SE7550) PARM(&PCORF &PBRCD &PDDPT &POPTN +
                          &PNSEC &PBOOK &PCNUM &PPTFR)

/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CHGVAR VAR(&MEM) VALUE('SEC7550 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

 ABNOR:

             CHGJOB     SWS(XXXXXX11)

/* Abnormal termination */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC7550 - SE CO Automatic Allocation +
                          Processing ended abnormally - see job +
                          log') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
