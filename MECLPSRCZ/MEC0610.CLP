/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Outgoing messages release by range')         */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC0610 - Outgoing messages release by range               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 29May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      00000              Date 00Xxx00              */
/*                       00000            DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*                                                                  */
/********************************************************************/
 
PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Parameters received from ME0605 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
 
/*/COPY WNCPYSRC,MEC0610007                                          */
/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
 
/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&NW) TYPE(*CHAR) LEN(6)  /* NETWORK  */
             DCL        VAR(&MF) TYPE(*CHAR) LEN(16)  /* FROM TRNO */
             DCL        VAR(&MT) TYPE(*CHAR) LEN(16)  /* TO TRNO */
 
/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&NW2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&GRP) TYPE(*CHAR) LEN(1)
 
/* Used to build OPNQRYF command for mandatory selection */
             DCL        VAR(&TRNF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&GRP2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TRNF2) TYPE(*CHAR) LEN(3)
 
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
             SNDPGMMSG  MSG('Outgoing messages released by range +
                          report - I/C') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error switches. */
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,MEC0610002                                          */
/* Tags 1 - 3 delimit the selection criteria */
 
/* Tag 1 - Set up selection criteria for network id */
TAG1:        CHGVAR  VAR(&NW) VALUE(%SST(&RPARM 1 6))
/**********  IF   COND((&NW) **= '   ') THEN( +                                      */ /*BG18886*/
/**********   DO)                                                                   */ /*BG18886*/
             IF   COND((&NW) *NE '   ') THEN(DO)                                       /*BG18886*/
 
/* If not the first selection insert ' & ' to combine selections */
             IF         COND(&LGL) THEN(DO)
                   CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                   CHGVAR  VAR(&C) VALUE(&C + 3)
                   ENDDO
 
/**********     CHGVAR  VAR(&NW2) VALUE('"' ** &NW ** '"')                          */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' ** +
                            &NW2 )                                                  */ /*BG18886*/
                CHGVAR  VAR(&NW2) VALUE('"' *CAT &NW *CAT '"')                        /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *CAT +
                            &NW2 )                                                     /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
 
/*    TAG 2 - Sets up select criteria for from Trno & to Trno */
 
TAG2:        CHGVAR  VAR(&MF) VALUE(%SST(&RPARM  7 16))
             CHGVAR  VAR(&MT) VALUE(%SST(&RPARM 23 16))
 
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
 
               CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(TRNO = %RANGE(')
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
 
/**********TAG3:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
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
/* Select messages with status of amended or created   */
 
TAG4:
 
/* If not the first selection insert ' & ' To combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
 
                CHGVAR  VAR(&GRP) VALUE('1')
/**********     CHGVAR  VAR(&GRP2) VALUE('"' ** &GRP ** '"')                          */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MGSG = ' ** +
                            &GRP2)                                                    */ /*BG18886*/
                CHGVAR  VAR(&GRP2) VALUE('"' *CAT &GRP *CAT '"')                         /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MGSG = ' *CAT +
                            &GRP2)                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
                CHGVAR  VAR(&LGL) VALUE('1')
 
/* Select messages where the TRNO of the first part is blank */
 
TAG5:
 
/* If not the first selection insert ' & ' To combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
                  CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')
                  CHGVAR  VAR(&C) VALUE(&C + 3)
                  ENDDO
 
 
                CHGVAR  VAR(&TRNF) VALUE(' ')
/**********     CHGVAR  VAR(&TRNF2) VALUE('"' ** &TRNF ** '"')                        */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TRNF = ' ** +
                            &TRNF2)                                                   */ /*BG18886*/
                CHGVAR  VAR(&TRNF2) VALUE('"' *CAT &TRNF *CAT '"')                       /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TRNF = ' *CAT +
                            &TRNF2)                                                      /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)
/*/COPY WNCPYSRC,MEC0610001                                          */
 
                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)
 
/*/COPY WNCPYSRC,MEC0610008                                          */
/* Set up input and update files                      */
             OVRDBF     FILE(MGOREFI) TOFILE(MGOREFPD) SHARE(*YES)
             OVRDBF     FILE(MGOREFU) TOFILE(MGOREFPD) SHARE(*YES)
 
/* Over-ride database file MGOREFPD & open Query File */
             OVRDBF     FILE(MGOREFPD) SHARE(*YES)
/*/COPY WNCPYSRC,MEC0610003                                          */
             OPNQRYF    FILE((MGOREFPD)) OPTION(*INP *UPD) +
                          QRYSLT(&ALL) KEYFLD((BRCA *ASCEND) (TRNO))
/*/COPY WNCPYSRC,MEC0610004                                          */
 
             CALL    PGM(ME0610) PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,MEC0610005                                          */
             ENDDO
 
/* Close file MGOREFPD */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Outgoing Messages release by range +
                          report ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
/*/COPY WNCPYSRC,MEC0610006                                          */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
