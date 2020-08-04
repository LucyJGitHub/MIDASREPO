/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Reverse fwd reval. a/c balances')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0370 - Reverse Fwd Revaluation Account Balances          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. 259402             Date 06Jun20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG7578            Date 14Jun05              */
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      140486             Date 30Apr99              */
/*                      CMC001 *CREATE     Date 18Mar96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       259402 - No Reversal on first day of the month for          */
/*                Forward Revaluation posted on last day of          */
/*                previous month. Applied fix 220292 to address      */
/*                the latter problem. Also applied 251998 as         */
/*                Preventive fix, to correct the Account Section     */
/*                passed when generating the Forward Revaluation     */
/*                Reversal posting.                                  */
/*              - Applied for MD-55899                               */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG7578- No reversal FR posting. Accessing wrong positions  */
/*                on SDDEALPD. Also map ACODQQ to 0 in OPNQRYF.      */
/*       CGL029 - Increase account codes to 10 digits                */
/*       140486 - No forward revaluation happened when account       */
/*                becomes zero balance.                              */
/*       CMC001 - Management Accounts Enhancement for PCA            */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) /*        +
                          Return Code */
             DCL        VAR(&PKEY) TYPE(*CHAR) LEN(7) /*        +
                          Period Set */
             DCL        VAR(&PBAS) TYPE(*CHAR) LEN(7) /*        +
                          Posting Basis */
/**********  DCL        VAR(&FACC) TYPE(*CHAR) LEN(4) VALUE('0000') +*/                   /*CGL029*/
             DCL        VAR(&FACC) TYPE(*CHAR) LEN(10) +
                          VALUE('0000000000')                                             /*CGL029*/
                          /* Fwd Trade Account code */
/**********  DCL        VAR(&FRPL) TYPE(*CHAR) LEN(4) VALUE('0000') +*/                   /*CGL029*/
             DCL        VAR(&FRPL) TYPE(*CHAR) LEN(10) +
                          VALUE('0000000000')                                             /*CGL029*/
                          /* Fwd Trade P&L Account code */
             DCL        VAR(&PGCD) TYPE(*CHAR) LEN(4) /*        +
                          Primary Control Group code */
             DCL        VAR(&PDCT) TYPE(*CHAR) LEN(2) /*        +
                          Period Century */
             DCL        VAR(&PDYR) TYPE(*CHAR) LEN(2) /*        +
                          Period Year */
             DCL        VAR(&PDNY) TYPE(*CHAR) LEN(2) /*        +
                          Period Number within Year */
             DCL        VAR(&DEVD) TYPE(*CHAR) LEN(5) /*        +
                          Diary Event Date */
             DCL        VAR(&PSTD) TYPE(*CHAR) LEN(5) /*        +
                          Posting Date */
             DCL        VAR(&FRVL) TYPE(*CHAR) LEN(1) /*        +
                          Fwd Revaluation Date? */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(1) VALUE('N')                           /*259402*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1) VALUE(' ')                           /*259402*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*259402*/
             DCL        VAR(&ACSC) TYPE(*CHAR) LEN(2)                                     /*259402*/
             DCL        VAR(&ACSCD) TYPE(*CHAR) LEN(4)                                    /*259402*/
             DCLF       FILE(SDBANKPD) /* Bank ICD */
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/                                                                  /*EE9201*/
             SNDPGMMSG  MSG('MCC0370 - Reverse Fwd Reval A/c +
                          Balances') TOMSGQ(MRUNQ)                    /*ER9201*/
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Access Last Diary Event to check for Transfer Date */
/**/
             CALL       PGM(AODIRYR0) PARM(&RTCD '*LAST' ' '  +
                          &DSFDY)
             CHGVAR     VAR(&DEVD) VALUE(%SST(&DSFDY 1 5))
             CHGVAR     VAR(&FRVL) VALUE(%SST(&DSFDY 11 1))
/**/
/* If No Transfer today Terminate Program */
/**/
             IF         COND(&FRVL *NE 'Y') THEN(GOTO CMDLBL(END))
/**/
/* Access Bank ICD for Run Date */
/**/
             RCVF
             CHGVAR     VAR(&PSTD) VALUE(&BJRDNB)
/**/
/* Set Extract paramters  */
/**/
             IF         COND(&PBAS *EQ 'P') THEN(CHGVAR VAR(&DEVD) +
                          VALUE(&PSTD))

/**/
/* Access Dealing ICD for Foward Revaluation A/c and Contra */
/**/
             CALL       PGM(AODEALR0) PARM(&RTCD '*FIRST' &DSFDY)
/**********  CHGVAR     VAR(&FACC) VALUE(%SST(&DSFDY 11 4))          */                   /*CGL029*/
/**********  CHGVAR     VAR(&FRPL) VALUE(%SST(&DSFDY 15 4))          */                   /*CGL029*/
/*           CHGVAR     VAR(&FACC) VALUE(%SST(&DSFDY 122 10))  */                 /*CGL029 BUG7578*/
/*           CHGVAR     VAR(&FRPL) VALUE(%SST(&DSFDY 132 10))  */                 /*CGL029 BUG7578*/
             CHGVAR     VAR(&FACC) VALUE(%SST(&DSFDY 133 10))                            /*BUG7578*/
             CHGVAR     VAR(&FRPL) VALUE(%SST(&DSFDY 143 10))                            /*BUG7578*/
                                                                                          /*259402*/
/**/                                                                                      /*259402*/
/* Access Account Codes for account section of contra Acc   */                            /*259402*/
/**/                                                                                      /*259402*/
             CALL       PGM(AOACODR0) PARM(&RTCD '*KEY' &FRPL +
                          &DSSDY)                                                         /*259402*/
             CHGVAR     VAR(&ACSC) VALUE(%SST(&DSSDY 72 2))                               /*259402*/

/**/
/* Access PCA ICD for Primary Mgmt A/c Control Group */
/**/
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             CHGVAR     VAR(&PGCD) VALUE(%SST(&DSFDY 15 2))
/**/
/* Access Primary Control Group for Period Set */
/**/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PGCD &DSFDY)
             CHGVAR     VAR(&PKEY) VALUE(%SST(&DSFDY 33 1))
