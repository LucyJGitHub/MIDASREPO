/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR Switchable feature init for CAP023')         */
/*********************************************************************/
/*                                                                   */
/*       Midas ABS - European Reporting - Italy                      */
/*                                                                   */
/*       IRC0105 - IR Daily Postings Extract                         */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti Internalitonal 1997.             */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. MBV006             Date 06Jun08              */
/*                      UIT021             Date 10FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       MBV006 - Extract Loan IQ transactions                       */
/*       UIT021 - Bank of Italy Monthly Reporting                    */
/*                                                                   */
/*********************************************************************/

/***  Start Program.  ***/
             PGM        PARM(&CNAM &CSEQ)

/***  Declare variable.  ***/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&IRPSTI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('UIT021')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTCPY) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Copyright Midas-Kapiti International LTD. 1997')
             DCLF       FILE(SDMMODPD)
             RCVF

/***  Global monitor message.  ***/
             MONMSG     MSGID(CPF0000 CPI0000 CPA0000 MCH0000 +
                          RPG0000) EXEC(GOTO CMDLBL(ERROR))

/***  Execute this processing only if BOI Monthly Reporting is switch on  ***/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ENDPGM))


 CHECKDTA:   CHKOBJ     OBJ(IRSTAT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ERROR))
             ALCOBJ     OBJ((IRSTAT *DTAARA *EXCLRD)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(CHECKDTA))

/***  Send execution message.  ***/
             SNDPGMMSG  MSG('IRC0105 - Daily Posting Extract') +
                          TOMSGQ(MRUNQ)

/***  Call CB0150 to indicated that RPG will run.  ***/
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
                                                                                          /*MBV006*/
/**   Add postings from Loan IQ                ***/                                       /*MBV006*/
                                                                                          /*MBV006*/
             CPYF       FROMFILE(BVIRDPSTPD) TOFILE(IRAPOSPD) +
                          MBROPT(*ADD)                                                    /*MBV006*/
             CLRPFM     FILE(BVIRDPSTPD)                                                  /*MBV006*/

/***  PROCESS NEXT MONTH'S POSTINGS  ***/

/***  Retrieve data area IRSTAT with Bank of Italy Postings flag  ***/
             RTVDTAARA  DTAARA(IRSTAT (9 1)) RTNVAR(&IRPSTI)
             IF         COND(&IRPSTI = Y) THEN(DO)
                   CPYF       FROMFILE(IRNMPSPD) TOFILE(IRDPSTPD) +
                              MBROPT(*REPLACE)
                   MONMSG     MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                              FILE(IRDPSTPD))
                   ENDDO
             ELSE       CMD(CLRPFM FILE(IRDPSTPD))

/***  Call the pgm daily postings extract  ***/
             CHGDTAARA  DTAARA(IRSTAT (1 1)) VALUE('Y')
             CHGJOB     SWS(00000000)
             CALL       PGM(IR0105)

/***  U7 on and U8 off : program or file error.  ***/
             IF         COND(%SWITCH(XXXXXX10)) THEN(SNDPGMMSG +
                          MSG('IR0105 - JOB TERMINATED - PROGRAM +
                          ERROR') TOMSGQ(MRUNQ MOPERQ))

/***  U7 and U8 on : database error.  ***/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('IR0105 - JOB TERMINATED - DATABASE +
                          ERROR') TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO

/***  If no errors, copy daily file to monthly file,   ***/
/**   reset postings indicator & exit program  ***/

 NOERROR:    IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CPYF       FROMFILE(IRDPSTPD) TOFILE(IRMPSTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(IRNMPSPD)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(IRSTAT (9 1)) VALUE('N')
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((IRSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000)

/***  Call CB0150 to indicate normal end of program.  ***/
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

             GOTO       CMDLBL(ENDPGM)
             ENDDO

 ERROR:      DMPCLPGM
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSG('IRC0105 - JOB TERMINATED - PROGRAM +
                          ERROR') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

/**/
 ENDPGM:     CHGVAR     VAR(&ACTCPY) VALUE('Copyright Midas-Kapiti')
             RCLRSC
             ENDPGM
