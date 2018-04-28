/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facility Currency Amount Initialisation')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/********LEC0011I*-*LE*FACILITY*CURRENCY*AMOUNT*INITIALISATION********/                   /*CLE106*/
/*       LEC0027  - LE Facility Currency Amount Initialisation       */                   /*CLE106*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE106             Date 01Aug04              */
/*       Prev Amend No. 223803  *CREATE    Date 23Dec03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE106 - Renamed LEC0017 and LE0017 to LEC0027 and LE0027   */
/*                respectively since LEC0017 and LE0017 aready exist */
/*                in core library.                                   */
/*       223803 - Initialise facility currency principal amount      */
/*                for main loans against non-revolving credit        */
/*                facilities                                         */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351)
 
/**********     CALL       PGM(LE0017)                               */                   /*CLE106*/
                CALL       PGM(LE0027)                                                    /*CLE106*/
 
             ENDCMTCTL
             MONMSG     MSGID(CPF8350)
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
 
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
/********* ABNOR:      SNDPGMMSG  MSG('Program LEC0017 ended abnormally')   +
                          TOPGMQ(*EXT)                               */                   /*CLE106*/
 ABNOR:      SNDPGMMSG  MSG('Program LEC0027 ended abnormally')   +
                          TOPGMQ(*EXT)                                                    /*CLE106*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
