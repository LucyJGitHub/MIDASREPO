/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Comp to call pay report/auth prog')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTC0803 - Component to Call Payments Reporting/Authorisation*/
/*                 program FT0803                                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD041081           Date 05Sep16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CFT008             Date 04Jan00              */
/*                      CFT006             Date 16Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CFT003  *CREATE    Date 05May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD041081 - Reset DATARA when it reaches 9999.               */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CFT008 - Funds Transfer addition of MT102 messages          */
/*       CFT006 - Funds Transfer addition of MT101 messages          */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CFT003 - FT Batch Authorisation                             */
/*                Based on FTCH004 original references:              */
/*                CFT078/068151/IMP039/DBF148/HUB01B                 */
/*                                                                   */
/*********************************************************************/

  PGM          PARM(&RSEQ &RLVL &RBCH)

/* Parameters received from FT0803 & RCF */
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPAR2) TYPE(*CHAR) LEN(144)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)

/* Used for query selection criteria */
             DCL        VAR(&ALL)   TYPE(*CHAR) LEN(500)
             DCL        VAR(&BAN1)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&BANO)  TYPE(*DEC) LEN(4)

/* Used to break down &RPAR2 into individual selection criteria */
             DCL        VAR(&RPAU) TYPE(*CHAR) LEN(1)  /* REPT/AUTHO */
             DCL        VAR(&FTRN) TYPE(*CHAR) LEN(15) /* FROM TRNO */
             DCL        VAR(&TTRN) TYPE(*CHAR) LEN(15) /* TO TRNO */
             DCL        VAR(&FVDT) TYPE(*CHAR) LEN(5)  /* FROM SVDT */
             DCL        VAR(&TVDT) TYPE(*CHAR) LEN(5)  /* TO SVDT */
             DCL        VAR(&FPDT) TYPE(*CHAR) LEN(5)  /* FROM PVDT */
             DCL        VAR(&TPDT) TYPE(*CHAR) LEN(5)  /* TO PVDT */
             DCL        VAR(&PYTP) TYPE(*CHAR) LEN(2)  /* Pymt Type */
             DCL        VAR(&PYST) TYPE(*CHAR) LEN(2)  /* Pymt SType */
             DCL        VAR(&SMCY) TYPE(*CHAR) LEN(3)  /* Settle CCY */
             DCL        VAR(&PCCY) TYPE(*CHAR) LEN(3)  /* Paymnt CCY */
             DCL        VAR(&NCDE) TYPE(*CHAR) LEN(5)  /* Nostro Cde */
             DCL        VAR(&SETM) TYPE(*CHAR) LEN(2)  /* Set.Method */
             DCL        VAR(&CPIN) TYPE(*CHAR) LEN(1)  /* Clearing P */
             DCL        VAR(&PAGI) TYPE(*CHAR) LEN(1)  /* Autopay    */
             DCL        VAR(&OPR1) TYPE(*CHAR) LEN(10) /* Optr Name 1*/
             DCL        VAR(&OPR2) TYPE(*CHAR) LEN(10) /* Optr Name 2*/
             DCL        VAR(&OPR3) TYPE(*CHAR) LEN(10) /* Optr Name 3*/
             DCL        VAR(&OPR4) TYPE(*CHAR) LEN(10) /* Optr Name 4*/
             DCL        VAR(&OPR5) TYPE(*CHAR) LEN(10) /* Optr Name 5*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10) /* Auth User  */
             DCL        VAR(&BCNO) TYPE(*CHAR) LEN(4)  /* BATCH NO.  */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RDAT) TYPE(*CHAR) LEN(7)
/* Used to control building of OPNQRYF command */
             DCL        VAR(&C)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&D)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&E)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&F)     TYPE(*DEC)  LEN(3 0) VALUE(1)
             DCL        VAR(&BANOA) TYPE(*CHAR) LEN(4)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                   /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CRE020*/
                                                                                          /*CRE020*/

/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNCDE &OPTN &SARD &FMT)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *NE '       ' *AND &RTNCDE *NE +
                          '*NRF   ') THEN(GOTO CMDLBL(END))                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTNCDE *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/


/* Set-off Data Base Error switches. */
             CHGJOB     SWS(XXXXXX00)

/* Start Commitment Control. */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/

