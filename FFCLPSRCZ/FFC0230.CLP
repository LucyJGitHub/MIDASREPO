/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Manual Position Close out Input')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0230  -  MANUAL POSITION CLOSE OUT INPUT                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. 261122             Date 15Jul09              */
/*                      261052             Date 09Jul09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSD027             Date 18May06              */
/*                      CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      141434             Date 05Mar99              */
/*                      104890             Date 21Jun96              */
/*                  CFF004                 DATE 02OCT96              */
/*                  S71062                 DATE 01DEC95              */
/*                  E44676(FUJI-F00004)    DATE 01AUG92              */
/*                  S01117             DATE 01MAR90                  */
/*                  S01240             DATE 22/03/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       261122 - Futures and Options - Close-out Function Errors.   */
/*                There are no transactions listed for position      */
/*                close-out.                                         */
/*       261052 - Error in Position close-out maintenance due to     */
/*                missing quotation marks in OPNQRYF operation.      */
/*   CSD027 - Conversion of customer number to alphanumeric          */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*   141434  -  REMOVE PYR NE 0 CONDITION TO ALLOW FOR YEAR (20)00  */
/*   104890  -  OVRDBF TRANS9                                        */
/*   CFF004  -  Increase in size of Price Fields.                    */
/*   S71062  -  FF/PM EXERCISE OPTION                                */
/*   E44676      - Automatically update unrealised P&L after         */
/*               - position closeout and trades input.               */
/*   S01117  -  REL.10 MULTIBRANCHING                                */
/*   S01240  -  ADDITION OF REAL TIME STATEMENT CHANGES              */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        VAR(&PBRCD) TYPE(*DEC) LEN(3 0)            */ /*S01117*/
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)             /*E44676*/
             DCL        VAR(&SBJOB)   TYPE(*CHAR)  LEN(30)            /*E44676*/
             DCL        VAR(&PBRCD) TYPE(*CHAR) LEN(3)                /*S01117*/
             DCL        VAR(&PINST) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PYR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PMN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PPTCL) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&PSTPR) TYPE(*DEC) LEN(11 7)              /*CFF004*/
             DCL        VAR(&PSTPR) TYPE(*DEC) LEN(15 8)              /*CFF004*/
/*********** DCL        VAR(&PBRK) TYPE(*DEC) LEN(6 0)                  CSD027*/
             DCL        VAR(&PBRK) TYPE(*CHAR) LEN(6)                 /*CSD027*/
/*********** DCL        VAR(&PCUS) TYPE(*DEC) LEN(6 0)                  CSD027*/
             DCL        VAR(&PCUS) TYPE(*CHAR) LEN(6)                 /*CSD027*/
             DCL        VAR(&BLK6) TYPE(*CHAR) LEN(6) VALUE('      ') /*CSD027*/
             DCL        VAR(&PBOK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PBOK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BPUIND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0)
/**********  DCL        VAR(&ZERO)  TYPE(*DEC) LEN(6 0) VALUE(0) */                       /*261122*/
             DCL        VAR(&BLANK) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PPTFR) TYPE(*CHAR) LEN(4)                /*S71062*/
/*                                                                  */
             DCL        VAR(&SLCT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SLCT1) TYPE(*CHAR) LEN(18)  +
                        VALUE('(ISTT *EQ "     ")')
             DCL        VAR(&SLCT2) TYPE(*CHAR) LEN(13)  +
                        VALUE('(MTHN *EQ   )')
             DCL        VAR(&SLCT3) TYPE(*CHAR) LEN(13)  +
                        VALUE('(YRNO *EQ   )')
/**********  DCL        VAR(&SLCT4) TYPE(*CHAR) LEN(17)  + */                             /*261052*/
/**********             VALUE('(CUSC *EQ       )') */                                     /*261052*/
             DCL        VAR(&SLCT4) TYPE(*CHAR) LEN(19)  +
                        VALUE('(CUSC *EQ "      ")')                                      /*261052*/
/**********  DCL        VAR(&SLCT5) TYPE(*CHAR) LEN(17)  + */                             /*261052*/
/**********             VALUE('(BOCO *EQ       )') */                                     /*261052*/
             DCL        VAR(&SLCT5) TYPE(*CHAR) LEN(19)  +
                        VALUE('(BOCO *EQ "      ")')                                      /*261052*/
             DCL        VAR(&SLCT6) TYPE(*CHAR) LEN(15)  +
                        VALUE('(BOKC *EQ "  ")')
             DCL        VAR(&SLCT7) TYPE(*CHAR) LEN(14)  +
                        VALUE('(PCAL *EQ " ")')
