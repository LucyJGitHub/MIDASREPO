/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Agency Trade Settlement')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC4321 - Agency Trades Settlement                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE039  *CREATE    Date 18Mar03              */
/*                      xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*********************************************************************/
/*      CCB020 - COB Restructure - Secondary COB Infrastructure      */
/*      CSE039 - Automatic Settlement of Trades                      */
/*********************************************************************/
             PGM        PARM(&DTAARA)
 
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DTAARA) VALUE('SEC4320')
 
/* Check for Switchable feature CSE039. */
             CALL       PGM(AOSARDR0) PARM(&CSE039 '*VERIFY' +
                          'CSE039' &AOFMT)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE(Y)
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 
LOOP:
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT Phase Check  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
/**********  IF         ((%SST(&MPHAS 1 1)) *NE 'A') THEN(DO)                          */ /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
                SNDPGMMSG  MSG('AGENCY TRADE SETTLEMENT NOW COMPLETE') +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             CALL       PGM(SE4320)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE('N')
                GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                DLYJOB     DLY(120)
                GOTO       CMDLBL(LOOP)
             ENDDO
             GOTO       CMDLBL(END)
 
ABNOR:
             SNDPGMMSG  MSG('SEC4320 - Agency Trade Settlement pgm +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGDTAARA  DTAARA(&DTAARA (1 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