/* Retrieve parameters from internal data area *LDA */

             RTVDTAARA  DTAARA(*LDA (1 144)) RTNVAR(&RPAR2)

/* Break RPAR2 into individual components  */
             CHGVAR     VAR(&RPAU) VALUE(%SST(&RPAR2 1 1))
             CHGVAR     VAR(&FTRN) VALUE(%SST(&RPAR2 2 15))
             CHGVAR     VAR(&TTRN) VALUE(%SST(&RPAR2 17 15))
             CHGVAR     VAR(&FVDT) VALUE(%SST(&RPAR2 32 5))
             CHGVAR     VAR(&TVDT) VALUE(%SST(&RPAR2 37 5))
             CHGVAR     VAR(&FPDT) VALUE(%SST(&RPAR2 42 5))
             CHGVAR     VAR(&TPDT) VALUE(%SST(&RPAR2 47 5))
             CHGVAR     VAR(&PYTP) VALUE(%SST(&RPAR2 52 2))
             CHGVAR     VAR(&PYST) VALUE(%SST(&RPAR2 54 2))
             CHGVAR     VAR(&SMCY) VALUE(%SST(&RPAR2 56 3))
             CHGVAR     VAR(&PCCY) VALUE(%SST(&RPAR2 59 3))
             CHGVAR     VAR(&NCDE) VALUE(%SST(&RPAR2 62 5))
             CHGVAR     VAR(&SETM) VALUE(%SST(&RPAR2 67 2))
             CHGVAR     VAR(&CPIN) VALUE(%SST(&RPAR2 69 1))
             CHGVAR     VAR(&PAGI) VALUE(%SST(&RPAR2 70 1))
             CHGVAR     VAR(&USER) VALUE(%SST(&RPAR2 71 10))
             CHGVAR     VAR(&OPR1) VALUE(%SST(&RPAR2 81 10))
             CHGVAR     VAR(&OPR2) VALUE(%SST(&RPAR2 91 10))
             CHGVAR     VAR(&OPR3) VALUE(%SST(&RPAR2 101 10))
             CHGVAR     VAR(&OPR4) VALUE(%SST(&RPAR2 111 10))
             CHGVAR     VAR(&OPR5) VALUE(%SST(&RPAR2 121 10))
             CHGVAR     VAR(&BCNO) VALUE(%SST(&RPAR2 141 4))


/*           CALL       PGM(PAUSEDQ) PARM('Pause     ')    */

/**/
/* Check if request is Authorise or Reporting */
/**/
             IF         COND(&RPAU *EQ 'R')  +
             THEN(DO)
             RTVDTAARA  DTAARA(FTBDTA (1 4)) RTNVAR(&BAN1)
             CHGVAR     VAR(&BANO) VALUE(&BAN1)
/*           CHGVAR     VAR(&BANO) VALUE(&BANO + 1) */                                  /*MD041081*/
/* Reset FTBDTA when reaches 9999 */                                                    /*MD041081*/
             IF         COND(&BANO *EQ 9999) THEN(CHGVAR VAR(&BANO) +
                          VALUE(1))                                                     /*MD041081*/
             ELSE       CMD(CHGVAR VAR(&BANO) VALUE(&BANO + 1))                         /*MD041081*/
             CHGVAR     VAR(&BAN1) VALUE(&BANO)
             CHGDTAARA  DTAARA(FTBDTA (1 4)) VALUE(&BAN1)
