/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Logical Acknowledgements Enquiry')              */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                             */
/*                                                                   */
/*     MSC1010 - LOGICAL ACKNOWLEDGEMENTS ENQUIRY                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01310             Date 06Dec90              */
/*                      S01259             Date 20Aug90              */
/*                NO. S01194            DATE  24APR90                */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5005 else call MS1010          */
/*     S01194 - STANDING DATA CHANGES.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/* Declare Message Detail Field.                                    */
/*                                                                  */
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)           /*S01310S01194*/
             DCL        VAR(&MEM2) TYPE(*CHAR) LEN(50)                /*S01259*/
/************DCL        VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                   */
/* Set-off Data Base Error Switches.                                 */
/*                                                                   */
             CHGJOB     SWS(XXXXXX00)
/*                                                                   */
/* Call Input Cycle Enquiry Program.                                */
/*                                                                  */
/************RTVDTAARA  DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*call*MS5005                                  /*S01259S01310*/
/************IF*COND(&SWII* EQ 'Y') THEN(DO)                    /*S01259S01310*/
                CALL PGM(MS5005)                                      /*S01259*/
                                                                      /*S01259*/
/* For Database Errors Recover Data From Local Data Area, Send        /*S01259*/
/* Message to MOPERQ.                                                 /*S01259*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)                      /*S01259*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM2)         /*S01259*/
                SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM2) +
                TOPGMQ(*EXT) TOMSGQ(MOPERQ)                           /*S01259*/
                ENDDO                                                 /*S01259*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*off*call*MS1010                                 /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/************CALL*******PGM(MS1010)                                   /*S01310*/
/************                                                   /*S01194S01310*/
/************CHGVAR VAR(&BISCPY) VALUE('COPYRIGHT MKI')         /*S01194S01310*/
/**************************                                           /*S01310*/
/**For*Database*Errors*Recover Data From Local Data Area, Send        /*S01310*/
/**Message*to*MOPERQ.******                                           /*S01310*/
/**************************                                           /*S01310*/
/************IF*********COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01310*/
/****************RTVDTAARA* DTAARA(LDA (134 44)) RTNVAR(&MEM)         /*S01194*/
/****************RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)   /*S01194S01310*/
/****************SNDPGMMSG* MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) + /*S01310*/
/**************************   TOPGMQ(*EXT) TOMSGQ(MOPERQ)             /*S01310*/
/************ENDDO*********                                           /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('S.W.I.F.T. Logical Acknowledgements +
                          Enquiry ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
