/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Set Selection String for OPNQRYF')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - USER DEFINED CORRESPONDENCE                         */
/*                                                                   */
/*       CGC5420 - Setup Selection String for OPNQRYF                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD048610           Date 26Dec17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG14209           Date 25Jul07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      245055             Date 08Nov06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241824             Date 06Oct06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCG009             DATE 01JUN95              */
/*            AMEND NO. 089165             DATE 24MAY95              */
/*            AMEND NO. 089166             DATE 22MAY95              */
/*            AMEND NO. 086662             DATE 25APR95              */
/*            AMEND NO. 083971             DATE 28FEB95              */
/*            AMEND NO. S01522             DATE 24JAN95              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD048610 - Correct selection on extracted date.             */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG14209 - CGC5410 Failed during COB.                       */
/*       245055 - Review 241824.                                     */
/*       241824 - Allow print process request by Module Id           */
/*                and by Extract Date.                               */
/*       CCG009 - Private Banking UDC                                */
/*       089165 - Allow to select up to yesterday                    */
/*       089166 - Correct to date processing                         */
/*       086662 - Add correspondence type to selection criteria -    */
/*                (This has increased the size of the parameter      */
/*                passed)                                            */
/*       083971 - Change for primary only                            */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&RPARM &RBCH &SELECT &OPTIONS)

/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')


/* Parameter received for RCF */
/*           DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)*/                          /*241824*/
/*           DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(115)*/                   /*241824 245055*/
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)                            /*245055*/
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)

/* General */
             DCL        VAR(&OPTIONS)     TYPE(*CHAR) LEN(256)

/* Used for query selection criteria */
             DCL        VAR(&SELECT)      TYPE(*CHAR) LEN(512)

             DCL        VAR(&BRCH_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&CORR_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRIM_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&PTYP_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&PSTP_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&FDAT_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&TDAT_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&LGID_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&STTS_SL)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&ATRM_SL)     TYPE(*CHAR) LEN(25)
             DCL        VAR(&EXDT_SL)     TYPE(*CHAR) LEN(25)                             /*241824*/
             DCL        VAR(&MODI_SL)     TYPE(*CHAR) LEN(25)                             /*241824*/

/* Used to break down &RPARM into individual selection criteria */
             DCL        VAR(&CORRESP)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRIMARY)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTTYPE)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBTYPE)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROMDATE)    TYPE(*DEC)  LEN(5)
             DCL        VAR(&FROMDATEA)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&TODATE)      TYPE(*DEC)  LEN(5)
             DCL        VAR(&TODATEA)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&LANGUAGE)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACC_PTH)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACC_PTHEND)  TYPE(*CHAR) LEN(2)          /*CCG009*/
             DCL        VAR(&STATUS1)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&STATUS2)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&STATUS3)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&STATUS4)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&STATUS5)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&ATRM)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&COT) TYPE(*CHAR) LEN(1) /* 086662 */
/************DCL        VAR(&EXDT) TYPE(*CHAR) LEN(7) */                           /*241824*245055*/
             DCL        VAR(&EXDT) TYPE(*CHAR) LEN(5)                                     /*245055*/
             DCL        VAR(&MODI) TYPE(*CHAR) LEN(2)                                     /*241824*/

/* Declare file SDBANKPD  */
             DCLF       FILE(SDBANKPD)

/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)

/* Copyright Statement                                               */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
/* */
/* Get Bank Information and see if non-working days exist */
/* */
             OVRDBF     FILE(SDBANKPD) SHARE(*NO)
             RCVF

/* Retrieve constituent data from &RPARM                             */
             CHGVAR     VAR(&CORRESP ) VALUE(%SST(&RPARM 11 10))
             CHGVAR     VAR(&PRIMARY ) VALUE(%SST(&RPARM 21 1))
             CHGVAR     VAR(&PRTTYPE ) VALUE(%SST(&RPARM 22 10))
             CHGVAR     VAR(&SUBTYPE ) VALUE(%SST(&RPARM 32 10))
             CHGVAR     VAR(&FROMDATEA) VALUE(%SST(&RPARM 42 5))
             CHGVAR     VAR(&TODATEA ) VALUE(%SST(&RPARM 47 5))
             CHGVAR     VAR(&LANGUAGE) VALUE(%SST(&RPARM 52 10))
