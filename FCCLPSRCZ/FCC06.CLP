/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FC Reset Periodic file date/ICI d/a')           */
    /*****************************************************************/
    /*                                                               */
    /*  Midas - Report Control Facility Module               */
    /*                                                               */
    /*  FCC06 - RCF FILE/DATA AREA RESET FOR PERIODICS               */
    /*                                                               */
    /*   (c) Finastra International Limited 2001                     */
    /*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
    /*       PREV AMEND.NO.                  DATE 00/00/00           */
    /*                                       DATE 00/00/00           */
    /*                                                               */
    /*   MD046248 - Finastra Rebranding                              */
    /*****************************************************************/
    /*                                                               */
    /*  THIS PROGRAM CALLS RPG PROG FC0020 TO RESET LAST ACTIVE DATE */
    /*  OF A PERIODIC REQUEST. IT ALSO RESETS THE INPUT CYCLE INIT   */
    /*                  DATAAREA TO BLANK                            */
    /*                                                               */
    /*****************************************************************/
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGDTAARA  DTAARA(FCC01) VALUE(' ')
 
             CALL       PGM(FC0020)
 
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       ABNOR
             ENDDO
 
             GOTO       CMDLBL(THEEND)
    /*                                                              */
 ABNOR:      SNDPGMMSG  MSG('R.C.F Periodic Requests Reset - +
                          Terminated Abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(THEEND))
 THEEND:     ENDPGM
