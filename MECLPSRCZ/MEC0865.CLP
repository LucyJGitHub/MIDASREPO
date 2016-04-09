/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Original Outgoing Mail (ISO format)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0865 - Original Outgoing Mail (ISO format)                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*   Last Amend No. BG18886           DATE 29May08                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO.  00000            DATE 00XXX00                   */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   BG18886 - Amend non-standard codes.                             */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&NT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&EX)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&MS)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&MS2)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&SY) TYPE(*CHAR) LEN(6) VALUE('      ')
 
/* Used to cotrol building of OPNQRYF command */
             DCL        VAR(&LGL)   TYPE(*LGL)
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Original Outgoing Mail (ISO format)') +
                          TOMSGQ(MRUNQ)
 
/* Tags 1 - 3 delimit the selection criteria */
 
/*    TAG 1 - Sets up selection criteria for system */
 TAG1:       CHGVAR     VAR(&EX) VALUE('MIDAS')
 
             CHGVAR     VAR(%SST(&ALL &C 16)) VALUE('(SYTM = %VALUES(')
             CHGVAR     VAR(&C) VALUE(&C + 16)
 
/**********  CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' ***&EX ***'"')                    */ /*BG18886*/
             CHGVAR  VAR(%SST(&ALL &C 8)) VALUE('"' *CAT &EX *CAT '"')                   /*BG18886*/
             CHGVAR  VAR(&C) VALUE(&C + 9)
 
/**********  CHGVAR     VAR(%SST(&ALL &C 8)) VALUE('"' ***&SY ***'"')                 */ /*BG18886*/
             CHGVAR     VAR(%SST(&ALL &C 8)) VALUE('"' *CAT &SY *CAT '"')                /*BG18886*/
             CHGVAR  VAR(&C) VALUE(&C + 9)
 
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR  VAR(&LGL) VALUE('1')
 
/* TAG 2 - Sets up selection criteria for network PAPER */
TAG2:        CHGVAR  VAR(&NT) VALUE('PAPER')
 
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
                            &NT2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
/*    TAG 3 - Sets up selection criteria for message status ('RSND') */
TAG3:        CHGVAR  VAR(&MS) VALUE('RSND')
 
/* If not the first selection insert ' & ' to combine selections    */
                IF   COND(&LGL) THEN( +
                   DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&MS2) VALUE('"' ***&MS ***'"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 14)) VALUE('(MGST = ' ***+
                            &MS2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&MS2) VALUE('"' *CAT &MS *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 14)) VALUE('(MGST = ' *CAT +
                            &MS2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 14)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
/* Over-ride database file MGOREFPD & open query file */
             OVRDBF  FILE(MGOREFPD) SHARE(*YES)
             OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (MODI))
 
/* Create data queue MEDTQPRT */
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90)
             CALL       PGM(ME0865) PARM('     ' 'B' 'ALL')
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Original Outgoing Mail (ISO format) +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
 
/* Close file MGOREFPD */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
