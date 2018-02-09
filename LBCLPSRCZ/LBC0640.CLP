/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LB Extract Retail Regeneration.')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0640 - Portfolio Lending Extract Retail Regeneration     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD031950           Date 17Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      095241             Date 01Nov95              */
/*                      S01408             Date 05May95              */
/*                      S01498             DATE 11AUG94              */
/*                      064504             DATE 22DEC93              */
/*                      35723              DATE 27JAN92              */
/*                      S01189             DATE 10AUG92              */
/*                      B8094              DATE 26SEP91              */
/*                      B5955              DATE 07MAY91              */
/*                      R1052              DATE 17DEC90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD031950 - Recompiled due to changed CUSEXZ1.               */
/*       095241 - WRONG NAME FOR MESSAGE FILE LBUSRMSG               */
/*       S01408 - Addition of core hook LBC0640MP1                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       064504 - SECURITY CPYF IN QTEMP CAUSING RESTART PROBLEMS    */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       B8094  - RE3380 not needed as accruals are not shown        */
/*                in Lombards any more                               */
/*       B5955  - File "LBEXCOPD" Never cleared during update        */
/*       R1052  - AMEND RETAIL INTEREST ACCRUALS CALCS               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
/*>>S01189>>*/
/**********  PGM                                                    **/
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01498*/
/*<<S01189<<*/
 
/* >>> 064504 >>> */
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)              */ /*S01498*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)                 /*S01498*/
/* <<< 064504 <<< */
 
/* RESET JOB SWITCHES                                                */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/*           SNDPGMMSG  MSG('LBC0640 - Lombard Retail Regeneration') +    */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                    */
             SNDPGMMSG  MSG('LBC0640 - Portfolio Lending - Retail +
                          Regeneration') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* >>> 064504 >>> */
/* CREATE LDA IF NOT PRESENT */                                       /*S01498*/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)               /*S01498*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                       /*S01498*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)                               /*S01498*/
             ENDDO                                                    /*S01498*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DLIB')      */ /*S01498*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DPLIB')        /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0640MP1                                          */
                                                                      /*S01408*/
/* <<< 064504 <<< */
 
/* CLEAR SECURITY COPY FILE, AND COPY IN DATA FROM LIVE FILE         */
/* >>> 064504 >>> */
/**********  DLTF       FILE(QTEMP/WWEXTRPD)                  ********/
             DLTF       FILE(&DLIB/WWEXTRPD)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF0000)
 
/* CREATE SECURITY COPY FILE                                         */
/* >>> 064504 >>> */
/**********  CPYF       FROMFILE(*LIBL/LBEXTRPD) +                   */
/**********               TOFILE(QTEMP/WWEXTRPD) MBROPT(*ADD) +      */
/**********               CRTFILE(*YES)                              */
             CPYF       FROMFILE(*LIBL/LBEXTRPD) +
                          TOFILE(&DLIB/WWEXTRPD) MBROPT(*ADD) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(WWEXTRPD))
/* >>> 064504 >>> */
/*******     CPYF       FROMFILE(*LIBL/LBEXCOPD) +                       */
/*******                  TOFILE(QTEMP/XLBEXCOPD) MBROPT(*REPLACE) +     */
/*******                  CRTFILE(*YES)                            */ /*B5955*/
             CPYF       FROMFILE(*LIBL/LBEXCOPD) +
                          TOFILE(&DLIB/XLBEXCOPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
/* <<< 064504 <<< */
MONMSG CPF2817 CMPDTA(CPF2869) EXEC(CLRPFM XLBEXCOPD)                 /*B5955*/
 
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE(' ')
                   CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/* EXECUTE PROGRAM   */                                                /*R1052*/
/*           CALL       PGM(*LIBL/LB0640)   */                         /*R1052*/
 
/* EXECUTE ACCRUED INTEREST/CHARGES REPORT TO UPDATE REACRD   */       /*R1052*/
OVRDBF CUSEXZ1 SHARE(*NO)
/*>>B8094>>*/
/************CALL       PGM(*LIBL/REC3380)*/                           /*R1052*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(CALL +
                          PGM(*LIBL/LB0640))*/                         /*R1052*/
             CALL       PGM(*LIBL/LB0640)
                                                                       /*R1052*/
/*<<B8094<<*/
/* ERROR DURING PROCESSING                                           */
/***         MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)          */
/***         SNDPGMMSG  MSG('LBC0640 - Ended abnormally') TOMSGQ(MRUNQ)  */
/***         SNDPGMMSG  MSG('LBC0640 - Ended abnormally') +              */
/***                      TOMSGQ(MOPERQ)                                 */
/***         CPYF       FROMFILE(QTEMP/WWEXTRPD) +                       */
/***                      TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)        */
/***         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                   */
/***         ENDDO                                                       */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       /*35723*/
                   CHGJOB  SWS(XXXXXX11)                              /*35723*/
                   GOTO    CMDLBL(END)                                /*35723*/
             ENDDO                                                    /*35723*/
 
/* DATABASE IN ERROR DURING PROCESSING                               */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
/*           SNDPGMMSG  MSG('LBC0640 - Database error') TOMSGQ(MRUNQ) /*S01498*/
/*           SNDPGMMSG  MSG('LBC0640 - Database error') TOMSGQ(MOPERQ)/*S01498*/
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)            /*S01498*/
/**********  SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRSMG) MSGDTA(&DATA) +* *095241*/
/**********               TOMSGQ(MOPERQ MRUNQ)                *S01498* *095241*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*095241*/
/* >>> 064504 >>>*/
/******      CPYF       FROMFILE(QTEMP/WWEXTRPD) +                    */
/******                   TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
/* <<< 064504 <<<*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/* >>> 064504 >>>*/
/*******     CPYF       FROMFILE(QTEMP/XLBEXCOPD) +               */
/*******                  TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE) */  /*B5955*/
 
             CPYF       FROMFILE(&DLIB/XLBEXCOPD) +
                          TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)
/* <<< 064504 <<<*/
             MONMSG CPF2817 CMPDTA(CPF2869)                           /*B5955*/
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* FILE CONTROLS OUT OF BALANCE DURING PROCESSING                    */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/*           SNDPGMMSG  MSG('LBC0640 - File Controls out of Balance') +
                          TOMSGQ(MRUNQ)                               /*S01498*/
/*           SNDPGMMSG  MSG('LBC0640 - File Controls out of Balance') +
                          TOMSGQ(MOPERQ)                              /*S01498*/
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)            /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
/* >>> 064504 >>>*/
/*******     CPYF       FROMFILE(QTEMP/WWEXTRPD) +                    */
/*******                  TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)     */
             CPYF       FROMFILE(&DLIB/WWEXTRPD) +
                          TOFILE(*LIBL/LBEXTRPD) MBROPT(*REPLACE)
/* <<< 064504 <<<*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/* >>> 064504 >>>*/
/*******     CPYF       FROMFILE(QTEMP/XLBEXCOPD) +               */
/*******                  TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE) */  /*B5955*/
             CPYF       FROMFILE(&DLIB/XLBEXCOPD) +
                          TOFILE(*LIBL/LBEXCOPD) MBROPT(*REPLACE)
/* <<< 064504 <<<*/
 
             MONMSG CPF2817 CMPDTA(CPF2869)                           /*B5955*/
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/*>>> 064504 >>>*/
             DLTF       FILE(&DLIB/WWEXTRPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DLIB/XLBEXCOPD)
             MONMSG     MSGID(CPF0000)
/*<<< 064504 <<<*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 END:        ENDPGM
