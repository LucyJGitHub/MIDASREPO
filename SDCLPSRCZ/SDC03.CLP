/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Database Maintenance')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standing Data Module                              */
/*                                                                   */
/*       SDC03 - TABLE FILE MAINTENANCE                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 099226             Date 05Feb96              */
/*                      087757             Date 24Oct95              */
/*                      S01413             DATE 13APR93              */
/*                      RT0159             DATE 25JUN91              */
/*                      E17785                  16AUG90              */
/*                      E22545                  09AUG90              */
/*                      S01179                  11/09/88             */
/*                      S01129                  10/03/87             */
/*                      S01147                  08/01/88             */
/*                      E11161                  29/07/87             */
/*                      E11184                  20/07/87             */
/*                      E10441                  02/03/87             */
/*                      S01109                  10/06/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       099226 - Change 087757 has resulted in a subset of SD       */
/*                functions being locked out with an 'in use by      */
/*                by another user' message.                          */
/*       087757 - Check if A/C key file is being used by another     */
/*                workstation for update.                            */
/*       S01413 - Retail 3 Incorporation.                            */
/*       RT0159 - Messages should be sent via new Midas Info Screen. */
/*       E17785 - Redundant code removed                             */
/*       E22545 - Reference to TABST (old ST Module) removed.        */
/*       S01179 - AS400 Conversion                                   */
/*       S01129 - Securities Trading                                 */
/*       S01147 - Remove E11184 for release 22                       */
/*       E11161 - Error msg not being sent to MOPERQ.                */
/*       E11184 - Temp. fix to use old SD Maint. progs.              */
/*       E10441 - STDSI Should be SHARE(*NO)                         */
/*       S01109 - Addition of standard settlement instructions.      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRM01 &PRM02)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                            */
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        &PRM02        TYPE(*CHAR)  LEN(1)
             DCL        &SWS          TYPE(*CHAR)  LEN(8)
/************DCL        &N            TYPE(*CHAR)  LEN(8) **/         /*RT0159*/
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &MSG          TYPE(*CHAR)  LEN(75)
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*087757*/
/**/
               CHGJOB     SWS(00000000)
 
             IF         COND(&PRM02 *EQ '1') THEN(DO)
                OVRDBF     FILE(TABLE) TOFILE(TABSDU)
                OVRDBF     FILE(TABLEI) TOFILE(TABSDU) SHARE(*NO)
             ENDDO
             IF         COND(&PRM02 *EQ '2') THEN(OVRDBF FILE(TABLE)           +
                          TOFILE(TABSDM))
             IF         COND(&PRM02 *EQ '3') THEN(OVRDBF FILE(TABLE)           +
                          TOFILE(TABSDU))
             IF         COND(&PRM02 *EQ '4') THEN(OVRDBF FILE(TABLE)           +
                          TOFILE(TABCLI))
/************IF         COND(&PRM02 *EQ '5') THEN(OVRDBF FILE(TABLE)    E22545*/
/************             TOFILE(TABST))                                E22545*/
             IF         COND(&PRM02 *EQ '6') THEN(OVRDBF FILE(TABLE)           +
                          TOFILE(TABSE))                              /*S01129*/
 
             IF         COND(&PRM01 *EQ 'SD0010') THEN(DO)
               OVRDBF     FILE(CLIND) TOFILE(CLINT) SHARE(*NO)
               OVRDBF     FILE(CLINT2) TOFILE(CLINT) SHARE(*NO)
/************  RCVDTAARA  DTAARA(MMOD)                              *  *S01179*/
               RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                  /*S01179*/
               IF         COND(%SUBSTRING(&MMOD 10 1) *EQ Y) THEN(DO)
                   CHGJOB     SWS(XX1XXXXX)
               ENDDO
               IF         COND(%SUBSTRING(&MMOD 02 1) *EQ Y) THEN(DO)
                   CHGJOB     SWS(1XXXXXXX)
               ENDDO
               IF         COND(%SUBSTRING(&MMOD 04 1) *EQ Y) THEN(DO)
                   CHGJOB     SWS(X1XXXXXX)
               ENDDO
             ENDDO
