/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Historic Transactions Enquiry')              */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0303  -  HISTORIC TRANSACTION ENQUIRY CL CONTROL PGM         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSD027B            Date 23Jun06              */
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      130611             Date 30Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      133487             Date 06Apr00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  CFF004             DATE 18SEP96                  */
/*                  096093             DATE 17JAN96                  */
/*                  086733             DATE 21JUN95                  */
/*                  082478             DATE 01FEB95                  */
/*                  S01332             DATE 17MAY91                  */
/*                  S01117             DATE 30MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSD027B - Change customer number to alpha                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   130611 - Complete CFF004                                        */
/*   133487 - Program ends abnormally due to incorrect passing       */
/*            of paramater. Field &RSTP is left blank and not        */
/*            considered by program.                                 */
/*   CFF004  -  Increase in size of Price Fields                     */
/*   096093  -  Selection not working if strike price not used       */
/*   086733  -  Selection not working                                */
/*   082478  -  Define &RSTP (strike price) as a character field, as */
/*              the strike price of an option can be quoted in ticks */
/*              (-) as well as decimals - if the instrument is a     */
/*              future, initialise this field to '0' for QRYSLT      */
/*           -  Produce dump if abnormal termination                 */
/*   S01332  -  Amended for Exposure Management Release 10 to bypass */
/*              FF0700 if pgm called via stack                       */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                  */
/*   DECLARE VARIABLES                                              */
/*                                                                  */
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
/*********** DCL        VAR(&RBRCD) TYPE(*DEC) LEN(3 0)            */ /*S01117*/
             DCL        VAR(&RBRCA) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&RINST) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RMON) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RYER) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RPCL) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&RSTP) TYPE(*CHAR) LEN(12)        /*082478**CFF004*/
             DCL        VAR(&RSTP) TYPE(*CHAR) LEN(16)                /*CFF004*/
/************DCL        VAR(&RSTP) TYPE(*DEC) LEN(11 7)               /*082478*/
/************DCL        VAR(&RSTPN) TYPE(*DEC) LEN(11 7)      /*096093**CFF004*/
             DCL        VAR(&RSTPN) TYPE(*DEC) LEN(15 8)              /*CFF004*/
             DCL        VAR(&RCUSF) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&RCUS) TYPE(*DEC) LEN(6 0)                                 */ /*CSD027*/
             DCL        VAR(&RCUS) TYPE(*CHAR) LEN(6)                                     /*CSD027*/
             DCL        VAR(&RBRKF) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&RBRK) TYPE(*DEC) LEN(6 0)                                 */ /*CSD027*/
             DCL        VAR(&RBRK) TYPE(*CHAR) LEN(6)                                     /*CSD027*/
             DCL        VAR(&RBOK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RDNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LDYNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RUNA) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&BLANK) TYPE(*CHAR) LEN(256)
/*                                                                  */
             DCL        VAR(&SLCT) TYPE(*CHAR) LEN(256)
/*********** DCL        VAR(&SLCT1) TYPE(*CHAR) LEN(14)  +         */ /*S01117*/
/**********             VALUE('(BRCD *EQ    )')                    */ /*S01117*/
             DCL        VAR(&SLCT1) TYPE(*CHAR) LEN(16)  +
                        VALUE('(BRCA *EQ "   ")')                     /*S01117*/
             DCL        VAR(&SLCT2) TYPE(*CHAR) LEN(18)  +
                        VALUE('(ISTT *EQ "     ")')
             DCL        VAR(&SLCT3) TYPE(*CHAR) LEN(13)  +
                        VALUE('(MTHN *EQ   )')
             DCL        VAR(&SLCT4) TYPE(*CHAR) LEN(13)  +
                        VALUE('(YRNO *EQ   )')
             DCL        VAR(&SLCT5) TYPE(*CHAR) LEN(14)  +
                        VALUE('(PCAL *EQ " ")')
             DCL        VAR(&SLCT6) TYPE(*CHAR) LEN(23)  +
                        VALUE('(STRP *EQ             )')