/**/
/* Set-up OPNQRY command for OTPAYXJ0 - for FT0806 */
/**/

             CHGVAR     VAR(%SST(&ALL &C 12)) VALUE('(RECI = "D")')
             CHGVAR     VAR(&C) VALUE(&C + 13)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)

             IF         COND((&FTRN *NE ' ') *AND (&TTRN *NE ' ')) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 16)) VALUE('(PREF = %RANGE("')
             CHGVAR     VAR(&C) VALUE(&C + 16)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&FTRN)
             CHGVAR     VAR(&C) VALUE(&C + 15)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('" "')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&TTRN)
             CHGVAR     VAR(&C) VALUE(&C + 15)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('"')
             CHGVAR     VAR(&C) VALUE(&C + 1)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND((&FVDT *NE ' ') *AND (&TVDT *NE ' ')) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE('(SLDT = %RANGE(')
             CHGVAR     VAR(&C) VALUE(&C + 16)
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&FVDT)
             CHGVAR     VAR(&C) VALUE(&C + 6)
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&TVDT)
             CHGVAR     VAR(&C) VALUE(&C + 6)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND((&FPDT *NE ' ') *AND (&TPDT *NE ' ')) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE('(PVDT = %RANGE(')
             CHGVAR     VAR(&C) VALUE(&C + 16)
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&FPDT)
             CHGVAR     VAR(&C) VALUE(&C + 6)
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&TPDT)
             CHGVAR     VAR(&C) VALUE(&C + 6)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&PYTP *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(PYTP = "')
             CHGVAR     VAR(&C) VALUE(&C + 9)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYTP)
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&PYST *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(PYST = "')
             CHGVAR     VAR(&C) VALUE(&C + 9)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYST)
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&SMCY *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(SMCY = "')
             CHGVAR     VAR(&C) VALUE(&C + 9)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&SMCY)
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&PCCY *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(PCCY = "')
             CHGVAR     VAR(&C) VALUE(&C + 9)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&PCCY)
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&SETM *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INSETM = "')
             CHGVAR     VAR(&D) VALUE(&C + 1)
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&SETM)
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 1)
                          ENDDO

             IF         COND(&CPIN *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INSTPI = "')
             CHGVAR     VAR(&E) VALUE(&C)
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(&CPIN)
             CHGVAR     VAR(&C) VALUE(&C + 1)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             IF         COND(&PAGI *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INAUTO = "')
             CHGVAR     VAR(&F) VALUE(&C)
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(&PAGI)
             CHGVAR     VAR(&C) VALUE(&C + 1)

             IF         COND(&PAGI *NE 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&ALL &C 15)) VALUE('" *OR INAUTO = ')
               CHGVAR     VAR(&C) VALUE(&C + 15)
               CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('" ")')
               CHGVAR     VAR(&C) VALUE(&C + 5)
             ENDDO

             ELSE CMD(DO)
               CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
               CHGVAR     VAR(&C) VALUE(&C + 3)
             ENDDO

             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)

             ENDDO
/**/
             IF         COND((&RBCH *NE ' ') *AND (&RBCH *NE 'ALL')) +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(BRCA = "')
             CHGVAR     VAR(&C) VALUE(&C + 9)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&RBCH)
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                          ENDDO
/**/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE('(AUIN *NE ')
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('"Y")')
             CHGVAR     VAR(&C) VALUE(&C + 5)
/**/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('(')
             CHGVAR     VAR(&C) VALUE(&C + 1)
                          ENDDO
/**/
             IF         COND(&OPR1 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSR2 = "')
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR1)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
                          ENDDO
/**/
             IF         COND(&OPR2 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSR2 = "')
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR2)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
                          ENDDO
/**/
             IF         COND(&OPR3 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSR2 = "')
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR3)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
                          ENDDO
/**/
             IF         COND(&OPR4 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSR2 = "')
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR4)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
                          ENDDO
/**/
             IF         COND(&OPR5 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSR2 = "')
             CHGVAR     VAR(&C) VALUE(&C + 11)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR5)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)
                          ENDDO
/**/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(')')
             CHGVAR     VAR(&C) VALUE(&C + 2)
                         ENDDO