/**/
/* Access Current Period Century, Year and Number */
/**/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PKEY 0 &DSFDY)
             CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))
             CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))

             CALL       PGM(CB0812) PARM(&RUN &RTN)                                       /*259402*/
             IF         COND(&RUN *EQ 'Y') THEN(DO)                                       /*259402*/
                CALL PGM(AORPERR0) PARM(&RTCD '*PREV' &PKEY 0 &DSFDY)                     /*259402*/
                CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))                             /*259402*/
                CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))                             /*259402*/
                CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))                             /*259402*/
             ENDDO                                                                        /*259402*/
                                                                                          /*259402*/
/* Set up OPNQRYF to Fwd Trade A/c balances */

/*********** OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +      *140486*/
/***********              QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +    *140486*/
/***********              ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +    *140486*/
/***********              ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +    *140486*/
/***********              ''' *AND HBPDCB *NE 0 *AND (HBACCD *EQ +     *140486*/
/***********              ''' *CAT &FACC *CAT ''')') MAPFLD((BRCA +    *140486*/
/***********              HBBRCD) (CCY HBCYCD) (ACOD HBACCD) (CNUM +   *140486*/
/***********              HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +  *140486*/
/***********              HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +  *140486*/
/***********              HBACNB) (ACSC HBACSC) (PAMT 'HBPDCB * +      *140486*/
/***********              -1') (VOIN 1) (GETP '''F''') (ATYP ''' +     *140486*/
/***********              ''') (CPNB (&PDCT *CAT &PDYR *CAT &PDNY)) +  *140486*/
/***********              (PNAR '''FWD P&L VALUATION REVERSAL''') +    *140486*/
/***********              (EVDT &DEVD) (PDTM (&PSTD *CAT '235959')) +  *140486*/
/***********              (DRCR 1))                                   /*140486*/
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +    */                   /*CGL029*/
/**********               QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +  */                   /*CGL029*/
/**********               ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT + */                   /*CGL029*/
/**********               ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) + */                   /*CGL029*/
/**********               (ACOD HBACCD) (CNUM HBCUST) (ACSQ HBACSN) +*/                   /*CGL029*/
/**********               (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +*/                   /*CGL029*/
/**********               (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) +*/                   /*CGL029*/
/**********               (PAMT 'HBPDCB * -1') (VOIN 1) (GETP +      */                   /*CGL029*/
/**********               '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +*/                   /*CGL029*/
/**********               &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +      */                   /*CGL029*/
/**********               VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +*/                   /*CGL029*/
/**********               (&PSTD *CAT '235959')) (DRCR 1))           */            /*140486 CGL029*/
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +    */                  /*BUG7578*/
/**********               QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +  */                  /*BUG7578*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +  */                  /*BUG7578*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +  */                  /*BUG7578*/
/**********               ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT + */                  /*BUG7578*/
/**********               ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) + */                  /*BUG7578*/
/**********               (ACOD HBACCD) (CNUM HBCUST) (ACSQ HBACSN) +*/                  /*BUG7578*/
/**********               (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +*/                  /*BUG7578*/
/**********               (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) +*/                  /*BUG7578*/
/**********               (PAMT 'HBPDCB * -1') (VOIN 1) (GETP +      */                  /*BUG7578*/
/**********               '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +*/                  /*BUG7578*/
/**********               &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +      */                  /*BUG7578*/
/**********               VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +*/                  /*BUG7578*/
/**********               (&PSTD *CAT '235959')) (DRCR 1) (ACODQQ +  */                  /*BUG7578*/
/**********               QQACCD))                                   */         /*CGL029   BUG7578*/
             OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +
                          QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +
                          ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +
                          ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +
                          ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT +
                          ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) +
                          (ACOD HBACCD) (CNUM HBCUST) (ACSQ HBACSN) +
                          (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +
                          (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) +
                          (PAMT 'HBPDCB * -1') (VOIN 1) (GETP +
                          '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +
                          &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +
                          VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +
                          (&PSTD *CAT '235959')) (DRCR 1) (ACODQQ +
                          0))                                                            /*BUG7578*/