/**********  DCL        VAR(&SLCT7) TYPE(*CHAR) LEN(17)  +                             */ /*CSD027*/
/**********             VALUE('(CUSC *EQ       )')                                     */ /*CSD027*/
             DCL        VAR(&SLCT7) TYPE(*CHAR) LEN(19)  +
                        VALUE('(CUSC *EQ "      ")')                                      /*CSD027*/
             DCL        VAR(&SLCT8) TYPE(*CHAR) LEN(17)  +
                        VALUE('(BOCO *EQ       )')
             DCL        VAR(&SLCT9) TYPE(*CHAR) LEN(15)  +
                        VALUE('(BOKC *EQ "  ")')
/**********  DCL        VAR(&DATA)  TYPE(*CHAR) LEN(80)                        /*S01332*/ /*CGL029*/
             DCL        VAR(&DATA)  TYPE(*CHAR) LEN(86)                                   /*CGL029*/
             DCL        VAR(&RQDTD) TYPE(*CHAR) LEN(2)               /*S01332*/
             DCL        VAR(&RSTI) TYPE(*CHAR) LEN(1)                /*S01332*/
             DCL        VAR(&RFOI) TYPE(*DEC) LEN(1)                 /*S01332*/
             DCL        VAR(&PGN1D)  TYPE(*CHAR) LEN(8)              /*S01332*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
                                                                     /*S01332*/
/*   IF POSITIONS 2 TO 9 ON DTAARA/EMSDS ARE BLANK, THIS IS THE   */ /*S01332*/
/*   FIRST ENQUIRY IN THE STACK, SO CLEAR DTAARA/EMSDS AND SET    */ /*S01332*/
/*   POSITIONS 2 TO 9 TO 'FFC0303' TO INDICATE THAT THIS IS FIRST */ /*S01332*/
/*   ENQUIRY IN STACK                                             */ /*S01332*/
                                                                     /*S01332*/
             RTVDTAARA DTAARA(EMSDS (2 8)) RTNVAR(&PGN1D)            /*S01332*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01332*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*S01332*/
                CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('FFC0303 ')     /*S01332*/
             ENDDO                                                   /*S01332*/
                                                                     /*S01332*/
/**********  RTVDTAARA  DTAARA(EMSDS (81 80)) RTNVAR(&DATA)                    /*S01332*/ /*CGL029*/
/**********  CHGVAR     VAR(&RQDTD) VALUE(%SST(&DATA 79 2))                    /*S01332*/ /*CGL029*/
             RTVDTAARA  DTAARA(EMSDS (81 86)) RTNVAR(&DATA)                               /*CGL029*/
             CHGVAR     VAR(&RQDTD) VALUE(%SST(&DATA 85 2))                               /*CGL029*/
                                                                     /*S01332*/
/* Do while first time and command 5 pressed                        */
/*                                                                  */
 DOW:        CHGJOB SWS(XXXX0000)
             CHGVAR VAR(&COUNT) VALUE(1)
             CHGVAR VAR(&SLCT) VALUE(&BLANK)
/*                                                                   /*S01332*/
/* If not called as part of stack call FF0700                        /*S01332*/
                                                                     /*S01332*/
             IF         COND(&RQDTD *EQ '  ') THEN(+
             DO)                                                     /*S01332*/
/**********  CHGDTAARA  DTAARA(EMSDS (159 2)) VALUE('  ')                      /*S01332*/ /*CGL029*/
             CHGDTAARA  DTAARA(EMSDS (165 2)) VALUE('  ')                                 /*CGL029*/
