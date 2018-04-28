/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MS Midas swift direct link i/c term')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Swift Direct Link Module                            */
/*                                                                   */
/*       MSC0501 - Swift Direct Link I/c termination                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB023             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. 206433             Date  3Jul02              */
/*                      CSD013             DATE 30AUG02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 10SEP97              */
/*                      120202             DATE 10JUN97              */
/*                      CCB001 *CREATE     DATE 01MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB023 - COB Restructure - Input Cycle Termination          */
/*                Restructuring                                      */
/*       206433 - COB Halt at MSC0501 but does not send a MSG to     */
/*                MOPERQ to inform user that there are outstanding   */
/*                MSGS.                                              */
/*       CSD013 - Replace dtaara CBPROMPT value with SDSVALPD record */
/*                value.                                             */
/*       S01408 - Hooks created with source name MSCPYSRC            */
/*                were renamed to be the standard WNCPYSRC.          */
/*       120202 - AOMGMER0 parameters have changed                   */
/*       CCB001 - CoB Enhancement (Batch Processing)                 */
/*                                                                   */
/*********************************************************************/
             PGM
 
/**COPY*MSCPYSRC,MSC0501INT**************************************/    /*S01408*/
/*/COPY WNCPYSRC,MSC0501INT                                     */    /*S01408*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**********  DCL        VAR(&MSRTN) TYPE(*LGL) LEN(1)                                  */ /*CCB023*/
/**********  DCL        VAR(&REOPN) TYPE(*CHAR) LEN(1)                                 */ /*CCB023*/
/************DCL        VAR(&SDMGME) TYPE(*CHAR) LEN(188)             /*120202*/
/**********  DCL        VAR(&SDMGME) TYPE(*CHAR) LEN(800)                       */ /*120202 CCB023*/
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                  */ /*CCB023*/
 /********** DCL        VAR(&CBPROMPT) TYPE(*CHAR) LEN(256) **/                           /*CSD013*/
/**********  DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                         */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                        */ /*CSD013 CCB023*/
/**********  DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                       */ /*CSD013 CCB023*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')                  */ /*CCB023*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXX000)
 
/*********** RTVDTAARA  DTAARA(CBPROMPT (1 256)) RTNVAR(&CBPROMPT) **/                    /*CSD013*/
/**Get*'ReopenSwiftTrans'*system*value*from*file*SDSVALPD***/                      /*CSD013 CCB023*/
                                                                                          /*CSD013*/
/**********  CALL       PGM(AOSVALR0) PARM(&RTNCDE +                                   */ /*CCB023*/
/**********               'ReopenSwiftTrans' &SVAL1 &SVALK2 +                          */ /*CCB023*/
/**********               &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +                       */ /*CCB023*/
/**********               &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +                      */ /*CCB023*/
/**********               &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +                       */ /*CCB023*/
/**********               &SVALK0 &SVAL10)                                             */ /*CCB023*/
                                                                                          /*CSD013*/
/**If*the*'ReopenSwiftTrans'*system*value*is*missing*then*end*abnormally**/        /*CSD013 CCB023*/
                                                                                          /*CSD013*/
/**********  IF         COND(%SST(&SVAL1 1 4) *EQ '*NRF') THEN(GOTO +                  */ /*CCB023*/
/**********               CMDLBL(ABNOR))                                        */ /*CSD013 CCB023*/
                                                                                          /*CSD013*/
/**********  CHGVAR     VAR(&MSRTN) VALUE('0')                                         */ /*CCB023*/
 
/**COPY*MSCPYSRC,MSC0501MPS**************************************/    /*S01408*/
/*/COPY WNCPYSRC,MSC0501MPS                                     */    /*S01408*/
 
/***Access*PF/SDMGMEPD*to*determine**/                                                    /*CCB023*/
/***whether*communications*are*through*the*SWIFT*interface**/                             /*CCB023*/
/***or*through*the*Merva*interface**/                                                     /*CCB023*/
 
/**********  CHGVAR     VAR(&RTCD) VALUE('*MSG   ')                                    */ /*CCB023*/
/**********  CALL       PGM(AOMGMER0) PARM(&RTCD &OPTN &SDMGME)                        */ /*CCB023*/
 
/**Database*error*handling**/                                                             /*CCB023*/
 
/**********  IF         COND(&RTCD *NE '       ') THEN(DO)                             */ /*CCB023*/
/**********    SNDPGMMSG  MSG('Error on access to ICD file +                           */ /*CCB023*/
/**********                 AOMGMEPD') TOMSGQ(MOPERQ)                                  */ /*CCB023*/
/**********    GOTO       CMDLBL(ABNOR)                                                */ /*CCB023*/
/**********  ENDDO                                                                     */ /*CCB023*/
 
/**If*craeted/amended*msgs*awaiting*transmission*give*opportunity***/                     /*CCB023*/
/**to*reopen*onput*cycle**/                                                               /*CCB023*/
 
/**Call*created/amended*msgs*awaiting*transmission*report**/                              /*CCB023*/
 
/**********  CALL       PGM(MEC0400)                                                   */ /*CCB023*/
/*/COPY WNCPYSRC,MSC0501001                                          */
 
/**********  IF         COND(%SWITCH(XXXXX1XX)) THEN(CHGVAR +                          */ /*CCB023*/
/**********               VAR(&REOPN) VALUE(Y))                                        */ /*CCB023*/
 
/*********** IF         COND((&REOPN *EQ 'Y') *AND (%SST(&CBPROMPT 1 +  **/               /*CSD013*/
/************************ 1)) *EQ 'Y') THEN(DO)                         **/               /*CSD013*/
/**********  IF         COND((&REOPN *EQ 'Y') *AND (%SST(&SVAL1 1 +
                          1)) *EQ 'Y') THEN(DO)                                 */ /*CSD013 CCB023*/
 
/**********  SNDMSG     MSG('Outstanding messages awaiting +
                          transmission. Pls reopen input cycle as +
                          per COB Predefined Decision Table.') +
                          TOMSGQ(MOPERQ)                                        */ /*206433 CCB023*/
 
/**Check*for*communications*through*the*Merva*interface**/                                /*CCB023*/
/**rather*than*the*SWIFT*interface**/                                                     /*CCB023*/
 
/**********     IF         COND(%SST(&SDMGME 17 4) *EQ 'APPC') +
                             THEN(CALL PGM(MSC6001))                                   */ /*CCB023*/
/*/COPY WNCPYSRC,MSC0501002                                          */
/**********  ELSE       CMD(CALL PGM(MSC4001))                                         */ /*CCB023*/
/**********     GOTO       CMDLBL(ABNOR)                                               */ /*CCB023*/
/**********  ENDDO                                                                     */ /*CCB023*/
 
/* Midas/SWIFT direct link reports */
 
             CALL       PGM(MSC05)
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/**COPY*MSCPYSRC,MSC0501MPE**************************************/    /*S01408*/
/*/COPY WNCPYSRC,MSC0501MPE                                     */    /*S01408*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/**COPY*MSCPYSRC,MSC0501ERR**************************************/    /*S01408*/
/*/COPY WNCPYSRC,MSC0501ERR                                     */    /*S01408*/
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDMSG     MSG('MSC0501 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
/**COPY*MSCPYSRC,MSC0501END**************************************/    /*S01408*/
/*/COPY WNCPYSRC,MSC0501END                                     */    /*S01408*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
