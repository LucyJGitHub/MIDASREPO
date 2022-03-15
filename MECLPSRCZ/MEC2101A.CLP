/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages report')                      */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC2101A - Outgoing messages report - COB                  */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. 250674             Date 10Mar22              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       250674 - Condition Call to MEC0810 by Branch.              */
/*                Add Call to MEC0810 for MT100 only                */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
             PGM

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBIN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY SDCPYSRC,SDSVALDCL                                         */                     /*250674*/

/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)

/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing messages report') TOMSGQ(MRUNQ)

/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)

/* Access data area rundat for the Multibranching indicator */
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)

/* Obtain RUNDAT in YYMMDD format */
             CALL       PGM(ZM0080) PARM(&RUNDAT &FORMAT)

/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO

/* Set parmeters used to call MEC0810 */
             CHGVAR     VAR(%SST(&PARM 15 3)) VALUE('***')
             CHGVAR     VAR(%SST(&PARM 18 4)) VALUE('1234')
             CHGVAR     VAR(%SST(&PARM 23 6)) VALUE(&RUNDAT)
             CHGVAR     VAR(%SST(&PARM 29 6)) VALUE(&RUNDAT)

/*/COPY WNCPYSRC,MEC2101A01                                          */
/* Call MEC0810 (Outgoing message details report - System level) */
             CALL       PGM(MEC0810) PARM('   ' 'S' '   ' &PARM)
/*/COPY WNCPYSRC,MEC2101A02                                          */

/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO

/* If system is multibranched then produce branch 'ALL' report */

    IF     COND(&MBIN = 'Y') THEN(DO)

/* Get System Value for MultiBranchALL and GenerateMT100Report*/                          /*250674*/

              CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                         'MultiBranchALL' &SVAL1 +
                         'GenerateMT100Report' &SVAL2 +
                         ' ' &SVAL3 +
                         ' ' &SVAL4 +
                         ' ' &SVAL5 +
                         ' ' &SVAL6 +
                         ' ' &SVAL7 +
                         ' ' &SVAL8 +
                         ' ' &SVAL9 +
                         ' ' &SVAL10)                                                     /*250674*/

               IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                            CMDLBL(ERR))                                                  /*250674*/

             IF     COND(&SVAL1 = 'Y') THEN(DO)                                           /*250674*/
/**Call*MEC0810*(Outgoing*message*details*report*-*System*level)**/                       /*250674*/
/* Call MEC0810 (Outgoing message details report - Branch level) */                       /*250674*/
             CALL       PGM(MEC0810) PARM('   ' 'B' 'ALL' &PARM)

/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
             ENDDO                                                                        /*250674*/
    ENDDO

             IF     COND(&SVAL2 = 'Y') THEN(DO)                                           /*250674*/
/* Call MEC0810 (Outgoing message details report - System level/MT100 Only) */            /*250674*/
             CHGVAR     VAR(%SST(&PARM 15 3)) VALUE('100')                                /*250674*/
             CALL       PGM(MEC0810) PARM('   ' 'S' '   ' &PARM)                          /*250674*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*250674*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                             /*250674*/
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)                                              /*250674*/
             ENDDO                                                                        /*250674*/
             ENDDO                                                                        /*250674*/

             GOTO END
 ERR:        SNDPGMMSG  MSG('Outgoing messages report COB +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)

 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
