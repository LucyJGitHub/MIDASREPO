/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Reset DL confirmations active flag')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     DEALING  MODULE                                   */
/*                                                                   */
/********DLC0210F-RESET*BUSY*FLAG*IN*DLSTAT*****                     */
/*   DLC0210F - RESET 'DEALING CONFIRMATIONS ACTIVE' FLAG ON DLSTAT  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 079445             DATE 02DEC94              */
/*       PREV AMEND NO. E14914             17/07/89                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       079445 - Include in Release 10                              */
/*                Amend pgm to use Midas Info Screen                 */
/*       E14914 - NEW PROGRAM                                        */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*079445*/
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(30)
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
                                                                      /*079445*/
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'Y') THEN(DO)
/************SNDUSRMSG**MSG('Batch confirmations terminated.Is the +
/***********************  problem rectified? Please enter Y or N') +
/***********************  VALUES(Y N) MSGTYPE(*INQ) MSGRPY(&REPLY)     *079445*/
                                                                      /*079445*/
/*  DISPLAY MIDAS INFORMATION SCREEN                          */      /*079445*/
                CHGVAR     VAR(&REPLY) VALUE('N')                     /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE('''Dealing +
                          Confirmations Active'' flag is ''Y''')      /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE('If the +
                          dealing confirmations print job has')       /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE('terminated +
                          abnormally for any reason, take  ''Y''')    /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE('to reset +
                          ''Dealing Confirmations Active'' flag')     /*079445*/
             CALL       PGM(SCC0010) PARM('DLC0210F' 'OPTION' +
                          &REPLY)                                     /*079445*/
 
             IF         COND(&REPLY *EQ 'Y') THEN(DO)
                CHGVAR     VAR(%SUBSTRING(&DLSTAT 6 1)) VALUE(N)
                CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)
             ENDDO
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             ELSE       CMD(DO)                                       /*079445*/
                                                                      /*079445*/
/*  DISPLAY MIDAS INFORMATION SCREEN                          */      /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE('''Dealing +
                          Confirmations Active'' flag is not ''Y''')  /*079445*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE('No further +
                          action required')                           /*079445*/
             CALL       PGM(SCC0010) PARM('DLC0210F' 'ENTER' ' ')     /*079445*/
             ENDDO                                                    /*079445*/
/************ELSE       CMD(SNDPGMMSG MSG('Batch confirmations print + *079445*/
/************             had not terminated') TOPGMQ(*EXT))           *079445*/
                                                                      /*079445*/
 ENDPGM:     DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
