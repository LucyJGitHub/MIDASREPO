/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Pos Sett Authorised Over Blk CR A/C Rep')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/********SECH030 - SE Positions Settlements Authorised Over Blocked  */                  /*HUT111*/
/*       XXC111030 - SE Positions Settlements Authorised Over Blocked*/                  /*HUT111*/
/*                 Credit A/C Report                                 */
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2016************/                  /*HUT111*/
/*       (c) Finastra International Systems Ltd. 2020                */                  /*HUT111*/
/*                                                                   */
/*       Last Amend No. HUT111             Date 08Apr20              */
/*       Prev Amend No. HUT024  *CREATE    Date 17Oct16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT111 - Corporate Actions Blocked Credit Account           */
/*                (Upgrade HUT024 to FM2.1 SP22)                     */
/*       HUT024  Corporate Actions Blocked Credit Account           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2016')                 */                                      /*HUT111*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Systems Ltd. 2020') /*HUT111*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5) VALUE(' ')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Ensure dataarea QTEMP/LDA Exists */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF0000)

             CHGJOB     SWS(00000000)

 /*          CALL       PGM(SEH030) PARM(&SEQ)          */                               /*HUT111*/
             CALL       PGM(XX111030) PARM(&SEQ) /*HUT111*/

/* Database error processing */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*                SNDPGMMSG  MSG('JOB TERMINATED - SECH030') TOMSGQ(MRUNQ MOPERQ) */     /*HUT111*/
                SNDPGMMSG  MSG('JOB TERMINATED - XXC111030') TOMSGQ(MRUNQ MOPERQ) +
                             /*HUT111*/
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*              CLRPFM     FILE(SEPOBCPP)              */                                /*HUT111*/
                CLRPFM     FILE(XXPOBCTD) /*HUT111*/
/*           SNDPGMMSG  MSG('JOB ENDED NORMALLY - SECH030') TOMSGQ(MRUNQ +
                          MOPERQ)        */                                              /*HUT111*/
                SNDPGMMSG  MSG('JOB ENDED NORMALLY - XXC111030') TOMSGQ(MRUNQ +
                             MOPERQ) /*HUT111*/
             GOTO       CMDLBL(END)
             ENDDO

/* Abnoral termination */
ABNOR:
            CHGJOB SWS(XXXXXX11)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')          */         /*HUT111*/
            CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Systems Ltd. +
                         2020') /*HUT111*/


             ENDPGM