/**/
/*  Copy OPNQRYF to MCFREXPD  */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCFREXPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
/**/
/*********** OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +      *140486*/
/***********              QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +    *140486*/
/***********              ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +    *140486*/
/***********              ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +    *140486*/
/***********              ''' *AND HBPDCB *NE 0 *AND (HBACCD *EQ +     *140486*/
/***********              ''' *CAT &FACC *CAT ''')') MAPFLD((BRCA +    *140486*/
/***********              HBBRCD) (CCY HBCYCD) (ACOD &FRPL) (CNUM +    *140486*/
/***********              HBCUST) (ACSQ HBACSN) (PRFC HBPCCD) (BOKC +  *140486*/
/***********              HBBKCD) (OTTP HBOTTP) (OTST HBTSTY) (ASOC +  *140486*/
/***********              HBACNB) (ACSC HBACSC) (PAMT 'HBPDCB * +      *140486*/
/***********              1') (VOIN 1) (GETP '''F''') (ATYP ''' +      *140486*/
/***********              ''') (CPNB (&PDCT *CAT &PDYR *CAT &PDNY)) +  *140486*/
/***********              (PNAR '''FWD P&L VALUATION REVERSAL''') +    *140486*/
/***********              (EVDT &DEVD) (PDTM (&PSTD *CAT '235959')) +  *140486*/
/***********              (DRCR 0))                                   /*140486*/
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +    */                   /*CGL029*/
/**********               QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +  */                   /*CGL029*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +  */                   /*CGL029*/
/**********               ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT + */                   /*CGL029*/
/**********               ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) + */                   /*CGL029*/
/**********               (ACOD &FRPL) (CNUM HBCUST) (ACSQ HBACSN) + */                   /*CGL029*/
/**********               (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +*/                   /*CGL029*/
/**********               (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) +*/                   /*CGL029*/
/**********               (PAMT 'HBPDCB * 1') (VOIN 1) (GETP +       */                   /*CGL029*/
/**********               '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +*/                   /*CGL029*/
/**********               &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +      */                   /*CGL029*/
/**********               VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +*/                   /*CGL029*/
/**********               (&PSTD *CAT '235959')) (DRCR 0))           */        /*140486*/ /*CGL029*/