/*                                                                    *S01332*/
/*                                                                  */
/* Call HISTORIC TRANSACTION ENQUIRY PROGRAM FF0700                 */
/*                                                                  */
/******CALL      PGM(FF0700) PARM(&RBRCD &RINST &RMON &RYER +      */ /*S01117*/
/**********        &RPCL &RSTP &RCUSF &RCUS &RBRKF &RBRK &RBOK +   */ /*S01117*/
/**********        &RDNO &LDYNO &RUNA &DATF)                       */ /*S01117*/
/*******CALL       PGM(FF0700) PARM(&RBRCA &RINST &RMON &RYER +
/*******             &RPCL &RSTP &RCUSF &RCUS &RBRKF &RBRK &RBOK +
/*******             &RDNO &LDYNO &RUNA &DATF &MBIN)          /*S01117  096093*/
        CALL       PGM(FF0700) PARM(&RBRCA &RINST &RMON &RYER +
                     &RPCL &RSTPN &RCUSF &RCUS &RBRKF &RBRK &RBOK +
                     &RDNO &LDYNO &RUNA &DATF &MBIN)                  /*096093*/
             IF         COND(&RSTPN *NE 0) THEN(CHGVAR VAR(&RSTP) +
                          VALUE(&RSTPN))                              /*096093*/
             ELSE       CMD(CHGVAR VAR(&RSTP) VALUE('0'))             /*096093*/
             ENDDO                                                   /*S01332*/
/*                                                                   /*S01332*/
/* If called as part of stack update variables                       /*S01332*/
/*                                                                   /*S01332*/
             ELSE  IF   COND(&RQDTD *NE '  ') THEN(+
             DO)                                                     /*S01332*/
             CHGJOB     STSMSG(*NONE)                                /*S01332*/
/**********  CHGVAR     VAR(&RBRCA) VALUE(%SST(&DATA 25 3))     S01332 130611*/
             CHGVAR     VAR(&RBRCA) VALUE(%SST(&DATA 29 3))          /*130611*/
             CHGVAR     VAR(&RINST) VALUE(%SST(&DATA 1 5))           /*S01332*/
/**********  CHGVAR     VAR(&RPCL) VALUE(%SST(&DATA 18 1))      S01332 130611*/
/**********  CHGVAR     VAR(&RFOI) VALUE(%SST(&DATA 34 1))      S01332 130611*/
             CHGVAR     VAR(&RPCL) VALUE(%SST(&DATA 22 1))           /*130611*/
             CHGVAR     VAR(&RFOI) VALUE(%SST(&DATA 38 1))           /*130611*/
             IF   COND(&RFOI *GT 3) THEN(DO)                         /*S01332*/
/**********  CHGVAR     VAR(&RSTP) VALUE(%SST(&DATA 6 12))      S01332 130611*/
             CHGVAR     VAR(&RSTP) VALUE(%SST(&DATA 6 16))           /*130611*/
             IF   COND(&RSTP *EQ ' ') THEN(DO)                       /*133487*/
                  CHGVAR     VAR(&RSTP) VALUE('0')                   /*133487*/
             ENDDO                                                   /*133487*/
             ENDDO                                                   /*S01332*/
             ELSE       CMD(DO)                                      /*082478*/
             CHGVAR     VAR(&RSTP) VALUE('0')                        /*082478*/
             ENDDO                                                   /*082478*/
/**********  CHGVAR     VAR(&RBRKF) VALUE(%SST(&DATA 28 1))     S01332 130611*/
/**********  CHGVAR     VAR(&RMON) VALUE(%SST(&DATA 32 2))      S01332 130611*/
/**********  CHGVAR     VAR(&RYER) VALUE(%SST(&DATA 30 2))      S01332 130611*/
/**********  CHGVAR     VAR(&RSTI) VALUE(%SST(&DATA 29 1))      S01332 130611*/
             CHGVAR     VAR(&RBRKF) VALUE(%SST(&DATA 32 1))          /*130611*/
             CHGVAR     VAR(&RMON) VALUE(%SST(&DATA 36 2))           /*130611*/
             CHGVAR     VAR(&RYER) VALUE(%SST(&DATA 34 2))           /*130611*/
             CHGVAR     VAR(&RSTI) VALUE(%SST(&DATA 33 1))           /*130611*/
                                                                     /*S01332*/
             IF   COND(&RBRKF *NE 'Y') THEN(+
             DO)                                                     /*S01332*/
             CHGVAR     VAR(&RCUSF) VALUE('Y')                       /*S01332*/
