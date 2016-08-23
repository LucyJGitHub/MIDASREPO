/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing payment messages by nostro')           */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                          */
/*                                                                  */
/*       MEC0820 - Outgoing payment messages by nostro report       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No.  BG18886          DATE 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  00000            DATE 00XXX00              */
/*                       00000            DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  BG18886 - Amend non-standard codes.                             */
/*                                                                  */
/********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from ME0815 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&MD) TYPE(*CHAR) LEN(2)   /* MODULE ID  */
             DCL        VAR(&NC) TYPE(*CHAR) LEN(3)   /* NOSTRO CCY */
             DCL        VAR(&NN) TYPE(*CHAR) LEN(2)   /* NOSTRO NO. */
             DCL        VAR(&NT) TYPE(*CHAR) LEN(6)   /* NETWORK    */
             DCL        VAR(&FD) TYPE(*CHAR) LEN(6)   /* FROM DATE  */
             DCL        VAR(&TD) TYPE(*CHAR) LEN(6)   /* TO DATE    */
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&MD2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&NC2)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FD2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TD2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
 
/* Used to control building of OPNQRYF command */
             DCL        VAR(&LGL)   TYPE(*LGL)
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing payment messages by nostro +
                          report - I/C') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Tags 1 - 7 delimit the selection criteria */
 
/* Tag 1 - Set up selection criteria for module id */
TAG1:        CHGVAR  VAR(&MD) VALUE(%SST(&RPARM 1 2))
/**********  IF   COND((&MD) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MD) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
             IF         COND(&LGL) THEN(DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/************   CHGVAR  VAR(&MD2) VALUE('"' ** &MD ** '"')                            */ /*BG18886*/
/************   CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' ** +
                            &MD2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&MD2) VALUE('"' *CAT &MD *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' *CAT +
                            &MD2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/* Tag 2 - Set up selection criteria for nostro currency */
 
 TAG2:       CHGVAR     VAR(&NC) VALUE(%SST(&RPARM 3 3))
/**********  IF   COND((&NC) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&NC) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&NC2) VALUE('"' ** &NC ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(CCY = ' ** +
                            &NC2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&NC2) VALUE('"' *CAT &NC *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(CCY = ' *CAT +
                            &NC2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/* Tag 3 - Set up selection criteria for nostro number */
 
 TAG3:       CHGVAR     VAR(&NN) VALUE(%SST(&RPARM 6 2))
/**********  IF         COND((&NN)**= '  ') THEN(DO)                                  */ /*BG18886*/
             IF         COND((&NN) *NE '  ') THEN(DO)                                    /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********  CHGVAR     VAR(%SST(&ALL &C 10)) VALUE('(NSNO = ' ** &NN)                */ /*BG18886*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE('(NSNO = ' *CAT &NN)                 /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 10)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    Tag 4 - Set up selection criteria for network */
 
TAG4:        CHGVAR  VAR(&NT) VALUE(%SST(&RPARM 8 6))
/**********  IF   COND((&NT) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&NT) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&NT2) VALUE('"' ** &NT ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' ** +
                            &NT2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&NT2) VALUE('"' *CAT &NT *CAT '"')
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *CAT +
                            &NT2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
 
/* Tag 5 - Set up non-definable selection criteria for payments only */
 
/* If not the first selection insert ' & ' to combine selections */
 TAG5:       IF         COND(&LGL) THEN(DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
             CHGVAR     VAR(%SST(&ALL &C 46)) +
           VALUE('(MTPY = %VALUES("100" "200" "201" "202" "203")')
                CHGVAR  VAR(&C) VALUE(&C + 46)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
/* Tag 6  - set up selection criteria for from and to date */
 
TAG6:        CHGVAR  VAR(&FD) VALUE(%SST(&RPARM 14 6))
             CHGVAR  VAR(&TD) VALUE(%SST(&RPARM 20 6))
 
/* If not the first selection insert ' & ' To combine selections */
             IF   COND(&LGL) THEN( +
                DO)
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                CHGVAR  VAR(&C) VALUE(&C + 3)
                ENDDO
 
/**********  CHGVAR  VAR(&FD2) VALUE('"' ** &FD ** '"')                               */ /*BG18886*/
/**********  CHGVAR  VAR(&TD2) VALUE('"' ** &TD ** '"')                               */ /*BG18886*/
             CHGVAR  VAR(&FD2) VALUE('"' *CAT &FD *CAT '"')                              /*BG18886*/
             CHGVAR  VAR(&TD2) VALUE('"' *CAT &TD *CAT '"')                              /*BG18886*/
 
             CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(SVDT = %RANGE(')
             CHGVAR  VAR(&C) VALUE(&C + 15)
             CHGVAR  VAR(%SST(&ALL &C 8)) VALUE(&FD2)
             CHGVAR  VAR(&C) VALUE(&C + 9)
             CHGVAR  VAR(%SST(&ALL &C 8)) VALUE(&TD2)
             CHGVAR  VAR(&C) VALUE(&C + 8)
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE('))')
             CHGVAR  VAR(&C) VALUE(&C + 6)
 
             CHGVAR  VAR(&LGL) VALUE('1')
 
/*    Tag 7 - set up selection criteria for branch */
 
/**********TAG7:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
               DO)                                                                    */ /*BG18886*/
TAG7:        IF  COND((&RBCH *NE '    ') & (&RBCH *NE 'ALL')) THEN( +
               DO)                                                                       /*BG18886*/
 
/* If not the first selection insert ' & ' To combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
/**********     CHGVAR  VAR(&BCH) VALUE('"' ** &RBCH ** '"')                          */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 13)) VALUE('(BRCA = ' ** +
                            &BCH )                                                    */ /*BG18886*/
                CHGVAR  VAR(&BCH) VALUE('"' *CAT &RBCH *CAT '"')                         /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 13)) VALUE('(BRCA = ' *CAT +
                            &BCH )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 13)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
             ENDDO
 
/* Over-ride database file MGOREFPD & open Query File */
             OVRDBF  FILE(MGOREFPD) SHARE(*YES)
             OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (SYTM) (MODI) (MGSG) (MGST))
 
/* Create data queue MEDTQPRT */
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
             CALL    PGM(ME0820) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
/* Close file MGOREFPD */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing Payment Messages by Nostro +
                          report ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