/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +     */                  /*CGL029*/
/**********               QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +   */                  /*CGL029*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +   */                  /*CGL029*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +   */                  /*CGL029*/
/**********               ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT +  */                  /*CGL029*/
/**********               ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) +  */                  /*CGL029*/
/**********               (ACOD &FRPL) (CNUM HBCUST) (ACSQ HBACSN) +  */                  /*CGL029*/
/**********               (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) + */                  /*CGL029*/
/**********               (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) + */                  /*CGL029*/
/**********               (PAMT 'HBPDCB * 1') (VOIN 1) (GETP +        */                  /*CGL029*/
/**********               '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT + */                  /*CGL029*/
/**********               &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +       */                  /*CGL029*/
/**********               VALUATION REVERSAL''') (EVDT &DEVD) (PDTM + */                  /*CGL029*/
/**********               (&PSTD *CAT '235959')) (DRCR 0) (ACODQQ +   */                  /*CGL029*/
/**********               '    '))                                    */                  /*CGL029*/
/**********                                                                               /*259402*/
/**********  OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +                         /*259402*/
/**********               QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +                       /*259402*/
/**********               ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +                       /*259402*/
/**********               ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +                       /*259402*/
/**********               ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT +                      /*259402*/
/**********               ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) +                      /*259402*/
/**********               (ACOD &FRPL) (CNUM HBCUST) (ACSQ HBACSN) +                      /*259402*/
/**********               (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +                     /*259402*/
/**********               (OTST HBTSTY) (ASOC HBACNB) (ACSC HBACSC) +                     /*259402*/
/**********               (PAMT 'HBPDCB * 1') (VOIN 1) (GETP +                            /*259402*/
/**********               '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +                     /*259402*/
/**********               &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +                           /*259402*/
/**********               VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +                     /*259402*/
/**********               (&PSTD *CAT '235959')) (DRCR 0) (ACODQQ +                       /*259402*/
/**********               0))                                                  /*CGL029*/ /*259402*/
/**/                                                                                      /*259402*/
             CHGVAR     VAR(&ACSCD) VALUE('''' *CAT &ACSC *CAT '''')                      /*259402*/
             OPNQRYF    FILE((GLHIBLPD &PGCD)) FORMAT(MCPCACPD) +
                          QRYSLT(' HBPDCT *EQ ''' *CAT &PDCT *CAT +
                          ''' *AND HBPDYR *EQ ''' *CAT &PDYR *CAT +
                          ''' *AND HBPDNY *EQ ''' *CAT &PDNY *CAT +
                          ''' *AND (HBACCD *EQ ''' *CAT &FACC *CAT +
                          ''')') MAPFLD((BRCA HBBRCD) (CCY HBCYCD) +
                          (ACOD &FRPL) (CNUM HBCUST) (ACSQ HBACSN) +
                          (PRFC HBPCCD) (BOKC HBBKCD) (OTTP HBOTTP) +
                          (OTST HBTSTY) (ASOC HBACNB) (ACSC &ACSCD) +
                          (PAMT 'HBPDCB * 1') (VOIN 1) (GETP +
                          '''F''') (ATYP ''' ''') (CPNB (&PDCT *CAT +
                          &PDYR *CAT &PDNY)) (PNAR '''FWD P&L +
                          VALUATION REVERSAL''') (EVDT &DEVD) (PDTM +
                          (&PSTD *CAT '235959')) (DRCR 0) (ACODQQ +
                          0))                                                             /*259402*/
/**/
/*  Copy OPNQRYF to MCFREXPD  */
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCFREXPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
/**/
             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination Processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Reversal of Forward Reval A/c Balances +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CLOF       OPNID(GLHIBLPD)
             MONMSG     MSGID(CPF4520)
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