/**********  CHGVAR     VAR(&RCUS) VALUE(%SST(&DATA 19 6))      S01332 130611*/
             CHGVAR     VAR(&RCUS) VALUE(%SST(&DATA 23 6))           /*130611*/
             ENDDO                                                   /*S01332*/
                                                                     /*S01332*/
             ELSE  IF   COND(&RBRKF *EQ 'Y') THEN(+
             DO)                                                     /*S01332*/
/**********  CHGVAR     VAR(&RBRK) VALUE(%SST(&DATA 19 6))      S01332 130611*/
             CHGVAR     VAR(&RBRK) VALUE(%SST(&DATA 23 6))           /*130611*/
             ENDDO                                                   /*S01332*/
                                                                     /*S01332*/
             ENDDO                                                   /*S01332*/
                                                                     /*S01332*/
/* If cmd/1 was pressed then end program                            */
/*                                                                  */
             IF  COND(%SWITCH(XXXXX1XX)) THEN(GOTO END)
/*                                                                  */
/* Check that no database error occured on previous program         */
/*                                                                  */
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                                                                  */
/* Set up query select parameters                                   */
/*                                                                  */
/*********** CHGVAR VAR(%SST(&SLCT1 11 3)) VALUE(&RBRCD)           */ /*S01117*/
             CHGVAR VAR(%SST(&SLCT1 12 3)) VALUE(&RBRCA)              /*S01117*/
/*********** CHGVAR VAR(%SST(&SLCT &COUNT 14)) VALUE(&SLCT1)       */ /*S01117*/
/*********** CHGVAR VAR(&COUNT) VALUE(&count + 15)                 */ /*S01117*/
             CHGVAR VAR(%SST(&SLCT &COUNT 16)) VALUE(&SLCT1)          /*S01117*/
             CHGVAR VAR(&COUNT) VALUE(&count + 17)                    /*S01117*/
/*                                                                  */
             IF  COND(&RINST *NE '     ') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT2 12 5)) VALUE(&RINST)
             CHGVAR VAR(%SST(&SLCT &COUNT 18)) VALUE(&SLCT2)
             CHGVAR VAR(&COUNT) VALUE(&count + 19)
             ENDDO
/*                                                                  */
             IF  COND(&RMON *NE 0) THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT3 11 2)) VALUE(&RMON)
             CHGVAR VAR(%SST(&SLCT &COUNT 13)) VALUE(&SLCT3)
             CHGVAR VAR(&COUNT) VALUE(&count + 14)
             ENDDO
/*                                                                  */
             IF  COND(&RMON *NE 0) THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT4 11 2)) VALUE(&RYER)
             CHGVAR VAR(%SST(&SLCT &COUNT 13)) VALUE(&SLCT4)
             CHGVAR VAR(&COUNT) VALUE(&count + 14)
             ENDDO
/*                                                                  */
             IF  COND(&RPCL *NE ' ') THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
             CHGVAR VAR(%SST(&SLCT5 12 1)) VALUE(&RPCL)
             CHGVAR VAR(%SST(&SLCT &COUNT 14)) VALUE(&SLCT5)
             CHGVAR VAR(&COUNT) VALUE(&count + 15)
             ENDDO
/*                                                                  */
/************IF  COND(&RSTP *NE 0) THEN(DO)                           /*082478*/
             IF  COND(&RSTP *NE '0') THEN(DO)                         /*082478*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT6 11 12)) VALUE(&RSTP)
             CHGVAR VAR(%SST(&SLCT &COUNT 23)) VALUE(&SLCT6)
             CHGVAR VAR(&COUNT) VALUE(&count + 24)
             ENDDO
/*                                                                  */
             IF  COND(&RCUSF *EQ 'Y') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/**********  CHGVAR VAR(%SST(&SLCT7 11 6)) VALUE(&RCUS)                                */ /*CSD027*/
