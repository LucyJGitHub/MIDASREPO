/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages status report')               */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0880 - Outgoing messages by S.W.I.F.T. account report        */
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
 
/* Parameters recieved from ME0875 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&FB)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&TB)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&NT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&FD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&TD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&FA)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&TA)    TYPE(*CHAR) LEN(15)
             DCL        VAR(&AT)    TYPE(*CHAR) LEN(1)
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&AT2)   TYPE(*CHAR) LEN(3)
 
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
             SNDPGMMSG  MSG('Outgoing messages S.W.I.F.T. account +
                          report') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Tags 1 - 5 delimits the selection criteria */
 
/*    TAG 1 - Sets up selection criteria for branches */
 
TAG1:        CHGVAR  VAR(&FB) VALUE(%SST(&RPARM 1 3))
             CHGVAR  VAR(&TB) VALUE(%SST(&RPARM 19 3))
 
/* If not the first selection insert ' & ' to combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
                CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(BRCA = %RANGE(')
                CHGVAR  VAR(&C) VALUE(&C + 15)
 
/**********     CHGVAR  VAR(%SST(&ALL &C 5)) VALUE('"' ***&FB ***'"')                 */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 5)) VALUE('"' *CAT &FB *CAT '"')                /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 6)
/**********     CHGVAR  VAR(%SST(&ALL &C 5)) VALUE('"' ***&TB ***'"')                 */ /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 5)) VALUE('"' *CAT &TB *CAT '"')                /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 5)
                CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
                CHGVAR  VAR(&C) VALUE(&C + 2)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
/*    TAG 2 - Sets up selection criteria for from A/C & to A/C */
TAG2:        CHGVAR  VAR(&FA) VALUE(%SST(&RPARM 4 15))
             CHGVAR  VAR(&TA) VALUE(%SST(&RPARM 22 15))
 
/**********  IF  COND((&FA**= '   ') & (&TA**= '    ')) THEN( +
               DO)                                                                    */ /*BG18886*/
             IF  COND((&FA *NE '   ') & (&TA *NE '    ')) THEN( +
               DO)                                                                       /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
               CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(SACN = %RANGE(')
               CHGVAR  VAR(&C) VALUE(&C + 15)
/**********    CHGVAR  VAR(%SST(&ALL &C 17)) VALUE('"' ***&FA ***'"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 17)) VALUE('"' *CAT &FA *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 18)
/**********    CHGVAR  VAR(%SST(&ALL &C 17)) VALUE('"' ***&TA ***'"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 17)) VALUE('"' *CAT &TA *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 17)
               CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
               CHGVAR  VAR(&C) VALUE(&C + 2)
 
               CHGVAR  VAR(&LGL) VALUE('1')
               ENDDO
 
/*    TAG 3 - Sets up selection criteria for network */
 
TAG3:        CHGVAR  VAR(&NT) VALUE(%SST(&RPARM 37 6))
/**********  IF   COND((&NT)**= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&NT) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&NT2) VALUE('"' ***&NT ***'"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' ***+
                            &NT2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&NT2) VALUE('"' *CAT &NT *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *CAT +
                            &NT2 )                                                      /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 4 - Sets up selection criteria for from date & to date */
 
TAG4:        CHGVAR  VAR(&FD) VALUE(%SST(&RPARM 43 6))
             CHGVAR  VAR(&TD) VALUE(%SST(&RPARM 49 6))
 
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
 
/*    TAG 5 - Sets up selection criteria for a/c type */
 
TAG5:        CHGVAR  VAR(&AT) VALUE(%SST(&RPARM 55 1))
/**********  IF         COND((&AT)**= ' ') THEN(DO)                                   */ /*BG18886*/
             IF         COND((&AT) *NE ' ') THEN(DO)                                     /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&AT2) VALUE('"' ***&AT ***'"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(AORR = ' ***+
                            &AT2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&AT2) VALUE('"' *CAT &AT *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(AORR = ' *CAT +
                            &AT2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/* Over-ride database file MGOREFPD & open query file */
             OVRDBF  FILE(MGOREFPD) SHARE(*YES)
             OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (MGDE) (TRNO))
 
 
/* Create data queue MEDTQPRT */
             DLTDTAQ    DTAQ(QTEMP/MEDTQPRT)
             MONMSG     MSGID(CPF0000)
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
 
             CALL    PGM(ME0880) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing messages by S.W.I.F.T. account +
         report ENDED ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
/* Close file MGOREFPD */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
