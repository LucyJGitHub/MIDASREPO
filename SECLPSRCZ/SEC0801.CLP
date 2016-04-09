/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Exposure Reports - Holdings')                */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                 */
/*                                                                   */
/*       SEC0801   HOLDINGS EXPOSURE REPORT                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG11913           Date 17Aug06              */
/*       Prev Amend No. BUG11638           Date 29Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAC005             Date 23Nov98              */
/*                      098862             Date 26Jan96              */
/*                      E37910             Date 31Mar92              */
/*                      E29102             DATE 02OCT91              */
/*                      S01117             DATE 09JAN91              */
/*                      E23530             DATE 20SEP90              */
/*                      E23283             DATE 21AUG90              */
/*                      E21159             DATE 12APR90              */
/*                      S01179             DATE 16/12/88             */
/*                      S01176             DATE 25/08/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*      BUG11913 - Open query error in BKPHDQF file because RSKC     */
/*                 field has been changed from numeric to alpha.     */
/*      BUG11638 - SEC0801 failed                                    */
/*      CAC005 - Profit Centre Accounting - SE Enhancement           */
/*      098862 - The open query file commands which join BKPHDJF2 to */
/*               CLINTCB fail because both files have the            */
/*               filler field ZZ005 specified on them.  Solution is  */
/*               to use the MAPFLD parameter to specify one of the   */
/*               files (arbitrarily the first in each case) to use.  */
/*               This was introduced when ZZ005 was introduced to    */
/*               BKPHDJF2 by fix 052254.                             */
/*               Similarly on join of CPOSNJF and CLINTCB.           */
/*      E37910 - In single branch mode the system is blank, so the   */
/*               entity is blank.This causes problems on the opnqryf */
/*               command for BKPHDGF2.                               */
/*      E29102 - FIELD BHBR HAS BEEN REPLACED BY BHBA.               */
/*                 "   BRCD  "   "     "   "  "  BRCA.               */
/*                 "   CSBR  "   "     "   "  "  CSBA.               */
/*      S01117 - MULTIBRANCHING                                      */
/*      E23530 - PROGRAM REWRITTEN FOR REL 2 PTF 2 TO PURGE DELETED  */
/*               LINES, REMOVE UNNESSESARY OPNQRYF COMMANDS FOR FILES*/
/*               BKPHDQF AND CPOSNQF, RATIONALISE STRUCTURE AND      */
/*               INSERT CORRECT COMMENT LINES.  DDS FOR BKPHDJF2 AND */
/*               CPOSNJF ALSO AMENDED TO EXCLUDE ZERO POSITIONS -    */
/*               THIS ALSO EXCLUDES POSITIONS FOR DELETED SECURITIES.*/
/*      E23283 - DB ERROR CAUSED BY RSKC = 0 IF &CAT = 5             */
/*      E21159 - PROGRAM FALL-OVER DUE TO S38 FORMAT USED            */
/*      S01179 - RELEASE                                         */
/*      S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/************PGM        PARM(&LEVEL &BYBOOK &CAT &HOLD &EXCEPT +     * *S01117*/
/************                &FACTORED)                              * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BYBOOK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EXCEPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FACTORED) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LETTER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CATF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LVLF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ETYF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BOKF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LMTF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LLMF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SLMF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&EXDF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CATL) TYPE(*CHAR) LEN(6)
/*           DCL        VAR(&ETYL) TYPE(*CHAR) LEN(6)             */ /*E29102*/
             DCL        VAR(&ETYL) TYPE(*CHAR) LEN(7)
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01117*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(*BLANKS) /*CAC005*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) VALUE(*VERIFY) /*CAC005*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6) VALUE(CAC005)  /*CAC005*/
             DCL        VAR(&CAC005) TYPE(*CHAR) LEN(1) VALUE('N')    /*CAC005*/
 
/* EXTRACT PROMPT PARAMETERS FROM RCF */                              /*S01117*/
             CHGVAR     VAR(&LEVEL) VALUE(&RLEV)                      /*S01117*/
             CHGVAR     VAR(&BYBOOK) VALUE(%SST(&RPARM 1 1))          /*S01117*/
             CHGVAR     VAR(&CAT) VALUE(%SST(&RPARM 2 1))             /*S01117*/
             CHGVAR     VAR(&HOLD) VALUE(%SST(&RPARM 3 1))            /*S01117*/
             CHGVAR     VAR(&EXCEPT) VALUE(%SST(&RPARM 4 1))          /*S01117*/
             CHGVAR     VAR(&FACTORED) VALUE(%SST(&RPARM 5 1))        /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                          */
 
             CHGVAR     VAR(&MSG)  +
             VALUE('SEC0801 - Exposure Report - Holdings')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                    */
 
             CHGJOB     SWS(00000000)
 
/* IF BYBOOK IS Y SET ON U1                            */
 
             IF         COND(&BYBOOK *EQ 'Y') THEN(CHGJOB +
                          SWS('1XXXXXXX'))
 
/*  SET UP PARAMETERS REQUIRED IN  SLIMQF OPNQRYF COMMAND */
 
             IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '2')) +
                          THEN(DO)
                          CHGVAR &FILE 'SLIMH '
                          CHGVAR &LETTER 'H'
                          CHGVAR &CATF 'CSTL'
                          ENDDO
             IF         COND(&CAT *EQ '3') THEN(DO)
                          CHGVAR &FILE 'SLIMF '
                          CHGVAR &LETTER 'F'
                          CHGVAR &CATF 'CNCL'
                          ENDDO
             IF         COND((&CAT *EQ '4') *OR (&CAT *EQ '5')) +
                          THEN(DO)
                          CHGVAR &FILE 'SLIME '
                          CHGVAR &LETTER 'E'
                          CHGVAR &CATF 'CTYL'
                          ENDDO
             IF         COND(&CAT *EQ '6') THEN(DO)
                          CHGVAR &FILE 'SLIMG '
                          CHGVAR &LETTER 'G'
                          CHGVAR &CATF 'INTL'
                          ENDDO
             IF         COND(&CAT *EQ '7') THEN(DO)
                          CHGVAR &FILE 'SLIMI '
                          CHGVAR &LETTER 'I'
                          CHGVAR &CATF 'SCTL'
                          ENDDO
 
             CHGVAR &ETYF ('ETY' *CAT &LETTER)
             CHGVAR &LVLF ('LVL' *CAT &LETTER)
             CHGVAR &BOKF ('BOK' *CAT &LETTER)
             CHGVAR &LMTF ('LMT' *CAT &LETTER)
             CHGVAR &LLMF ('LLM' *CAT &LETTER)
             CHGVAR &SLMF ('SLM' *CAT &LETTER)
             CHGVAR &EXDF ('EXD' *CAT &LETTER)
             IF         COND(&CAT *EQ '7') THEN(DO)
                          CHGVAR &LMTF '''  '''
                          ENDDO
 