/**/
/* Execute OPNQRF for INPAYXJ0 command using the set-up parameters.  */
/**/
/* */
/* Copy from Awaiting authorisation file to improve open query                */
/* performance                                                                */
/* */
             CPYF       FROMFILE(INPUNTBB) TOFILE(QTEMP/Q_INPAY) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             OPNQRYF    FILE((QTEMP/Q_INPAY) (INPAYXPD)) +
                          FORMAT(INPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (INSETM)) +
                          JFLD((PREF INPREF)) OPNID(INPAYXJ0)
             CPYFRMQRYF FROMOPNID(INPAYXJ0) TOFILE(QTEMP/INPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
/**/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')
             CHGVAR     VAR(&C) VALUE(&C + 2)
             CHGVAR     VAR(%SST(&ALL &C 27)) VALUE('(LVL1 = "Y") & +
                          (LVL2 = "Y")')
             CHGVAR     VAR(&C) VALUE(&C + 28)

/* Change INSETM to STMT, INSTPI to OPSTPI and INAUTO to OPAUTO for OTPAYXJ0. */

             IF         COND(&SETM *NE ' ') +
                          THEN(DO)
                CHGVAR     VAR(%SST(&ALL &D 7)) VALUE('STMT = ')
                CHGVAR     VAR(&D) VALUE(&D + 7)
                CHGVAR     VAR(%SST(&ALL &D 2)) VALUE(&SETM)
                CHGVAR     VAR(&D) VALUE(&D + 2)
                CHGVAR     VAR(%SST(&ALL &D 5)) VALUE(')    ')
             ENDDO

             IF         COND(&CPIN *NE ' ') +
                          THEN(DO)
                CHGVAR     VAR(%SST(&ALL &E 11)) VALUE('(OPSTPI = "')
                CHGVAR     VAR(&E) VALUE(&E + 11)
                CHGVAR     VAR(%SST(&ALL &E 1)) VALUE(&CPIN)
                CHGVAR     VAR(&E) VALUE(&E + 1)
                CHGVAR     VAR(%SST(&ALL &E 2)) VALUE('")')
             ENDDO

             IF         COND(&PAGI *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(%SST(&ALL &F 11)) VALUE('(OPAUTO = "')
             CHGVAR     VAR(&F) VALUE(&F + 11)
             CHGVAR     VAR(%SST(&ALL &F 1)) VALUE(&PAGI)
             CHGVAR     VAR(&F) VALUE(&F + 1)

             IF         COND(&PAGI *NE 'Y') THEN(DO)
               CHGVAR     VAR(%SST(&ALL &F 15)) VALUE('" *OR OPAUTO = ')
               CHGVAR     VAR(&F) VALUE(&F + 15)
               CHGVAR     VAR(%SST(&ALL &F 4)) VALUE('" ")')
               CHGVAR     VAR(&F) VALUE(&F + 5)
             ENDDO

             ELSE CMD(DO)
               CHGVAR     VAR(%SST(&ALL &F 2)) VALUE('")')
               CHGVAR     VAR(&F) VALUE(&F + 3)
             ENDDO

             CHGVAR     VAR(%SST(&ALL &F 1)) VALUE('&')
             ENDDO
/**/
/* Execute OPNQRF for OTPAYJ1 command using the set-up parameters.*/
/**/
/* */
/* Copy from Awaiting authorisation file to improve open query                */
/* performance                                                                */
/* */
             CPYF       FROMFILE(OTPDNOBB) TOFILE(QTEMP/Q_OTPAY) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             OPNQRYF    FILE((QTEMP/Q_OTPAY) (OTPAYXPD)) +
                          FORMAT(OTPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (STMT)) +
                          JFLD((PREF OPPREF)) OPNID(OTPAYXJ0)
             CPYFRMQRYF FROMOPNID(OTPAYXJ0) TOFILE(QTEMP/OTPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
/**/                                                                 /*CFT006*/
/* Set-up OPNQRY command for RFTHDXD0 - for FT0806 */                /*CFT006*/
/**/                                                                 /*CFT006*/
                                                                     /*CFT006*/
             CHGVAR     VAR(&ALL) VALUE(' ')                         /*CFT006*/
             CHGVAR     VAR(&C) VALUE(1)                             /*CFT006*/
                                                                     /*CFT006*/
             IF         COND((&FTRN *NE ' ') *AND (&TTRN *NE ' ')) +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 17)) VALUE('(RFTID = +
                          %RANGE("')                                 /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 17)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&FTRN)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 15)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('" "')            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&TTRN)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 15)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('"')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 1)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND((&FVDT *NE ' ') *AND (&TVDT *NE ' ')) +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 17)) VALUE('(DBTVDT = +
                          %RANGE(')                                  /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 18)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&FVDT)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 6)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&TVDT)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 6)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&PYTP *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(PYTP = "')      /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 9)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYTP)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&PYST *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(PYST = "')      /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 9)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYST)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&PAGI *EQ 'Y') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('*STP')           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
             ENDDO                                                   /*CFT006*/
/**/                                                                 /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE('(AUIN *NE ')    /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('"Y")')           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 5)                        /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND((&RBCH *NE ' ') *AND (&RBCH *NE 'ALL')) +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(BRCA = "')      /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 9)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&RBCH)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)                  /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('(')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 1)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&OPR1 *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR1)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&OPR2 *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR2)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&OPR3 *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR3)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&OPR4 *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR4)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND(&OPR5 *NE ' ') +
                          THEN(DO)                                   /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR5)           /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT006*/
                          ENDDO                                      /*CFT006*/
/**/                                                                 /*CFT006*/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)                  /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(')')              /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT006*/
                         ENDDO                                       /*CFT006*/
/* Copy from Awaiting authorisation file to improve open query       /*CFT006*/
/* performance                                                       /*CFT006*/
/* */                                                                /*CFT006*/
             CPYF       FROMFILE(FT101HPD) TOFILE(QTEMP/Q_RFTHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
             OPNQRYF    FILE((QTEMP/Q_RFTHD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(RFTHDXD0)               /*CFT006*/
                                                                     /*CFT006*/
             CPYFRMQRYF FROMOPNID(RFTHDXD0) TOFILE(QTEMP/FT101X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
/**/                                                                 /*CFT008*/
/**/                                                                 /*CFT008*/
/* Set-up OPNQRY command for CCTHDXD0 - for FT0806 */                /*CFT008*/
/**/                                                                 /*CFT008*/
                                                                     /*CFT008*/
             CHGVAR     VAR(&ALL) VALUE(' ')                         /*CFT008*/
             CHGVAR     VAR(&C) VALUE(1)                             /*CFT008*/
                                                                     /*CFT008*/
             IF         COND((&FTRN *NE ' ') *AND (&TTRN *NE ' ')) +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 17)) VALUE('(CCTID = +
                          %RANGE("')                                 /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 17)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&FTRN)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 15)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('" "')            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE(&TTRN)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 15)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('"')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 1)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND((&FVDT *NE ' ') *AND (&TVDT *NE ' ')) +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 17)) VALUE('(DBTVDT = +
                          %RANGE(')                                  /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 18)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&FVDT)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 6)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 5)) VALUE(&TVDT)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 6)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('))')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&PYTP *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(CCTTYP = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYTP)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&PYST *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(CCTTST = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE(&PYST)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&SMCY *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(CCTCCY = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&SMCY)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&PAGI *EQ 'Y') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('*STP')           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
             ENDDO                                                   /*CFT008*/
/**/                                                                 /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE('(AUIN *NE ')    /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE('"Y")')           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 5)                        /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND((&RBCH *NE ' ') *AND (&RBCH *NE 'ALL')) +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 9)) VALUE('(BRCA = "')      /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 9)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE(&RBCH)            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)                  /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('&')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE('(')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 1)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&OPR1 *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR1)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&OPR2 *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR2)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&OPR3 *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR3)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&OPR4 *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR4)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND(&OPR5 *NE ' ') +
                          THEN(DO)                                   /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('*OR')            /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 11)) VALUE('(INUSER = "')   /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 11)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&OPR5)           /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 10)                       /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')             /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 3)                        /*CFT008*/
                          ENDDO                                      /*CFT008*/
