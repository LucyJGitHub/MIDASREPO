/*********************************************************************/
/**********STD****CLPBASE*********************************************/                 /*MD030783*/
/*STD    CLPBASEBND                                                  */                 /*MD030783*/
/*EXI    TEXT('Midas Outgoing messages status report')               */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE MANAGEMENT                             */
/*                                                                   */
/*   MEC0840 - Outgoing message status  report - selection           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD051728           Date 28Feb19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD030783           Date 13Nov14              */
/*                      AR1097217          Date 25Mar13              */
/*                  CCB023B            Date 06Aug12                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                   BG18886          DATE 29May08                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                   E29588           DATE 10DEC91                   */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*         MD051728 - Midas ME Outgoing Message Status (ME0840P1)    */
/*                    report is still reporting/capturing messages   */
/*                    from the previous days                         */
/*         MD046248 - Finastra Rebranding                            */
/*         MD030783 - COB component is failing while accessing       */
/*                    MGOREFL0 (in case of multiple messages).       */
/*         AR1097217 - DBICDM in use                                 */
/*         CCB023B - COB Restructure - Input Cycle Termination       */
/*                   Restructuring                                   */
/*         BG18886 - Amend non-standard codes.                       */
/*         E29588 - POST SWIFT RATIONALISATION AMENDMENTS            */
/*                o If date left blank do not use rundate but select */
/*                  all messages with TODY equal blank.              */
/*                                                                   */
/*********************************************************************/

PGM          PARM(&RSEQ &RLVL &RBCH &RPARM)

/* Parameters recieved from ME0835 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SQLSTR) TYPE(*CHAR) LEN(5000)                              /*MD030783*/

/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)

/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&MD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&EX)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&NT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PR)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&FD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&TD)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&FDC)   TYPE(*CHAR) LEN(6)               /*E29588*/
             DCL        VAR(&TDC)   TYPE(*CHAR) LEN(6)               /*E29588*/

/* Used to build OPNQRYF command for selection criteria */
             DCL        VAR(&MD2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&EX2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&NT2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PR2)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&BCH)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&TRNF)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&MS1)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS2)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS3)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MS4)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRNF2) TYPE(*CHAR) LEN(3)

             DCL        VAR(&PTS)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTST)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&TDY)   TYPE(*CHAR) LEN(3)               /*E29588*/
             DCL        VAR(&BLNK)  TYPE(*CHAR) LEN(1) VALUE(' ')    /*E29588*/
/* Used to control building of OPNQRYF command */
             DCL        VAR(&LGL)   TYPE(*LGL)
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                /*CCB023B*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)                                   /*CCB023B*/
             DCL        VAR(&ZONEID) TYPE(*CHAR) LEN(2)                                  /*CCB023B*/
             DCL        VAR(&PHAS)  TYPE(*CHAR) LEN(1)                                  /*MD051728*/
             DCL        VAR(&APOS)  TYPE(*CHAR) LEN(1)                                  /*MD051728*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MEC0840001                                          */

/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)

/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Outgoing message status  Report - I/C') +
                          TOMSGQ(MRUNQ)

/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)


/* Tags 1 - 8 delimits the selection criteria */

