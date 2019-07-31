/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing message details report')               */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0810 - Outgoing message details report - general selection   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00000              Date 00Xxx00              */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   BG18886 - Amend non-standard codes.                             */
/*                                                                   */
/*********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters recieved from ME0805 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&MD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&EX)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&NT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MG)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&MS)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&FD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&TD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&FT)    TYPE(*CHAR) LEN(16)
             DCL        VAR(&TT)    TYPE(*CHAR) LEN(16)
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&MD2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&EX2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PR2)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&MG2)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&MS1)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS2)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS3)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS4)   TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&PTS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTST)   TYPE(*CHAR) LEN(3)
/* Used to control building of OPNQRYF command */
             DCL        VAR(&LGL)   TYPE(*LGL)
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing messages detail Report - I/C') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
 
/* Tags 1 - 9 delimits the selection criteria */
 
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
 
TAG2:        CHGVAR  VAR(&EX) VALUE(%SST(&RPARM 3 6))
/**********  IF   COND((&EX) **= 'ALL   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&EX) *NE 'ALL   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&EX2) VALUE('"' ** &EX ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(SYTM = ' ** +
                            &EX2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&EX2) VALUE('"' *CAT &EX *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(SYTM = ' *CAT +
                            &EX2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 3 - Sets up selection criteria for network */
 
TAG3:        CHGVAR  VAR(&NT) VALUE(%SST(&RPARM 9 6))
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
 
/*    TAG 4 - Sets up selection criteria for message group */
 
TAG4:        CHGVAR  VAR(&MG) VALUE(%SST(&RPARM 15 3))
 
/* If not the first selection insert ' & ' to combine selections */
 
             IF   COND(&LGL) THEN( +
                DO)
                CHGVAR VAR(%SST(&ALL &C 3)) VALUE(' & ')
                CHGVAR VAR(&C) VALUE(&C + 3)
                ENDDO
 
/**********  CHGVAR  VAR(&MG2) VALUE('"' ** &MG ** '"')                               */ /*BG18886*/
             CHGVAR  VAR(&MG2) VALUE('"' *CAT &MG *CAT '"')                              /*BG18886*/
             CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(MTPY = %WLDCRD(')
             CHGVAR  VAR(&C) VALUE(&C + 16)
             CHGVAR  VAR(%SST(&ALL &C 5)) VALUE(&MG2)
             CHGVAR  VAR(&C) VALUE(&C + 6)
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE('"*."))')
             CHGVAR  VAR(&C) VALUE(&C + 6)
 
             CHGVAR  VAR(&LGL) VALUE('1')
 
/*    TAG 5 - Sets up selection criteria for message status */
 
TAG5:        CHGVAR  VAR(&MS) VALUE(%SST(&RPARM 18 4))
             CHGVAR  VAR(&MS1) VALUE(%SST(&MS 1 1))
             CHGVAR  VAR(&MS2) VALUE(%SST(&MS 2 1))
             CHGVAR  VAR(&MS3) VALUE(%SST(&MS 3 1))
             CHGVAR  VAR(&MS4) VALUE(%SST(&MS 4 1))
 
/* If not the first selection insert ' & ' to combine selections */
 
             IF   COND(&LGL) THEN( +
                DO)
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                CHGVAR  VAR(&C) VALUE(&C + 3)
                ENDDO
 
             CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(MGSG = %VALUES(')
             CHGVAR  VAR(&C) VALUE(&C + 16)
/**/
/**********  IF   COND((&MS1) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS1) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ** &MS1 ** '"')                */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS1 *CAT '"')               /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 4)
                ENDDO
/**/
/**********  IF   COND((&MS2) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS2) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ** &MS2 ** '"')                */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS2 *CAT '"')               /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 4)
                ENDDO
/**/
/**********  IF   COND((&MS3) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS3) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ** &MS3 ** '"')                */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS3 *CAT '"')               /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 4)
                ENDDO
/**/
/**********  IF   COND((&MS4) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS4) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ** &MS4 ** '"')                */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS4 *CAT '"')               /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 4)
                ENDDO
 
             CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR  VAR(&C) VALUE(&C + 2)
             CHGVAR  VAR(&LGL) VALUE('1')
 
/*    TAG 6 - Sets up selection criteria for priority */
 
TAG6:        CHGVAR  VAR(&PR) VALUE(%SST(&RPARM 22 1))
/**********  IF   COND((&PR) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&PR) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&PR2) VALUE('"' ** &PR ** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MPRY = ' ** +
                            &PR2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&PR2) VALUE('"' *CAT &PR *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MPRY = ' *CAT +
                            &PR2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 7 - Sets up selection criteria for from date & to date */
 
TAG7:        CHGVAR  VAR(&FD) VALUE(%SST(&RPARM 23 6))
             CHGVAR  VAR(&TD) VALUE(%SST(&RPARM 29 6))
 
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
 
/*    TAG 8 - Sets up selection criteria for from trno & to trno */
 
TAG8:        CHGVAR  VAR(&FT) VALUE(%SST(&RPARM 35 16))
             CHGVAR  VAR(&TT) VALUE(%SST(&RPARM 51 16))
 
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
 
/*    TAG 9 - Sets up selection criteria for brca */
 
/**********TAG9:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
               DO)                                                                    */ /*BG18886*/
TAG9:        IF  COND((&RBCH *NE '    ') & (&RBCH *NE 'ALL')) THEN( +
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
 
/*    TAG 10- Sets up selection criteria for PTST */
/*    Neccessary if option 4 (Cancelled/released/undelivered) */
/*    not taken */
 
TAG10:
 
             IF   COND((&MS4) = ' ') THEN( +
                DO)
 
/* If not the first selection insert ' & ' to combine selections */
 
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
                CHGVAR  VAR(&PTS) VALUE('D')
/**********     CHGVAR  VAR(&PTST) VALUE('"' ** &PTS ** '"')                          */ /*BG18886*/
                CHGVAR  VAR(&PTST) VALUE('"' *CAT &PTS *CAT '"')                         /*BG18886*/
 
/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(PTST **= ' ** +
                            &PTST)                                                    */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(PTST *NE ' *CAT +
                            &PTST)                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
               ENDDO
 
/* Over-ride database file MGOREFPD & open query file */
 
             OVRDBF  FILE(MGOREFPD) SHARE(*YES)
             OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (SYTM) (MODI) (MGSG) (MGST))
 
/* Create data queue MEDTQPRT */
 
             DLTDTAQ    DTAQ(QTEMP/MEDTQPRT)
             MONMSG     MSGID(CPF0000)
 
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
             CALL    PGM(ME0810) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing message detail report ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
/* Close file MGOREFPD */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