/**/                                                                  /*S01129*/
/*           IF         COND(&PRM01 *EQ 'SD0012') THEN(DO)  /*S01129*  *S01129*/
             IF         COND(&PRM01 *EQ 'SD0013') THEN(DO)            /*S01129*/
                OVRDBF     FILE(TABLE) TOFILE(TABSE)                  /*S01129*/
/*************  RCVDTAARA  DTAARA(MMOD)                             *  *S01179*/
                RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                 /*S01179*/
                IF        COND(%SUBSTRING(&MMOD 21 1) *EQ Y) THEN(DO) /*S01129*/
                   CHGVAR  VAR(&PRM01) VALUE('SD0013')                /*S01129*/
                ENDDO                                                 /*S01129*/
             ENDDO                                                    /*S01129*/
/**/                                                                  /*S01129*/
/**/
             IF         COND(&PRM01 *EQ 'SD0180') THEN(DO)
/*************  RCVDTAARA  DTAARA(MMOD)                             *  *S01179*/
                RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                 /*S01179*/
                IF         COND(%SUBSTRING(&MMOD 05 1) *EQ Y) THEN(DO)
                   CHGJOB     SWS(1XXXXXXX)
                ENDDO
             ENDDO
/**/                                                                  /*S01109*/
/************IF         COND(&PRM01 *EQ 'SD7534') THEN(DO)         */ /*E17785*/
/***************OVRDBF     FILE(TABLE) TOFILE(TABDLI)              */ /*E17785*/
/***************OVRDBF     FILE(STDSI) TOFILE(STDSI) SHARE(*NO)    */ /*E17785*/
/***************IF         COND(%SUBSTRING(&MMOD 05 1) *EQ Y) THEN(DO)/*E17785*/
/******************CHGJOB     SWS(1XXXXXXX)                        */ /*E17785*/
/************ENDDO                                                 */ /*E17785*/
/************ENDDO                                                 */ /*E17785*/
/**/                                                                  /*S01109*/
             IF         COND(&PRM01 *EQ 'SD0284') THEN(DO)
               OVRDBF     FILE(TABLE) TOFILE(TABSDM) SHARE(*NO)
               OVRDBF     FILE(TABLE2) TOFILE(TABSDM) SHARE(*NO)
             ENDDO
/****/                                                                /*E11184*/
 /*          RCVDTAARA  DTAARA(MMOD)                                *  *S01147*/
 /*          IF         COND(%SUBSTRING(&MMOD 12 1) *EQ N) THEN(DO) *  *S01147*/
 /*             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)      *  *S01147*/
 /*             IF      COND(&PRM01 *EQ 'SD0020') THEN(DO)          *  *S01147*/
 /*             CHGVAR VAR(&PRM01) VALUE('TMPSD020')                *  *S01147*/
 /*             ENDDO                                               *  *S01147*/
 /*             IF      COND(&PRM01 *EQ 'SD0220') THEN(DO)          *  *S01147*/
 /*             CHGVAR VAR(&PRM01) VALUE('TMPSD220')                *  *S01147*/
 /*             ENDDO                                               *  *S01147*/
 /*             IF      COND(&PRM01 *EQ 'SD0150') THEN(DO)          *  *S01147*/
 /*             CHGVAR VAR(&PRM01) VALUE('TMPSD150')                *  *S01147*/
 /*             ENDDO                                               *  *S01147*/
 /*             IF      COND(&PRM01 *EQ 'SD0250') THEN(DO)          *  *S01147*/
 /*             CHGVAR VAR(&PRM01) VALUE('TMPSD250')                *  *S01147*/
 /*             ENDDO                                               *  *S01147*/
 /*             IF      COND(&PRM01 *EQ 'SD0070') THEN(DO)          *  *S01147*/
 /*             CHGVAR VAR(&PRM01) VALUE('TMPSD070')                *  *S01147*/
 /*             ENDDO                                               *  *S01147*/
 /*          ENDDO                                                  *  *S01147*/