/**********  CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT7)                           */ /*CSD027*/
/**********  CHGVAR VAR(&COUNT) VALUE(&count + 18)                                     */ /*CSD027*/
             CHGVAR VAR(%SST(&SLCT7 12 6)) VALUE(&RCUS)                                   /*CSD027*/
             CHGVAR VAR(%SST(&SLCT &COUNT 19)) VALUE(&SLCT7)                              /*CSD027*/
             CHGVAR VAR(&COUNT) VALUE(&count + 20)                                        /*CSD027*/
             ENDDO
/*                                                                  */
             IF  COND(&RBRKF *EQ 'Y') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT8 11 6)) VALUE(&RBRK)
             CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT8)
             CHGVAR VAR(&COUNT) VALUE(&count + 18)
             ENDDO
/*                                                                  */
             IF  COND(&RBOK *NE '  ') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT9 12 2)) VALUE(&RBOK)
             CHGVAR VAR(%SST(&SLCT &COUNT 15)) VALUE(&SLCT9)
             ENDDO
/*                                                                  */
             OVRDBF     FILE(TRANS9) SHARE(*YES)                      /*086733*/
             OPNQRYF FILE(TRANS9)                             +
                     OPTION(*INP)                             +
                     QRYSLT(&SLCT)                            +
                     KEYFLD( (TRSD *DESCEND)  TNBR)           +
                     OPTIMIZE(*FIRSTIO)                          +
                     SEQONLY(*NO    )
/*                                                                  */
/* Call FF0701                                                      */
/*                                                                  */
/*          CALL PGM(FF0701) PARM(&RDNO &LDYNO &RBRCD &RUNA &DATF) */ /*S01117*/
/************CALL PGM(FF0701) PARM(&RDNO &LDYNO &RBRCA &RUNA +     */
/************                      &DATF &MBIN)            /*S01117*/ /*S01332*/
             CALL PGM(FF0701) PARM(&RDNO &LDYNO &RBRCA &RUNA +
                                   &DATF &MBIN &RSTI &RINST) /*S01332*/
/*                                                                  */
             CLOF       OPNID(TRANS9)
             DLTOVR     FILE(TRANS9)                                  /*086733*/
/*                                                                  */
             IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                                                                  */
/**If*command*5*pressed*then*repeat*loop****/                        /*S01332*/
/* If cmd 12 pressed then repeat loop if not called via stack        /*S01332*/
/*                                                                  */
             IF         COND(&RQDTD *EQ '  ') THEN(+
             DO)                                                    /*S01332*/
             IF  COND(%SWITCH(XXXX1XXX)) THEN(GOTO DOW)
             ENDDO                                                  /*S01332*/
/*                                                                  */
/* If command 1 pressed then end program                            */
/*                                                                  */
             GOTO END
/*                                                                  */
/*     Database error processing. Send message to MOPERQ & WORKSTN  */
/*                                                                  */
 DBERR:
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT)
             GOTO END
/*                                                                  */
/*     Abnormal error processing. Message to MOPERQ MRUNQ & WORKSTN */
/*                                                                  */
 ABNOR:      SNDPGMMSG  MSG('Futures & Options Historic +
                           Transaction Enquiry ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     INQMSGRPY(*RQD) SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM                                                 /*082478*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082478*/
/*                                                                  */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                     /*S01332*/
/*   RESET POSITIONS 2 TO 9 ON EMSDS TO BLANK                     */ /*S01332*/
                                                                     /*S01332*/
             RTVDTAARA DTAARA(EMSDS (2 8)) RTNVAR(&PGN1D)            /*S01332*/
             IF COND(&PGN1D *EQ 'FFC0303 ') THEN(DO)                 /*S01332*/
             CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('        ')        /*S01332*/
             ENDDO
             CHGJOB     STSMSG(*NORMAL)                              /*S01332*/
             ENDPGM
/*                                                                  */