/* Check if CAC005 is switched on */                                  /*CAC005*/
                                                                      /*CAC005*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD)      /*CAC005*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)           /*CAC005*/
                CHGVAR     VAR(&CAC005) VALUE('Y')                    /*CAC005*/
                ENDDO                                                 /*CAC005*/
 
/*      O P E N   Q U E R Y   F I L E   S L I M Q F                 */
/*      -------------------------------------------                 */
 
/*  OVERIDE DATABASE FILE                      */
 
             OVRDBF     FILE(SLIMQF) TOFILE(&FILE) SHARE(*YES)
 
/*  CATEGORY = 1 OR 2 (WITH EXTRA MAP FOR ZONED FIELD)               */
        IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '2')) THEN(DO)
 
             IF         COND(&BYBOOK *EQ 'Y') THEN(DO)
             OPNQRYF    FILE((&FILE)) FORMAT(SLIMQF) QRYSLT('(' *CAT +
                          &BOKF *CAT ' *NE '' '') *AND (' *CAT &LVLF +
                          *CAT ' *EQ ''' *CAT &LEVEL *CAT            +
                          ''') *AND (RECI *EQ ''D'')')               +
                          KEYFLD((SQEN) (SQBK) (SQCT))               +
                          MAPFLD((SQEN &ETYF) (SQBK &BOKF)           +
                           (SQLT &LMTF) (SQLL &LLMF) (SQSL &SLMF)    +
                           (WKCS &CATF *CHAR 6) (SQCT WKCS)          +
                           (SQEX &EXDF))
             ENDDO
             ELSE   (DO)
             OPNQRYF    FILE((&FILE)) FORMAT(SLIMQF) QRYSLT('(' *CAT +
                          &BOKF *CAT ' *EQ '' '') *AND (' *CAT &LVLF +
                          *CAT ' *EQ ''' *CAT &LEVEL *CAT            +
                          ''') *AND (RECI *EQ ''D'')')               +
                         KEYFLD((SQEN) (SQBK) (SQCT))                +
                         MAPFLD((SQEN &ETYF) (SQBK &BOKF)            +
                          (SQLT &LMTF) (SQLL &LLMF) (SQSL &SLMF)     +
                          (WKCS &CATF *CHAR 6) (SQCT WKCS)           +
                          (SQEX &EXDF))
            ENDDO
        ENDDO
 
/*  CATEGORY = 3 4 5 6 OR 7                                          */
        IF         COND((&CAT *NE '1') *AND (&CAT *NE '2')) THEN(DO)
 
             IF         COND(&BYBOOK *EQ 'Y') THEN(DO)
             OPNQRYF    FILE((&FILE)) FORMAT(SLIMQF)                 +
                        QRYSLT('(' *CAT &BOKF *CAT ' *NE '' '')      +
                          *AND (' *CAT &LVLF *CAT ' *EQ ''' *CAT     +
                          &LEVEL *CAT ''') *AND (RECI *EQ ''D'')')   +
                        KEYFLD((SQEN) (SQBK) (SQCT))                 +
                        MAPFLD((SQCT &CATF) (SQEN &ETYF) (SQBK &BOKF) +
                         (SQLT &LMTF) (SQLL &LLMF) (SQSL &SLMF)       +
                         (SQEX &EXDF))
             ENDDO
             ELSE   (DO)
             OPNQRYF    FILE((&FILE)) FORMAT(SLIMQF) QRYSLT('(' *CAT +
                          &BOKF *CAT ' *EQ '' '') *AND (' *CAT &LVLF +
                          *CAT ' *EQ ''' *CAT &LEVEL *CAT            +
                          ''') *AND (RECI *EQ ''D'')')               +
                        KEYFLD((SQEN) (SQBK) (SQCT))                 +
                        MAPFLD((SQCT &CATF) (SQEN &ETYF) (SQBK &BOKF) +
                         (SQLT &LMTF) (SQLL &LLMF) (SQSL &SLMF)       +
                         (SQEX &EXDF))
             ENDDO
        ENDDO
 
 
/*      O P E N   Q U E R Y   F I L E   B K P H D Q F                */
/*      ---------------------------------------------                */
 
/* OPEN QUERY FILE BKPHDQF IF REPORT ON OWN HOLDINGS OR ALL HOLDINGS */
 
  IF      COND((&HOLD *EQ 'O') *OR (&HOLD *EQ 'A')) THEN(DO)
 
/*  DETERMINE WHICH JOIN FILES REQIURED */
 
        CHGVAR &FN1 '0'
        CHGVAR &FN2 '0'
 
/*  IF CAT EQ 1 2 OR 5, CHANGE FN1 TO '2'                           */
        IF   COND((&CAT *EQ '1') *OR (&CAT *EQ '2') +
             *OR (&CAT *EQ '5'))    +
           THEN(CHGVAR &FN1 '2')
 
/*  IF COMPANY LEVEL, CAT 3 4 6 OR 7, CHANGE FN2 TO '2'           */
        IF   COND(&LEVEL *EQ 'C') THEN(DO)
           IF (&FN1 *EQ '0') THEN(CHGVAR &FN2 '2')
/*  IF COMPANY LEVEL, CAT 1 2 OR 5, CHANGE FN2 TO '3'             */
        ELSE (CHGVAR &FN2 '3')
        ENDDO
 
/*  SET UP PARAMETERS REQUIRED IN BKPHDQF OPNQRYF COMMAND         */
 
        IF   COND(&CAT *EQ '1') THEN(CHGVAR &CATL 'RSKC')
        IF   COND(&CAT *EQ '2') THEN(CHGVAR &CATL (&FN1 *CAT '/CPAR'))
        IF   COND(&CAT *EQ '3') THEN(CHGVAR &CATL 'BQNC')
        IF   COND(&CAT *EQ '4') THEN(CHGVAR &CATL 'SCOR')
        IF   COND(&CAT *EQ '5') THEN(CHGVAR &CATL (&FN1 *CAT '/CCTZ'))
        IF   COND(&CAT *EQ '6') THEN(CHGVAR &CATL 'SITP')
        IF   COND(&CAT *EQ '7') THEN(CHGVAR &CATL 'BHSC')
 
        IF   COND(&BYBOOK *EQ 'Y') THEN(CHGVAR &BOKF 'BHBK')
        IF   COND(&BYBOOK *EQ 'N') THEN(CHGVAR &BOKF '''  ''')
 
/*******IF   COND(&LEVEL *EQ 'B') THEN(CHGVAR &ETYL 'BHBR')       */  /*E29102*/
        IF   COND(&LEVEL *EQ 'B') THEN(CHGVAR &ETYL 'BHBA')           /*E29102*/
/**IF  COND(&LEVEL *EQ 'C') THEN(CHGVAR &ETYL (&FN2 *CAT '/CMPY')) */ /*E29102*/
    IF  COND(&LEVEL *EQ 'C') THEN(CHGVAR &ETYL (&FN2 *CAT '/CMPYM'))  /*E29102*/
        IF   COND(&LEVEL *EQ 'S') THEN(CHGVAR &ETYL ''' ''')
        IF   COND(&LEVEL *EQ ' ') THEN(CHGVAR &ETYL 'BHBA')           /*E37910*/
 
 
/*  OVERIDE DATABASE FILE                      */
 
        IF   COND(&CAC005 *EQ 'N') THEN(DO)                           /*CAC005*/
             OVRDBF     FILE(BKPHDQF) TOFILE(BKPHDJF2) SHARE(*YES)
             ENDDO                                                    /*CAC005*/
        ELSE (DO)                                                     /*CAC005*/
             OVRDBF     FILE(BKPHDQJF) TOFILE(BKPHDJF2) SHARE(*YES)   /*CAC005*/
             ENDDO                                                    /*CAC005*/
 
 
/****** F I R S T   S E T  -  N O T  C O M P A N Y  L E V E L *******/
 
/*  1ST SET - CATEGORY EQ 3 4 6 OR 7 - NO JOIN FILE                 */
 
/*  FIRST SET - IF NO JOINED FILE                                    */
    IF         COND((&FN1 *EQ '0') *AND (&FN2 *EQ '0')) THEN(DO)
 
/*  CATEGORY  - 3 4 6 OR 7, NOT COMPANY LEVEL                     */
    IF         COND(&CAC005 *EQ 'N') THEN(DO)                         /*CAC005*/
                                                                      /*CAC005*/
                  OPNQRYF FILE(BKPHDJF2)  +
                  FORMAT(BKPHDQF) +
                  QRYSLT('SCOR *NE ''   ''')  +
                  KEYFLD((BQEN) (BQBK) (BQCT)) +
                  MAPFLD((BQCT &CATL)   +
                         (BQBK &BOKF) (BQEN &ETYL))
 
    ENDDO                                                             /*CAC005*/
    ELSE (DO)                                                         /*CAC005*/
                  OPNQRYF FILE((BKPHDJF2) (SDBKPCPD)) +
                  FORMAT(BKPHDQJF) +
                  QRYSLT('SCOR *NE ''   ''')  +
                  KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +
                  JFLD((BHBK 2/PSPSBK)) +
                  MAPFLD((BQCT &CATL) (BQBK &BOKF) +
                         (BQEN &ETYL) (USBK PSBKCD) (PRFC PSPRFC))    /*CAC005*/
    ENDDO                                                             /*CAC005*/
    ENDDO
    ELSE (DO)
 
