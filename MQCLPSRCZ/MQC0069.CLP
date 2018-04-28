/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ OPNQRYF for MQPOSTINGS - a/c mvmnts')        */
/********************************************************************/
/*                                                                  */
/*   Midas  MidasQ MODULE                                   */
/*                                                                  */
/*   MQC0069 - OPEN QUERY FILE SELECTION CRITERIA FOR MQPOSTINGS    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 188501             Date 31Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01182             Date 01May90              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       188501  -  Remove redundant code.                           */
/*   S01182  -  NEW PROGRAM INTRODUCED FOR MIS                      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&TPR#UR &SELECT)
/**/
             DCL        VAR(&TPR#UR) TYPE(*CHAR) LEN(500)
             DCL        VAR(&SELECT) TYPE(*CHAR) LEN(81)
             DCL        VAR(&FLD1) TYPE(*CHAR) LEN(2)  /* ASEC */
/**********  DCL        VAR(&FLD2) TYPE(*CHAR) LEN(4)  /* BPCD */     /*188501*/
             DCL        VAR(&FLD3) TYPE(*CHAR) LEN(1)  /* ATYP */
/**********  DCL        VAR(&FLD4) TYPE(*CHAR) LEN(4)  /* ACOD */                         /*CGL029*/
             DCL        VAR(&FLD10) TYPE(*CHAR) LEN(10)                                   /*CGL029*/
             DCL        VAR(&BLK10) TYPE(*CHAR) LEN(10)                                   /*CGL029*/
/**********  DCL        VAR(&FLD5) TYPE(*CHAR) LEN(1)  /* BPSN */     /*188501*/
/**********  DCL        VAR(&FLD6) TYPE(*CHAR) LEN(1)  /* BPIN */     /*188501*/
/**********  DCL        VAR(&FLD7) TYPE(*CHAR) LEN(1)  /* CRDR */     /*188501*/
/**********  DCL        VAR(&BSPLC) TYPE(*CHAR) LEN(6)    */          /*188501*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             CHGVAR     VAR(&FLD1) VALUE(%SST(&TPR#UR 14 2))
/**********  CHGVAR     VAR(&FLD2) VALUE(%SST(&TPR#UR 16 4))  */      /*188501*/
/**********  CHGVAR     VAR(&FLD3) VALUE(%SST(&TPR#UR 20 1))  */      /*188501*/
/**********  CHGVAR     VAR(&FLD4) VALUE(%SST(&TPR#UR 21 4))  */      /*188501*/
             CHGVAR     VAR(&FLD3) VALUE(%SST(&TPR#UR 16 1))          /*188501*/
/**********  CHGVAR     VAR(&FLD4) VALUE(%SST(&TPR#UR 17 4))         */            /*188501 CGL029*/
             CHGVAR     VAR(&FLD10) VALUE(%SST(&TPR#UR 17 10))                            /*CGL029*/
/**********  CHGVAR     VAR(&FLD5) VALUE(%SST(&TPR#UR 59 1))  */      /*188501*/
/**********  CHGVAR     VAR(&FLD6) VALUE(%SST(&TPR#UR 60 1))  */      /*188501*/
/**********  CHGVAR     VAR(&FLD7) VALUE(%SST(&TPR#UR 61 1))  */      /*188501*/
/**/
/* To set up the correct field name for the BSPL code depending upon */
/*  the value of the Set No., the BSPL Indicator & the Credit/Debit  */
/**/
/* Balance sheet credit 1                                            */
/****IF*COND(&FLD5 *EQ '1' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSC1'))   */                 /*188501*/
/**/
/* Balance sheet credit 2                                            */
/****IF*COND(&FLD5 *EQ '2' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSC2'))   */                 /*188501*/
/**/
/* Balance sheet credit 3                                            */
/****IF*COND(&FLD5 *EQ '3' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSC3'))   */                 /*188501*/
/**/
/* Balance sheet debit 1                                             */
/****IF*COND(&FLD5 *EQ '1' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSD1'))   */                 /*188501*/
/**/
/* Balance sheet debit 2                                             */
/****IF*COND(&FLD5 *EQ '2' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSD2'))   */                 /*188501*/
/**/
/* Balance sheet debit 3                                             */
/****IF*COND(&FLD5 *EQ '3' *AND &FLD6 *EQ 'B' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5BSD3'))   */                 /*188501*/
/**/
/* Profit & loss credit 1                                            */
/****IF*COND(&FLD5 *EQ '1' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLC1'))   */                 /*188501*/
/**/
/* Profit & loss credit 2                                            */
/****IF*COND(&FLD5 *EQ '2' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLC2'))   */                 /*188501*/
/**/
/* Profit & loss credit 3                                            */
/****IF*COND(&FLD5 *EQ '3' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'C') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLC3'))   */                 /*188501*/
/**/
/* Profit & loss debit 1                                             */
/****IF*COND(&FLD5 *EQ '1' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLD1'))   */                 /*188501*/
/**/
/* Profit & loss debit 2                                             */
/****IF*COND(&FLD5 *EQ '2' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLD2'))   */                 /*188501*/
/**/
/* Profit & loss debit 3                                             */
/****IF*COND(&FLD5 *EQ '3' *AND &FLD6 *EQ 'P' *AND &FLD7 *EQ 'D') THEN/*188501*/
/********** (CHGVAR VAR(&BSPLC) VALUE('A5PLD3'))   */                 /*188501*/
/**/
/* For ease of understanding let the four fields in the data area */
/* be known as A, B,C, and D repectively  for  ASEC,BSPL,ATYP,ACOD */
/**/
/* For Input Field Pattern A */
   IF  COND(&FLD1 *NE '  ') THEN(DO)                   /* B01 */
         CHGVAR VAR(%SST(&SELECT 1 15))  VALUE('A5ACSC *EQ "  "')
         CHGVAR  VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))
/**/
/* For Input Field Pattern A B */                      /* B02 */
/****IF**COND(&FLD2 *NE '    ') THEN(DO)  */                          /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 38))  VALUE('A5ACSC *EQ "  " +   /*188501*/
/********** AND BSPLCD *EQ "    "')              **/                  /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 22 6)) VALUE(&BSPLC)  */           /*188501*/
/**/
/* For Input Field Pattern A B C */
/******IF**COND(&FLD3 *NE ' ') THEN(DO)                /*B03 */       /*188501*/
/********** CHGVAR VAR(%SST(&SELECT 1 58))  VALUE('A5ACSC *EQ "  " +  /*188501*/
/********** *AND BSPLCD *EQ "    " *AND A5ACTY *EQ " "') */           /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 57 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 22 6)) VALUE(&BSPLC)   */          /*188501*/
/**/
/* For Input Field Pattern A B C D */
/********IF**COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */      /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 81))  VALUE('A5ACSC *EQ "  " +   /*188501*/
/***********AND BSPLCD *EQ "    " *AND A5ACTY *EQ " " *AND +          /*188501*/
/**********A5ACCD *EQ "    "')   */                                   /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 57 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 77 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 22 6)) VALUE(&BSPLC)  */           /*188501*/
/**/
/********ENDDO                                         /* E04 */      /*188501*/
/**********                                                           /*188501*/
/******ENDDO                                           /* E03 */      /*188501*/
/******ELSE       CMD(DO)                              /* X03 */      /*188501*/
/**/
/* For Input Field Pattern A B D */
/********** COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */       /*188501*/
/********** CHGVAR VAR(%SST(&SELECT 1 61))  VALUE('A5ACSC *EQ "  " +  /*188501*/
/********** *AND BSPLCD *EQ "    " *AND A5ACCD *EQ "    "')   */      /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 57 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR  VAR(%SST(&SELECT 22 6)) VALUE(&BSPLC)              /*188501*/
/********ENDDO                                         /* E04 */      /*188501*/
/******ENDDO                                           /* E03 */      /*188501*/
/**/
/**********ENDDO                                           /* E02 */  /*188501*/
/**********ELSE     CMD(DO)                                /* X02 */  /*188501*/
/**/
/* For Input Field Pattern A C */
         IF  COND(&FLD3 *NE ' ') THEN(DO)              /* B03 */
            CHGVAR VAR(%SST(&SELECT 1 35))  VALUE('A5ACSC *EQ "  " +
            *AND A5ACTY *EQ " "')
           CHGVAR  VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))
