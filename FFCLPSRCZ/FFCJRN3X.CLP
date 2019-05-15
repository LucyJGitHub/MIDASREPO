/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Final JRN proc. for sub-compnt')             */
/********************************************************************/
/*                                                                  */
/*   Midas  -  Futures and Options Module                       */
/*                                                                  */
/*   FFCJRN3X  -  FINAL JOURNAL PROCESSING FOR SUB-COMPONENT        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  079666             Date 01Dec94                 */
/*                  E21147             Date 20Feb90                 */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   BG18886 - Amend non-standard codes.                            */
/*   CCB009  -  Journal files throughout close of business          */
/*   079666  -  Add global monitor message processing               */
/*   E211Q7  -  REPLACE QCAEXEC CALL WITH QCMDEXC FOR AS400         */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILES)
/**/
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(252)
             DCL        VAR(&FILS) TYPE(*CHAR) LEN(440)
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FINAL) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&INITIAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INITIALN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FINALA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(750)
             DCL        VAR(&N1) TYPE(*CHAR) LEN(2) VALUE(X'0001')
             DCL        VAR(&N2) TYPE(*CHAR) LEN(2) VALUE(X'0002')
             DCL        VAR(&N3) TYPE(*CHAR) LEN(2) VALUE(X'0003')
             DCL        VAR(&N4) TYPE(*CHAR) LEN(2) VALUE(X'0004')
             DCL        VAR(&N5) TYPE(*CHAR) LEN(2) VALUE(X'0005')
             DCL        VAR(&N6) TYPE(*CHAR) LEN(2) VALUE(X'0006')
             DCL        VAR(&N7) TYPE(*CHAR) LEN(2) VALUE(X'0007')
             DCL        VAR(&N8) TYPE(*CHAR) LEN(2) VALUE(X'0008')
             DCL        VAR(&N9) TYPE(*CHAR) LEN(2) VALUE(X'0009')
             DCL        VAR(&N10) TYPE(*CHAR) LEN(2) VALUE(X'000A')
             DCL        VAR(&N11) TYPE(*CHAR) LEN(2) VALUE(X'000B')
             DCL        VAR(&N12) TYPE(*CHAR) LEN(2) VALUE(X'000C')
             DCL        VAR(&N13) TYPE(*CHAR) LEN(2) VALUE(X'000D')
             DCL        VAR(&N14) TYPE(*CHAR) LEN(2) VALUE(X'000E')
             DCL        VAR(&N15) TYPE(*CHAR) LEN(2) VALUE(X'000F')
             DCL        VAR(&N16) TYPE(*CHAR) LEN(2) VALUE(X'0010')
             DCL        VAR(&N17) TYPE(*CHAR) LEN(2) VALUE(X'0011')
             DCL        VAR(&N18) TYPE(*CHAR) LEN(2) VALUE(X'0012')
             DCL        VAR(&N19) TYPE(*CHAR) LEN(2) VALUE(X'0013')
             DCL        VAR(&N20) TYPE(*CHAR) LEN(2) VALUE(X'0014')
             DCL        VAR(&N21) TYPE(*CHAR) LEN(2) VALUE(X'0015')
             DCL        VAR(&N22) TYPE(*CHAR) LEN(2) VALUE(X'0016')
             DCL        VAR(&N23) TYPE(*CHAR) LEN(2) VALUE(X'0017')
             DCL        VAR(&N24) TYPE(*CHAR) LEN(2) VALUE(X'0018')
             DCL        VAR(&N25) TYPE(*CHAR) LEN(2) VALUE(X'0019')
             DCL        VAR(&FFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/*  SUCCESSFUL COMPLETION, END JOURNALLING & UPDATE 'UPDATE' FLAG    */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                ENDJRNPF   FILE(*ALL) JRN(FFJRN)
             ENDDO                                                    /*CCB009*/
                CHGDTAARA  DTAARA(FFSTAT (11 1)) VALUE('N')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
             CHGVAR     VAR(&NUMB) VALUE(%SST(&FILES 1 2))
                   IF         COND(&NUMB>=&N1) THEN(CHGVAR VAR(&FILS) +
                                VALUE('(' *CAT (%SST(&FILES 3 10)) +
                                *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N2) THEN(CHGVAR VAR(%SST(&FILS +
                                19 17)) VALUE('(' *CAT (%SST(&FILES +
                                13 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N3) THEN(CHGVAR VAR(%SST(&FILS +
                                37 17)) VALUE('(' *CAT (%SST(&FILES +
                                23 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N4) THEN(CHGVAR VAR(%SST(&FILS +
                                55 17)) VALUE('(' *CAT (%SST(&FILES +
                                33 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N5) THEN(CHGVAR VAR(%SST(&FILS +
                                73 17)) VALUE('(' *CAT (%SST(&FILES +
                                43 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N6) THEN(CHGVAR VAR(%SST(&FILS +
                                91 17)) VALUE('(' *CAT (%SST(&FILES +
                                53 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N7) THEN(CHGVAR VAR(%SST(&FILS +
                               109 17)) VALUE('(' *CAT (%SST(&FILES +
                                63 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N8) THEN(CHGVAR VAR(%SST(&FILS +
                               127 17)) VALUE('(' *CAT (%SST(&FILES +
                                73 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB>=&N9) THEN(CHGVAR VAR(%SST(&FILS +
                               145 17)) VALUE('(' *CAT (%SST(&FILES +
                                83 10)) *BCAT '*ALL' *CAT ')' ))
                   IF         COND(&NUMB >= &N10) THEN(CHGVAR +
                              VAR(%SST(&FILS 163 17)) VALUE('(' *CAT +
                              (%SST(&FILES 93 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N11) THEN(CHGVAR +
                              VAR(%SST(&FILS 181 17)) VALUE('(' *CAT +
                              (%SST(&FILES 103 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N12) THEN(CHGVAR +
                              VAR(%SST(&FILS 199 17)) VALUE('(' *CAT +
                              (%SST(&FILES 113 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N13) THEN(CHGVAR +
                              VAR(%SST(&FILS 217 17)) VALUE('(' *CAT +
                              (%SST(&FILES 123 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N14) THEN(CHGVAR +
                              VAR(%SST(&FILS 235 17)) VALUE('(' *CAT +
                              (%SST(&FILES 133 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N15) THEN(CHGVAR +
                              VAR(%SST(&FILS 253 17)) VALUE('(' *CAT +
                              (%SST(&FILES 143 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N16) THEN(CHGVAR +
                              VAR(%SST(&FILS 271 17)) VALUE('(' *CAT +
                              (%SST(&FILES 153 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N17) THEN(CHGVAR +
                              VAR(%SST(&FILS 289 17)) VALUE('(' *CAT +
                              (%SST(&FILES 163 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N18) THEN(CHGVAR +
                              VAR(%SST(&FILS 307 17)) VALUE('(' *CAT +
                              (%SST(&FILES 173 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N19) THEN(CHGVAR +
                              VAR(%SST(&FILS 325 17)) VALUE('(' *CAT +
                              (%SST(&FILES 183 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N20) THEN(CHGVAR +
                              VAR(%SST(&FILS 343 17)) VALUE('(' *CAT +
                              (%SST(&FILES 193 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N21) THEN(CHGVAR +
                              VAR(%SST(&FILS 361 17)) VALUE('(' *CAT +
                              (%SST(&FILES 203 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N22) THEN(CHGVAR +
                              VAR(%SST(&FILS 379 17)) VALUE('(' *CAT +
                              (%SST(&FILES 213 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N23) THEN(CHGVAR +
                              VAR(%SST(&FILS 387 17)) VALUE('(' *CAT +
                              (%SST(&FILES 223 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N24) THEN(CHGVAR +
                              VAR(%SST(&FILS 405 17)) VALUE('(' *CAT +
                              (%SST(&FILES 233 10)) *BCAT '*ALL' +
                              *CAT ')'))
                   IF         COND(&NUMB >= &N25) THEN(CHGVAR +
                              VAR(%SST(&FILS 423 17)) VALUE('(' *CAT +
                              (%SST(&FILES 243 10)) *BCAT '*ALL' +
                              *CAT ')'))
/**/
/*  UNSUCCESSFUL COMPLETION - REMOVE ALL JOURNAL CHANGES FROM &INIT */
/*  & SAVE FINAL SEQUENCE NUMBER                                    */
/**/
             RTVDTAARA  DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
/**/
             CHGVAR     VAR(&INITIAL) VALUE(%SST(&FFSTAT 12 10))
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             RTVJRNE    JRN(FFJRN) FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) RTNSEQNBR(&FINAL)
             MONMSG     MSGID(CPF7073) EXEC(DO)
                        CHGVAR (&FINALA) VALUE('0000000000')
                        ENDJRNPF   FILE(*ALL) JRN(FFJRN)
                        GOTO SETPARM
                        ENDDO
             CHGVAR     VAR(&FINALA) VALUE(&FINAL)
/**/
/*     IF NO JOURNAL ENTRIES WERE WRITTEN, DO NOT PERFORM 'RMVJRNCHG'*/
/*     AS 'FROM ENTRY' WILL BE LESS THAN 'TO ENTRY' AND SO INVALID   */
/**/
             CHGVAR     VAR(&INITIALN) VALUE(&INITIAL)
             IF         COND(&FINAL *LT &INITIALN) THEN(GOTO +
                          CMDLBL(ENDRMV))
/**/
/**********  CHGVAR     VAR(&MSG) VALUE('RMVJRNCHG JRN(FFJRN) FILE(' +
                          ** &FILS ** ' ) FROMENT(' ** &FINALA +
                          ** ') TOENT(' ** &INITIAL ** ')')           */ /*BG18886*/
             CHGVAR     VAR(&MSG) VALUE('RMVJRNCHG JRN(FFJRN) FILE(' +
                          *CAT &FILS *TCAT ' ) FROMENT(' *CAT +
                          &FINALA *TCAT ') TOENT(' *CAT &INITIAL +
                          *TCAT ')')                                     /*BG18886*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*                                                                      CCB009*/
/*     Retrieve the journal sequence number of the most recent          CCB009*/
/*     journal entry.                                                   CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          RTNSEQNBR(&FINAL)                           /*CCB009*/
             MONMSG     MSGID(CPF7073) EXEC(DO)                       /*CCB009*/
                        CHGVAR (&FINALA) VALUE('0000000000')          /*CCB009*/
                        GOTO SETPARM                                  /*CCB009*/
                        ENDDO                                         /*CCB009*/
             CHGVAR     VAR(&FINALA) VALUE(&FINAL)                    /*CCB009*/
/**/                                                                  /*CCB009*/
/*     If no journal entries were written, do not perform 'RMVJRNCHG'*/
/*     as 'from' entry will be less than 'to' entry and so invalid.  */
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&INITIALN) VALUE(&INITIAL)                /*CCB009*/
             IF         COND(&FINAL *LT &INITIALN) THEN(GOTO +
                          CMDLBL(ENDRMV))                             /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  CHGVAR     VAR(&MSG) VALUE('RMVJRNCHG JRN(ICJRN) FILE(' +
                          ** &FILS ** ' ) FROMENT(' ** &FINALA +
                          ** ') TOENT(' ** &INITIAL ** ')')           */ /*CCB009*/ /*BG18886*/
             CHGVAR     VAR(&MSG) VALUE('RMVJRNCHG JRN(ICJRN) FILE(' +
                          *CAT &FILS *TCAT ' ) FROMENT(' *CAT +
                          &FINALA *TCAT ') TOENT(' *CAT &INITIAL +
                          *TCAT ')')                                     /*CCB009*/ /*BG18886*/
             ENDDO                                                    /*CCB009*/
/*********** CALL       PGM(QCAEXEC) PARM(&MSG 750)                   **E21147*/
             CALL       PGM(QCMDEXC) PARM(&MSG 750)                   /*E21147*/
ENDRMV:
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(FFJRN)
             ENDDO                                                    /*CCB009*/
/**/
SETPARM:
             CHGDTAARA  DTAARA(FFSTAT (22 10)) VALUE(&FINALA)
/**/
             GOTO       CMDLBL(END)                                   /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFCJRN3X - Final journal processing +
                          for sub-component terminated abnormally') +
                          TOMSGQ(MOPERQ MRUNQ) /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
END:                                                                  /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