/*********** DCL        VAR(&SLCT8) TYPE(*CHAR) LEN(23)  +            /*CFF004*/
/***********            VALUE('(STRP *EQ             )')              /*CFF004*/
             DCL        VAR(&SLCT8) TYPE(*CHAR) LEN(27)  +
                        VALUE('(STRP *EQ                 )')          /*CFF004*/
/*********** DCL        VAR(&SLCT9) TYPE(*CHAR) LEN(14)  +         */ /*S01117*/
/**********             VALUE('(BRCD *EQ    )')                    */ /*S01117*/
             DCL        VAR(&SLCT9) TYPE(*CHAR) LEN(16)  +
                        VALUE('(BRCA *EQ "   ")')                     /*S01117*/
             DCL        VAR(&SLCT10) TYPE(*CHAR) LEN(17) +
                        VALUE('(PTFR *EQ "    ")')                    /*S71062*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   CALL MANUAL CLOSURE PROMPT SCREEN FOR INPUT PARAMETERS         */
/**/
U1LOOP:
             OVRDBF     FILE(TABFF) SHARE(*NO)
/**/
             CHGVAR VAR(&COUNT) VALUE(1)
             CHGVAR VAR(&SLCT) VALUE(&BLANK)
/**/
/****** CALL       PGM(FF0050) PARM((&PBRCD)(&PINST)(&PYR)(&PMN) +     *S71062*/
/******            (&PPTCL)(&PSTPR)(&PBRK)(&PCUS)(&PBOK)(&PMKT) +      *S71062*/
/******            (&BPUIND))                                          *S71062*/
        CALL       PGM(FF0050) PARM(&PBRCD &PINST &PYR &PMN +
                   &PPTCL &PSTPR &PBRK &PCUS &PBOK &PMKT +
                   &BPUIND &PPTFR)                                    /*S71062*/
/**/
/* FOR DATABASE ERRORS RETURN TO CALLING COMPONENT                  */
/**/
         IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO END)
/**/
         IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO END)
/**/
         IF         COND(&PMKT *EQ '  ') THEN(DO)
/**/
/*   OVERRIDES FOR FF0060  */
/**/
             OVRDBF  FILE(TRANS) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(CLOSTD) TOFILE(CLOSTD) MBR(OTC)
             OVRDBF  FILE(CLOSTT) TOFILE(CLOSTT) MBR(OTC)
/**/
/*   OVERRIDES FOR FF0360   (CALLED WITHIN FF0060)         */
/**/
             OVRDBF  FILE(CLOST4) TOFILE(CLOST4) MBR(OTC)
             OVRDBF  FILE(CLOST5) TOFILE(CLOST5) MBR(OTC)
             OVRDBF  FILE(CLOST6) TOFILE(CLOST6) MBR(OTC)
             OVRDBF  FILE(MEMOSM) TOFILE(MEMOSM) MBR(OTC)
             OVRDBF  FILE(PRONOM) TOFILE(PRONOM) MBR(OTC)
             OVRDBF  FILE(FFACMVD) TOFILE(FFACMVD) MBR(OTC)           /*S01240*/
             OVRDBF  FILE(POSTNC) TOFILE(POSTNC) MBR(OTC)
             OVRDBF  FILE(POSTNK) TOFILE(POSTNK) MBR(OTC)
             OVRDBF  FILE(TRSETS) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRSETP) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRANSS) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(TRANSP) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF  FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
         ENDDO
         ELSE       CMD(DO)
/**/
/*   OVERRIDES FOR FF0060  */
/**/
             OVRDBF  FILE(TRANS) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(CLOSTD) TOFILE(CLOSTD) MBR(&PMKT)
             OVRDBF  FILE(CLOSTT) TOFILE(CLOSTT) MBR(&PMKT)
