/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Customer / Portfolio Cashflow (Daily COB)')  */
/********************************************************************/
/*                                                                  */
/*       Midas     PORTFOLIO MANAGEMENT MODULE                      */
/*                                                                  */
/*       PMC0430 - PM CUSTOMER / PORTFOLIO CASHFLOW                 */
/*                 (COB mandatory processing)                       */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. 081506             DATE 11JAN94             */
/*                      S01486  LV         DATE 29SEP94             */
/*                      049421             DATE 18JAN93             */
/*                      049467             DATE 18JAN93             */
/*                      R00300             DATE 28AUG90             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       081506  -  WRONG PARAMETER PASSED                          */
/*       S01486  -  PORTFOLIO MANAGEMENT UPGRADE TO R10             */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       R00300  -  Message file changes.                           */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCL        VAR(&WWCLP) TYPE(*CHAR) LEN(7)                /*S01486*/
/************DCL        VAR(&WWUSRP) TYPE(*CHAR) LEN(10)              /*S01486*/
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                 /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
 
/*  GLOBAL MONITOR MESSAGE:                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                        CMDLBL(ENDTAG))
 
/*  SET OFF SWITCHES:                                                */
             CHGJOB     SWS(00000000)
 
/*  RETRIEVE CASHFLOW CONTROL DATE                                   */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
 
/***SET*UP*CALLING PROGRAM NAME:                                      /*S01486*/
/************CHGVAR     VAR(&WWCLP) VALUE('PMC0431')                  /*S01486*/
/************                                                         /*S01486*/
/***RETRIEVE*USER PROFILE OF SIGNED ON USER */                        /*S01486*/
/************RTVJOBA    USER(&WWUSRP)                                 /*S01486*/
 
/*  REPORT DURING EOD :                         */
             CHGJOB     SWS(X1XXXXXX)
 
/************OVRDBF    FILE(PMCASHPO) TOFILE(SDACOFPD) SHARE(*YES) */ /*S01486*/
             OVRDBF     FILE(PMCASHQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPP)) +
                          FORMAT(PMCASHPO) QRYSLT('PNRECI *EQ "D" +
                          *AND W1CASN *GT 0 *AND W2CASN *LE "' *CAT +
                          &DAECD *CAT '" ') KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (PMPORTPP/PNCNUM +
                          *MAPFLD/W1CNUM)) MAPFLD((W1CNUM +
                          'SDCUSTPD/BBCUST' *ZONED 6 0) (W1CASN PNCASN  +
                          *ZONED 5) (W2CASN W1CASN *CHAR 5))  */      /*S01486*/
             OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMCASHQ0) QRYSLT('PNRECI *EQ "D" +
                          *AND W1CASN *GT 0 *AND W2CASN *LE "' *CAT +
                          &DAECD *CAT '" ') KEYFLD((SDACOFPD/AZACOC) +
                          (SDCUSTPD/BBCUST)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (PMPORTPD/PNCNUM +
                          *MAPFLD/W1CNUM)) MAPFLD((W1CNUM +
                          'SDCUSTPD/BBCUST' *ZONED 6 0) (W1CASN PNCASN  +
                          *ZONED 5) (W2CASN W1CASN *CHAR 5))          /*S01486*/
/************CALL       PGM(PM0430) PARM(' ' ' ' ' ' 'Y' 'Y' 'Y') */  /*S01486*/
/** CALL       PGM(PM0430) PARM('     ' '*ALL' 'Y' 'Y' 'Y')  /*S01486   081506*/
    CALL  PGM(PM0430) PARM('     ' '*ALL' '*ALL' '*ALL' 'Y' 'N' 'N')  /*081506*/
 
             CLOF       OPNID(SDACOFPD)
             DLTOVR     FILE(*ALL)
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  DATABASE ERROR, IF U7 + U8 ON:                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)             /*S01486*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
************************TOMSGQ(MOPERQ MRUNQ)                         */
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)  */                      /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*  FILE OUT OF BALANCE ERROR, IF U8 ON:                             */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) TOMSGQ(MOPERQ +
**************************MRUNQ)                                     */
/************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)   */                                 /*S01486*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 ENDTAG:     DMPCLPGM
/**********ENDPGM:     RCLRSC                                          *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
         ENDPGM                                                       /*S01486*/
