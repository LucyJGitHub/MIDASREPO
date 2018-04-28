/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interest History Switchability')             */
/*******************************************************************/
/*                                                                 */
/*       Midas - Dealing Module                            */
/*                                                                 */
/*       PROGRAM     DLC9100 - INTEREST HISTORY SWITCHABILITY      */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND : 073175         DATE : 21NOV95                */
/*       PREV AMEND : 085716         DATE : 12APR95                */
/*                    AUS006         DATE : 04AUG92                */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       073175 - Interest History Enquiry Print loops if more     */
/*                than one user takes the option since both write  */
/*                records with the same RRN - fix is to create a   */
/*                new member for each user.                        */
/*       085716 - INCORRECT TEXT ON MIDAS INFORMATION SCREEN IF    */
/*                SAR NOT SWITCHED ON                              */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*********************************************************************/
 
             PGM        PARM(&PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10) /*S01390*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&WWUSER) TYPE(*CHAR) LEN(10)              /*073175*/
             DCL        VAR(&MBRNAM) TYPE(*CHAR) LEN(9)               /*073175*/
             DCL        VAR(&WWUSID) TYPE(*CHAR) LEN(3)               /*073175*/
             DCL        VAR(&WWNUMB) TYPE(*CHAR) LEN(6)               /*073175*/
/**/
/* Monitor for error messages not trapped in the rest of the */       /*073175*/
/* program. If they occur reclaim resources and exit.        */       /*073175*/
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))                    /*073175*/
/**/                                                                  /*073175*/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('AUS006')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *NE '       ') THEN(DO)
             RTVMSG     MSGID(XXM0001) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(XXM0004) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
/* 085716 */
/****        RTVMSG     MSGID(XXM0004) MSGF(MIDASMSG) MSG(&MESSAGE) ***/
/****        CHGDTAARA  DTAARA(MIDASMSG (451 50)) VALUE(&MESSAGE)  ***/
             RTVMSG     MSGID(XXM0005) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
/* 085716 */
             CALL       PGM(SCC0040) PARM('DLC9100' 'ENTER' &REPLY)
             ENDDO
/**/
             ELSE       CMD(DO)
/* Create member in HISTEAA for this session                       */ /*073175*/
             RTVJOBA    USER(&WWUSER) NBR(&WWNUMB)                    /*073175*/
             CHGVAR     VAR(&WWUSID) VALUE(%SST(&WWUSER 1 3))         /*073175*/
             CHGVAR     VAR(&MBRNAM) VALUE(&WWUSID *TCAT &WWNUMB)     /*073175*/
             CHKOBJ     OBJ(HISTEAA) OBJTYPE(*FILE) MBR(&MBRNAM)      /*073175*/
             MONMSG     MSGID(CPF9815) EXEC(DO)                       /*073175*/
             ADDPFM     FILE(HISTEAA) MBR(&MBRNAM)                    /*073175*/
             ENDDO                                                    /*073175*/
/* .. or clear member if it already exists                         */ /*073175*/
             CLRPFM     FILE(HISTEAA) MBR(&MBRNAM)                    /*073175*/
                                                                      /*073175*/
/* Override file to member for user and call program               */ /*073175*/
             OVRDBF     FILE(HISTEAA) MBR(&MBRNAM)                    /*073175*/
/*********** CALL       PGM(&PARM)                               ***/ /*073175*/
             CALL       PGM(&PARM) PARM(&MBRNAM)                      /*073175*/
             ENDDO
                                                                      /*073175*/
             GOTO       CMDLBL(ENDPGM)                                /*073175*/
/**/                                                                  /*073175*/
ABNOR:                                                                /*073175*/
/*/COPY WNCPYSRC,DLC9100ERR                                        */ /*073175*/
                                                                      /*073175*/
             CHGJOB     SWS(XXXXXX11)                                 /*073175*/
                                                                      /*073175*/
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN  */              /*073175*/
             RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)   /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)     /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
             RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)   /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
             CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')             /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
             CALL       PGM(SCC0010) PARM('DLC9100' 'ENTER' &REPLY)   /*073175*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*073175*/
/**/                                                                  /*073175*/
ENDPGM:                                                               /*073175*/
/*/COPY WNCPYSRC,DLC9100END                                        */ /*073175*/
                                                                      /*073175*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