/**/
/*   OVERRIDES FOR FF0360   (CALLED WITHIN FF0060)         */
/**/
             OVRDBF  FILE(CLOST4) TOFILE(CLOST4) MBR(&PMKT)
             OVRDBF  FILE(CLOST5) TOFILE(CLOST5) MBR(&PMKT)
             OVRDBF  FILE(CLOST6) TOFILE(CLOST6) MBR(&PMKT)
             OVRDBF  FILE(MEMOSM) TOFILE(MEMOSM) MBR(&PMKT)
             OVRDBF  FILE(PRONOM) TOFILE(PRONOM) MBR(&PMKT)
             OVRDBF  FILE(FFACMVD) TOFILE(FFACMVD) MBR(&PMKT)         /*S01240*/
             OVRDBF  FILE(POSTNC) TOFILE(POSTNC) MBR(&PMKT)
             OVRDBF  FILE(POSTNK) TOFILE(POSTNK) MBR(&PMKT)
             OVRDBF  FILE(TRSETS) TOFILE(TRSET) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRSETP) TOFILE(TRSET) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRANSS) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(TRANSP) TOFILE(TRANS) MBR(&PMKT) SHARE(*NO)
             OVRDBF  FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF  FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
         ENDDO
/*                                                                  */
/* Set up query select parameters                                   */
/*                                                                  */
             IF  COND(&PINST *NE '     ') THEN(DO)
             CHGVAR VAR(%SST(&SLCT1 12 5)) VALUE(&PINST)
             CHGVAR VAR(%SST(&SLCT &COUNT 18)) VALUE(&SLCT1)
             CHGVAR VAR(&COUNT) VALUE(&count + 19)
             ENDDO
/*                                                                  */
             IF  COND(&PMN *NE 0) THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT2 11 2)) VALUE(&PMN)
             CHGVAR VAR(%SST(&SLCT &COUNT 13)) VALUE(&SLCT2)
             CHGVAR VAR(&COUNT) VALUE(&count + 14)
             ENDDO
/*                                                                  */
/************IF  COND(&PYR *NE 0) THEN(DO)                        */ /*141434*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT3 11 2)) VALUE(&PYR)
             CHGVAR VAR(%SST(&SLCT &COUNT 13)) VALUE(&SLCT3)
             CHGVAR VAR(&COUNT) VALUE(&count + 14)
/*********** ENDDO                                                */ /*141434*/
/*                                                                  */
/*********** IF  COND(&PCUS *EQ -1) THEN(DO)                CSD027*/
             IF  COND(&PCUS *EQ '******') THEN(DO)        /*CSD027*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/**********  CHGVAR VAR(%SST(&SLCT4 11 6)) VALUE(&ZERO) */                                /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT4) */                           /*261052*/
/**********  CHGVAR VAR(&COUNT) VALUE(&count + 18) */                                     /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT4 12 6)) VALUE(&ZERO) */                         /*261052 261122*/
             CHGVAR VAR(%SST(&SLCT4 12 6)) VALUE('      ')                                /*261122*/
             CHGVAR VAR(%SST(&SLCT &COUNT 19)) VALUE(&SLCT4)                              /*261052*/
             CHGVAR VAR(&COUNT) VALUE(&COUNT + 20)                                        /*261052*/
             ENDDO
/*                                                                  */
/*********** IF  COND(&PCUS *GT 0) THEN(DO)                 CSD027*/
/**********  IF  COND(&PCUS *GT &BLK6) THEN(DO) */                                 /*CSD027 261122*/
             IF  COND((&PCUS *GT &BLK6) *AND (&PCUS *NE '******')) +
                   THEN(DO)                                                               /*261122*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/**********  CHGVAR VAR(%SST(&SLCT4 11 6)) VALUE(&PCUS) */                                /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT4) */                           /*261052*/
/**********  CHGVAR VAR(&COUNT) VALUE(&count + 18) */                                     /*261052*/
             CHGVAR VAR(%SST(&SLCT4 12 6)) VALUE(&PCUS)                                   /*261052*/
             CHGVAR VAR(%SST(&SLCT &COUNT 19)) VALUE(&SLCT4)                              /*261052*/
             CHGVAR VAR(&COUNT) VALUE(&COUNT + 20)                                        /*261052*/
             ENDDO
/*                                                                  */
/*********** IF  COND(&PBRK *EQ -1) THEN(DO)                 CSD027*/
             IF  COND(&PBRK *EQ '******') THEN(DO)         /*CSD027*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/**********  CHGVAR VAR(%SST(&SLCT5 11 6)) VALUE(&ZERO) */                                /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT5) */                           /*261052*/
