/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Position Settlement Authorised Today Rpt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/********SECH025 - Midas SE Position Settlement Authorised Today Rpt */                  /*HUT105*/
/*       XXC105025 - Midas SE Position Settlement Auth Today Rpt     */                  /*HUT105*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2008************/                  /*HUT105*/
/*       (c) Finastra International Systems Ltd. 2020                */                  /*HUT105*/
/*                                                                   */
/*       Last Amend No. HUT105             Date 07Apr20              */
/*       Prev Amend No. HUT011  *CREATE    Date 12May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT105 - Bulk Position Settlement Authorisation             */
/*                (Upgrade HUT011 to FM2.1 SP20)                     */
/*       HUT011 - Bulk Position Settlement Authorisation             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2008')                                              */         /*HUT105*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Systems Ltd. 2020') /*HUT105*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(00000000) /*HUT105*/

/*           CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)       */                     /*HUT105*/

/*           IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ERR02))                          */                     /*HUT105*/

 /*          IF         COND(&STAT *EQ 'N') THEN(DO)               */                    /*HUT105*/

/*              CLRPFM     FILE(POSETDX4)                                     */         /*HUT105*/
                CLRPFM     FILE(XXPOSEX4) /*HUT105*/
             CHGVAR     VAR(%SST(&PARM 1 5)) VALUE(&CSEQ)
/*           CALL       PGM(SEH024) PARM(&CSEQ &PARM)                         */         /*HUT105*/
             CALL       PGM(XX105024) PARM(&CSEQ &PARM) /*HUT105*/

/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*           SNDPGMMSG  MSG('JOB TERMINATED - SEH024') TOMSGQ(MRUNQ +
                          MOPERQ)             */                                         /*HUT105*/
                SNDPGMMSG  MSG('JOB TERMINATED - XX105024') TOMSGQ(MRUNQ MOPERQ) +
                             /*HUT105*/
                GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*           SNDPGMMSG  MSG('JOB ENDED NORMALLY - SEH024') TOMSGQ(MRUNQ +
                          MOPERQ)                                          */            /*HUT105*/
                SNDPGMMSG  MSG('JOB ENDED NORMALLY - XX105024') TOMSGQ(MRUNQ +
                             MOPERQ) /*HUT105*/
             GOTO       CMDLBL(END)
             ENDDO

 /*          ENDDO                */                                                     /*HUT105*/

/* Error in CB0160 */

/*ERR02:       CHGVAR     VAR(&MSG) VALUE('Component SECH025 +
                        sequence 00001 is not set up.  Data Base +
                        error in program CB0160 database CBCOMSPD')            */        /*HUT105*/
 ERR02:      CHGVAR     VAR(&MSG) VALUE('Component XXC105025 sequence 00001 is not +
                          set up.  Data Base error in program CB0160 database +
                          CBCOMSPD') /*HUT105*/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(END)

/* Abnoral termination */

ABNOR:
            CHGJOB SWS(XXXXXX11)

END:
/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')             */      /*HUT105*/
            CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Systems Ltd. +
                         2020.') /*HUT105*/


             ENDPGM