/****** S E C O N D   S E T  -  N O T  C O M P A N Y  L E V E L ****/
 
/*  2ND SET - CATEGORY EQ 1 2 OR 5 - JOIN FILE  CLINTCB            */
 
/* IF CAT EQ 1 2 OR 5 AND NOT COMPANY LEVEL                        */
      IF           COND((&FN1 *EQ '2') *AND (&FN2 *EQ '0')) THEN(DO)
 
/* IF CAT EQ 1 2 OR 5                                              */
             IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '2') *OR +
                          (&CAT *EQ '5')) THEN(DO)
/*  CATEGORY = 1 OR 5 WITH EXTRA MAP FOR ZONED FIELD */
             IF       COND((&CAT *EQ '1') *OR (&CAT *EQ '5'))  THEN(DO)
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +  *098862*/
/************             QRYSLT('RSKC *NE 0')                   +    *098862*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))           +    *098862*/
/************             JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)      +    *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +    *098862*/
/************              *CHAR 6) (BQCT WRK2) (BQEN &ETYL)     +    *098862*/
/************              (BQBK &BOKF))                              *098862*/
             IF         COND(&CAC005 *EQ 'N') THEN(DO)                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +   */    /*098862*/ /*BUG11638*/
/**********               QRYSLT('RSKC *NE 0') KEYFLD((BQEN) (BQBK) +  */    /*098862*/ /*BUG11638*/
/**********               (BQCT)) JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +  */    /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +     */    /*098862*/ /*BUG11638*/
/**********               *CHAR 6) (BQCT WRK2) (BQEN &ETYL) (BQBK +    */    /*098862*/ /*BUG11638*/
/**********               &BOKF) (ZZ005 '1/ZZ005'))                    */    /*098862*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +       /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('RSKC *NE 000000') KEYFLD((BQEN) (BQBK) + /*BUG11638*/ /*BUG11913*/
/**********               (BQCT)) JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +      /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********               *CHAR 6) (BQCT WRK2) (BQEN &ETYL) (BQBK +        /*BUG11638*/ /*BUG11913*/
/**********               &BOKF) (ZZ005 '1/ZZ005'))                        /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +
                          QRYSLT('RSKC *NE ''000000'' *OR RSKC *NE +
                          '' ''') KEYFLD((BQEN) (BQBK) (BQCT)) +
                          JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (BQCT WRK2) (BQEN &ETYL) (BQBK +
                          &BOKF) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO                                                   /*CAC005*/
             ELSE (DO)                                               /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +       */     /*CAC005*/ /*BUG11638*/
/**********               FORMAT(BKPHDQJF) QRYSLT('RSKC *NE 0') +     */     /*CAC005*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +       */     /*CAC005*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +       */     /*CAC005*/ /*BUG11638*/
/**********               JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) + */     /*CAC005*/ /*BUG11638*/
/**********               (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +     */     /*CAC005*/ /*BUG11638*/
/**********               &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +     */     /*CAC005*/ /*BUG11638*/
/**********               (USBK PSBKCD) (PRFC PSPRFC))                */     /*CAC005*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +            /*BUG11638*/ /*BUG11913*/
/**********               FORMAT(BKPHDQJF) QRYSLT('RSKC *NE 000000') +     /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +            /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +            /*BUG11638*/ /*BUG11913*/
/**********               JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) +      /*BUG11638*/ /*BUG11913*/
/**********               (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +          /*BUG11638*/ /*BUG11913*/
/**********               &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +          /*BUG11638*/ /*BUG11913*/
/**********               (USBK PSBKCD) (PRFC PSPRFC))                     /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +
                          FORMAT(BKPHDQJF) QRYSLT('RSKC *NE +
                          ''000000'' *OR RSKC *NE '' ''') +
                          KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +
                          JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +
                          JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) +
                          (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +
                          &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +
                          (USBK PSBKCD) (PRFC PSPRFC))                                  /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ENDDO
/*  CATEGORY =2 WITH EXTRA MAP FOR ZONED FIELD */
             IF         COND((&CAT *EQ '2')) THEN(DO)
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +  *098862*/
/************             QRYSLT('CPAR *NE 0')                   +    *098862*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))           +    *098862*/
/************             JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)      +    *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +    *098862*/
/************               *CHAR 6) (BQCT WRK2) (BQEN &ETYL)    +    *098862*/
/************               (BQBK &BOKF))                             *098862*/
             IF         COND(&CAC005 *EQ 'N') THEN(DO)                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) + */      /*098862*/ /*BUG11638*/
