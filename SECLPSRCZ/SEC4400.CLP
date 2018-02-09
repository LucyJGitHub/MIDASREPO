/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Securities movements enquiry')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading                                  */
/*                                                                   */
/*       SEC4400 - Midas SE Transaction Message Enquiry              */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG10851R          Date 27Apr06              */
/*                      BUG10851           Date 16Mar06              */
/*                      BUG8823            Date 17Nov05              */
/*                      BUG2526            Date 13May04              */
/*                      CSE039   *CREATE   Date 21Jan03              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG10851R- Additional database error occurred during Depot  */
/*                  Movement enquiry                                 */
/*       BUG10851 - Database error occured in Depot Movement enquiry.*/
/*                  Remove libraries for MMM and move ME messages    */
/*                  to Global library.                               */
/*       BUG8823 - Trying to add incorrect libraries for MMM         */
/*       BUG2526 - Unable to use Security movements enquiry as it    */
/*                 always go to DBERROR. Need to do the same file    */
/*                 override as SE4400 and SE4410.                    */
/*       CSE039 - Auto-settlement of trades                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)             */                 /*BUG10851*/
/**********  DCL        VAR(&TOLIB2)  TYPE(*CHAR) LEN(10)            */     /*BUG8823*/ /*BUG10851*/
/**********  DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                 */                 /*BUG10851*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                  /*BUG8823*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/*           CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))                                  BUG8823*/
/**Get*GLOBAL*prefix**************************************************/     /*BUG8823*/ /*BUG10851*/
/**********  CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +            */                 /*BUG10851*/
/**********               'GlobalSystemPrefix' &SVAL1 &SVALK2 +      */                 /*BUG10851*/
/**********               &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +     */                 /*BUG10851*/
/**********               &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +    */                 /*BUG10851*/
/**********               &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +     */                 /*BUG10851*/
/**********               &SVALK10 &SVAL10)                          */                 /*BUG10851*/
                                                                                         /*BUG8823*/
                                                                                         /*BUG8823*/
/*           CHGVAR     VAR(&PRE) VALUE('RP')                                              BUG8823*/
/*           CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'MLINK')                               BUG8823*/
/**********  CHGVAR     VAR(&PRE) VALUE(&SVAL1)                      */     /*BUG8823*/ /*BUG10851*/
/**********  CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'GMLINK')        */     /*BUG8823*/ /*BUG10851*/
/**********  CHGVAR    VAR(&TOLIB2) VALUE(&PRE *TCAT 'GMLOBJ')       */     /*BUG8823*/ /*BUG10851*/
 
/*  CHECK IF DTAARA/SESDS EXISTS. IF NOT, CREATE IT.                 */
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9800) EXEC(DO)
 
             CRTDTAARA  DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37)
 
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
             ENDDO
 
/*  CLEAR DTAARA/SESDS AND SET ORIGINAL PGM. TO ENQUIRY PGM.         */
/*                     AND SET ZONED FIELDS                          */
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 8)) VALUE('SE4400  ')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
 
             OVRDBF FILE(TRADSDZ2) TOFILE(TRADSDY2) SHARE(*NO)
             OVRDBF FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)
             OVRDBF FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)
             OVRDBF FILE(DPTMVDZ3) TOFILE(DPTMVDY2) SHARE(*NO)
             OVRDBF FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)
             OVRDBF FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)
/**********  OVRDBF FILE(MESSAGES11) TOFILE(MEML11PD)                */     /*BUG2526*/ /*BUG10851*/
/**********  OVRDBF FILE(MESSAGES10) TOFILE(MEML10PD)                */     /*BUG2526*/ /*BUG10851*/
             OVRDBF FILE(MESSAGES11) TOFILE(MEML11PD)                                  /*BUG10851R*/
             OVRDBF FILE(MESSAGES10) TOFILE(MEML10PD)                                  /*BUG10851R*/
             CPYF       FROMFILE(SETRANPD) TOFILE(QTEMP/SETRANPDX) +
                          MBROPT(*ADD) CRTFILE(*YES)
             CPYF       FROMFILE(SEMESSPD) TOFILE(QTEMP/SEMESSPDX) +
                          MBROPT(*ADD) CRTFILE(*YES)
/**********  ADDLIBLE   LIB(&TOLIB) POSITION(*LAST)                  */                 /*BUG10851*/
/**********  MONMSG     MSGID(CPF2103)                               */                 /*BUG10851*/
/*           ADDLIBLE   LIB(MRDLNKOBJ) POSITION(*LAST)                                     BUG8823*/
/**********  ADDLIBLE   LIB(&TOLIB2) POSITION(*LAST)                 */     /*BUG8823*/ /*BUG10851*/
/**********  MONMSG     MSGID(CPF2103)                               */                 /*BUG10851*/
 
             CALL       PGM(SE4400)
 
             DLTF       FILE(QTEMP/SETRANPDX)
             DLTF       FILE(QTEMP/SEMESSPDX)
             DLTOVR     FILE(*ALL)
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2003')
 
/*           RMVLIBLE   LIB(MRDLNKOBJ)                                                     BUG8823*/
/**********  RMVLIBLE   LIB(&TOLIB2)                                 */     /*BUG8823*/ /*BUG10851*/
/**********  MONMSG     MSGID(CPF0000)                               */                 /*BUG10851*/
 
/**********  RMVLIBLE   LIB(&TOLIB)                                  */                /*BUG10851*/
/**********  MONMSG     MSGID(CPF0000)                               */                /*BUG10851*/
 
             ENDPGM