/*********** CHGVAR     VAR(&ACC_PTH ) VALUE(%SST(&RPARM 62 10)) **** /*CCG009*/
             CHGVAR     VAR(&ACC_PTHEND) VALUE(%SST(&RPARM 62 2))     /*CCG009*/
             CHGVAR     VAR(&ACC_PTH) VALUE('CGPGEN' *CAT +
                          &ACC_PTHEND)                                /*CCG009*/
             CHGVAR     VAR(&STATUS1 ) VALUE(%SST(&RPARM 72 4))
             CHGVAR     VAR(&STATUS2 ) VALUE(%SST(&RPARM 76 4))
             CHGVAR     VAR(&STATUS3 ) VALUE(%SST(&RPARM 80 4))
             CHGVAR     VAR(&STATUS4 ) VALUE(%SST(&RPARM 84 4))
             CHGVAR     VAR(&STATUS5 ) VALUE(%SST(&RPARM 88 4))
             CHGVAR     VAR(&ATRM    ) VALUE(%SST(&RPARM 92 1))
             CHGVAR     VAR(&COT) VALUE(%SST(&RPARM 96 1)) /* 086662 */
/************CHGVAR     VAR(&EXDT) VALUE(%SST(&RPARM 98 7)) */                     /*241824*245055*/
             CHGVAR     VAR(&EXDT) VALUE(%SST(&RPARM 54 5))                               /*245055*/
/************CHGVAR     VAR(&MODI) VALUE(%SST(&RPARM 105 2))                       /*241824*245055*/
             CHGVAR     VAR(&MODI) VALUE(%SST(&RPARM 59 2))                               /*245055*/


/* Set up Selection strings for OPNQRYF */


/* Branch                                                            */
             IF        COND((&RBCH *NE '   ') *AND (&RBCH *NE 'ALL')) +
                                                        THEN(DO)
                  CHGVAR VAR(&BRCH_SL) VALUE('(DRBRCA *EQ "' *TCAT +
                                 &RBCH *TCAT '")')
                  CHGVAR VAR(&SELECT) VALUE(&BRCH_SL)
             ENDDO

/* Correspondent                                                     */
/* If &COT is 'C' then &CORRESP is the correspondent                 */
/* If &COT is 'T' then &CORRESP is the correspondent type            */
/* Correspondent type cannot be added onto the end of &RPARM since   */
/* this would take &RPARM > 100 necessitating changes throughout RCF */
             IF         COND(&COT *EQ 'C') THEN(DO) /* 086662 */
             IF         COND(&CORRESP *NE '          ') THEN(DO)
                  CHGVAR VAR(&CORR_SL) VALUE('(DRDCOR *EQ "' *TCAT +
                                 &CORRESP *TCAT '")')

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                      CHGVAR VAR(&SELECT) VALUE(&CORR_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &CORR_SL)
                  ENDDO
             ENDDO
             ENDDO       /* 086662 */

/* Primary Only?                                                     */
             IF         COND(&PRIMARY *EQ 'Y') THEN(DO)
/**************** CHGVAR VAR(&PRIM_SL) + ***************************** 083971*/
/*********************** VALUE('(DRPCOR *EQ "          ")') ********** 083971*/
             CHGVAR     VAR(&PRIM_SL) VALUE('(DRPCOR *EQ DRDCOR)')   /*083971*/

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&PRIM_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &PRIM_SL)
                  ENDDO
             ENDDO


/* Print Type                                                        */
             IF         COND(&PRTTYPE *NE '          ') THEN(DO)
                  CHGVAR VAR(&PTYP_SL) VALUE('(DRPTYP *EQ "' *TCAT +
                                 &PRTTYPE *TCAT '")')

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&PTYP_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &PTYP_SL)
                  ENDDO
             ENDDO


/* Sub-type                                                          */
             IF         COND((&SUBTYPE *NE '          ') *AND +
                          (&PRTTYPE *NE '          ')) THEN(DO)
                  CHGVAR VAR(&PSTP_SL) VALUE('(DRPSTP *EQ "' *TCAT +
                                 &SUBTYPE *TCAT '")')

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&PSTP_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &PSTP_SL)
                  ENDDO
             ENDDO