/**********               QRYSLT('CPAR *NE 0')                   +   */      /*098862*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))           +   */      /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)      +   */      /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +   */      /*098862*/ /*BUG11638*/
/**********                 *CHAR 6) (BQCT WRK2) (BQEN &ETYL)    +   */      /*098862*/ /*BUG11638*/
/**********                 (BQBK &BOKF) (ZZ005 '1/ZZ005'))          */      /*098862*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +       /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('CPAR *NE 000000')              +         /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))           +         /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)      +         /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (BQCT WRK2) (BQEN &ETYL)    +         /*BUG11638*/ /*BUG11913*/
/**********                 (BQBK &BOKF) (ZZ005 '1/ZZ005'))                /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB)) FORMAT(BKPHDQF) +
                          QRYSLT('CPAR *NE ''000000'' *OR CPAR *NE +
                          '' ''') KEYFLD((BQEN) (BQBK) (BQCT)) +
                          JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (BQCT WRK2) (BQEN &ETYL) (BQBK +
                          &BOKF) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ELSE (DO)                                                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +       */     /*CAC005*/ /*BUG11638*/
/**********               FORMAT(BKPHDQJF) QRYSLT('CPAR *NE 0') +     */     /*CAC005*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +       */     /*CAC005*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +       */     /*CAC005*/ /*BUG11638*/
/**********               JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) + */     /*CAC005*/ /*BUG11638*/
/**********               (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +     */     /*CAC005*/ /*BUG11638*/
/**********               &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +     */     /*CAC005*/ /*BUG11638*/
/**********               (USBK PSBKCD) (PRFC PSPRFC))                */     /*CAC005*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +            /*BUG11638*/ /*BUG11913*/
/**********               FORMAT(BKPHDQJF) QRYSLT('CPAR *NE 000000') +     /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +            /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +            /*BUG11638*/ /*BUG11913*/
/**********               JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) +      /*BUG11638*/ /*BUG11913*/
/**********               (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +          /*BUG11638*/ /*BUG11913*/
/**********               &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +          /*BUG11638*/ /*BUG11913*/
/**********               (USBK PSBKCD) (PRFC PSPRFC))                     /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (SDBKPCPD)) +
                          FORMAT(BKPHDQJF) QRYSLT('CPAR *NE +
                          ''000000'' *OR CPAR *NE '' ''') +
                          KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +
                          JFLD((RSKC 2/CNUM) (BHBK 3/PSPSBK)) +
                          JDFTVAL(*YES) MAPFLD((WRK1 &CATL *CHAR 6) +
                          (WRK2 WRK1 *CHAR 6) (BQCT WRK2) (BQEN +
                          &ETYL) (BQBK &BOKF) (ZZ005 '1/ZZ005') +
                          (USBK PSBKCD) (PRFC PSPRFC))                                  /*BUG11913*/
             ENDDO
             ENDDO
 
         ENDDO
 
      ENDDO
 
/********** T H I R D   S E T  -  C O M P A N Y  L E V E L ***********/
 
/*  3RD SET - CATEGORY EQ 1 2 OR 5 - JOIN FILES  CLINTCB, TABLETR    */
/*  3ND SET - CATEGORY EQ 3 4 6 OR 5 - JOIN FILE  TABLETR            */
 
      IF      COND(&LEVEL *EQ 'C') THEN(DO)
 
/*  CATEGORY = 1 2 OR 5 WITH EXTRA MAP FOR ZONED FIELD               */
           IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '2') *OR +
                        (&CAT *EQ '5')) THEN(DO)
 
             IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '5')) +
                          THEN(DO)
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR))   +        E29102*/
/***********              FORMAT(BKPHDQF)                      +        E29102*/
/***********              QRYSLT('RSKC *NE 0')                 +        E29102*/
/***********              KEYFLD((BQEN) (BQBK) (BQCT))         +        E29102*/
/***********              JFLD((RSKC 2/CNUM) (BHBR 3/BRCD))    +        E29102*/
/***********              JDFTVAL(*YES)                        +        E29102*/
/***********              MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +      E29102*/
/***********                *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +      E29102*/
/***********                (BQEN &ETYL))                               E29102*/
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR))   +      *098862*/
/************             FORMAT(BKPHDQF)                      +      *098862*/
/************             QRYSLT('RSKC *NE 0')                 +      *098862*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))         +      *098862*/
/************             JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))    +      *098862*/
/************             JDFTVAL(*YES)                        +      *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +    *098862*/
/************               *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +    *098862*/
/************               (BQEN &ETYL))                  /*E29102*  *098862*/
             IF         COND(&CAC005 *EQ 'N') THEN(DO)                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR))   +   */        /*098862*/ /*BUG11638*/
/**********               FORMAT(BKPHDQF)                      +   */        /*098862*/ /*BUG11638*/
/**********               QRYSLT('RSKC *NE 0')                 +   */        /*098862*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))         +   */        /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))    +   */        /*098862*/ /*BUG11638*/
/**********               JDFTVAL(*YES)                        +   */        /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 + */        /*098862*/ /*BUG11638*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    + */        /*098862*/ /*BUG11638*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005'))        */        /*098862*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR))   +           /*BUG11638*/ /*BUG11913*/
/**********               FORMAT(BKPHDQF)                      +           /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('RSKC *NE 000000')            +           /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))         +           /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))    +           /*BUG11638*/ /*BUG11913*/
/**********               JDFTVAL(*YES)                        +           /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +         /*BUG11638*/ /*BUG11913*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005'))                /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +
                          FORMAT(BKPHDQF) QRYSLT('RSKC *NE +
                          ''000000'' *OR RSKC *NE '' ''') +
                          KEYFLD((BQEN) (BQBK) (BQCT)) JFLD((RSKC +
                          2/CNUM) (BHBA 3/BRCA)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (BQCT WRK2) (BQBK &BOKF) (BQEN +
                          &ETYL) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ELSE (DO)                                                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR) +       */       /*CAC005*/ /*BUG11638*/