/**********CHGVAR VAR(%SST(&SELECT 34 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
           CHGVAR  VAR(%SST(&SELECT 34 1)) VALUE(%SST(&TPR#UR 16 1))  /*188501*/
/**/
/* For Input Field Pattern A C D */
/**********IF  COND(&FLD4 *NE '    ') THEN(DO)         /* B04 */                          /*CGL029*/
/********** CHGVAR VAR(%SST(&SELECT 1 58))  VALUE('A5ACSC *EQ "  " +                      /*CGL029*/
/********** *AND A5ACTY *EQ " " *AND A5ACCD *EQ "    "')                                  /*CGL029*/
           IF  COND(&FLD10 *NE &BLK10) THEN(DO)                                           /*CGL029*/
            CHGVAR VAR(%SST(&SELECT 1 64))  VALUE('A5ACSC *EQ "  " +
            *AND A5ACTY *EQ " " *AND A5ACCD *EQ "          "')                            /*CGL029*/
           CHGVAR  VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))
/**********CHGVAR VAR(%SST(&SELECT 34 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 54 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
           CHGVAR  VAR(%SST(&SELECT 34 1)) VALUE(%SST(&TPR#UR 16 1))  /*188501*/
           CHGVAR  VAR(%SST(&SELECT 54 1)) VALUE(%SST(&TPR#UR 17 1))  /*188501*/
           ENDDO                                       /* E04 */
/**/
         ENDDO                                         /* E03 */
         ELSE       CMD(DO)                            /* X03 */
/**/
/* For Input Field Pattern A D */
/********IF  COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */                          /*CGL029*/
/********** CHGVAR VAR(%SST(&SELECT 1 38))  VALUE('A5ACSC *EQ "  " + */                   /*CGL029*/
/********** *AND A5ACCD *EQ "    "')                                 */                   /*CGL029*/
         IF  COND(&FLD10 *NE &BLK10) THEN(DO)                                             /*CGL029*/
            CHGVAR VAR(%SST(&SELECT 1 44))  VALUE('A5ACSC *EQ "  " +
            *AND A5ACCD *EQ "          "')                                                /*CGL029*/
           CHGVAR  VAR(%SST(&SELECT 13 2)) VALUE(%SST(&TPR#UR 14 2))
/**********CHGVAR VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR  VAR(%SST(&SELECT 34 4)) VALUE(%SST(&TPR#UR 17 4)) */            /*188501 CGL029*/
           CHGVAR  VAR(%SST(&SELECT 34 10)) VALUE(%SST(&TPR#UR 17 10))                    /*CGL029*/
         ENDDO                                         /* E04 */
/**/
       ENDDO                                           /* E03 */
/**/
/**********ENDDO                                           /* E02 */  /*188501*/
/**/
   ENDDO                                               /* E01 */
   ELSE       CMD(DO)                                  /* X01 */
/**/
/* For Input Field Pattern B */
/****IF**COND(&FLD2 *NE '    ') THEN(DO)               /* B02 */      /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 17)) VALUE('BSPLCD *EQ "   "')*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 6)) VALUE(&BSPLC) */             /*188501*/
/**/
/* For Input Field Pattern B C */
/******IF**COND(&FLD3 *NE ' ') THEN(DO)                /* B03 */      /*188501*/
/********** CHGVAR VAR(%SST(&SELECT 1 37))  VALUE('BSPLCD *EQ "    " +/*188501*/
/********** *AND A5ACTY *EQ " "')  */                                 /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 36 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 6)) VALUE(&BSPLC) */             /*188501*/
/**/
/* For Input Field Pattern B C D */
/**********  COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */      /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 60))  VALUE('BSPLCD *EQ "    " + /*188501*/
/********** *AND A5ACTY *EQ " " *AND A5ACCD *EQ "    "') */           /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 36 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 56 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 6)) VALUE(&BSPLC) */             /*188501*/
/********ENDDO                                         /* E04 */      /*188501*/
/**/
/******ENDDO                                           /* E03 */      /*188501*/
/******ELSE     CMD(DO)                                /* X03 */      /*188501*/
/**/
/* For Input Field Pattern B D */
/********** COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */       /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 40))  VALUE('BSPLCD *EQ "    " + /*188501*/
/********** *AND A5ACCD *EQ "    "')  */                              /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 16 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 36 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 1 6)) VALUE(&BSPLC) */             /*188501*/
/********ENDDO                                         /* E04 */      /*188501*/
/**/
/******ENDDO                                           /* E03 */      /*188501*/
/**/
/******ENDDO                                           /* E02 */      /*188501*/
/******ELSE  CMD(DO)                                   /* X02 */      /*188501*/
/**/
/* For Input Field Pattern C */
       IF  COND(&FLD3 *NE ' ') THEN(DO)                /* B03 */
            CHGVAR VAR(%SST(&SELECT 1 14))  VALUE('A5ACTY *EQ " "')