/**/                                                                 /*CFT008*/
             IF         COND((&OPR1 *NE ' ') *OR (&OPR2 *NE ' ') *OR +
                          (&OPR3 *NE ' ') *OR (&OPR4 *NE ' ') *OR +
                          (&OPR5 *NE ' ')) THEN(DO)                  /*CFT008*/
             CHGVAR     VAR(%SST(&ALL &C 1)) VALUE(')')              /*CFT008*/
             CHGVAR     VAR(&C) VALUE(&C + 2)                        /*CFT008*/
                         ENDDO                                       /*CFT008*/
/* Copy from Awaiting authorisation file to improve open query       /*CFT008**/
/* performance                                                       /*CFT008**/
/* */                                                                /*CFT008*/
             CPYF       FROMFILE(FT102HPD) TOFILE(QTEMP/Q_CCTHD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/
             OPNQRYF    FILE((QTEMP/Q_CCTHD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(CCTHDXD0)               /*CFT008*/
                                                                     /*CFT008*/
             CPYFRMQRYF FROMOPNID(CCTHDXD0) TOFILE(QTEMP/FT102X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/
/**/                                                                 /*CFT008*/
             OVRDBF     FILE(INPAYJ2) TOFILE(QTEMP/INPAYJ2)
             OVRDBF     FILE(OTPAYJ2) TOFILE(QTEMP/OTPAYJ2)
             OVRDBF     FILE(FT101X0) TOFILE(QTEMP/FT101X0)          /*CFT006*/
             OVRDBF     FILE(FT102X0) TOFILE(QTEMP/FT102X0)          /*CFT008*/

             CALL       PGM(FT0806)

/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
             ENDDO

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             DLTOVR     FILE(INPAYJ2)
             MONMSG MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(OTPAYJ2)
             MONMSG MSGID(CPF0000 MCH0000)
             DLTOVR     FILE(FT101X0)                                /*CFT006*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT006*/
             DLTOVR     FILE(FT102X0)                                /*CFT008*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT008*/
             CLOF    OPNID(OTPAYXJ0)
             MONMSG MSGID(CPF0000 MCH0000)
             CLOF    OPNID(INPAYXJ0)
             MONMSG MSGID(CPF0000 MCH0000)
             CLOF    OPNID(RFTHDXD0)                                 /*CFT006*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT006*/
             CLOF    OPNID(CCTHDXD0)                                 /*CFT008*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT008*/

             CHGVAR     VAR(&ALL) VALUE(' ')
             CHGVAR     VAR(&RDAT) VALUE('       ')
             CHGVAR     VAR(%SST(&ALL 1 11)) VALUE('(INBANO = "')
             CHGVAR     VAR(%SST(&ALL 12 4)) VALUE(&BANO)
             CHGVAR     VAR(%SST(&ALL 16 16)) VALUE('") & (INRDAT = +
                          "')
             CHGVAR     VAR(%SST(&ALL 33 7)) VALUE(&RDAT)
             CHGVAR     VAR(%SST(&ALL 40 2)) VALUE('")')
             CHGVAR     VAR(&BANOA) VALUE(&BANO)
/* */
/* Copy out records from static select to improve performance of              */
/* open query processing                                                      */
/* */
             CPYF       FROMFILE(INPAYXL1) TOFILE(QTEMP/Q_INPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF INBANO *EQ &BANOA))
             OPNQRYF    FILE((INPAYDD) (QTEMP/Q_INPAYXPD)) +
                          FORMAT(INPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (INSETM)) +
                          JFLD((PREF INPREF)) OPNID(INPAYXJ0)
             CPYFRMQRYF FROMOPNID(INPAYXJ0) TOFILE(QTEMP/INPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CHGVAR     VAR(&ALL) VALUE(' ')
             CHGVAR     VAR(&RDAT) VALUE('       ')
             CHGVAR     VAR(%SST(&ALL 1 11)) VALUE('(OPBANO = "')
             CHGVAR     VAR(%SST(&ALL 12 4)) VALUE(&BANO)
             CHGVAR     VAR(%SST(&ALL 16 16)) VALUE('") & (OPRDAT = +
                          "')
             CHGVAR     VAR(%SST(&ALL 33 7)) VALUE(&RDAT)
             CHGVAR     VAR(%SST(&ALL 40 2)) VALUE('")')
             CHGVAR     VAR(&BANOA) VALUE(&BANO)
/* */
/* Copy out records from static select to improve performance of              */
/* open query processing                                                      */
/* */

             CPYF       FROMFILE(OTPAYXL1) TOFILE(QTEMP/Q_OTPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF OPBANO *EQ &BANOA))
             OPNQRYF    FILE((OTPAYDD) (QTEMP/Q_OTPAYXPD)) +
                          FORMAT(OTPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (STMT)) +
                          JFLD((PREF OPPREF)) OPNID(OTPAYXJ0)
             CPYFRMQRYF FROMOPNID(OTPAYXJ0) TOFILE(QTEMP/OTPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
                                                                     /*CFT006*/
             CHGVAR     VAR(&ALL) VALUE(' ')                         /*CFT006*/
             CHGVAR     VAR(%SST(&ALL 1 10)) VALUE('(BAUTH = "')     /*CFT006*/
             CHGVAR     VAR(%SST(&ALL 11 4)) VALUE(&BANO)            /*CFT006*/
             CHGVAR     VAR(%SST(&ALL 15 2)) VALUE('")')             /*CFT006*/
/* */                                                                /*CFT006*/
/* Copy out records from static select to improve performance of     /*CFT006*/
/* open query processing                                             /*CFT006*/
/* */                                                                /*CFT006*/
             CPYF       FROMFILE(FT101HPD) TOFILE(QTEMP/Q_FT101HPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
             OPNQRYF    FILE((QTEMP/Q_FT101HPD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(RFTHDXD0)               /*CFT006*/
             CPYFRMQRYF FROMOPNID(RFTHDXD0) TOFILE(QTEMP/FT101X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
/* */                                                                /*CFT008*/
/* Copy out records from static select to improve performance of     /*CFT008*/
/* open query processing                                             /*CFT008*/
/* */                                                                /*CFT008*/
             CPYF       FROMFILE(FT102HPD) TOFILE(QTEMP/Q_FT102HPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/
             OPNQRYF    FILE((QTEMP/Q_FT102HPD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(CCTHDXD0)               /*CFT008*/
             CPYFRMQRYF FROMOPNID(CCTHDXD0) TOFILE(QTEMP/FT102X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/

             ENDDO

             ENDDO
/**/
/* If request is authorise select only records with AUIN *NE "Y"  */
/* and BATCH NUMBER not equal to blank.                           */
/**/
             IF         COND(&RPAU *EQ X) +
             THEN(DO)

/* Select Incoming Payments                                       */
             CHGVAR     VAR(&ALL) VALUE(' ')
             CHGVAR     VAR(&C) VALUE(1)
             CHGVAR     VAR(%SST(&ALL 1 30)) VALUE('(AUIN *NE "Y") & +
                          (INBANO *EQ "')
             CHGVAR     VAR(&C) VALUE(&C + 30)
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE(&BCNO)
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('") ')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE('& (INRUSR *EQ +
                          "') /*NALD*/
             CHGVAR     VAR(&C) VALUE(&C + 15)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&USER)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)


/* */
/* Copy out records from static select to improve performance of              */
/* open query processing                                                      */
/* */
             CHGVAR     VAR(&BANOA) VALUE(&BCNO)
             CPYF       FROMFILE(INPAYXL1) TOFILE(QTEMP/Q_INPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF INBANO *EQ &BANOA))
             OPNQRYF    FILE((INPAYDD) (QTEMP/Q_INPAYXPD)) +
                          FORMAT(INPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (INSETM)) +
                          JFLD((PREF INPREF)) OPNID(INPAYXJ0)
             CPYFRMQRYF FROMOPNID(INPAYXJ0) TOFILE(QTEMP/INPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)


/* Select Outgoing Payments                                       */
             CHGVAR     VAR(&ALL) VALUE(' ')
             CHGVAR     VAR(&C) VALUE(1)
             CHGVAR     VAR(%SST(&ALL 1 30)) VALUE('(AUIN *NE "Y") & +
                          (OPBANO *EQ "')
             CHGVAR     VAR(&C) VALUE(&C + 30)
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE(&BCNO)
             CHGVAR     VAR(&C) VALUE(&C + 4)
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('") ')
             CHGVAR     VAR(&C) VALUE(&C + 3)
             CHGVAR     VAR(%SST(&ALL &C 15)) VALUE('& (OPRUSR *EQ +
                          "') /*NALD*/
             CHGVAR     VAR(&C) VALUE(&C + 15)
             CHGVAR     VAR(%SST(&ALL &C 10)) VALUE(&USER)
             CHGVAR     VAR(&C) VALUE(&C + 10)
             CHGVAR     VAR(%SST(&ALL &C 2)) VALUE('")')
             CHGVAR     VAR(&C) VALUE(&C + 3)


             CPYF       FROMFILE(OTPAYXL1) TOFILE(QTEMP/Q_OTPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF OPBANO *EQ &BANOA))
             OPNQRYF    FILE((OTPAYDD) (QTEMP/Q_OTPAYXPD)) +
                          FORMAT(OTPAYXJ0) QRYSLT(&ALL) +
                          KEYFLD((BRCA) (PCCY) (PVDT) (STMT)) +
                          JFLD((PREF OPPREF)) OPNID(OTPAYXJ0)
             CPYFRMQRYF FROMOPNID(OTPAYXJ0) TOFILE(QTEMP/OTPAYJ2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
                                                                     /*CFT006*/
             CHGVAR     VAR(&ALL) VALUE(' ')                         /*CFT006*/
             CHGVAR     VAR(&C) VALUE(1)                             /*CFT006*/
             CHGVAR     VAR(%SST(&ALL 1 29)) VALUE('(AUIN *NE "Y") & +
                          (BAUTH *EQ "')                             /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 29)                       /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 4)) VALUE(&BCNO)            /*CFT006*/
             CHGVAR     VAR(&C) VALUE(&C + 4)                        /*CFT006*/
             CHGVAR     VAR(%SST(&ALL &C 3)) VALUE('") ')            /*CFT006*/
                                                                     /*CFT006*/
/* */                                                                /*CFT006*/
/* Copy out records from static select to improve performance of     /*CFT006*/
/* open query processing                                             /*CFT006*/
/* */                                                                /*CFT006*/
             CPYF       FROMFILE(FT101HPD) TOFILE(QTEMP/Q_FT101HPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
             OPNQRYF    FILE((QTEMP/Q_FT101HPD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(RFTHDXD0)               /*CFT006*/
             CPYFRMQRYF FROMOPNID(RFTHDXD0) TOFILE(QTEMP/FT101X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT006*/
/* */                                                                /*CFT008*/
/* Copy out records from static select to improve performance of     /*CFT008*/
/* open query processing                                             /*CFT008*/
/* */                                                                /*CFT008*/
             CPYF       FROMFILE(FT102HPD) TOFILE(QTEMP/Q_FT102HPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/
             OPNQRYF    FILE((QTEMP/Q_FT102HPD)) FORMAT(*FILE) +
                          QRYSLT(&ALL) OPNID(CCTHDXD0)               /*CFT008*/
             CPYFRMQRYF FROMOPNID(CCTHDXD0) TOFILE(QTEMP/FT102X0) +
                          MBROPT(*REPLACE) CRTFILE(*YES)             /*CFT008*/
                                                                     /*CFT008*/
                                                                     /*CFT008*/
             ENDDO
             OVRDBF     FILE(INPAYJ2) TOFILE(QTEMP/INPAYJ2)
             OVRDBF     FILE(OTPAYJ2) TOFILE(QTEMP/OTPAYJ2)
             OVRDBF     FILE(FT101X0) TOFILE(QTEMP/FT101X0)          /*CFT006*/
             OVRDBF     FILE(FT102X0) TOFILE(QTEMP/FT102X0)          /*CFT008*/

             CALL       PGM(FT0803) PARM(&RSEQ &RLVL &RBCH &RPARM)

/* If database error detected recover data from LDA and send message */
/* to MOPERQ                                                         */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO CMDLBL(ERR)
             ENDDO

             COMMIT
/* */
/* Call FTC0804 to control submit of Pay/Receive */
/* only if Authorise mode is requested            */
/* */
             IF         COND(&RPAU *EQ 'X') THEN(DO)
             CALL       PGM(FTC0804)
             ENDDO
/* */

             GOTO END

 ERR:        SNDPGMMSG  MSG('Call to Payments Reporting/Autho+
                          risation ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
/**/
/* Roll Back changes */
/**/
             ROLLBACK
             DMPCLPGM

 END:        CLOF    OPNID(OTPAYXJ0)
             MONMSG MSGID(CPF0000 MCH0000)
             CLOF    OPNID(INPAYXJ0)
             MONMSG MSGID(CPF0000 MCH0000)
             CLOF    OPNID(RFTHDXD0)                                 /*CFT006*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT006*/
             CLOF    OPNID(CCTHDXD0)                                 /*CFT008*/
             MONMSG MSGID(CPF0000 MCH0000)                           /*CFT008*/

/**/
/* End Commitment Control. */
/**/
             ENDCMTCTL
             MONMSG MSGID(CPF0000 MCH0000 RPG0000)

             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                                          /*CRE020*/
          IF         COND((%SWITCH(XXXXXX00)) +
                     *AND (&CRE020 = 'Y') +
                     *AND (&RPAU = 'X')) THEN(DO)                                         /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL   REC000881 +
                          (FT0803 FT)') INLLIBL(*JOBD) MSGQ(MOPERQ)                       /*CRE020*/
                ENDDO                                                                     /*CRE020*/
                                                                                          /*CRE020*/
             ENDPGM