/* From date                                                         */

             IF         COND(&FROMDATEA *NE '00000') THEN(DO)
/* If '0000J' then default to run date from SDBANKPD */
             IF         COND(&FROMDATEA *NE '0000J') THEN(DO)
                  CHGVAR VAR(&FDAT_SL) VALUE('(DRPRTD *GE ' *CAT +
                                &FROMDATEA *TCAT ')')
             ENDDO
             ELSE       CMD(DO)
                  CHGVAR VAR(&FROMDATEA) VALUE(&BJRDNB)
                  CHGVAR VAR(&FDAT_SL) VALUE('(DRPRTD *GE ' *CAT +
                                &FROMDATEA *TCAT ')')
             ENDDO

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&FDAT_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' *AND ' *CAT &FDAT_SL)
                  ENDDO
             ENDDO


/* To date                                                         */
             IF         COND(&TODATEA *NE '00000') THEN(DO)
/* If '0000J' then default to run date from SDBANKPD */
             IF         COND(&TODATEA *NE '0000J') THEN(DO)
/************     CHGVAR VAR(&TDAT_SL) VALUE('(DRPRTD *GE ' *CAT +     *089166*/
/* If '0000K' then default to run date from SDBANKPD */
             IF         COND(&TODATEA *NE '0000K') THEN(DO)           /*089165*/
                  CHGVAR VAR(&TDAT_SL) VALUE('(DRPRTD *LE ' *CAT +
                                &TODATEA *TCAT ')')                   /*089166*/
             ENDDO       /*089165*/
             ELSE       CMD(DO)                                       /*089165*/
                  CHGVAR VAR(&TODATEA) VALUE(&BJRDNB)                 /*089165*/
                  CHGVAR VAR(&TDAT_SL) VALUE('(DRPRTD *LT ' *CAT +
                                &TODATEA *TCAT ')')                   /*089165*/
             ENDDO       /*089165*/
             ENDDO
             ELSE       CMD(DO)
                  CHGVAR VAR(&TODATEA) VALUE(&BJRDNB)
                  CHGVAR VAR(&TDAT_SL) VALUE('(DRPRTD *LE ' *CAT +
                                &TODATEA *TCAT ')')
             ENDDO

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&TDAT_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &TDAT_SL)
                  ENDDO
             ENDDO


/* Language ID                                                       */
             IF         COND(&LANGUAGE *NE '  ') THEN(DO)
                  CHGVAR VAR(&LGID_SL) VALUE('(DRLGID *EQ "' *TCAT +
                                &LANGUAGE *TCAT '")')

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&LGID_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &LGID_SL)
                  ENDDO
             ENDDO


/* Status                                                            */
             IF         COND(&STATUS1 *NE '    ') THEN(DO)
                  CHGVAR VAR(&STTS_SL) VALUE('(DRISTS *EQ %VALUES("' +
                                 *TCAT &STATUS1)

                  IF         COND(&STATUS2 *NE '    ') THEN( +
                        CHGVAR VAR(&STTS_SL) VALUE(&STTS_SL *TCAT +
                                 '" "' *TCAT &STATUS2))

                  IF         COND(&STATUS3 *NE '    ') THEN( +
                        CHGVAR VAR(&STTS_SL) VALUE(&STTS_SL *TCAT +
                                 '" "' *TCAT &STATUS3))

                  IF         COND(&STATUS4 *NE '    ') THEN( +
                        CHGVAR VAR(&STTS_SL) VALUE(&STTS_SL *TCAT +
                                 '" "' *TCAT &STATUS4))

                  IF         COND(&STATUS5 *NE '    ') THEN( +
                        CHGVAR VAR(&STTS_SL) VALUE(&STTS_SL *TCAT +
                                 '" "' *TCAT &STATUS5))

                  CHGVAR VAR(&STTS_SL) VALUE(&STTS_SL *TCAT '"))')


                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&STTS_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &STTS_SL)
                  ENDDO
             ENDDO


/* Auto-Transmission Indicator                                       */
             IF         COND(&ATRM     *NE '  ') THEN(DO)
                  CHGVAR VAR(&ATRM_SL) VALUE('(DRATRM *EQ "' *TCAT +
                                &ATRM *TCAT '")')

                  IF         COND(&SELECT *EQ ' ') THEN(DO)
                     CHGVAR VAR(&SELECT) VALUE(&ATRM_SL)
                  ENDDO

                  ELSE CMD(DO)
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &ATRM_SL)
                  ENDDO
             ENDDO