/**********CHGVAR VAR(%SST(&SELECT 13 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
           CHGVAR  VAR(%SST(&SELECT 13 1)) VALUE(%SST(&TPR#UR 16 1))  /*188501*/
/**/
/* For Input Field Pattern C D */
/********IF  COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */                          /*CGL029*/
/********** CHGVAR VAR(%SST(&SELECT 1 37))  VALUE('A5ACTY *EQ " " +  */                   /*CGL029*/
/********** *AND A5ACCD *EQ "    "')                                 */                   /*CGL029*/
         IF  COND(&FLD10 *NE &BLK10) THEN(DO)                                             /*CGL029*/
            CHGVAR VAR(%SST(&SELECT 1 43))  VALUE('A5ACTY *EQ " " +
            *AND A5ACCD *EQ "          "')                                                /*CGL029*/
/**********CHGVAR VAR(%SST(&SELECT 13 1)) VALUE(%SST(&TPR#UR 20 1))*/ /*188501*/
/**********CHGVAR VAR(%SST(&SELECT 33 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
           CHGVAR  VAR(%SST(&SELECT 13 1)) VALUE(%SST(&TPR#UR 16 1))  /*188501*/
/**********CHGVAR  VAR(%SST(&SELECT 33 1)) VALUE(%SST(&TPR#UR 17 4)) */            /*188501 CGL029*/
           CHGVAR  VAR(%SST(&SELECT 33 1)) VALUE(%SST(&TPR#UR 17 10))                     /*CGL029*/
         ENDDO                                         /* E04 */
/**/
       ENDDO                                           /* E03 */
       ELSE     CMD(DO)                                /* X03 */
/**/
/* For Input Field Pattern D */
/********IF  COND(&FLD4 *NE '    ') THEN(DO)           /* B04 */                          /*CGL029*/
/********** CHGVAR VAR(%SST(&SELECT 1 17))  VALUE('A5ACCD *EQ "    "')/                   /*CGL029*/
         IF  COND(&FLD10 *NE &BLK10) THEN(DO)                                             /*CGL029*/
            CHGVAR VAR(%SST(&SELECT 1 23))  VALUE('A5ACCD *EQ "          "')              /*CGL029*/
/**********CHGVAR VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 21 4))*/ /*188501*/
/**********CHGVAR  VAR(%SST(&SELECT 13 4)) VALUE(%SST(&TPR#UR 17 4)) */            /*188501 CGL029*/
           CHGVAR  VAR(%SST(&SELECT 13 10)) VALUE(%SST(&TPR#UR 17 10))                    /*CGL029*/
         ENDDO                                         /* E04 */
/**/
       ENDDO                                           /* E03 */
/**/
/**********ENDDO                                       /* E02 */      /*188501*/
/**/
   ENDDO                                               /* E01 */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