/**********  CHGVAR VAR(&COUNT) VALUE(&count + 18) */                                     /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT5 12 6)) VALUE(&ZERO) */                         /*261052 261122*/
             CHGVAR VAR(%SST(&SLCT5 12 6)) VALUE('      ')                                /*261122*/
             CHGVAR VAR(%SST(&SLCT &COUNT 19)) VALUE(&SLCT5)                              /*261052*/
             CHGVAR VAR(&COUNT) VALUE(&COUNT + 20)                                        /*261052*/
             ENDDO
/*                                                                  */
/*********** IF  COND(&PBRK *GT 0) THEN(DO)                  CSD027*/
/**********  IF  COND(&PBRK *GT &BLK6) THEN(DO) */                                 /*CSD027 261122*/
             IF  COND((&PBRK *GT &BLK6) *AND (&PBRK *NE '******')) +
                   THEN(DO)                                                               /*261122*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/**********  CHGVAR VAR(%SST(&SLCT5 11 6)) VALUE(&PBRK) */                                /*261052*/
/**********  CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT5) */                           /*261052*/
/**********  CHGVAR VAR(&COUNT) VALUE(&count + 18) */                                     /*261052*/
             CHGVAR VAR(%SST(&SLCT5 12 6)) VALUE(&PBRK)                                   /*261052*/
             CHGVAR VAR(%SST(&SLCT &COUNT 19)) VALUE(&SLCT5)                              /*261052*/
             CHGVAR VAR(&COUNT) VALUE(&COUNT + 20)                                        /*261052*/
             ENDDO
/*                                                                  */
             IF  COND(&PBOK *NE '  ') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT6 12 2)) VALUE(&PBOK)
             CHGVAR VAR(%SST(&SLCT &COUNT 15)) VALUE(&SLCT6)
             CHGVAR VAR(&COUNT) VALUE(&count + 16)
             ENDDO
/*                                                                  */
             IF  COND(&PPTCL *NE ' ') THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
             CHGVAR VAR(%SST(&SLCT7 12 1)) VALUE(&PPTCL)
             CHGVAR VAR(%SST(&SLCT &COUNT 14)) VALUE(&SLCT7)
             CHGVAR VAR(&COUNT) VALUE(&count + 15)
             ENDDO
/*                                                                  */
             IF  COND(&PSTPR *NE 0) THEN(DO)
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/*********** CHGVAR VAR(%SST(&SLCT8 11 12)) VALUE(&PSTPR)     /*CFF004*/
/*********** CHGVAR VAR(%SST(&SLCT &COUNT 23)) VALUE(&SLCT8)  /*CFF004*/
/*********** CHGVAR VAR(&COUNT) VALUE(&count + 24)            /*CFF004*/
             CHGVAR VAR(%SST(&SLCT8 11 16)) VALUE(&PSTPR)     /*CFF004*/
             CHGVAR VAR(%SST(&SLCT &COUNT 27)) VALUE(&SLCT8)  /*CFF004*/
             CHGVAR VAR(&COUNT) VALUE(&count + 28)            /*CFF004*/
             ENDDO
/*                                                                  */
/*********** IF  COND(&PBRCD *NE 0) THEN(DO)                       */ /*S01117*/
             IF  COND(&PBRCD *NE '   ') THEN(DO)                      /*S01117*/
                 IF  COND(&COUNT *GT 1) THEN(DO)
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)
                 ENDDO
/*********** CHGVAR VAR(%SST(&SLCT9 11 3)) VALUE(&PBRCD)           */ /*S01117*/
             CHGVAR VAR(%SST(&SLCT9 12 3)) VALUE(&PBRCD)              /*S01117*/
/*********** CHGVAR VAR(%SST(&SLCT &COUNT 14)) VALUE(&SLCT9)       */ /*S01117*/
             CHGVAR VAR(%SST(&SLCT &COUNT 16)) VALUE(&SLCT9)          /*S01117*/
/*********** CHGVAR VAR(&COUNT) VALUE(&count + 15)                    /*S71062*/
             CHGVAR VAR(&COUNT) VALUE(&count + 17)                    /*S71062*/
             ENDDO
