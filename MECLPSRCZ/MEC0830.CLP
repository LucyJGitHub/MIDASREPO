/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Outgoing messages by transaction')              */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0830 - Outgoing payment messages by transaction         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00000              Date 00Xxx00              */
/*                       00000            DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*    BG18886 - Amend non-standard codes.                            */
/*                                                                   */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from ME0825 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&MD) TYPE(*CHAR) LEN(2)   /* MODULE ID  */
             DCL        VAR(&MF) TYPE(*CHAR) LEN(15)  /* FROM MTRN */
             DCL        VAR(&MT) TYPE(*CHAR) LEN(15)  /* TO MTRN */
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&MD2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MF2)   TYPE(*CHAR) LEN(15)
             DCL        VAR(&MT2)   TYPE(*CHAR) LEN(15)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
 
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
             SNDPGMMSG  MSG('Outgoing payment messages by +
                          transaction report - I/C') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Tags 1 - 3 delimit the selection criteria */
 
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
 
/*    TAG 2 - Sets up select criteria for from Midas trn & to Midas */
/*            trn    */
 
TAG2:        CHGVAR  VAR(&MF) VALUE(%SST(&RPARM  3 15))
             CHGVAR  VAR(&MT) VALUE(%SST(&RPARM 18 15))
 
/**********  IF  COND((&MF **= '   ') & (&MT **= '    ')) THEN( +
               DO)                                                                    */ /*BG18886*/
             IF  COND((&MF *NE '   ') & (&MT *NE '    ')) THEN( +
               DO)                                                                       /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
 
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
               CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(MTRN = %RANGE(')
               CHGVAR  VAR(&C) VALUE(&C + 15)
/**********    CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' ** &MF ** '"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' *CAT &MF *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 19)
/**********    CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' ** &MT ** '"')                 */ /*BG18886*/
               CHGVAR  VAR(%SST(&ALL &C 18)) VALUE('"' *CAT &MT *CAT '"')                /*BG18886*/
               CHGVAR  VAR(&C) VALUE(&C + 18)
               CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
               CHGVAR  VAR(&C) VALUE(&C + 2)
 
               CHGVAR  VAR(&LGL) VALUE('1')
               ENDDO
 
 
/*    Tag 3 - set up selection criteria for branch */
 
/***********TAG3:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
               DO)                                                                    */ /*BG18886*/
TAG3:        IF  COND((&RBCH *NE '    ') & (&RBCH *NE 'ALL')) THEN( +
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
             OPNQRYF    FILE((MGOREFPD)) QRYSLT(&ALL) KEYFLD((BRCA +
                          *ASCEND) (SYTM) (MODI) (MTRN) (MTPY))
 
/* Create data queue MEDTQPRT */
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
             CALL    PGM(ME0830) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
/* Close file MGOREFPD */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing Payment Messages by +
                          Transaction report ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