/**********               (SDBKPCPD)) FORMAT(BKPHDQJF)         +    */       /*CAC005*/ /*BUG11638*/
/**********               QRYSLT('RSKC *NE 0')                 +    */       /*CAC005*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT))  +    */       /*CAC005*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA)     +    */       /*CAC005*/ /*BUG11638*/
/**********               (BHBK 4/PSPSBK)) JDFTVAL(*YES)   +        */       /*CAC005*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +  */       /*CAC005*/ /*BUG11638*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +  */       /*CAC005*/ /*BUG11638*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005') +        */       /*CAC005*/ /*BUG11638*/
/**********                 (USBK PSBKCD) (PRFC PSPRFC))            */       /*CAC005*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR) +              /*BUG11638*/ /*BUG11913*/
/**********               (SDBKPCPD)) FORMAT(BKPHDQJF)         +           /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('RSKC *NE 000000')            +           /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT))  +           /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA)     +           /*BUG11638*/ /*BUG11913*/
/**********               (BHBK 4/PSPSBK)) JDFTVAL(*YES)   +               /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +         /*BUG11638*/ /*BUG11913*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005') +               /*BUG11638*/ /*BUG11913*/
/**********                 (USBK PSBKCD) (PRFC PSPRFC))                   /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR) +
                          (SDBKPCPD)) FORMAT(BKPHDQJF) QRYSLT('RSKC +
                          *NE ''000000'' *OR RSKC *NE '' ''') +
                          KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +
                          JFLD((RSKC 2/CNUM) (BHBA 3/BRCA) (BHBK +
                          4/PSPSBK)) JDFTVAL(*YES) MAPFLD((WRK1 +
                          &CATL *CHAR 6) (WRK2 WRK1 *CHAR 6) (BQCT +
                          WRK2) (BQBK &BOKF) (BQEN &ETYL) (ZZ005 +
                          '1/ZZ005') (USBK PSBKCD) (PRFC PSPRFC))                       /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ENDDO
 
/*  CATEGORY = 2 WITH EXTRA MAP FOR ZONED FIELD                      */
             IF         COND((&CAT *EQ '2')) THEN(DO)
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +          E29102*/
/************             FORMAT(BKPHDQF)                    +          E29102*/
/************             QRYSLT('CPAR *NE 0')               +          E29102*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))       +          E29102*/
/************             JFLD((RSKC 2/CNUM) (BHBR 3/BRCD))  +          E29102*/
/************             JDFTVAL(*YES)                      +          E29102*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +      E29102*/
/************               *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +      E29102*/
/************               (BQEN &ETYL))                               E29102*/
/************OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +        *098862*/
/************             FORMAT(BKPHDQF)                    +        *098862*/
/************             QRYSLT('CPAR *NE 0')               +        *098862*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))       +        *098862*/
/************             JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))  +        *098862*/
/************             JDFTVAL(*YES)                      +        *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +    *098862*/
/************               *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +    *098862*/
/************               (BQEN &ETYL))                    /*E29102**098862*/
             IF         COND(&CAC005 *EQ 'N') THEN(DO)                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +     */        /*098862*/ /*BUG11638*/
/**********               FORMAT(BKPHDQF)                    +     */        /*098862*/ /*BUG11638*/
/**********               QRYSLT('CPAR *NE 0')               +     */        /*098862*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))       +     */        /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))  +     */        /*098862*/ /*BUG11638*/
/**********               JDFTVAL(*YES)                      +     */        /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 + */        /*098862*/ /*BUG11638*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    + */        /*098862*/ /*BUG11638*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005'))        */        /*098862*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +             /*BUG11638*/ /*BUG11913*/
/**********               FORMAT(BKPHDQF)                    +             /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('CPAR *NE 000000')          +             /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (BQBK) (BQCT))       +             /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA))  +             /*BUG11638*/ /*BUG11913*/
/**********               JDFTVAL(*YES)                      +             /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +         /*BUG11638*/ /*BUG11913*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005'))                /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)) +
                          FORMAT(BKPHDQF) QRYSLT('CPAR *NE +
                          ''000000'' *OR CPAR *NE '' ''') +
                          KEYFLD((BQEN) (BQBK) (BQCT)) JFLD((RSKC +
                          2/CNUM) (BHBA 3/BRCA)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (BQCT WRK2) (BQBK &BOKF) (BQEN +
                          &ETYL) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ELSE (DO)                                                /*CAC005*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)   +    */        /*CAC005*/ /*BUG11638*/
/**********               (SDBKPCPD)) FORMAT(BKPHDQJF)        +    */        /*CAC005*/ /*BUG11638*/
/**********               QRYSLT('CPAR *NE 0')                +    */        /*CAC005*/ /*BUG11638*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +    */        /*CAC005*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA)    +    */        /*CAC005*/ /*BUG11638*/
/**********               (BHBK 4/PSPSBK)) JDFTVAL(*YES)      +    */        /*CAC005*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 + */        /*CAC005*/ /*BUG11638*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    + */        /*CAC005*/ /*BUG11638*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005')       + */        /*CAC005*/ /*BUG11638*/
/**********                 (USBK PSBKCD) (PRFC PSPRFC))           */        /*CAC005*/ /*BUG11638*/
/**********  OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR)   +            /*BUG11638*/ /*BUG11913*/
/**********               (SDBKPCPD)) FORMAT(BKPHDQJF)        +            /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('CPAR *NE 000000')           +            /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +            /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM) (BHBA 3/BRCA)    +            /*BUG11638*/ /*BUG11913*/
/**********               (BHBK 4/PSPSBK)) JDFTVAL(*YES)      +            /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (BQCT WRK2) (BQBK &BOKF)    +         /*BUG11638*/ /*BUG11913*/
/**********                 (BQEN &ETYL) (ZZ005 '1/ZZ005')       +         /*BUG11638*/ /*BUG11913*/
/**********                 (USBK PSBKCD) (PRFC PSPRFC))                   /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((BKPHDJF2) (CLINTCB) (TABLETR) +
                          (SDBKPCPD)) FORMAT(BKPHDQJF) QRYSLT('CPAR +
                          *NE ''000000'' *OR CPAR *NE '' ''') +
                          KEYFLD((BQEN) (USBK) (PRFC) (BQCT)) +
                          JFLD((RSKC 2/CNUM) (BHBA 3/BRCA) (BHBK +
                          4/PSPSBK)) JDFTVAL(*YES) MAPFLD((WRK1 +
                          &CATL *CHAR 6) (WRK2 WRK1 *CHAR 6) (BQCT +
                          WRK2) (BQBK &BOKF) (BQEN &ETYL) (ZZ005 +
                          '1/ZZ005') (USBK PSBKCD) (PRFC PSPRFC))                       /*BUG11913*/
             ENDDO                                                    /*CAC005*/
             ENDDO
           ENDDO
           ELSE (DO)