/*                                                                  */
/*                                                                     *S71062*/
             IF  COND(&PPTFR *NE ' ') THEN(DO)                        /*S71062*/
                 IF  COND(&COUNT *GT 1) THEN(DO)                      /*S71062*/
                 CHGVAR VAR(%SST(&SLCT &COUNT 4)) VALUE('*AND')       /*S71062*/
                 CHGVAR     VAR(&COUNT) VALUE(&count + 5)             /*S71062*/
                 ENDDO                                                /*S71062*/
             CHGVAR VAR(%SST(&SLCT10 12 4)) VALUE(&PPTFR)             /*S71062*/
             CHGVAR VAR(%SST(&SLCT &COUNT 17)) VALUE(&SLCT10)         /*S71062*/
             CHGVAR VAR(&COUNT) VALUE(&count + 18)                    /*S71062*/
             ENDDO                                                    /*S71062*/
/*                                                                  */
             OVRDBF     FILE(TRANS9) SHARE(*YES)                   /*104890*/
             OPNQRYF    FILE((TRANS9)) OPTION(*INP) QRYSLT(&SLCT) +
                          KEYFLD((TRSD *ASCEND) (TNBR)) +
                          OPTIMIZE(*FIRSTIO) SEQONLY(*NO)
/**/
/*   CALL MANUAL POSITION CLOSE OUT INPUT (FF0060)                  */
/**/
/****** CALL       PGM(FF0060) PARM((&PBRCD)(&PINST)(&PYR)(&PMN) +     *S71062*/
/******            (&PPTCL)(&PSTPR)(&PBRK)(&PCUS)(&PBOK)(&PMKT) +      *S71062*/
/******            (&BPUIND))                                          *S71062*/
        CALL       PGM(FF0060) PARM(&PBRCD &PINST &PYR &PMN +
                   &PPTCL &PSTPR &PBRK &PCUS &PBOK &PMKT +
                   &BPUIND &PPTFR)                                    /*S71062*/
/**/
             CLOF       OPNID(TRANS9)
             DLTOVR     FILE(TRANS9)                               /*104890*/
/**/
/*   IF OTC NOT USED,DEALLOCATE DATA AREA                           */
/**/
             IF         COND(&PMKT *NE '  ') THEN(DO)
                 DLCOBJ     OBJ((&PMKT *DTAARA *SHRRD))
             ENDDO
/**/
             DLTOVR     FILE(*ALL)
/**/                                                                  /*E44676*/
/* Submit job to update unrealised P&L                             */ /*E44676*/
/**/                                                                  /*E44676*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*E44676*/
/*                                                        */          /*E44676*/
/** Pass the market parameter as 'OTC' for OTC's          */          /*E44676*/
/*                                                        */          /*E44676*/
                                                                      /*E44676*/
             IF         COND(&PMKT *EQ '  ') THEN(DO)                 /*E44676*/
                CHGVAR     VAR(&MARKT) VALUE('OTC')                   /*E44676*/
             ENDDO                                                    /*E44676*/
             ELSE       CMD(DO)                                       /*E44676*/
             CHGVAR     VAR(&MARKT) VALUE(&PMKT)                      /*E44676*/
             ENDDO                                                    /*E44676*/
                                                                      /*E44676*/
             CHGVAR     VAR(&SBJOB) VALUE('CALL FFC0221 PARM(' *CAT +
                          &MARKT *CAT ')')                            /*E44676*/
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                  /*E44676*/
/************SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +                            /*CSC023*/
/************             JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +                        /*CSC023*/
/************             RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ)  /*E44676*/          /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ)      /*E44676*/          /*CSC023*/
             SBMJOB     JOB('RVAL' *CAT &MARKT) JOBD(MBATCH) +
                          JOBQ(FFJQRV) USER(*JOBD) RTGDTA(*JOBD) +
                          RQSDTA(&SBJOB) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)          /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) JOBQ(FFJQRV) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MIDASRMV') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
             ENDDO                                                    /*E44676*/
/**/
/* IF U1 IS OFF (CMD/5 TAKEN IN FF0060) GO BACK TO U1LOOP           */
/**/
             IF         COND(%SWITCH(0XXXXX00)) THEN(GOTO U1LOOP)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*END:********ENDPGM                                               */ /*E44676*/
/**/                                                                  /*E44676*/
END:                                                                  /*E44676*/
             ENDPGM                                                   /*E44676*/
