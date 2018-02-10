/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing Mail Re-print (ISO format)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0860 - Outgoing Mail Re - print (ISO format)                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*   Last Amend No. MD046248           Date 27Oct17                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*   Prev Amend No.  BG18886          DATE 29May08                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                   00000            DATE 00XXX00                   */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters recieved from ME0855 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&MD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&FD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&TD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&FT)    TYPE(*CHAR) LEN(16)
             DCL        VAR(&TT)    TYPE(*CHAR) LEN(16)
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&NT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&MS)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&MS2)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MD2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&EX)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SY)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
 
/* Used to cotrol building of OPNQRYF command */
             DCL        VAR(&LGL)   TYPE(*LGL)
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing mail re-print (ISO format)') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
 
/* Tags 1 - 7 delimits the selection criteria */
 
/*    Tag 1 - Set up selection criteria for module id */
 
TAG1:        CHGVAR  VAR(&MD) VALUE(%SST(&RPARM 1 2))
/**********  IF   COND((&MD) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MD) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
/* If not the first selection insert ' & ' to combine selections */
 
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&MD2) VALUE('"' ** &MD ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' ** +
                            &MD2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&MD2) VALUE('"' *CAT &MD *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' *CAT +
                            &MD2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 2 - Sets up selection criteria for system */
 
TAG2:        CHGVAR  VAR(&EX) VALUE('MIDAS')
/**********  IF   COND((&EX) **= '    ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&EX) *NE '    ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(SYTM = %VALUES(')
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
/**********     CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' ** &EX ** '"')                 */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' *CAT &EX *CAT '"')                /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 9)
 
/**********     CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' ** &SY ** '"')                 */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' *CAT &SY *CAT '"')                /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 9)
 
                CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR  VAR(&C) VALUE(&C + 2)
             CHGVAR  VAR(&LGL) VALUE('1')
 
             ENDDO
 
/*    TAG 3 - Sets up selection criteria for from date & to date */
 
TAG3:        CHGVAR  VAR(&FD) VALUE(%SST(&RPARM 3 6))
             CHGVAR  VAR(&TD) VALUE(%SST(&RPARM 9 6))
 
/* If not the first selection insert ' & ' to combine selections */
 
             IF   COND(&LGL) THEN( +
                DO)
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                CHGVAR  VAR(&C) VALUE(&C + 3)
                ENDDO
 
             CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(MGDE = %RANGE(')
             CHGVAR  VAR(&C) VALUE(&C + 15)
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE(&FD)
             CHGVAR  VAR(&C) VALUE(&C + 7)
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE(&TD)
             CHGVAR  VAR(&C) VALUE(&C + 6)
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE('))')
             CHGVAR  VAR(&C) VALUE(&C + 6)
 
             CHGVAR  VAR(&LGL) VALUE('1')
 
/*    TAG 4 - Sets up selection criteria for from trno & to trno */
 
TAG4:        CHGVAR  VAR(&FT) VALUE(%SST(&RPARM 15 16))
             CHGVAR  VAR(&TT) VALUE(%SST(&RPARM 31 16))
 
/**********  IF  COND((&FT **= '   ') & (&TT **= '    ')) THEN( +
               DO)                                                                    */ /*BG18886*/
             IF  COND((&FT *NE '   ') & (&TT *NE '    ')) THEN( +
               DO)                                                                       /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
               CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(TRNO = %RANGE(')
               CHGVAR  VAR(&C) VALUE(&C + 15)
/**********    CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' ** &FT ** '"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' *CAT &FT *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 19)
/**********    CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' ** &TT ** '"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' *CAT &TT *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 18)
               CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
               CHGVAR  VAR(&C) VALUE(&C + 2)
 
               CHGVAR  VAR(&LGL) VALUE('1')
               ENDDO
 
/*    TAG 5 - Sets up selection criteria for brca */
 
/**********TAG5:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
               DO)                                                                    */ /*BG18886*/
TAG5:        IF  COND((&RBCH *NE '    ') & (&RBCH *NE 'ALL')) THEN( +
               DO)                                                                       /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
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
 
/*    TAG 6 - Sets up selection criteria for network PAPER ONLY */
 
TAG6:        CHGVAR  VAR(&NT) VALUE('PAPER')
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
                CHGVAR  VAR(&NT2) VALUE('"' *CAT &NT *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *CAT +
                            &NT2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 7 - Sets up selection criteria for message status ('PRTD') */
 
TAG7:        CHGVAR  VAR(&MS) VALUE('PRTD')
/**********  IF   COND((&MS) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections    */
 
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&MS2) VALUE('"' ** &MS ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 14)) VALUE('(MGST = ' ** +
                            &MS2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&MS2) VALUE('"' *CAT &MS *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 14)) VALUE('(MGST = ' *CAT +
                            &MS2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 14)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
 
/* Over-ride database file MGOREFPD & open query file */
 
             OVRDBF  FILE(MGOREFPD) SHARE(*YES)
             OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (MODI))
 
/* Create data queue MEDTQPRT */
 
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90)
             CALL    PGM(ME0860) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing mail re-print (ISO format) +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
/* Close file MGOREFPD */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
