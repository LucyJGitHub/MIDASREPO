/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('Midas SE Pos Sett Unauthorised/Auth Today Rpt')       */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                          */
/*                                                                  */
/********SECH024*-*Position*Settlement*Unauthorised/Authorised*******/                   /*HUT105*/
/*       XXC105024 - Position Settlement Unauthorised/Authorised    */                   /*HUT105*/
/*                 Today Report (I/C)                               */
/*                                                                  */
/********(c)*Misys*International*Banking*Systems*Ltd.*2008***********/                   /*HUT105*/
/*       (c) Finastra International Systems Ltd. 2020               */                   /*HUT105*/
/*                                                                  */
/*       Last Amend No. HUT105            Date 07Apr20              */
/*       Prev Amend No. HUT011  *CREATE   Date 12May08              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       HUT105 - Bulk Position Settlement Authorisation            */
/*                (Upgrade HUT011/015 to FM2.1 SP22)                */
/*       HUT011 - Bulk Position Settlement Authorisation            */
/*                                                                  */
/********************************************************************/

             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)

             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RETRN7) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200) VALUE(' ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50) VALUE(' ')
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Misys Banking Systems Ltd. +
                          2008')                                  */                      /*HUT105*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) Copyright +
                          Finastra International Systems Ltd. 2020') /*HUT105*/

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* ensure dataarea QTEMP/LDA Exists */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(00000000)

/**ensure*feature*HUT011*is*active**/                                                     /*HUT105*/
/* ensure feature HUT105 is active */                                                     /*HUT105*/

   /*        CALL       PGM(AOSARDR0) PARM(&RETRN7 '*VERIFY' +
                          'HUT011' &FMT200)                                   */          /*HUT105*/
             CALL       PGM(AOSARDR0) PARM(&RETRN7 '*VERIFY' 'HUT105' &FMT200) +
                          /*HUT105*/

             IF         COND(&RETRN7 *NE '       ') THEN(GOTO +
                          CMDLBL(END))

/* call Report Program */

/*           CLRPFM     FILE(POSETDX4)                                */                  /*HUT105*/
/*           CALL       PGM(SEH024) PARM(&RSEQ &RPARM)                */                  /*HUT105*/
             CLRPFM     FILE(XXPOSEX4) /*HUT105*/
             CALL       PGM(XX105024) PARM(&RSEQ &RPARM) /*HUT105*/

/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

ABNOR:
             CHGJOB     SWS(XXXXXX11)
/*           SNDPGMMSG  MSG('SECH024 - Position Settlement Unauthorised +
                          or Authorised Today Report ended abnormally +
                          - see joblog') TOMSGQ(MRUNQ MOPERQ)               */            /*HUT105*/
             SNDPGMMSG  MSG('XXC105024 - Position Settlement Unauthorised or +
                          Authorised Today Report ended abnormally - see joblog') +
                          TOMSGQ(MRUNQ MOPERQ) /*HUT105*/

/*END:         CHGVAR     VAR(&CPYFLD) VALUE('Copyright Misys Banking +
                          Systems Ltd.')   */                                             /*HUT105*/
 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Finastra International +
                          Systems Ltd. 2020') /*HUT105*/
             MONMSG     MSGID(CPF0000)

             ENDPGM