/* Extract date                                                      */                   /*241824*/
/************IF         COND(&EXDT *NE '       ') THEN(DO) */                      /*241824*245055*/
/************IF         COND(%SST(&EXDT 1 1) *EQ '0') THEN(CHGVAR + */             /*241824*245055*/
/************             VAR(%SST(&EXDT 1 1)) VALUE(' ')) */                      /*241824*245055*/
/************     CHGVAR VAR(&EXDT_SL) VALUE('(DRARDT *EQ "' *TCAT + */            /*241824*245055*/
/************                    &EXDT *TCAT '")') */                              /*241824*245055*/
                                                                                          /*245055*/
/**********  IF         COND(&EXDT *NE '00000') THEN(DO)             */      /*245055*/ /*BUG14209*/
             IF         COND(&EXDT *NE '00000' *AND &EXDT *NE +
                          '       ') THEN(DO)                                           /*BUG14209*/
/* If '0000J' then default to run date from SDBANKPD */                                   /*245055*/
             IF         COND(&EXDT *NE '0000J') THEN(DO)                                  /*245055*/
/*********        CHGVAR VAR(&EXDT_SL) VALUE('(DRRDNB *GE ' *CAT +
                                &EXDT *TCAT ')') */                              /*245055*MD048610*/
                  CHGVAR VAR(&EXDT_SL) VALUE('(DRRDNB *EQ ' *CAT +
                                &EXDT *TCAT ')')                                        /*MD048610*/
             ENDDO       /*245055*/
             ELSE       CMD(DO)                                                           /*245055*/
                  CHGVAR VAR(&EXDT) VALUE(&BJRDNB)                                        /*245055*/
/*********        CHGVAR VAR(&EXDT_SL) VALUE('(DRRDNB *GE ' *CAT +
                                &EXDT *TCAT ')') */                              /*245055*MD048610*/
                  CHGVAR VAR(&EXDT_SL) VALUE('(DRRDNB *EQ ' *CAT +
                                &EXDT *TCAT ')')                                        /*MD048610*/
             ENDDO       /*245055*/
                                                                                          /*245055*/
                  IF         COND(&SELECT *EQ ' ') THEN(DO)                               /*241824*/
                     CHGVAR VAR(&SELECT) VALUE(&EXDT_SL)                                  /*241824*/
                  ENDDO       /*241824*/
                                                                                          /*241824*/
                  ELSE CMD(DO)                                                            /*241824*/
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &EXDT_SL)                       /*241824*/
                  ENDDO       /*241824*/
             ENDDO       /*241824*/
                                                                                          /*241824*/
/* Module Id                                                         */                   /*241824*/
             IF         COND(&MODI *NE '       ') THEN(DO)                                /*241824*/
                  CHGVAR VAR(&MODI_SL) VALUE('(DRMODI *EQ "' *TCAT +
                                 &MODI *TCAT '")')                                        /*241824*/
                                                                                          /*241824*/
                  IF         COND(&SELECT *EQ ' ') THEN(DO)                               /*241824*/
                     CHGVAR VAR(&SELECT) VALUE(&MODI_SL)                                  /*241824*/
                  ENDDO       /*241824*/
                                                                                          /*241824*/
                  ELSE CMD(DO)                                                            /*241824*/
                     CHGVAR VAR(&SELECT) +
                           VALUE(&SELECT *TCAT ' & ' *CAT &MODI_SL)                       /*241824*/
                  ENDDO       /*241824*/
             ENDDO       /*241824*/
                                                                                          /*241824*/

/* Override database file CGUDCRPD and open query file */
             IF         COND(&SELECT *EQ ' ') THEN(DO)
                CHGVAR VAR(&SELECT) VALUE('*ALL')
             ENDDO


/* Terminate Program normally                                        */
             GOTO       CMDLBL(ENDCLPGM)


/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             DMPCLPGM
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5420 ended abnormally') MSGTYPE(*ESCAPE)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)


 ENDCLPGM:
             RCLRSC     LVL(*CALLER)
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             ENDPGM

