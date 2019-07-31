/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Stop Meridian links')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC0710 - Stop meridian links                               */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1031152          Date 06Dec12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG12602A          Date 27Nov06              */
/*                      218954             Date 02Nov06              */
/*                      BUG12602           Date 09Nov06              */
/*                      236309             Date 03Nov05              */
/*                      BUG3866            Date 29Jul04              */
/*                      216542             Date 02Apr03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025  *CREATE    Date 06Mar02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1031152 - Error issuing WRKMMMSVR command which calls     */
/*                   program MEC2100. Issue command when CSW038 is   */
/*                   switched OFF. (Child: AR1031154)                */
/*       BUG12602A-Missing '&' in CSW038 indicator as qualifier.     */
/*       218954 - Change DELETE JOURNAL RECEIVER to avoid CPA7025    */
/*       BUG12602-Issue WRKMMMSVR ACTION(*MIDASCOB) if CSW034 is ON  */
/*                and CSW038 is OFF.                                 */
/*       236309 - Issue WRKMMMSVR ACTION(*MIDASCOB) if CSW034 is ON. */
/*       BUG3866- Meridian Server should not be started nor ended    */
/*                Global Processing is ON.                           */
/*       216542 - Condition CAS interface usage with CSW026          */
/*       CSW025 - Midas Message Manager                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CSW026) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*216542*/
             DCL        VAR(&CSW034) TYPE(*CHAR) LEN(1) VALUE(' ')                       /*BUG3866*/
             DCL        VAR(&CSW038) TYPE(*CHAR) LEN(1) VALUE(' ')                      /*BUG12602*/
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MDL2CASLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MERIDDBLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR)
 
             CHGJOB     SWS(00000000)
 
             RTVJOBA    CURLIB(&CURLIB)
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')
 
             IF         COND(&PRTCD *EQ ' ') THEN(DO)
                CHGVAR     VAR(&CSW025) VALUE('Y')
             ENDDO
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW026')                              /*216542*/
                                                                                          /*216542*/
             IF         COND(&PRTCD *EQ ' ') THEN(DO)                                     /*216542*/
                CHGVAR     VAR(&CSW026) VALUE('Y')                                        /*216542*/
             ENDDO                                                                        /*216542*/
                                                                                          /*216542*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW034')                             /*BUG3866*/
                                                                                         /*BUG3866*/
             IF         COND(&PRTCD *EQ ' ') THEN(DO)                                    /*BUG3866*/
                CHGVAR     VAR(&CSW034) VALUE('Y')                                       /*BUG3866*/
             ENDDO                                                                       /*BUG3866*/
                                                                                         /*BUG3866*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW038')                            /*BUG12602*/
                                                                                        /*BUG12602*/
             IF         COND(&PRTCD *EQ ' ') THEN(DO)                                   /*BUG12602*/
                CHGVAR     VAR(&CSW038) VALUE('Y')                                      /*BUG12602*/
             ENDDO                                                                      /*BUG12602*/
                                                                                        /*BUG12602*/
             RTVDTAARA  DTAARA(MESTAT (50 1)) RTNVAR(&MNGSYS)
 
             IF COND(&CSW025 *EQ 'Y') THEN(DO)
/* Stop Export from this Midas system to Meridian. */
                WRKMSMIF   OPERATION(*SHUTDOWN) MCID(*ALL) TYPE(*SYNCH)
/**********     IF         COND(&MNGSYS *EQ 'Y') THEN(DO) */                             /*BUG3866*/
             IF COND((&MNGSYS *EQ 'Y') *AND (&CSW034 *NE 'Y')) THEN(DO)                  /*BUG3866*/
/* If this is the managing Midas system also stop Meridian */
 
/* Stop Meridian - SWIFT (CAS) interface. */
                   IF COND(&CSW026 *EQ 'Y') THEN(DO)                                      /*216542*/
                   RTVDTAARA  DTAARA(MESTAT (61 10)) RTNVAR(&MDL2CASLIB)
                   CHGCURLIB  CURLIB(&MDL2CASLIB)
                   WRKMLCASIF   OPERATION(*SHUTDOWN)
                   ENDDO                                                                  /*216542*/
 
/* Reset the current library. */
                   IF         COND(&CURLIB *EQ '*NONE     ') THEN(DO)
                      CHGCURLIB  CURLIB(*CRTDFT)
                   ENDDO
                   ELSE       CMD(DO)
                      CHGCURLIB  CURLIB(&CURLIB)
                   ENDDO
 
/* Stop Meridian Message Manager server. */
                   IF COND(&CSW038 *NE 'Y') THEN(DO)                                   /*AR1031152*/
                   WRKMMMSVR  ACTION(*SHUTDOWN)
 
                   RTVDTAARA  DTAARA(MESTAT (9 10)) RTNVAR(&MERIDDBLIB)
/***************   DLTJRNRCV  JRNRCV(&MERIDDBLIB/QSQJRN*)   */                            /*218954*/
/***************   MONMSG     MSGID(CPF7022 CPF2117)        */                            /*218954*/
             DLTJRNRCV  JRNRCV(&MERIDDBLIB/QSQJRN*) +
                        DLTOPT(*IGNINQMSG)                                                /*218954*/
                MONMSG     MSGID(CPF0000)                                                 /*218954*/
                   ENDDO                                                               /*AR1031152*/
                ENDDO
/**********     IF COND(&CSW034 *EQ 'Y') THEN(DO)                                /*236309 BUG12602*/
/**********     IF COND((&CSW034 *EQ 'Y') *AND (CSW038 *NE 'Y')) THEN(DO)     /*BUG12602 BUG12602A*/
                IF COND((&CSW034 *EQ 'Y') *AND (&CSW038 *NE 'Y')) THEN(DO)             /*BUG12602A*/
                   WRKMMMSVR  ACTION(*MIDASCOB)                                           /*236309*/
                ENDDO                                                                     /*236309*/
             ENDDO
 
             GOTO       CMDLBL(END)
ERROR:
             CHGVAR     VAR(&MSG) VALUE('Meridian DBIC save failure')
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