/*  CATEGORY = 3 4 6 OR 7                                            */
/************OPNQRYF    FILE((BKPHDJF2) (TABLETR)) FORMAT(BKPHDQF) +    E29102*/
/************             QRYSLT('SCOR *NE ''   ''')               +    E29102*/
/************             KEYFLD((BQEN) (BQBK) (BQCT))             +    E29102*/
/************             JFLD((BHBR 2/BRCD))                      +    E29102*/
/************             JDFTVAL(*YES)                            +    E29102*/
/************             MAPFLD((BQCT &CATL) (BQBK &BOKF)         +    E29102*/
/************               (BQEN &ETYL))                               E29102*/
             IF         COND(&CAC005 *EQ 'N') THEN(DO)                /*CAC005*/
             OPNQRYF    FILE((BKPHDJF2) (TABLETR)) FORMAT(BKPHDQF) +
                          QRYSLT('SCOR *NE ''   ''')               +
                          KEYFLD((BQEN) (BQBK) (BQCT))             +
                          JFLD((BHBA 2/BRCA))                      +
                          JDFTVAL(*YES)                            +
                          MAPFLD((BQCT &CATL) (BQBK &BOKF)         +
                            (BQEN &ETYL))                             /*E29102*/
             ENDDO                                                    /*CAC005*/
             ELSE (DO)                                                /*CAC005*/
             OPNQRYF    FILE((BKPHDJF2) (TABLETR) (SDBKPCPD))      +
                          FORMAT(BKPHDQJF)                         +
                          QRYSLT('SCOR *NE ''   ''')               +
                          KEYFLD((BQEN) (USBK) (PRFC) (BQCT))      +
                          JFLD((BHBA 2/BRCA) (BHBK 3/PSPSBK))      +
                          JDFTVAL(*YES)                            +
                          MAPFLD((BQCT &CATL) (BQBK &BOKF)         +
                            (BQEN &ETYL) (USBK PSBKCD)             +
                            (PRFC PSPRFC))                            /*CAC005*/
             ENDDO                                                    /*CAC005*/
           ENDDO
 
        ENDDO
 
     ENDDO
 
   ENDDO
 
 
/*      O P E N   Q U E R Y   F I L E   C P O S N Q F                */
/*      ---------------------------------------------                */
 
/*  OPEN QUERY FILE CPOSNQF  IF REQUIRED */
 
             IF      COND((&HOLD *EQ 'D') *OR (&HOLD *EQ 'A') *OR +
                          (&HOLD *EQ 'S')) THEN(DO)
 
 
/*  DETERMINE WHICH JOIN FILES REQIURED */
 
        CHGVAR &FN1 '0'
        CHGVAR &FN2 '0'
 
/*  IF CAT EQ 1 2 OR 5, CHANGE FN1 TO '2'                           */
        IF   COND((&CAT *EQ '1') *OR (&CAT *EQ '2') +
             *OR (&CAT *EQ '5'))    +
           THEN(CHGVAR &FN1 '2')
 
/*  IF COMPANY LEVEL, CAT 3 4 6 OR 7, CHANGE FN2 TO '2'           */
        IF   COND(&LEVEL *EQ 'C') THEN(DO)
           IF (&FN1 *EQ '0') THEN(CHGVAR &FN2 '2')
/*  IF COMPANY LEVEL, CAT 1 2 OR 5, CHANGE FN2 TO '3'             */
        ELSE (CHGVAR &FN2 '3')
        ENDDO
 
/*  SET UP PARAMETERS REQUIRED IN CPOSNQF OPNQRYF COMMAND */
 
        IF   COND(&CAT *EQ '1') THEN(CHGVAR &CATL 'RSKC')
        IF   COND(&CAT *EQ '2') THEN(CHGVAR &CATL (&FN1 *CAT '/CPAR'))
        IF   COND(&CAT *EQ '3') THEN(CHGVAR &CATL 'CQNC')
        IF   COND(&CAT *EQ '4') THEN(CHGVAR &CATL 'SCOR')
        IF   COND(&CAT *EQ '5') THEN(CHGVAR &CATL (&FN1 *CAT '/CCTZ'))
        IF   COND(&CAT *EQ '6') THEN(CHGVAR &CATL 'SITP')
        IF   COND(&CAT *EQ '7') THEN(CHGVAR &CATL 'CSSC')
 
        IF   COND(&BYBOOK *EQ 'Y') THEN(CHGVAR &BOKF 'BHBK')
        IF   COND(&BYBOOK *EQ 'N') THEN(CHGVAR &BOKF '''  ''')
 
/*******IF   COND(&LEVEL *EQ 'B') THEN(CHGVAR &ETYL 'CSBR')    */     /*E29102*/
        IF   COND(&LEVEL *EQ 'B') THEN(CHGVAR &ETYL 'CSBA')           /*E29102*/
/*****IF  COND(&LEVEL *EQ 'C') THEN(CHGVAR &ETYL (&FN2 *CAT '/CMPY'))  *E29102*/
    IF  COND(&LEVEL *EQ 'C') THEN(CHGVAR &ETYL (&FN2 *CAT '/CMPYM'))  /*E29102*/
        IF   COND(&LEVEL *EQ 'S') THEN(CHGVAR &ETYL ''' ''')
        IF   COND(&LEVEL *EQ ' ') THEN(CHGVAR &ETYL 'CSBA')           /*E37910*/
 
/*  OVERIDE DATABASE FILE                                            */
 
             OVRDBF     FILE(CPOSNQF) TOFILE(CPOSNJF) SHARE(*YES)
 
/****** F I R S T   S E T  -  N O T  C O M P A N Y  L E V E L *******/
 
/*  1ST SET - CATEGORY EQ 3 4 6 OR 7 - NO JOIN FILE                 */
 
       IF         COND((&FN1 *EQ '0') *AND (&FN2 *EQ '0')) THEN(DO)
 
/*  CATEGORY  - 3 4 6 OR 7, NOT COMPANY LEVEL                     */
                  OPNQRYF FILE(CPOSNJF)  +
                  FORMAT(CPOSNQF) +
                  QRYSLT('SCOR *NE ''   ''')  +
                  KEYFLD((CQEN) (CQBK) (CQCT)) +
                  MAPFLD((CQCT &CATL)   +
                         (CQBK &BOKF) (CQEN &ETYL))
 
        ENDDO
        ELSE (DO)
 