/*    TAG 1 - Sets up selection criteria for network */

             CHGVAR     VAR(&APOS) VALUE('''')                                          /*MD051728*/
TAG1:        CHGVAR  VAR(&NT) VALUE(%SST(&RPARM 1 6))
/**********  IF         COND((&NT **= '      ') & (&NT **= 'ALL   ')) +
                          THEN(DO)                                                    */ /*BG18886*/
             IF         COND((&NT *NE '      ') & (&NT *NE 'ALL   ')) +
                          THEN(DO)                                                       /*BG18886*/

/* If not the first selection insert ' & ' to combine selections */

                IF   COND(&LGL) THEN( +
                   DO)
/**********        CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')       */                   /*MD051728*/
/**********        CHGVAR  VAR(&C) VALUE(&C + 3)                   */                   /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                       /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 5)                                     /*MD051728*/
                   ENDDO

/**********     CHGVAR  VAR(&NT2) VALUE('"' ***&NT*** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *** +
                            &NT2 )                                                    */ /*BG18886*/
/**********     CHGVAR  VAR(&NT2) VALUE('"' *CAT &NT *CAT '"')     */           /*BG18886 MD051728*/
                CHGVAR  VAR(&NT2) VALUE(&APOS *CAT &NT *CAT &APOS)                      /*MD051728*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(NWRK = ' *CAT +
                            &NT2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO
/*    Tag 2 - Set up selection criteria for module id */

TAG2:        CHGVAR  VAR(&MD) VALUE(%SST(&RPARM 7 2))
/**********  IF   COND((&MD) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MD) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/
/* If not the first selection insert ' & ' to combine selections */

                IF   COND(&LGL) THEN( +
                   DO)
/**********        CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')       */                   /*MD051728*/
/**********        CHGVAR  VAR(&C) VALUE(&C + 3)                   */                   /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                       /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 5)                                     /*MD051728*/
                   ENDDO

/**********     CHGVAR  VAR(&MD2) VALUE('"' ***&MD*** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' *** +
                            &MD2 )                                                    */ /*BG18886*/
/**********     CHGVAR  VAR(&MD2) VALUE('"' *CAT &MD *CAT '"')                  /*BG18886 MD051728*/
                CHGVAR     VAR(&MD2) VALUE(&APOS *CAT &MD *CAT &APOS)                   /*MD051728*/
                CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(MODI = ' *CAT +
                            &MD2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO

/*    TAG 3 - Sets up selection criteria for system */

TAG3:        CHGVAR  VAR(&EX) VALUE(%SST(&RPARM 9 6))
/**********  IF   COND((&EX) **= 'ALL   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&EX) *NE 'ALL   ') THEN( +
                DO)                                                                      /*BG18886*/

/* If not the first selection insert ' & ' to combine selections */

                IF   COND(&LGL) THEN( +
                   DO)
/**********        CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')       */                   /*MD051728*/
/**********        CHGVAR     VAR(&C) VALUE(&C + 3)                */                   /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                       /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 5)                                     /*MD051728*/
                   ENDDO

/**********     CHGVAR  VAR(&EX2) VALUE('"' ***&EX ***'"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(SYTM = ' *** +
                            &EX2 )                                                    */ /*BG18886*/
/**********     CHGVAR  VAR(&EX2) VALUE('"' *CAT &EX *CAT '"')     */           /*BG18886 MD051728*/
                CHGVAR     VAR(&EX2) VALUE(&APOS *CAT &EX *CAT &APOS) +
                                                                                        /*MD051728*/
                CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(SYTM = ' *CAT +
                            &EX2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 16)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO


/*    TAG 4 - Sets up selection criteria for from date & to date */

             CHGVAR  VAR(&FDC) VALUE(%SST(&RPARM 15 6))              /*E29588*/
             CHGVAR  VAR(&TDC) VALUE(%SST(&RPARM 21 6))              /*E29588*/
/* If not blanks then setup using dates, else use TODY equal to blank*/
/**********  IF         COND((&FDC **= '      ') & (&TDC **= '      +
                          ')) THEN(DO)                                */ /*E29588*/ /*BG18886*/
             IF         COND((&FDC *NE '      ') & (&TDC *NE '      +
                          ')) THEN(DO)                                   /*E29588*/ /*BG18886*/

TAG4:        CHGVAR  VAR(&FD) VALUE(%SST(&RPARM 15 6))
             CHGVAR  VAR(&TD) VALUE(%SST(&RPARM 21 6))
/* If not the first selection insert ' & ' to combine selections */

             IF   COND(&LGL) THEN( +
                DO)
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')          */                   /*MD051728*/
/**********     CHGVAR  VAR(&C) VALUE(&C + 3)                      */                   /*MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                          /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 5)                                        /*MD051728*/
                ENDDO

/**********  CHGVAR  VAR(%SST(&ALL &C 15)) VALUE('(MGDE = %RANGE(')*/                   /*MD051728*/
/**********  CHGVAR  VAR(&C) VALUE(&C + 15)                        */                   /*MD051728*/
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(MGDE >= ')                         /*MD051728*/
             CHGVAR     VAR(&C) VALUE(&C + 9)                                           /*MD051728*/
             CHGVAR  VAR(%SST(&ALL &C 6)) VALUE(&FD)             
             CHGVAR  VAR(&C) VALUE(&C + 6)
/**********  CHGVAR  VAR(%SST(&ALL &C 6)) VALUE('))')              */                   /*MD051728*/
             CHGVAR     VAR(%SST(&ALL &C 13)) VALUE(' AND MGDE <= ')                    /*MD051728*/
             CHGVAR     VAR(&C) VALUE(&C + 13)                                          /*MD051728*/
             CHGVAR     VAR(%SST(&ALL &C 6)) VALUE(&TD)
             CHGVAR  VAR(&C) VALUE(&C + 6)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(')')                                 /*MD051728*/
             CHGVAR     VAR(&C) VALUE(&C + 1)                                           /*MD051728*/

             CHGVAR  VAR(&LGL) VALUE('1')

             ENDDO                                                   /*E29588*/
             ELSE (DO)                                               /*E29588*/
/* If not the first selection insert ' & ' to combine selections */  /*E29588*/
                                                                     /*E29588*/
             IF   COND(&LGL) THEN( +
                DO)                                                  /*E29588*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')          */            /*E29588 MD051728*/
/**********     CHGVAR  VAR(&C) VALUE(&C + 3)                      */            /*E29588 MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                          /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 5)                                        /*MD051728*/
                ENDDO                                                /*E29588*/
                                                                     /*E29588*/
/**********  CHGVAR  VAR(&TDY) VALUE('"' ***&BLNK*** '"')                  */ /*E29588*/ /*BG18886*/
/**********  CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TODY = ' ***     +
                         &TDY)                                                        */ /*BG18886*/
/**********  CHGVAR  VAR(&TDY) VALUE('"' *CAT &BLNK *CAT '"')      */    /*E29588 BG18886 MD051728*/
             CHGVAR     VAR(&TDY) VALUE(&APOS *CAT &BLNK *CAT &APOS)                    /*MD051728*/ 
                                                                  

             CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TODY = ' *CAT     +
                         &TDY)                                                           /*BG18886*/
             CHGVAR  VAR(&C) VALUE(&C + 11)                          /*E29588*/
                                                                     /*E29588*/
             CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')                 /*E29588*/
             CHGVAR  VAR(&C) VALUE(&C + 1)                           /*E29588*/
                                                                     /*E29588*/
             CHGVAR  VAR(&LGL) VALUE('1')                            /*E29588*/
             ENDDO                                                   /*E29588*/
                                                                     /*E29588*/
/*    TAG 5 - Sets up selection criteria for message status */

TAG5:        CHGVAR  VAR(&MS) VALUE(%SST(&RPARM 27 4))
             CHGVAR  VAR(&MS1) VALUE(%SST(&MS 1 1))
             CHGVAR  VAR(&MS2) VALUE(%SST(&MS 2 1))
             CHGVAR  VAR(&MS3) VALUE(%SST(&MS 3 1))
             CHGVAR  VAR(&MS4) VALUE(%SST(&MS 4 1))

/* If not the first selection insert ' & ' to combine selections */

             IF   COND(&LGL) THEN( +
                DO)
 /**********    CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')          */                   /*MD051728*/
 /**********    CHGVAR  VAR(&C) VALUE(&C + 3)                      */                   /*MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                          /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 5)                                        /*MD051728*/
                ENDDO

 /**********    CHGVAR  VAR(%SST(&ALL &C 16)) VALUE('(MGSG = %VALUES(')*/               /*MD051728*/
 /**********    CHGVAR  VAR(&C) VALUE(&C + 16)                     */                   /*MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(MGSG IN(')                      /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 9)                                        /*MD051728*/
/**/
/**********  IF   COND((&MS1) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS1) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ***&MS1*** '"')                */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS1 *CAT '"')*/    /*BG18886 MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&APOS *CAT &MS1 *CAT &APOS) +
                                                                                        /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 3)                                        /*MD051728*/
                ENDDO
/**/
/**********  IF   COND((&MS2) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS2) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ***&MS2*** '"')                */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS2 *CAT '"')*/    /*BG18886 MD051728*/
                IF         COND((&MS1) *NE ' ') THEN( DO)                               /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(',')                           /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 1)                                     /*MD051728*/
                ENDDO                                                                   /*MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&APOS *CAT &MS2 *CAT &APOS) +
                                                                                        /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 3)                                        /*MD051728*/
                ENDDO
/**/
/**********  IF   COND((&MS3) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS3) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ***&MS3*** '"')                */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS3 *CAT '"')*/   /*BG18886  MD051728*/
                IF         COND((&MS1 *NE ' ') *OR (&MS2 *NE ' ')) THEN(DO)             /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(',')                           /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 1)                                     /*MD051728*/
                ENDDO                                                                   /*MD051728*/
                CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&APOS *CAT &MS3 *CAT &APOS)       /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 3)                                        /*MD051728*/
                ENDDO
/**/
/**********  IF   COND((&MS4) **= ' ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&MS4) *NE ' ') THEN( +
                DO)                                                                      /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' ***&MS4*** '"')                */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 3)) VALUE('"' *CAT &MS4 *CAT '"')               /*BG18886*/
                IF         COND((&MS1 *NE ' ') *OR (&MS2 *NE ' ') *OR (&MS2 *NE ' +
                             ')) THEN(DO)                                               /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(',')                           /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 1)                                     /*MD051728*/
                ENDDO
                CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&APOS *CAT &MS4 *CAT &APOS)       /*MD051728*/
                CHGVAR     VAR(&C) VALUE(&C + 3)                                        /*MD051728*/
                ENDDO

/*/COPY WNCPYSRC,MEC0840002                                          */
             CHGVAR  VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR  VAR(&C) VALUE(&C + 2)
             CHGVAR  VAR(&LGL) VALUE('1')

/*    TAG 6 - Sets up selection criteria for priority */

TAG6:        CHGVAR  VAR(&PR) VALUE(%SST(&RPARM 31 1))
/**********  IF   COND((&PR) **= '   ') THEN( +
                DO)                                                                   */ /*BG18886*/
             IF   COND((&PR) *NE '   ') THEN( +
                DO)                                                                      /*BG18886*/

/* If not the first selection insert ' & ' to combine selections */

                IF   COND(&LGL) THEN( +
                   DO)
/**********        CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')       */                   /*MD051728*/
/**********        CHGVAR  VAR(&C) VALUE(&C + 3)                   */                   /*MD051728*/
                   CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                       /*MD051728*/
                   CHGVAR     VAR(&C) VALUE(&C + 5)                                     /*MD051728*/
                   ENDDO

/**********     CHGVAR  VAR(&PR2) VALUE('"' ***&PR*** '"')                            */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MPRY = ' *** +
                            &PR2 )                                                    */ /*BG18886*/
                CHGVAR  VAR(&PR2) VALUE('"' *CAT &PR *CAT '"')                           /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(MPRY = ' *CAT +
                            &PR2 )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')
                ENDDO


/*    TAG 7 - Sets up selection criteria for brca */

/**********TAG7:        IF  COND((&RBCH **= '    ') & (&RBCH **= 'ALL')) THEN( +
               DO)                                                                    */ /*BG18886*/
TAG7:        IF  COND((&RBCH *NE '    ') & (&RBCH *NE 'ALL')) THEN( +
               DO)                                                                       /*BG18886*/

/* If not the first selection insert ' & ' to combine selections */

               IF   COND(&LGL) THEN( +
                  DO)
/**********       CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')        */                   /*MD051728*/
/**********       CHGVAR  VAR(&C) VALUE(&C + 3)                    */                   /*MD051728*/
                  CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                        /*MD051728*/
                  CHGVAR     VAR(&C) VALUE(&C + 5)                                      /*MD051728*/
                  ENDDO

/**********     CHGVAR  VAR(&BCH) VALUE('"' ***&RBCH*** '"')                          */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 13)) VALUE('(BRCA = ' *** +
                            &BCH )                                                    */ /*BG18886*/
                CHGVAR  VAR(&BCH) VALUE('"' *CAT &RBCH *CAT '"')                         /*BG18886*/
                CHGVAR  VAR(%SST(&ALL &C 13)) VALUE('(BRCA = ' *CAT +
                            &BCH )                                                       /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 13)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')

               ENDDO

/* Select messages where the TRNO of the first part is blank */

TAG8:

/* If not the first selection insert ' & ' To combine selections */
               IF   COND(&LGL) THEN( +
                  DO)
/**********       CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')        */                   /*MD051728*/
/**********       CHGVAR  VAR(&C) VALUE(&C + 3)                    */                   /*MD051728*/
                  CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                        /*MD051728*/
                  CHGVAR     VAR(&C) VALUE(&C + 5)                                      /*MD051728*/
                  ENDDO


                CHGVAR  VAR(&TRNF) VALUE(' ')
/**********     CHGVAR  VAR(&TRNF2) VALUE('"' ***&TRNF*** '"')                        */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TRNF = ' *** +
/**********                 &TRNF2)                                                   */ /*BG18886*/
/**********     CHGVAR  VAR(&TRNF2) VALUE('"' *CAT &TRNF *CAT '"') */           /*BG18886 MD051728*/
                CHGVAR     VAR(&TRNF2) VALUE(&APOS *CAT &TRNF *CAT &APOS) +
                                                                                        /*MD051728*/
                CHGVAR  VAR(%SST(&ALL &C 11)) VALUE('(TRNF = ' *CAT +
                            &TRNF2)                                                      /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 11)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

/*    TAG 9- Sets up selection criteria for PTST */
/*    Neccessary if option 4 (Cancelled/released/undelivered) */
/*    not taken */

TAG9:

             IF   COND((&MS4) = ' ') THEN( +
                DO)

/* If not the first selection insert ' & ' to combine selections */

               IF   COND(&LGL) THEN( +
                  DO)
/**********       CHGVAR  VAR(%SST(&ALL &C 3)) VALUE(' & ')        */                   /*MD051728*/
/**********       CHGVAR  VAR(&C) VALUE(&C + 3)                    */                   /*MD051728*/
                  CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(' AND ')                        /*MD051728*/
                  CHGVAR     VAR(&C) VALUE(&C + 5)                                      /*MD051728*/
                  ENDDO

                CHGVAR  VAR(&PTS) VALUE('D')
/**********     CHGVAR  VAR(&PTST) VALUE('"' ***&PTS*** '"')                          */ /*BG18886*/
                CHGVAR     VAR(&PTST) VALUE(&APOS *CAT &PTS *CAT &APOS)                 /*MD051728*/

/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(PTST **= ' *** +
                            &PTST)                                                    */ /*BG18886*/
/**********     CHGVAR  VAR(%SST(&ALL &C 12)) VALUE('(PTST *NE ' *CAT +
/**********                 &PTST)                                                       /*BG18886*/
                CHGVAR     VAR(%SST(&ALL &C 12)) VALUE('(PTST != ' *CAT &PTST) +
                             /*BG18886*/
                CHGVAR  VAR(&C) VALUE(&C + 12)

                CHGVAR  VAR(%SST(&ALL &C 1)) VALUE(')')
                CHGVAR  VAR(&C) VALUE(&C + 1)

                CHGVAR  VAR(&LGL) VALUE('1')

               ENDDO

               CHGVAR     VAR(&PHAS) VALUE('C')                                         /*MD051728*/
               IF         COND(&RSEQ *NE '     ') THEN(DO)                              /*MD051728*/
                  CHGVAR     VAR(&PHAS) VALUE(' ')                                      /*MD051728*/
                  OVRDBF     FILE(MGOREFPD) TOFILE(MGOREFPD) SHARE(*YES)                /*MD051728*/
                  GOTO       SKIP                                                       /*MD051728*/
               ENDDO                                                                    /*MD051728*/

/* Over-ride database file MGOREFPD & open query file */

/**********  OVRDBF  FILE(MGOREFPD) SHARE(*YES)                      */                  /*CCB023B*/
/**********  OPNQRYF FILE((MGOREFPD)) QRYSLT(&ALL) +
                     KEYFLD((BRCA *ASCEND) (MGDE) (TRNO))            */                  /*CCB023B*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                   /*CCB023B*/
             CHGVAR     VAR(&ZONEID) VALUE(%SUBSTRING(&SDSTAT 6 2))                      /*CCB023B*/
             CHGVAR     VAR(&DMLIB) VALUE(&ZONEID *CAT 'DMLIB ')                         /*CCB023B*/
                                                                                         /*CCB023B*/
             RSTOBJ     OBJ(MGOREFPD) SAVLIB(&DMLIB) DEV(*SAVF) +
                          SAVF(DBICDM) RSTLIB(QTEMP)                                     /*CCB023B*/
/**********  MONMSG     MSGID(CPF0000)                               */        /*CCB023B AR1097217*/
             MONMSG     MSGID(CPF3812) EXEC(DO)                                        /*AR1097217*/
WAIT:          ALCOBJ     OBJ((DBICDM *FILE *EXCL)) WAIT(3)                            /*AR1097217*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO WAIT)                               /*AR1097217*/
               RSTOBJ     OBJ(MGOREFPD) SAVLIB(&DMLIB) DEV(*SAVF) +
                            SAVF(DBICDM) RSTLIB(QTEMP)                                 /*AR1097217*/
               DLCOBJ     OBJ((DBICDM *FILE *EXCL))                                    /*AR1097217*/
             ENDDO                                                                     /*AR1097217*/
/*           CPYF       FROMFILE(QTEMP/MGOREFPD) +
                          TOFILE(QTEMP/MGOREFL0) CRTFILE(*YES) */              /*CCB023B**MD030783*/
/*           MONMSG     MSGID(CPF0000) */                                      /*CCB023B**MD030783*/
/*           OPNQRYF    FILE((QTEMP/MGOREFL0)) KEYFLD((TRNO)) */               /*CCB023B**MD030783*/
                                                                                         /*CCB023B*/
             CHGVAR     VAR(&SQLSTR) VALUE('CREATE INDEX +
                          QTEMP/MGOREFL0 ON QTEMP/MGOREFPD (TRNO)')
             RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                      /*MD030783*/
                                                                                        /*MD030783*/
             OVRDBF     FILE(MGOREFPD) TOFILE(QTEMP/MGOREFPD) +
                          OVRSCOPE(*JOB)                                                 /*CCB023B*/
                                                                                        /*MD030783*/
             OVRDBF     FILE(MGOREFL0) TOFILE(QTEMP/MGOREFL0) +
                          OVRSCOPE(*JOB)                                                /*MD030783*/

 SKIP:                                                                                  /*MD051728*/
 /********** CALL    PGM(ME0840 PARM(&RSEQ &RLVL &RBCH &RPARM)     */                   /*MD051728*/

             CALL       PGM(ME0841) PARM(&RSEQ &RLVL &RBCH &RPARM &ALL)                 /*MD051728*/

/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO
                                                                                        /*MD030783*/
             IF         COND(&PHAS *EQ 'C') THEN(DO)                                    /*MD051728*/
             CHGVAR     VAR(&SQLSTR) VALUE('DROP INDEX +
                          QTEMP/MGOREFL0')                                              /*MD030783*/
             RUNSQL     SQL(&SQLSTR) COMMIT(*NONE)                                      /*MD030783*/
             ENDDO                                                                      /*MD051728*/

             GOTO END

 ERR:        SNDPGMMSG  MSG('Outgoing message status report ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)

/* Close file MGOREFPD */
 END:        CLOF    OPNID(MGOREFPD)
             MONMSG MSGID(CPF0000 MCH0000)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