/****/                                                                /*E11184*/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
/**************** FOLLOWING SECTION ADDED FOR CLIENT GROUP *********/ /*S01413*/
             IF         COND(&PRM01 *EQ 'SD2351R') THEN(DO)           /*S01413*/
                   OVRDBF     FILE(TABLE2) TOFILE(TABCGU) SHARE(*NO)  /*S01413*/
                   OVRDBF     FILE(TABLE3) TOFILE(TABCGU) SHARE(*NO)  /*S01413*/
             ENDDO                                                    /*S01413*/
             IF         COND(&PRM01 *EQ 'SD2351E') THEN(DO)           /*S01413*/
                   OVRDBF     FILE(TABLE2) TOFILE(TABCGU) SHARE(*NO)  /*S01413*/
             ENDDO                                                    /*S01413*/
/****************** END OF SECTION ADDED FOR CLIENT GROUP **********/ /*S01413*/
                                                                      /*087757*/
/** If A/C Keys Maintenance, check if file is being used by another    *087757*/
/** workstation for update                                             *087757*/
                                                                      /*087757*/
             IF         COND(&PRM01 *EQ 'SD0050') THEN(DO)            /*087757*/
                                                                      /*087757*/
               ALCOBJ     OBJ((ACKEYAL *FILE *SHRRD)) WAIT(0)         /*087757*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))       /*087757*/
               DLCOBJ     OBJ((ACKEYAL *FILE *SHRRD))                 /*087757*/
               ALCOBJ     OBJ((ACKEYAK *FILE *SHRRD)) WAIT(0)         /*087757*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MSG))       /*087757*/
               DLCOBJ     OBJ((ACKEYAK *FILE *SHRRD))                 /*087757*/
               GOTO       CMDLBL(CONTINUE)                            /*087757*/
                                                                      /*087757*/
/**********  ENDDO **/                                     /*087757*/ /*099226*/
 MSG:                                                                 /*087757*/
               RTVMSG     MSGID(SCM0086) MSGF(MIDASMSG) MSG(&MESSAGE) /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)   /*087757*/
               RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE) /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)   /*087757*/
               CHGDTAARA  DTAARA(MIDASMSG (10 1)) VALUE('1')          /*087757*/
               CALL       PGM(SCC0010) PARM('SDC03  ' 'ENTER' ' ')    /*087757*/
               GOTO       CMDLBL(ENDCLPGM)                            /*087757*/
             ENDDO                                                    /*099226*/
 CONTINUE:                                                            /*087757*/
                                                                      /*087757*/
             CALL       PGM(&PRM01)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
/***********    SNDPGMMSG MSG('Transaction failed. Re-input +         /*RT0159*/
/***********          necessary. Enter to continue.') TOPGMQ(*EXT)    /*RT0159*/
                CALL PGM(SDC0700) PARM('SDC03' 'TRANSFAIL' ' ')       /*RT0159*/
                GOTO ENDCLPGM
             ENDDO
             RTVJOBA    SWS(&SWS)
/*                                                                  */
             IF         COND((&PRM01 *NE 'SD0280') *AND  +
                             (&PRM01 *NE 'SD0011') *AND  +
                             (&PRM01 *NE 'SD0012')) THEN(DO)
 /*                                                                 */
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error')
                   ROLLBACK
                   SNDMSG     MSG(&MSG) TOMSGQ(&JOB)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)   /*E11161*/
 ENDD005:       ENDDO
             ENDDO
             ELSE       CMD(DO)
 /*                                                                 */
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   CHGVAR  VAR(&MSG) VALUE('Job Terminated - Database +
                           Error')
                   ROLLBACK
                   SNDMSG     MSG(&MSG) TOMSGQ(&JOB)
                SNDPGMMSG     MSG('JOB TERMINATED - DATABASE IN +
                              ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)   /*E11161*/
                ENDDO
             ENDDO
 /*                                                                 */
 ENDCLPGM:   RETURN
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM    /* END CL PGM */