/****** S E C O N D   S E T  -  N O T  C O M P A N Y  L E V E L ****/
 
/*  2ND SET - CATEGORY EQ 1 2 OR 5 - JOIN FILE  CLINTCB            */
 
/* IF CATEGORY EQ 1 2 OR 5 AND NOT COMPANY LEVEL                   */
        IF         COND((&FN1 *EQ '2') *AND (&FN2 *EQ '0')) THEN(DO)
 
/*  CATEGORY = 1 OR 5 WITH EXTRA MAP FOR ZONED FIELD */
             IF       COND((&CAT *EQ '1') *OR (&CAT *EQ '5'))  THEN(DO)
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +    *098862*/
/************             QRYSLT('RSKC *NE 0')                    +    *098862*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))            +    *098862*/
/************             JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)       +    *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1  +    *098862*/
/************               *CHAR 6) (CQCT WRK2) (CQEN &ETYL)     +    *098862*/
/************               (CQBK &BOKF))                              *098862*/
/**********  OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) + */       /*098862*/ /*BUG11638*/
/**********               QRYSLT('RSKC *NE 0')                    + */       /*098862*/ /*BUG11638*/
/**********               KEYFLD((CQEN) (CQBK) (CQCT))            + */       /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)       + */       /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1  + */       /*098862*/ /*BUG11638*/
/**********                 *CHAR 6) (CQCT WRK2) (CQEN &ETYL)     + */       /*098862*/ /*BUG11638*/
/**********                 (CQBK &BOKF) (ZZ005 '1/ZZ005'))         */       /*098862*/ /*BUG11638*/
             OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +
                          QRYSLT('RSKC *NE ''000000'' *OR RSKC *NE +
                          '' ''') KEYFLD((CQEN) (CQBK) (CQCT)) +
                          JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (CQCT WRK2) (CQEN &ETYL) (CQBK +
                          &BOKF) (ZZ005 '1/ZZ005')) /*BUG11638*/
             ENDDO
/*  CATEGORY = 2 WITH EXTRA MAP FOR ZONED FIELD */
             IF         COND((&CAT *EQ '2')) THEN(DO)
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +    *098862*/
/************             QRYSLT('CPAR *NE 0')                    +    *098862*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))            +    *098862*/
/************             JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)       +    *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1  +    *098862*/
/************               *CHAR 6) (CQCT WRK2) (CQEN &ETYL)     +    *098862*/
/************               (CQBK &BOKF))                              *098862*/
/**********  OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +  */      /*098862*/ /*BUG11638*/
/**********               QRYSLT('CPAR *NE 0')                    +  */      /*098862*/ /*BUG11638*/
/**********               KEYFLD((CQEN) (CQBK) (CQCT))            +  */      /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)       +  */      /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1  +  */      /*098862*/ /*BUG11638*/
/**********                 *CHAR 6) (CQCT WRK2) (CQEN &ETYL)     +  */      /*098862*/ /*BUG11638*/
/**********                 (CQBK &BOKF) (ZZ005 '1/ZZ005'))          */      /*098862*/ /*BUG11638*/
/**********  OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +        /*BUG11638*/ /*BUG11913*/
/**********               QRYSLT('CPAR *NE 000000')               +        /*BUG11638*/ /*BUG11913*/
/**********               KEYFLD((CQEN) (CQBK) (CQCT))            +        /*BUG11638*/ /*BUG11913*/
/**********               JFLD((RSKC 2/CNUM)) JDFTVAL(*YES)       +        /*BUG11638*/ /*BUG11913*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1  +        /*BUG11638*/ /*BUG11913*/
/**********                 *CHAR 6) (CQCT WRK2) (CQEN &ETYL)     +        /*BUG11638*/ /*BUG11913*/
/**********                 (CQBK &BOKF) (ZZ005 '1/ZZ005'))                /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((CPOSNJF) (CLINTCB)) FORMAT(CPOSNQF) +
                          QRYSLT('CPAR *NE ''000000'' *OR CPAR *NE +
                          '' ''') KEYFLD((CQEN) (CQBK) (CQCT)) +
                          JFLD((RSKC 2/CNUM)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (CQCT WRK2) (CQEN &ETYL) (CQBK +
                          &BOKF) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO
 
         ENDDO
 
/*************** T H I R D  S E T - C O M P A N Y   L E V E L ********/
 
/*  3RD SET - CATEGORY EQ 1 2 OR 5 - JOIN FILES  CLINTCB, TABLETR    */
/*  3ND SET - CATEGORY EQ 3 4 6 OR 5 - JOIN FILE  TABLETR            */
 
      IF      COND(&LEVEL *EQ 'C') THEN(DO)
 
          IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '2') *OR +
                       (&CAT *EQ '5')) THEN(DO)
 
             IF         COND((&CAT *EQ '1') *OR (&CAT *EQ '5')) +
                          THEN(DO)
/*  CATEGORY = 1 OR 5 WITH EXTRA MAP FOR ZONED FIELD                 */
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +          *E29102*/
/************             FORMAT(CPOSNQF) QRYSLT('RSKC *NE 0') +       *E29102*/
/************             KEYFLD((CQEN) (CQBK) (CQCT)) JFLD((RSKC +    *E29102*/
/************             2/CNUM) (CSBR 3/BRCD)) JDFTVAL(*YES) +       *E29102*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +     *E29102*/
/************             *CHAR 6) (CQCT WRK2) (CQBK &BOKF) (CQEN +    *E29102*/
/************             &ETYL))                                      *E29102*/
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +          *098862*/
/************             FORMAT(CPOSNQF) QRYSLT('RSKC *NE 0') +       *098862*/
/************             KEYFLD((CQEN) (CQBK) (CQCT)) JFLD((RSKC +    *098862*/
/************             2/CNUM) (CSBA 3/BRCA)) JDFTVAL(*YES) +       *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +     *098862*/
/************             *CHAR 6) (CQCT WRK2) (CQBK &BOKF) (CQEN +    *098862*/
/************             &ETYL))                            /*E29102* *098862*/
/**********  OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +        */      /*098862*/ /*BUG11638*/
/**********               FORMAT(CPOSNQF) QRYSLT('RSKC *NE 0') +     */      /*098862*/ /*BUG11638*/
/**********               KEYFLD((CQEN) (CQBK) (CQCT)) JFLD((RSKC +  */      /*098862*/ /*BUG11638*/
/**********               2/CNUM) (CSBA 3/BRCA)) JDFTVAL(*YES) +     */      /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +   */      /*098862*/ /*BUG11638*/
/**********               *CHAR 6) (CQCT WRK2) (CQBK &BOKF) (CQEN +  */      /*098862*/ /*BUG11638*/
/**********               &ETYL) (ZZ005 '1/ZZ005'))                  */      /*098862*/ /*BUG11638*/
             OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +
                          FORMAT(CPOSNQF) QRYSLT('RSKC *NE +
                          ''000000'' *OR RSKC *NE '' ''') +
                          KEYFLD((CQEN) (CQBK) (CQCT)) JFLD((RSKC +
                          2/CNUM) (CSBA 3/BRCA)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (CQCT WRK2) (CQBK &BOKF) (CQEN +
                          &ETYL) (ZZ005 '1/ZZ005'))                                     /*BUG11638*/
             ENDDO
             IF         COND((&CAT *EQ '2')) THEN(DO)
/*  CATEGORY = 2 WITH EXTRA MAP FOR ZONED FIELD                      */
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +          *E29102*/
/************             FORMAT(CPOSNQF)                   +          *E29102*/
/************             QRYSLT('CPAR *NE 0')              +          *E29102*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))      +          *E29102*/
/************             JFLD((RSKC 2/CNUM) (CSBR 3/BRCD)) +          *E29102*/
/************             JDFTVAL(*YES)                     +          *E29102*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +     *E29102*/
/************             *CHAR 6) (CQCT WRK2) (CQBK &BOKF)      +     *E29102*/
/************             (CQEN &ETYL))                                *E29102*/
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +          *098862*/
/************             FORMAT(CPOSNQF)                   +          *098862*/
/************             QRYSLT('CPAR *NE 0')              +          *098862*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))      +          *098862*/
/************             JFLD((RSKC 2/CNUM) (CSBA 3/BRCA)) +          *098862*/
/************             JDFTVAL(*YES)                     +          *098862*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +     *098862*/
/************             *CHAR 6) (CQCT WRK2) (CQBK &BOKF)      +     *098862*/
/************             (CQEN &ETYL))                      /*E29102* *098862*/
/**********  OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +       */       /*098862*/ /*BUG11638*/
/**********               FORMAT(CPOSNQF)                   +       */       /*098862*/ /*BUG11638*/
/**********               QRYSLT('CPAR *NE 0')              +       */       /*098862*/ /*BUG11638*/
/**********               KEYFLD((CQEN) (CQBK) (CQCT))      +       */       /*098862*/ /*BUG11638*/
/**********               JFLD((RSKC 2/CNUM) (CSBA 3/BRCA)) +       */       /*098862*/ /*BUG11638*/
/**********               JDFTVAL(*YES)                     +       */       /*098862*/ /*BUG11638*/
/**********               MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +  */       /*098862*/ /*BUG11638*/
/**********               *CHAR 6) (CQCT WRK2) (CQBK &BOKF)      +  */       /*098862*/ /*BUG11638*/
/**********               (CQEN &ETYL) (ZZ005 '1/ZZ005'))           */       /*098862*/ /*BUG11638*/
/************OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +              /*BUG11638*/ /*BUG11913*/
/************             FORMAT(CPOSNQF)                   +              /*BUG11638*/ /*BUG11913*/
/************             QRYSLT('CPAR *NE 000000')         +              /*BUG11638*/ /*BUG11913*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))      +              /*BUG11638*/ /*BUG11913*/
/************             JFLD((RSKC 2/CNUM) (CSBA 3/BRCA)) +              /*BUG11638*/ /*BUG11913*/
/************             JDFTVAL(*YES)                     +              /*BUG11638*/ /*BUG11913*/
/************             MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +         /*BUG11638*/ /*BUG11913*/
/************             *CHAR 6) (CQCT WRK2) (CQBK &BOKF)      +         /*BUG11638*/ /*BUG11913*/
/************             (CQEN &ETYL) (ZZ005 '1/ZZ005'))                  /*BUG11638*/ /*BUG11913*/
             OPNQRYF    FILE((CPOSNJF) (CLINTCB) (TABLETR)) +
                          FORMAT(CPOSNQF) QRYSLT('CPAR *NE +
                          ''000000'' *OR CPAR *NE '' ''') +
                          KEYFLD((CQEN) (CQBK) (CQCT)) JFLD((RSKC +
                          2/CNUM) (CSBA 3/BRCA)) JDFTVAL(*YES) +
                          MAPFLD((WRK1 &CATL *CHAR 6) (WRK2 WRK1 +
                          *CHAR 6) (CQCT WRK2) (CQBK &BOKF) (CQEN +
                          &ETYL) (ZZ005 '1/ZZ005'))                                     /*BUG11913*/
             ENDDO
          ENDDO
          ELSE (DO)
/*  CATEGORY = 3 4 6 OR 7                                            */
/************OPNQRYF    FILE((CPOSNJF) (TABLETR)) FORMAT(CPOSNQF) +    *E29102*/
/************             QRYSLT('SCOR *NE ''   ''')              +    *E29102*/
/************             KEYFLD((CQEN) (CQBK) (CQCT))            +    *E29102*/
/************             JFLD((CSBR 2/BRCD)) JDFTVAL(*YES)       +    *E29102*/
/************             MAPFLD((CQCT &CATL) (CQBK &BOKF)        +    *E29102*/
/************             (CQEN &ETYL))                                *E29102*/
             OPNQRYF    FILE((CPOSNJF) (TABLETR)) FORMAT(CPOSNQF) +
                          QRYSLT('SCOR *NE ''   ''')              +
                          KEYFLD((CQEN) (CQBK) (CQCT))            +
                          JFLD((CSBA 2/BRCA)) JDFTVAL(*YES)       +
                          MAPFLD((CQCT &CATL) (CQBK &BOKF)        +
                          (CQEN &ETYL))                               /*E29102*/
          ENDDO
        ENDDO
      ENDDO
    ENDDO
 
/* CALL THE PROGRAM SE1020                                           */
 
/************CALL       PGM(SE1020) PARM(&LEVEL &CAT &HOLD +         * *S01117*/
/************                            &EXCEPT &FACTORED)          * *S01117*/
             CALL       PGM(SE1020) PARM(&LEVEL &CAT &HOLD &EXCEPT +
                          &FACTORED &RSEQ &RENT)                      /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                         */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)            * *S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&MEM) VALUE('SEC0801 - Job Terminated, +
                          Database in error')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 ENDPGM:
 
/*  DELETE OVERIDE */
 
             DLTOVR     *ALL
             RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
